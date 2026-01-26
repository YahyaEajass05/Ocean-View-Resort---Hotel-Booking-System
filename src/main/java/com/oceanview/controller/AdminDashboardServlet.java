package com.oceanview.controller;

import com.oceanview.dao.*;
import com.oceanview.model.User;
import com.oceanview.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Admin Dashboard Servlet
 * Loads dashboard statistics and data for admin users
 * URL Mapping: /admin/dashboard (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class AdminDashboardServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardServlet.class);
    
    private UserDAO userDAO;
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private ReviewDAO reviewDAO;
    private PaymentDAO paymentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
        this.reservationDAO = new ReservationDAO();
        this.roomDAO = new RoomDAO();
        this.reviewDAO = new ReviewDAO();
        this.paymentDAO = new PaymentDAO();
        logger.info("AdminDashboardServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("loggedInUser");
        
        // Check if user has ADMIN role
        if (!"ADMIN".equals(user.getRole().toString())) {
            logger.warn("Unauthorized access attempt to admin dashboard by user: {} with role: {}", 
                       user.getUsername(), user.getRole());
            response.sendRedirect(request.getContextPath() + "/guest/home");
            return;
        }
        
        try {
            // Load dashboard statistics
            Map<String, Object> stats = loadDashboardStats();
            
            // Load recent reservations
            List<Reservation> recentReservations = reservationDAO.findRecent(10);
            
            // Set attributes for JSP
            request.setAttribute("stats", stats);
            request.setAttribute("recentReservations", recentReservations);
            
            logger.info("Admin dashboard accessed by: {}", user.getUsername());
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            logger.error("Error loading dashboard data", e);
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Load all dashboard statistics
     */
    private Map<String, Object> loadDashboardStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        // User statistics
        stats.put("totalUsers", userDAO.count());
        stats.put("activeUsers", userDAO.countByStatus("ACTIVE"));
        stats.put("guestCount", userDAO.countByRole("GUEST"));
        stats.put("staffCount", userDAO.countByRole("STAFF"));
        
        // Reservation statistics
        stats.put("totalReservations", reservationDAO.count());
        stats.put("confirmedReservations", reservationDAO.countByStatus("CONFIRMED"));
        stats.put("checkedInReservations", reservationDAO.countByStatus("CHECKED_IN"));
        stats.put("pendingReservations", reservationDAO.countByStatus("PENDING"));
        stats.put("todayCheckIns", reservationDAO.countTodayCheckIns());
        stats.put("todayCheckOuts", reservationDAO.countTodayCheckOuts());
        
        // Room statistics
        stats.put("totalRooms", roomDAO.count());
        stats.put("availableRooms", roomDAO.countByStatus("AVAILABLE"));
        stats.put("occupiedRooms", roomDAO.countByStatus("OCCUPIED"));
        stats.put("maintenanceRooms", roomDAO.countByStatus("MAINTENANCE"));
        stats.put("occupancyRate", calculateOccupancyRate());
        
        // Review statistics
        stats.put("totalReviews", reviewDAO.count());
        stats.put("pendingReviews", reviewDAO.countByStatus("PENDING"));
        stats.put("averageRating", reviewDAO.getAverageRating());
        
        // Revenue statistics (this month)
        stats.put("monthlyRevenue", paymentDAO.getMonthlyRevenue());
        stats.put("todayRevenue", paymentDAO.getTodayRevenue());
        stats.put("yearlyRevenue", paymentDAO.getYearlyRevenue());
        
        return stats;
    }
    
    /**
     * Calculate occupancy rate
     */
    private double calculateOccupancyRate() throws SQLException {
        int total = roomDAO.count();
        int occupied = roomDAO.countByStatus("OCCUPIED");
        if (total == 0) return 0.0;
        return (occupied * 100.0) / total;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
