package com.oceanview.controller;

import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import com.oceanview.util.Constants;
import com.oceanview.util.ValidationUtil;
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
import java.util.List;
import java.util.Optional;

/**
 * Reservation Servlet
 * Handles reservation operations
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ReservationServlet.class);
    private ReservationService reservationService;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        logger.info("ReservationServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "view":
                viewReservation(request, response);
                break;
            case "list":
                listReservations(request, response);
                break;
            case "cancel":
                cancelReservation(request, response);
                break;
            case "confirm":
                confirmReservation(request, response);
                break;
            case "checkin":
                checkInReservation(request, response);
                break;
            case "checkout":
                checkOutReservation(request, response);
                break;
            default:
                listReservations(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createReservation(request, response);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * Create a new reservation
     */
    private void createReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get parameters
            String guestIdStr = request.getParameter("guestId");
            String roomIdStr = request.getParameter("roomId");
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            String numberOfGuestsStr = request.getParameter("numberOfGuests");
            String specialRequests = request.getParameter("specialRequests");
            
            // Validate input
            if (!ValidationUtil.isValidInteger(guestIdStr) || 
                !ValidationUtil.isValidInteger(roomIdStr) ||
                !ValidationUtil.isValidInteger(numberOfGuestsStr)) {
                
                request.setAttribute(Constants.ATTR_ERROR, "Invalid input parameters");
                request.getRequestDispatcher("/views/guest/booking.jsp").forward(request, response);
                return;
            }
            
            int guestId = Integer.parseInt(guestIdStr);
            int roomId = Integer.parseInt(roomIdStr);
            int numberOfGuests = Integer.parseInt(numberOfGuestsStr);
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);
            
            // Get current user
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
            
            // Create reservation
            Reservation reservation = new Reservation();
            reservation.setGuestId(guestId);
            reservation.setRoomId(roomId);
            reservation.setCheckInDate(checkIn);
            reservation.setCheckOutDate(checkOut);
            reservation.setNumberOfGuests(numberOfGuests);
            reservation.setSpecialRequests(specialRequests);
            reservation.setCreatedBy(currentUser.getUserId());
            
            int reservationId = reservationService.createReservation(reservation);
            
            if (reservationId > 0) {
                session.setAttribute(Constants.ATTR_SUCCESS, "Reservation created successfully!");
                response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId);
            } else {
                String errorMsg = getErrorMessage(reservationId);
                request.setAttribute(Constants.ATTR_ERROR, errorMsg);
                request.getRequestDispatcher("/views/guest/booking.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.error("Error creating reservation", e);
            request.setAttribute(Constants.ATTR_ERROR, "Failed to create reservation");
            request.getRequestDispatcher("/views/guest/booking.jsp").forward(request, response);
        }
    }
    
    /**
     * View reservation details
     */
    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
            return;
        }
        
        int reservationId = Integer.parseInt(idStr);
        Optional<Reservation> reservationOpt = reservationService.getReservationById(reservationId);
        
        if (reservationOpt.isPresent()) {
            request.setAttribute("reservation", reservationOpt.get());
            request.getRequestDispatcher("/views/guest/reservation-details.jsp").forward(request, response);
        } else {
            request.setAttribute(Constants.ATTR_ERROR, "Reservation not found");
            request.getRequestDispatcher("/views/guest/my-bookings.jsp").forward(request, response);
        }
    }
    
    /**
     * List reservations
     */
    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        List<Reservation> reservations;
        
        if (user.isGuest()) {
            // Get guest's reservations only
            // You would need to get the guest ID from the database
            reservations = reservationService.getAllReservations(); // Simplified
        } else {
            // Admin/Staff can see all reservations
            reservations = reservationService.getAllReservations();
        }
        
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/views/reservations/list.jsp").forward(request, response);
    }
    
    /**
     * Confirm reservation
     */
    private void confirmReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
            return;
        }
        
        int reservationId = Integer.parseInt(idStr);
        boolean success = reservationService.confirmReservation(reservationId);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, "Reservation confirmed successfully!");
        } else {
            session.setAttribute(Constants.ATTR_ERROR, "Failed to confirm reservation");
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId);
    }
    
    /**
     * Check-in reservation
     */
    private void checkInReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
            return;
        }
        
        int reservationId = Integer.parseInt(idStr);
        boolean success = reservationService.checkInReservation(reservationId);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, Constants.MSG_CHECKIN_SUCCESS);
        } else {
            session.setAttribute(Constants.ATTR_ERROR, "Failed to check-in");
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId);
    }
    
    /**
     * Check-out reservation
     */
    private void checkOutReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
            return;
        }
        
        int reservationId = Integer.parseInt(idStr);
        boolean success = reservationService.checkOutReservation(reservationId);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, Constants.MSG_CHECKOUT_SUCCESS);
        } else {
            session.setAttribute(Constants.ATTR_ERROR, "Failed to check-out");
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationId);
    }
    
    /**
     * Cancel reservation
     */
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
            return;
        }
        
        int reservationId = Integer.parseInt(idStr);
        boolean success = reservationService.cancelReservation(reservationId);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, Constants.MSG_RESERVATION_CANCELLED);
        } else {
            session.setAttribute(Constants.ATTR_ERROR, "Failed to cancel reservation");
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=list");
    }
    
    /**
     * Update reservation
     */
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Implementation for update
        response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "Update not yet implemented");
    }
    
    /**
     * Get error message from error code
     */
    private String getErrorMessage(int errorCode) {
        switch (errorCode) {
            case -1: return "Check-in date cannot be in the past";
            case -2: return "Invalid date range";
            case -3: return "Room not found";
            default: return "Failed to create reservation";
        }
    }
}
