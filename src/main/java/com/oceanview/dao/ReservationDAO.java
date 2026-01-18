package com.oceanview.dao;

import com.oceanview.model.Reservation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Reservation DAO - Data Access Object for Reservation entity
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class ReservationDAO extends BaseDAO {
    
    private static final Logger logger = LoggerFactory.getLogger(ReservationDAO.class);
    
    // SQL Queries
    private static final String INSERT_RESERVATION = 
        "INSERT INTO reservations (reservation_number, guest_id, room_id, check_in_date, " +
        "check_out_date, number_of_guests, number_of_nights, total_amount, discount_amount, " +
        "tax_amount, final_amount, status, special_requests, created_by) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String UPDATE_RESERVATION = 
        "UPDATE reservations SET guest_id = ?, room_id = ?, check_in_date = ?, " +
        "check_out_date = ?, number_of_guests = ?, number_of_nights = ?, total_amount = ?, " +
        "discount_amount = ?, tax_amount = ?, final_amount = ?, status = ?, " +
        "special_requests = ?, updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";
    
    private static final String UPDATE_STATUS = 
        "UPDATE reservations SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";
    
    private static final String DELETE_RESERVATION = 
        "DELETE FROM reservations WHERE reservation_id = ?";
    
    private static final String SELECT_BY_ID = 
        "SELECT * FROM reservations WHERE reservation_id = ?";
    
    private static final String SELECT_BY_NUMBER = 
        "SELECT * FROM reservations WHERE reservation_number = ?";
    
    private static final String SELECT_ALL = 
        "SELECT * FROM reservations ORDER BY created_at DESC";
    
    private static final String SELECT_BY_GUEST = 
        "SELECT * FROM reservations WHERE guest_id = ? ORDER BY created_at DESC";
    
    private static final String SELECT_BY_ROOM = 
        "SELECT * FROM reservations WHERE room_id = ? ORDER BY check_in_date DESC";
    
    private static final String SELECT_BY_STATUS = 
        "SELECT * FROM reservations WHERE status = ? ORDER BY check_in_date";
    
    private static final String SELECT_BY_DATE_RANGE = 
        "SELECT * FROM reservations WHERE check_in_date >= ? AND check_out_date <= ? " +
        "ORDER BY check_in_date";
    
    private static final String SELECT_ACTIVE = 
        "SELECT * FROM reservations WHERE status IN ('CONFIRMED', 'CHECKED_IN') " +
        "ORDER BY check_in_date";
    
    private static final String SELECT_UPCOMING = 
        "SELECT * FROM reservations WHERE status = 'CONFIRMED' AND check_in_date >= CURDATE() " +
        "ORDER BY check_in_date";
    
    private static final String SELECT_CHECKED_IN_TODAY = 
        "SELECT * FROM reservations WHERE status = 'CONFIRMED' AND check_in_date = CURDATE()";
    
    private static final String SELECT_CHECKED_OUT_TODAY = 
        "SELECT * FROM reservations WHERE status = 'CHECKED_IN' AND check_out_date = CURDATE()";
    
    private static final String COUNT_BY_STATUS = 
        "SELECT COUNT(*) FROM reservations WHERE status = ?";
    
    /**
     * Create a new reservation
     */
    public int create(Reservation reservation) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(INSERT_RESERVATION, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, reservation.getReservationNumber());
            stmt.setInt(2, reservation.getGuestId());
            stmt.setInt(3, reservation.getRoomId());
            stmt.setDate(4, Date.valueOf(reservation.getCheckInDate()));
            stmt.setDate(5, Date.valueOf(reservation.getCheckOutDate()));
            stmt.setInt(6, reservation.getNumberOfGuests());
            stmt.setInt(7, reservation.getNumberOfNights());
            stmt.setBigDecimal(8, reservation.getTotalAmount());
            stmt.setBigDecimal(9, reservation.getDiscountAmount());
            stmt.setBigDecimal(10, reservation.getTaxAmount());
            stmt.setBigDecimal(11, reservation.getFinalAmount());
            stmt.setString(12, reservation.getStatus().name());
            stmt.setString(13, reservation.getSpecialRequests());
            stmt.setInt(14, reservation.getCreatedBy());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating reservation failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int reservationId = rs.getInt(1);
                logger.info("Reservation created successfully with ID: {}", reservationId);
                return reservationId;
            } else {
                throw new SQLException("Creating reservation failed, no ID obtained.");
            }
            
        } catch (SQLException e) {
            logSQLException("create reservation", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Update existing reservation
     */
    public boolean update(Reservation reservation) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(UPDATE_RESERVATION);
            
            stmt.setInt(1, reservation.getGuestId());
            stmt.setInt(2, reservation.getRoomId());
            stmt.setDate(3, Date.valueOf(reservation.getCheckInDate()));
            stmt.setDate(4, Date.valueOf(reservation.getCheckOutDate()));
            stmt.setInt(5, reservation.getNumberOfGuests());
            stmt.setInt(6, reservation.getNumberOfNights());
            stmt.setBigDecimal(7, reservation.getTotalAmount());
            stmt.setBigDecimal(8, reservation.getDiscountAmount());
            stmt.setBigDecimal(9, reservation.getTaxAmount());
            stmt.setBigDecimal(10, reservation.getFinalAmount());
            stmt.setString(11, reservation.getStatus().name());
            stmt.setString(12, reservation.getSpecialRequests());
            stmt.setInt(13, reservation.getReservationId());
            
            int affectedRows = stmt.executeUpdate();
            logger.info("Reservation updated: ID={}, affected rows={}", 
                       reservation.getReservationId(), affectedRows);
            
            return affectedRows > 0;
            
        } catch (SQLException e) {
            logSQLException("update reservation", e);
            throw e;
        } finally {
            closeResources(conn, stmt);
        }
    }
    
    /**
     * Update reservation status
     */
    public boolean updateStatus(int reservationId, Reservation.ReservationStatus status) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(UPDATE_STATUS);
            
            stmt.setString(1, status.name());
            stmt.setInt(2, reservationId);
            
            int affectedRows = stmt.executeUpdate();
            logger.info("Reservation status updated: ID={}, status={}", reservationId, status);
            
            return affectedRows > 0;
            
        } catch (SQLException e) {
            logSQLException("update reservation status", e);
            throw e;
        } finally {
            closeResources(conn, stmt);
        }
    }
    
    /**
     * Delete reservation
     */
    public boolean delete(int reservationId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(DELETE_RESERVATION);
            stmt.setInt(1, reservationId);
            
            int affectedRows = stmt.executeUpdate();
            logger.info("Reservation deleted: ID={}, affected rows={}", reservationId, affectedRows);
            
            return affectedRows > 0;
            
        } catch (SQLException e) {
            logSQLException("delete reservation", e);
            throw e;
        } finally {
            closeResources(conn, stmt);
        }
    }
    
    /**
     * Find reservation by ID
     */
    public Optional<Reservation> findById(int reservationId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_BY_ID);
            stmt.setInt(1, reservationId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToReservation(rs));
            }
            
            return Optional.empty();
            
        } catch (SQLException e) {
            logSQLException("find reservation by ID", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find reservation by reservation number
     */
    public Optional<Reservation> findByReservationNumber(String reservationNumber) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_BY_NUMBER);
            stmt.setString(1, reservationNumber);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToReservation(rs));
            }
            
            return Optional.empty();
            
        } catch (SQLException e) {
            logSQLException("find reservation by number", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find all reservations
     */
    public List<Reservation> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_ALL);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} reservations", reservations.size());
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find all reservations", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find reservations by guest
     */
    public List<Reservation> findByGuestId(int guestId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_BY_GUEST);
            stmt.setInt(1, guestId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} reservations for guest ID: {}", reservations.size(), guestId);
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find reservations by guest", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find reservations by status
     */
    public List<Reservation> findByStatus(Reservation.ReservationStatus status) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_BY_STATUS);
            stmt.setString(1, status.name());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} reservations with status: {}", reservations.size(), status);
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find reservations by status", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find active reservations
     */
    public List<Reservation> findActiveReservations() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_ACTIVE);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} active reservations", reservations.size());
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find active reservations", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find upcoming reservations
     */
    public List<Reservation> findUpcomingReservations() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_UPCOMING);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} upcoming reservations", reservations.size());
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find upcoming reservations", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find today's check-ins
     */
    public List<Reservation> findTodayCheckIns() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_CHECKED_IN_TODAY);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} check-ins for today", reservations.size());
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find today check-ins", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Find today's check-outs
     */
    public List<Reservation> findTodayCheckOuts() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Reservation> reservations = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(SELECT_CHECKED_OUT_TODAY);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
            
            logger.debug("Found {} check-outs for today", reservations.size());
            return reservations;
            
        } catch (SQLException e) {
            logSQLException("find today check-outs", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Count reservations by status
     */
    public int countByStatus(Reservation.ReservationStatus status) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(COUNT_BY_STATUS);
            stmt.setString(1, status.name());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
            return 0;
            
        } catch (SQLException e) {
            logSQLException("count reservations by status", e);
            throw e;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
    
    /**
     * Map ResultSet to Reservation object
     */
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setReservationNumber(rs.getString("reservation_number"));
        reservation.setGuestId(rs.getInt("guest_id"));
        reservation.setRoomId(rs.getInt("room_id"));
        reservation.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        reservation.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        reservation.setNumberOfGuests(rs.getInt("number_of_guests"));
        reservation.setNumberOfNights(rs.getInt("number_of_nights"));
        reservation.setTotalAmount(rs.getBigDecimal("total_amount"));
        reservation.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        reservation.setTaxAmount(rs.getBigDecimal("tax_amount"));
        reservation.setFinalAmount(rs.getBigDecimal("final_amount"));
        reservation.setStatus(Reservation.ReservationStatus.valueOf(rs.getString("status")));
        reservation.setSpecialRequests(rs.getString("special_requests"));
        reservation.setCreatedBy(rs.getInt("created_by"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            reservation.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            reservation.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return reservation;
    }
}
