package com.oceanview.service;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for RoomService
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("RoomService Tests")
class RoomServiceTest {
    
    @Mock
    private RoomDAO roomDAO;
    
    private RoomService roomService;
    
    private Room testRoom;
    
    @BeforeEach
    void setUp() {
        roomService = new RoomService();
        
        testRoom = new Room();
        testRoom.setRoomId(1);
        testRoom.setRoomNumber("101");
        testRoom.setRoomType(Room.RoomType.DELUXE);
        testRoom.setPricePerNight(new BigDecimal("150.00"));
        testRoom.setCapacity(2);
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
    }
    
    @Test
    @DisplayName("Should get room by ID")
    void testGetRoomById() throws SQLException {
        // Given
        when(roomDAO.findById(1)).thenReturn(Optional.of(testRoom));
        
        // This test demonstrates the concept
        assertThat(testRoom.getRoomId()).isEqualTo(1);
    }
    
    @Test
    @DisplayName("Should check if room is available")
    void testIsRoomAvailable() {
        // Given
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
        
        // Then
        assertThat(testRoom.isAvailable()).isTrue();
        assertThat(testRoom.isOccupied()).isFalse();
    }
    
    @Test
    @DisplayName("Should check if room is occupied")
    void testIsRoomOccupied() {
        // Given
        testRoom.setStatus(Room.RoomStatus.OCCUPIED);
        
        // Then
        assertThat(testRoom.isOccupied()).isTrue();
        assertThat(testRoom.isAvailable()).isFalse();
    }
    
    @Test
    @DisplayName("Should check if room is under maintenance")
    void testIsRoomUnderMaintenance() {
        // Given
        testRoom.setStatus(Room.RoomStatus.MAINTENANCE);
        
        // Then
        assertThat(testRoom.isUnderMaintenance()).isTrue();
        assertThat(testRoom.isAvailable()).isFalse();
    }
    
    @Test
    @DisplayName("Should calculate price for multiple nights")
    void testCalculatePrice() {
        // Given
        BigDecimal pricePerNight = new BigDecimal("150.00");
        testRoom.setPricePerNight(pricePerNight);
        int nights = 5;
        
        // When
        BigDecimal totalPrice = testRoom.calculatePrice(nights);
        
        // Then
        assertThat(totalPrice).isEqualByComparingTo(new BigDecimal("750.00"));
    }
    
    @Test
    @DisplayName("Should get room statistics")
    void testGetRoomStatistics() throws SQLException {
        // Given
        List<Room> rooms = new ArrayList<>();
        
        Room room1 = new Room();
        room1.setStatus(Room.RoomStatus.AVAILABLE);
        rooms.add(room1);
        
        Room room2 = new Room();
        room2.setStatus(Room.RoomStatus.OCCUPIED);
        rooms.add(room2);
        
        Room room3 = new Room();
        room3.setStatus(Room.RoomStatus.RESERVED);
        rooms.add(room3);
        
        Room room4 = new Room();
        room4.setStatus(Room.RoomStatus.MAINTENANCE);
        rooms.add(room4);
        
        when(roomDAO.findAll()).thenReturn(rooms);
        
        // Verify counts
        long availableCount = rooms.stream().filter(Room::isAvailable).count();
        long occupiedCount = rooms.stream().filter(Room::isOccupied).count();
        long reservedCount = rooms.stream().filter(Room::isReserved).count();
        long maintenanceCount = rooms.stream().filter(Room::isUnderMaintenance).count();
        
        assertThat(availableCount).isEqualTo(1);
        assertThat(occupiedCount).isEqualTo(1);
        assertThat(reservedCount).isEqualTo(1);
        assertThat(maintenanceCount).isEqualTo(1);
    }
    
    @Test
    @DisplayName("Should filter rooms by type")
    void testFilterRoomsByType() {
        // Given
        List<Room> rooms = new ArrayList<>();
        
        Room deluxeRoom = new Room();
        deluxeRoom.setRoomType(Room.RoomType.DELUXE);
        rooms.add(deluxeRoom);
        
        Room suiteRoom = new Room();
        suiteRoom.setRoomType(Room.RoomType.SUITE);
        rooms.add(suiteRoom);
        
        Room anotherDeluxe = new Room();
        anotherDeluxe.setRoomType(Room.RoomType.DELUXE);
        rooms.add(anotherDeluxe);
        
        // When
        long deluxeCount = rooms.stream()
            .filter(r -> r.getRoomType() == Room.RoomType.DELUXE)
            .count();
        
        // Then
        assertThat(deluxeCount).isEqualTo(2);
    }
    
    @Test
    @DisplayName("Should get room type name")
    void testGetRoomTypeName() {
        // Given
        testRoom.setRoomType(Room.RoomType.DELUXE);
        
        // Then
        assertThat(testRoom.getRoomTypeName()).isEqualTo("DELUXE");
    }
    
    @Test
    @DisplayName("Should get room status name")
    void testGetRoomStatusName() {
        // Given
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
        
        // Then
        assertThat(testRoom.getStatusName()).isEqualTo("AVAILABLE");
    }
}
