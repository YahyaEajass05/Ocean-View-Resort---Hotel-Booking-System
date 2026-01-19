package com.oceanview.controller;

import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import com.oceanview.service.RoomService;
import com.oceanview.service.BillingService;
import com.oceanview.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Dashboard Servlet
 * Provides dashboard data for different user roles
 * URL Mapping: /dashboard (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class DashboardServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(DashboardServlet.class);
    private ReservationService reservationService;
    private RoomService roomService;
    private BillingService billingService;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        roomService = new RoomService();
        billingService = new BillingService();
        logger.info("DashboardServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Load dashboard data based on user role
        if (user.isAdmin()) {
            loadAdminDashboard(request, response);
        } else if (user.isStaff()) {
            loadStaffDashboard(request, response);
        } else {
            loadGuestDashboard(request, response);
        }
    }
    
    /**
     * Load admin dashboard data
     */
    private void loadAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Room statistics
            int[] roomStats = roomService.getRoomStatistics();
            int totalRooms = roomStats[0] + roomStats[1] + roomStats[2] + roomStats[3];
            
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("availableRooms", roomStats[0]);
            request.setAttribute("occupiedRooms", roomStats[1]);
            request.setAttribute("reservedRooms", roomStats[2]);
            request.setAttribute("maintenanceRooms", roomStats[3]);
            
            // Reservation counts
            int totalReservations = reservationService.getAllReservations().size();
            int activeReservations = reservationService.getActiveReservations().size();
            int todayCheckIns = reservationService.getTodayCheckIns().size();
            int todayCheckOuts = reservationService.getTodayCheckOuts().size();
            
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("activeReservations", activeReservations);
            request.setAttribute("todayCheckIns", todayCheckIns);
            request.setAttribute("todayCheckOuts", todayCheckOuts);
            
            // Revenue
            double totalRevenue = billingService.getTotalRevenue();
            double monthlyRevenue = totalRevenue; // Simplified - use current total as monthly
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            
            // Total guests (unique guests from all reservations)
            int totalGuests = reservationService.getAllReservations().size(); // Simplified
            request.setAttribute("totalGuests", totalGuests);
            
            // Occupancy rate
            double occupancyRate = totalRooms > 0 ? ((double) roomStats[1] / totalRooms) * 100 : 0.0;
            request.setAttribute("occupancyRate", occupancyRate);
            
            // Pending reviews (simplified - count recent reservations)
            int pendingReviews = 0;
            request.setAttribute("pendingReviews", pendingReviews);
            
            // Recent activities
            request.setAttribute("recentReservations", reservationService.getAllReservations());
            request.setAttribute("todayCheckInsList", reservationService.getTodayCheckIns());
            request.setAttribute("todayCheckOutsList", reservationService.getTodayCheckOuts());
            
            logger.info("Admin dashboard data loaded successfully");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading admin dashboard", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading dashboard");
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Load staff dashboard data
     */
    private void loadStaffDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Today's activities
            request.setAttribute("todayCheckIns", reservationService.getTodayCheckIns());
            request.setAttribute("todayCheckOuts", reservationService.getTodayCheckOuts());
            
            // Room availability
            int[] roomStats = roomService.getRoomStatistics();
            request.setAttribute("availableRooms", roomStats[0]);
            request.setAttribute("occupiedRooms", roomStats[1]);
            
            // Active reservations
            request.setAttribute("activeReservations", reservationService.getActiveReservations());
            
            logger.info("Staff dashboard data loaded successfully");
            request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading staff dashboard", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading dashboard");
            request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Load guest dashboard data
     */
    private void loadGuestDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute(Constants.SESSION_USER);
            
            // Guest's bookings
            // Note: You would need to get guest ID from user ID
            // For now, showing all (simplified)
            request.setAttribute("upcomingBookings", reservationService.getAllReservations());
            
            // Available rooms
            request.setAttribute("availableRoomsCount", roomService.getAvailableRooms().size());
            
            logger.info("Guest dashboard data loaded successfully");
            request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading guest dashboard", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading dashboard");
            request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
        }
    }
}
