package com.oceanview.controller;

import com.oceanview.model.User;
import com.oceanview.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Settings Servlet
 * Handles system settings and configuration (Admin only)
 * URL Mapping: /settings (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class SettingsServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(SettingsServlet.class);
    
    @Override
    public void init() throws ServletException {
        logger.info("SettingsServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Load application properties
            Properties appProperties = loadApplicationProperties();
            
            // System information
            request.setAttribute("systemInfo", getSystemInfo());
            request.setAttribute("appProperties", appProperties);
            
            // Database info (safe to display)
            request.setAttribute("dbUrl", appProperties.getProperty("db.url", "Not configured"));
            request.setAttribute("dbUsername", appProperties.getProperty("db.username", "Not configured"));
            request.setAttribute("poolSize", appProperties.getProperty("db.pool.maxActive", "20"));
            
            // Application settings
            request.setAttribute("appName", appProperties.getProperty("app.name", "Ocean View Resort"));
            request.setAttribute("appVersion", appProperties.getProperty("app.version", "1.0.0"));
            request.setAttribute("maintenanceMode", appProperties.getProperty("app.maintenance.mode", "false"));
            
            request.getRequestDispatcher("/views/admin/settings.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading settings", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading settings");
            request.getRequestDispatcher("/views/admin/settings.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("updateGeneral".equals(action)) {
                updateGeneralSettings(request, response);
            } else if ("updateEmail".equals(action)) {
                updateEmailSettings(request, response);
            } else if ("updateSecurity".equals(action)) {
                updateSecuritySettings(request, response);
            } else if ("clearCache".equals(action)) {
                clearCache(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            logger.error("Error in SettingsServlet doPost", e);
            request.setAttribute(Constants.ATTR_ERROR, "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Load application properties
     */
    private Properties loadApplicationProperties() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("config/application.properties")) {
            
            if (input != null) {
                props.load(input);
            }
        } catch (IOException e) {
            logger.error("Failed to load application properties", e);
        }
        return props;
    }
    
    /**
     * Get system information
     */
    private java.util.Map<String, String> getSystemInfo() {
        java.util.Map<String, String> info = new java.util.HashMap<>();
        
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long allocatedMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = allocatedMemory - freeMemory;
        
        info.put("javaVersion", System.getProperty("java.version"));
        info.put("javaVendor", System.getProperty("java.vendor"));
        info.put("osName", System.getProperty("os.name"));
        info.put("osVersion", System.getProperty("os.version"));
        info.put("osArch", System.getProperty("os.arch"));
        info.put("maxMemory", formatBytes(maxMemory));
        info.put("allocatedMemory", formatBytes(allocatedMemory));
        info.put("freeMemory", formatBytes(freeMemory));
        info.put("usedMemory", formatBytes(usedMemory));
        info.put("availableProcessors", String.valueOf(runtime.availableProcessors()));
        
        return info;
    }
    
    /**
     * Format bytes to human-readable format
     */
    private String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(1024));
        String pre = "KMGTPE".charAt(exp-1) + "";
        return String.format("%.1f %sB", bytes / Math.pow(1024, exp), pre);
    }
    
    /**
     * Update general settings
     */
    private void updateGeneralSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // In a real application, you would update the database or configuration file
        String hotelName = request.getParameter("hotelName");
        String contactEmail = request.getParameter("contactEmail");
        String contactPhone = request.getParameter("contactPhone");
        String timezone = request.getParameter("timezone");
        String currency = request.getParameter("currency");
        
        logger.info("General settings updated: hotelName={}", hotelName);
        
        request.getSession().setAttribute(Constants.ATTR_SUCCESS, "General settings updated successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
    
    /**
     * Update email settings
     */
    private void updateEmailSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String smtpHost = request.getParameter("smtpHost");
        String smtpPort = request.getParameter("smtpPort");
        String smtpUsername = request.getParameter("smtpUsername");
        String fromEmail = request.getParameter("fromEmail");
        
        logger.info("Email settings updated: smtpHost={}, smtpPort={}", smtpHost, smtpPort);
        
        request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Email settings updated successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
    
    /**
     * Update security settings
     */
    private void updateSecuritySettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sessionTimeout = request.getParameter("sessionTimeout");
        String passwordMinLength = request.getParameter("passwordMinLength");
        String maxLoginAttempts = request.getParameter("maxLoginAttempts");
        
        logger.info("Security settings updated");
        
        request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Security settings updated successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
    
    /**
     * Clear application cache
     */
    private void clearCache(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Clear cache logic here
        logger.info("Application cache cleared");
        
        request.getSession().setAttribute(Constants.ATTR_SUCCESS, "Cache cleared successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
}
