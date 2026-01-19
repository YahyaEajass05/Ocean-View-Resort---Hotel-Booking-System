package com.oceanview.filter;

import com.oceanview.model.User;
import com.oceanview.util.Constants;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Authorization Filter
 * Checks if user has the required role to access specific resources
 * URL Patterns: /admin/*, /staff/* (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class AuthorizationFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(AuthorizationFilter.class);
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("AuthorizationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        
        // Get user from session
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            // Should not happen as AuthenticationFilter runs first
            logger.error("Authorization check failed: User not in session for URI: {}", requestURI);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        // Check authorization based on URI
        boolean isAuthorized = false;
        
        if (requestURI.contains("/admin/")) {
            // Only ADMIN can access /admin/*
            isAuthorized = user.isAdmin();
        } else if (requestURI.contains("/staff/")) {
            // ADMIN and STAFF can access /staff/*
            isAuthorized = user.isAdmin() || user.isStaff();
        }
        
        if (isAuthorized) {
            // User is authorized
            logger.debug("User {} authorized for URI: {}", user.getUsername(), requestURI);
            chain.doFilter(request, response);
        } else {
            // User not authorized
            logger.warn("Access denied for user {} to URI: {}", user.getUsername(), requestURI);
            
            // Set error message
            session.setAttribute(Constants.ATTR_ERROR, Constants.MSG_ACCESS_DENIED);
            
            // Redirect to appropriate dashboard based on role
            String redirectPath;
            if (user.isGuest()) {
                redirectPath = "/guest/home.jsp";
            } else if (user.isStaff()) {
                redirectPath = "/staff/dashboard.jsp";
            } else {
                redirectPath = "/";
            }
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + redirectPath);
        }
    }
    
    @Override
    public void destroy() {
        logger.info("AuthorizationFilter destroyed");
    }
}
