package com.oceanview.controller;

import com.oceanview.model.Payment;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import com.oceanview.service.BillingService;
import com.oceanview.service.ReservationService;
import com.oceanview.service.RoomService;
import com.oceanview.util.Constants;
import com.oceanview.util.DateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Report Servlet
 * Generates various reports for the hotel management system
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
@WebServlet("/report")
public class ReportServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ReportServlet.class);
    private ReservationService reservationService;
    private RoomService roomService;
    private BillingService billingService;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        roomService = new RoomService();
        billingService = new BillingService();
        logger.info("ReportServlet initialized");
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
        
        // Only admin and staff can access reports
        if (!user.isAdmin() && !user.isStaff()) {
            request.setAttribute(Constants.ATTR_ERROR, Constants.MSG_ACCESS_DENIED);
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "dashboard";
        }
        
        try {
            switch (action) {
                case "dashboard":
                    showReportDashboard(request, response);
                    break;
                case "revenue":
                    generateRevenueReport(request, response);
                    break;
                case "occupancy":
                    generateOccupancyReport(request, response);
                    break;
                case "reservations":
                    generateReservationReport(request, response);
                    break;
                case "rooms":
                    generateRoomReport(request, response);
                    break;
                default:
                    showReportDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.error("Error in ReportServlet GET", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error generating report");
            request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Show report dashboard
     */
    private void showReportDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        logger.info("Loading report dashboard");
        
        // Get summary statistics
        Map<String, Object> stats = new HashMap<>();
        
        // Reservation statistics
        List<Reservation> allReservations = reservationService.getAllReservations();
        stats.put("totalReservations", allReservations.size());
        stats.put("activeReservations", reservationService.getActiveReservations().size());
        
        // Room statistics
        int[] roomStats = roomService.getRoomStatistics();
        stats.put("availableRooms", roomStats[0]);
        stats.put("occupiedRooms", roomStats[1]);
        stats.put("reservedRooms", roomStats[2]);
        stats.put("maintenanceRooms", roomStats[3]);
        
        // Revenue statistics
        double totalRevenue = billingService.getTotalRevenue();
        stats.put("totalRevenue", totalRevenue);
        
        // Today's activities
        stats.put("todayCheckIns", reservationService.getTodayCheckIns().size());
        stats.put("todayCheckOuts", reservationService.getTodayCheckOuts().size());
        
        request.setAttribute("stats", stats);
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        if (user.isAdmin()) {
            request.getRequestDispatcher("/views/admin/reports/dashboard.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/staff/reports/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Generate revenue report
     */
    private void generateRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        LocalDate startDate = startDateStr != null ? DateUtil.parseDate(startDateStr) : LocalDate.now().minusMonths(1);
        LocalDate endDate = endDateStr != null ? DateUtil.parseDate(endDateStr) : LocalDate.now();
        
        logger.info("Generating revenue report from {} to {}", startDate, endDate);
        
        // Get all payments
        List<Payment> allPayments = billingService.getAllPayments();
        
        // Filter payments by date range
        List<Payment> filteredPayments = allPayments.stream()
            .filter(p -> p.getPaymentDate() != null)
            .filter(p -> {
                LocalDate paymentDate = p.getPaymentDate().toLocalDate();
                return !paymentDate.isBefore(startDate) && !paymentDate.isAfter(endDate);
            })
            .collect(Collectors.toList());
        
        // Calculate totals
        double totalRevenue = filteredPayments.stream()
            .filter(Payment::isCompleted)
            .mapToDouble(p -> p.getAmount().doubleValue())
            .sum();
        
        double totalRefunds = filteredPayments.stream()
            .filter(Payment::isRefunded)
            .mapToDouble(p -> p.getAmount().doubleValue())
            .sum();
        
        double netRevenue = totalRevenue - totalRefunds;
        
        // Group by payment method
        Map<String, Double> revenueByMethod = filteredPayments.stream()
            .filter(Payment::isCompleted)
            .collect(Collectors.groupingBy(
                p -> p.getPaymentMethod().name(),
                Collectors.summingDouble(p -> p.getAmount().doubleValue())
            ));
        
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("payments", filteredPayments);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalRefunds", totalRefunds);
        request.setAttribute("netRevenue", netRevenue);
        request.setAttribute("revenueByMethod", revenueByMethod);
        
        request.getRequestDispatcher("/views/reports/revenue.jsp").forward(request, response);
    }
    
    /**
     * Generate occupancy report
     */
    private void generateOccupancyReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        logger.info("Generating occupancy report");
        
        // Get room statistics
        int[] roomStats = roomService.getRoomStatistics();
        int totalRooms = roomStats[0] + roomStats[1] + roomStats[2] + roomStats[3];
        
        double occupancyRate = totalRooms > 0 ? 
            (double) roomStats[1] / totalRooms * 100 : 0;
        
        // Get all rooms
        List<Room> allRooms = roomService.getAllRooms();
        
        // Group rooms by type
        Map<String, Long> roomsByType = allRooms.stream()
            .collect(Collectors.groupingBy(
                r -> r.getRoomType().name(),
                Collectors.counting()
            ));
        
        // Group rooms by status
        Map<String, Long> roomsByStatus = allRooms.stream()
            .collect(Collectors.groupingBy(
                r -> r.getStatus().name(),
                Collectors.counting()
            ));
        
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableRooms", roomStats[0]);
        request.setAttribute("occupiedRooms", roomStats[1]);
        request.setAttribute("reservedRooms", roomStats[2]);
        request.setAttribute("maintenanceRooms", roomStats[3]);
        request.setAttribute("occupancyRate", occupancyRate);
        request.setAttribute("roomsByType", roomsByType);
        request.setAttribute("roomsByStatus", roomsByStatus);
        request.setAttribute("allRooms", allRooms);
        
        request.getRequestDispatcher("/views/reports/occupancy.jsp").forward(request, response);
    }
    
    /**
     * Generate reservation report
     */
    private void generateReservationReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String status = request.getParameter("status");
        
        LocalDate startDate = startDateStr != null ? DateUtil.parseDate(startDateStr) : LocalDate.now().minusMonths(1);
        LocalDate endDate = endDateStr != null ? DateUtil.parseDate(endDateStr) : LocalDate.now();
        
        logger.info("Generating reservation report from {} to {}", startDate, endDate);
        
        // Get all reservations
        List<Reservation> allReservations = reservationService.getAllReservations();
        
        // Filter reservations
        List<Reservation> filteredReservations = allReservations.stream()
            .filter(r -> r.getCheckInDate() != null)
            .filter(r -> !r.getCheckInDate().isBefore(startDate) && !r.getCheckInDate().isAfter(endDate))
            .filter(r -> status == null || status.isEmpty() || r.getStatus().name().equals(status))
            .collect(Collectors.toList());
        
        // Group by status
        Map<String, Long> reservationsByStatus = filteredReservations.stream()
            .collect(Collectors.groupingBy(
                r -> r.getStatus().name(),
                Collectors.counting()
            ));
        
        // Calculate total revenue from reservations
        double totalReservationRevenue = filteredReservations.stream()
            .filter(r -> !r.isCancelled())
            .mapToDouble(r -> r.getFinalAmount().doubleValue())
            .sum();
        
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("reservations", filteredReservations);
        request.setAttribute("reservationsByStatus", reservationsByStatus);
        request.setAttribute("totalReservationRevenue", totalReservationRevenue);
        
        request.getRequestDispatcher("/views/reports/reservations.jsp").forward(request, response);
    }
    
    /**
     * Generate room report
     */
    private void generateRoomReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        logger.info("Generating room report");
        
        List<Room> allRooms = roomService.getAllRooms();
        
        // Group by room type
        Map<String, List<Room>> roomsByType = allRooms.stream()
            .collect(Collectors.groupingBy(r -> r.getRoomType().name()));
        
        // Calculate statistics per room type
        Map<String, Map<String, Object>> typeStats = new HashMap<>();
        
        for (String type : roomsByType.keySet()) {
            List<Room> rooms = roomsByType.get(type);
            Map<String, Object> stats = new HashMap<>();
            
            stats.put("total", rooms.size());
            stats.put("available", rooms.stream().filter(Room::isAvailable).count());
            stats.put("occupied", rooms.stream().filter(Room::isOccupied).count());
            stats.put("reserved", rooms.stream().filter(Room::isReserved).count());
            stats.put("maintenance", rooms.stream().filter(Room::isUnderMaintenance).count());
            
            // Average price
            double avgPrice = rooms.stream()
                .mapToDouble(r -> r.getPricePerNight().doubleValue())
                .average()
                .orElse(0.0);
            stats.put("avgPrice", avgPrice);
            
            typeStats.put(type, stats);
        }
        
        request.setAttribute("allRooms", allRooms);
        request.setAttribute("roomsByType", roomsByType);
        request.setAttribute("typeStats", typeStats);
        
        request.getRequestDispatcher("/views/reports/rooms.jsp").forward(request, response);
    }
}
