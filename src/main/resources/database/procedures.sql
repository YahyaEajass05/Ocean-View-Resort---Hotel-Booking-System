-- ============================================
-- Ocean View Resort - Stored Procedures
-- Version: 1.0.0
-- Note: Execute these separately via JDBC after schema creation
-- ============================================

USE oceanview_resort;

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS sp_get_available_rooms;

-- Procedure: Get Available Rooms for specific dates and room type
CREATE PROCEDURE sp_get_available_rooms(
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_room_type VARCHAR(20)
)
BEGIN
    SELECT r.*
    FROM rooms r
    WHERE r.status = 'AVAILABLE'
    AND (p_room_type IS NULL OR r.room_type = p_room_type)
    AND r.room_id NOT IN (
        SELECT res.room_id
        FROM reservations res
        WHERE res.status IN ('CONFIRMED', 'CHECKED_IN', 'RESERVED')
        AND (
            (p_check_in BETWEEN res.check_in_date AND res.check_out_date)
            OR (p_check_out BETWEEN res.check_in_date AND res.check_out_date)
            OR (res.check_in_date BETWEEN p_check_in AND p_check_out)
        )
    );
END;
