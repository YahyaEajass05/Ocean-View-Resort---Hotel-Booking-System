package com.oceanview.filter;

import com.oceanview.dao.AuditLogDAO;
import com.oceanview.model.AuditLog;
import com.oceanview.model.User;
import com.oceanview.util.Constants;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Logging Filter
 * Logs all HTTP requests for monitoring and audit purposes
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
@WebFilter("/*")
public class LoggingFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(LoggingFilter.class);
    private AuditLogDAO auditLogDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.auditLogDAO = new AuditLogDAO();
        logger.info("LoggingFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // Get request details
        String method = httpRequest.getMethod();
        String uri = httpRequest.getRequestURI();
        String queryString = httpRequest.getQueryString();
        String ipAddress = getClientIP(httpRequest);
        
        // Log request
        long startTime = System.currentTimeMillis();
        logger.info("Request: {} {} from IP: {}", method, uri, ipAddress);
        
        // Process request
        chain.doFilter(request, response);
        
        // Log response time
        long duration = System.currentTimeMillis() - startTime;
        logger.info("Response: {} {} completed in {}ms", method, uri, duration);
        
        // Create audit log for important actions
        if (shouldAudit(uri)) {
            createAuditLog(httpRequest, uri, ipAddress);
        }
    }
    
    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    /**
     * Check if URI should be audited
     */
    private boolean shouldAudit(String uri) {
        // Audit important actions
        return uri.contains("/login") || 
               uri.contains("/logout") || 
               uri.contains("/register") ||
               uri.contains("/reservation") ||
               uri.contains("/payment") ||
               uri.contains("/user");
    }
    
    /**
     * Create audit log entry
     */
    private void createAuditLog(HttpServletRequest request, String uri, String ipAddress) {
        try {
            HttpSession session = request.getSession(false);
            User user = null;
            
            if (session != null) {
                user = (User) session.getAttribute(Constants.SESSION_USER);
            }
            
            AuditLog log = new AuditLog();
            
            if (user != null) {
                log.setUserId(user.getUserId());
            }
            
            // Determine action from URI
            String action = determineAction(uri);
            log.setAction(action);
            log.setEntityType("HTTP_REQUEST");
            log.setDetails(String.format("URI: %s, Method: %s", uri, request.getMethod()));
            log.setIpAddress(ipAddress);
            
            auditLogDAO.create(log);
            
        } catch (Exception e) {
            logger.error("Error creating audit log", e);
        }
    }
    
    /**
     * Determine action type from URI
     */
    private String determineAction(String uri) {
        if (uri.contains("/login")) return "LOGIN";
        if (uri.contains("/logout")) return "LOGOUT";
        if (uri.contains("/register")) return "REGISTER";
        if (uri.contains("/reservation")) return "RESERVATION";
        if (uri.contains("/payment")) return "PAYMENT";
        return "ACCESS";
    }
    
    @Override
    public void destroy() {
        logger.info("LoggingFilter destroyed");
    }
}
