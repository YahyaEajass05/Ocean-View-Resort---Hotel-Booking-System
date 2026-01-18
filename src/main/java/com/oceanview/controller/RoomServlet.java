package com.oceanview.controller;

import com.oceanview.model.Room;
import com.oceanview.service.RoomService;
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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Room Servlet
 * Handles room operations
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
@WebServlet("/room")
public class RoomServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(RoomServlet.class);
    private RoomService roomService;
    
    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
        logger.info("RoomServlet initialized");
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
                viewRoom(request, response);
                break;
            case "list":
                listRooms(request, response);
                break;
            case "search":
                searchRooms(request, response);
                break;
            case "available":
                getAvailableRooms(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRoom(request, response);
                break;
            default:
                listRooms(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createRoom(request, response);
        } else if ("update".equals(action)) {
            updateRoom(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * Create a new room
     */
    private void createRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get parameters
            String roomNumber = request.getParameter("roomNumber");
            String roomTypeStr = request.getParameter("roomType");
            String floorStr = request.getParameter("floor");
            String capacityStr = request.getParameter("capacity");
            String priceStr = request.getParameter("pricePerNight");
            String description = request.getParameter("description");
            String amenities = request.getParameter("amenities");
            String imageUrl = request.getParameter("imageUrl");
            
            // Validate input
            if (ValidationUtil.isEmpty(roomNumber) || ValidationUtil.isEmpty(roomTypeStr) ||
                !ValidationUtil.isValidInteger(floorStr) || !ValidationUtil.isValidInteger(capacityStr) ||
                !ValidationUtil.isValidDouble(priceStr)) {
                
                request.setAttribute(Constants.ATTR_ERROR, "Invalid input parameters");
                request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
                return;
            }
            
            // Create room object
            Room room = new Room();
            room.setRoomNumber(roomNumber.trim());
            room.setRoomType(Room.RoomType.valueOf(roomTypeStr));
            room.setFloor(Integer.parseInt(floorStr));
            room.setCapacity(Integer.parseInt(capacityStr));
            room.setPricePerNight(new BigDecimal(priceStr));
            room.setDescription(description);
            room.setAmenities(amenities);
            room.setImageUrl(imageUrl);
            room.setStatus(Room.RoomStatus.AVAILABLE);
            
            int roomId = roomService.createRoom(room);
            
            HttpSession session = request.getSession();
            if (roomId > 0) {
                session.setAttribute(Constants.ATTR_SUCCESS, "Room created successfully!");
                response.sendRedirect(request.getContextPath() + "/room?action=view&id=" + roomId);
            } else {
                String errorMsg = roomId == -1 ? "Room number already exists" : "Failed to create room";
                request.setAttribute(Constants.ATTR_ERROR, errorMsg);
                request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.error("Error creating room", e);
            request.setAttribute(Constants.ATTR_ERROR, "Failed to create room");
            request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update existing room
     */
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String roomIdStr = request.getParameter("roomId");
            
            if (!ValidationUtil.isValidInteger(roomIdStr)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
                return;
            }
            
            int roomId = Integer.parseInt(roomIdStr);
            Optional<Room> roomOpt = roomService.getRoomById(roomId);
            
            if (roomOpt.isEmpty()) {
                request.setAttribute(Constants.ATTR_ERROR, "Room not found");
                request.getRequestDispatcher("/views/admin/rooms.jsp").forward(request, response);
                return;
            }
            
            Room room = roomOpt.get();
            
            // Update room properties
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setRoomType(Room.RoomType.valueOf(request.getParameter("roomType")));
            room.setFloor(Integer.parseInt(request.getParameter("floor")));
            room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            room.setPricePerNight(new BigDecimal(request.getParameter("pricePerNight")));
            room.setDescription(request.getParameter("description"));
            room.setAmenities(request.getParameter("amenities"));
            room.setImageUrl(request.getParameter("imageUrl"));
            
            boolean success = roomService.updateRoom(room);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute(Constants.ATTR_SUCCESS, "Room updated successfully!");
                response.sendRedirect(request.getContextPath() + "/room?action=view&id=" + roomId);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to update room");
                request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.error("Error updating room", e);
            request.setAttribute(Constants.ATTR_ERROR, "Failed to update room");
            request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
        }
    }
    
    /**
     * View room details
     */
    private void viewRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            return;
        }
        
        int roomId = Integer.parseInt(idStr);
        Optional<Room> roomOpt = roomService.getRoomById(roomId);
        
        if (roomOpt.isPresent()) {
            request.setAttribute("room", roomOpt.get());
            request.getRequestDispatcher("/views/rooms/room-details.jsp").forward(request, response);
        } else {
            request.setAttribute(Constants.ATTR_ERROR, "Room not found");
            request.getRequestDispatcher("/views/rooms/list.jsp").forward(request, response);
        }
    }
    
    /**
     * List all rooms
     */
    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Room> rooms = roomService.getAllRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/views/rooms/list.jsp").forward(request, response);
    }
    
    /**
     * Search available rooms
     */
    private void searchRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");
        String roomTypeStr = request.getParameter("roomType");
        
        try {
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);
            
            List<Room> rooms;
            
            if (roomTypeStr != null && !roomTypeStr.isEmpty()) {
                Room.RoomType roomType = Room.RoomType.valueOf(roomTypeStr);
                rooms = roomService.searchAvailableRoomsByType(roomType, checkIn, checkOut);
            } else {
                rooms = roomService.searchAvailableRooms(checkIn, checkOut);
            }
            
            request.setAttribute("rooms", rooms);
            request.setAttribute("checkInDate", checkIn);
            request.setAttribute("checkOutDate", checkOut);
            request.getRequestDispatcher("/views/guest/search-results.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error searching rooms", e);
            request.setAttribute(Constants.ATTR_ERROR, "Invalid search parameters");
            request.getRequestDispatcher("/views/guest/search-rooms.jsp").forward(request, response);
        }
    }
    
    /**
     * Get available rooms
     */
    private void getAvailableRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Room> rooms = roomService.getAvailableRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/views/rooms/available.jsp").forward(request, response);
    }
    
    /**
     * Show add room form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
    }
    
    /**
     * Show edit room form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            return;
        }
        
        int roomId = Integer.parseInt(idStr);
        Optional<Room> roomOpt = roomService.getRoomById(roomId);
        
        if (roomOpt.isPresent()) {
            request.setAttribute("room", roomOpt.get());
            request.getRequestDispatcher("/views/admin/room-form.jsp").forward(request, response);
        } else {
            request.setAttribute(Constants.ATTR_ERROR, "Room not found");
            request.getRequestDispatcher("/views/admin/rooms.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete room
     */
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            return;
        }
        
        int roomId = Integer.parseInt(idStr);
        boolean success = roomService.deleteRoom(roomId);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, "Room deleted successfully!");
        } else {
            session.setAttribute(Constants.ATTR_ERROR, "Failed to delete room");
        }
        
        response.sendRedirect(request.getContextPath() + "/room?action=list");
    }
}
