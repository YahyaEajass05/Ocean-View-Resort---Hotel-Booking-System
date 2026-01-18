package com.oceanview.service;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Room Service
 * Handles room business logic
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class RoomService {
    
    private static final Logger logger = LoggerFactory.getLogger(RoomService.class);
    private final RoomDAO roomDAO;
    
    /**
     * Constructor
     */
    public RoomService() {
        this.roomDAO = new RoomDAO();
    }
    
    /**
     * Create a new room
     * @param room Room object
     * @return Room ID if successful, -1 if failed
     */
    public int createRoom(Room room) {
        try {
            // Check if room number already exists
            Optional<Room> existingRoom = roomDAO.findByRoomNumber(room.getRoomNumber());
            if (existingRoom.isPresent()) {
                logger.warn("Room creation failed: Room number already exists - {}", 
                           room.getRoomNumber());
                return -1;
            }
            
            int roomId = roomDAO.create(room);
            
            if (roomId > 0) {
                logger.info("Room created successfully: {}", room.getRoomNumber());
            }
            
            return roomId;
            
        } catch (SQLException e) {
            logger.error("Error creating room: {}", room.getRoomNumber(), e);
            return -2;
        }
    }
    
    /**
     * Update existing room
     * @param room Room object
     * @return true if successful
     */
    public boolean updateRoom(Room room) {
        try {
            boolean success = roomDAO.update(room);
            
            if (success) {
                logger.info("Room updated successfully: ID={}", room.getRoomId());
            }
            
            return success;
            
        } catch (SQLException e) {
            logger.error("Error updating room: ID={}", room.getRoomId(), e);
            return false;
        }
    }
    
    /**
     * Update room status
     * @param roomId Room ID
     * @param status New status
     * @return true if successful
     */
    public boolean updateRoomStatus(int roomId, Room.RoomStatus status) {
        try {
            boolean success = roomDAO.updateStatus(roomId, status);
            
            if (success) {
                logger.info("Room status updated: ID={}, status={}", roomId, status);
            }
            
            return success;
            
        } catch (SQLException e) {
            logger.error("Error updating room status: ID={}", roomId, e);
            return false;
        }
    }
    
    /**
     * Delete room
     * @param roomId Room ID
     * @return true if successful
     */
    public boolean deleteRoom(int roomId) {
        try {
            boolean success = roomDAO.delete(roomId);
            
            if (success) {
                logger.info("Room deleted successfully: ID={}", roomId);
            }
            
            return success;
            
        } catch (SQLException e) {
            logger.error("Error deleting room: ID={}", roomId, e);
            return false;
        }
    }
    
    /**
     * Get room by ID
     * @param roomId Room ID
     * @return Optional Room
     */
    public Optional<Room> getRoomById(int roomId) {
        try {
            return roomDAO.findById(roomId);
        } catch (SQLException e) {
            logger.error("Error getting room by ID: {}", roomId, e);
            return Optional.empty();
        }
    }
    
    /**
     * Get room by room number
     * @param roomNumber Room number
     * @return Optional Room
     */
    public Optional<Room> getRoomByNumber(String roomNumber) {
        try {
            return roomDAO.findByRoomNumber(roomNumber);
        } catch (SQLException e) {
            logger.error("Error getting room by number: {}", roomNumber, e);
            return Optional.empty();
        }
    }
    
    /**
     * Get all rooms
     * @return List of rooms
     */
    public List<Room> getAllRooms() {
        try {
            return roomDAO.findAll();
        } catch (SQLException e) {
            logger.error("Error getting all rooms", e);
            return List.of();
        }
    }
    
    /**
     * Get rooms by type
     * @param roomType Room type
     * @return List of rooms
     */
    public List<Room> getRoomsByType(Room.RoomType roomType) {
        try {
            return roomDAO.findByType(roomType);
        } catch (SQLException e) {
            logger.error("Error getting rooms by type: {}", roomType, e);
            return List.of();
        }
    }
    
    /**
     * Get available rooms
     * @return List of available rooms
     */
    public List<Room> getAvailableRooms() {
        try {
            return roomDAO.findAvailableRooms();
        } catch (SQLException e) {
            logger.error("Error getting available rooms", e);
            return List.of();
        }
    }
    
    /**
     * Search available rooms by date range
     * @param checkIn Check-in date
     * @param checkOut Check-out date
     * @return List of available rooms
     */
    public List<Room> searchAvailableRooms(LocalDate checkIn, LocalDate checkOut) {
        try {
            // Validate dates
            if (checkIn.isBefore(LocalDate.now())) {
                logger.warn("Search failed: Check-in date is in the past");
                return List.of();
            }
            
            if (checkOut.isBefore(checkIn)) {
                logger.warn("Search failed: Check-out date before check-in date");
                return List.of();
            }
            
            return roomDAO.findAvailableRoomsByDate(checkIn, checkOut);
            
        } catch (SQLException e) {
            logger.error("Error searching available rooms", e);
            return List.of();
        }
    }
    
    /**
     * Search available rooms by type and date range
     * @param roomType Room type
     * @param checkIn Check-in date
     * @param checkOut Check-out date
     * @return List of available rooms
     */
    public List<Room> searchAvailableRoomsByType(Room.RoomType roomType, 
                                                  LocalDate checkIn, 
                                                  LocalDate checkOut) {
        try {
            // Validate dates
            if (checkIn.isBefore(LocalDate.now())) {
                logger.warn("Search failed: Check-in date is in the past");
                return List.of();
            }
            
            if (checkOut.isBefore(checkIn)) {
                logger.warn("Search failed: Check-out date before check-in date");
                return List.of();
            }
            
            return roomDAO.findAvailableRoomsByTypeAndDate(roomType, checkIn, checkOut);
            
        } catch (SQLException e) {
            logger.error("Error searching available rooms by type", e);
            return List.of();
        }
    }
    
    /**
     * Get room statistics
     * @return Room statistics as array [available, occupied, reserved, maintenance]
     */
    public int[] getRoomStatistics() {
        try {
            int[] stats = new int[4];
            stats[0] = roomDAO.countByStatus(Room.RoomStatus.AVAILABLE);
            stats[1] = roomDAO.countByStatus(Room.RoomStatus.OCCUPIED);
            stats[2] = roomDAO.countByStatus(Room.RoomStatus.RESERVED);
            stats[3] = roomDAO.countByStatus(Room.RoomStatus.MAINTENANCE);
            
            return stats;
            
        } catch (SQLException e) {
            logger.error("Error getting room statistics", e);
            return new int[]{0, 0, 0, 0};
        }
    }
}
