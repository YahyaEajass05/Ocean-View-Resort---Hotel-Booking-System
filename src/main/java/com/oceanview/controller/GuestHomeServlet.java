package com.oceanview.controller;

import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Guest Home Servlet
 * Displays the guest dashboard/home page
 * URL Mapping: /guest/home (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class GuestHomeServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(GuestHomeServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Check if user has GUEST role
        if (!"GUEST".equals(user.getRole().toString())) {
            logger.warn("Unauthorized access attempt to guest home by user: {} with role: {}", 
                       user.getUsername(), user.getRole());
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // TODO: Load guest statistics from database
        // - Active bookings count
        // - Reviews written count
        // - Total stays count
        // - Loyalty points
        
        // TODO: Load current booking from database
        // - Latest confirmed/active reservation
        
        // TODO: Load special offers from database
        // - Active offers applicable to the guest
        
        // For now, forward to the JSP (static data will be shown)
        logger.info("Guest home accessed by: {}", user.getUsername());
        request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
