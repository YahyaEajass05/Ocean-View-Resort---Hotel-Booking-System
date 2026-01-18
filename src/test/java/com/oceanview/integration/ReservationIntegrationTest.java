package com.oceanview.integration;

import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for Reservation workflow
 */
@DisplayName("Reservation Integration Tests")
class ReservationIntegrationTest {
    
    private Room testRoom;
    private Reservation testReservation;
    
    @BeforeEach
    void setUp() {
        // Set up test data
        testRoom = new Room();
        testRoom.setRoomId(1);
        testRoom.setRoomNumber("101");
        testRoom.setRoomType(Room.RoomType.DELUXE);
        testRoom.setPricePerNight(new BigDecimal("150.00"));
        testRoom.setCapacity(2);
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
        
        testReservation = new Reservation();
        testReservation.setReservationId(1);
        testReservation.setGuestId(1);
        testReservation.setRoomId(1);
        testReservation.setCheckInDate(LocalDate.now().plusDays(1));
        testReservation.setCheckOutDate(LocalDate.now().plusDays(6));
        testReservation.setNumberOfGuests(2);
    }
    
    @Test
    @DisplayName("Should complete full reservation workflow")
    void testFullReservationWorkflow() {
        // Step 1: Create reservation (PENDING)
        testReservation.setStatus(Reservation.ReservationStatus.PENDING);
        assertThat(testReservation.isPending()).isTrue();
        assertThat(testReservation.canCancel()).isTrue();
        
        // Step 2: Calculate amounts
        testReservation.calculateAmounts(
            testRoom.getPricePerNight(),
            10.0, // 10% tax
            5.0   // 5% service charge
        );
        
        // 150 * 5 = 750
        assertThat(testReservation.getTotalAmount())
            .isEqualByComparingTo(new BigDecimal("750.00"));
        
        // Tax: 750 * 0.10 = 75
        assertThat(testReservation.getTaxAmount())
            .isEqualByComparingTo(new BigDecimal("75.00"));
        
        // Service: 750 * 0.05 = 37.50
        // Final: 750 + 75 + 37.50 = 862.50
        assertThat(testReservation.getFinalAmount())
            .isEqualByComparingTo(new BigDecimal("862.50"));
        
        // Step 3: Confirm reservation
        testReservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        testRoom.setStatus(Room.RoomStatus.RESERVED);
        
        assertThat(testReservation.isConfirmed()).isTrue();
        assertThat(testRoom.isReserved()).isTrue();
        assertThat(testReservation.isActive()).isTrue();
        
        // Step 4: Check-in (on check-in date)
        testReservation.setCheckInDate(LocalDate.now());
        assertThat(testReservation.canCheckIn()).isTrue();
        
        testReservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        testRoom.setStatus(Room.RoomStatus.OCCUPIED);
        
        assertThat(testReservation.isCheckedIn()).isTrue();
        assertThat(testRoom.isOccupied()).isTrue();
        assertThat(testReservation.canCancel()).isFalse(); // Cannot cancel after check-in
        
        // Step 5: Check-out
        assertThat(testReservation.canCheckOut()).isTrue();
        
        testReservation.setStatus(Reservation.ReservationStatus.CHECKED_OUT);
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
        
        assertThat(testReservation.isCheckedOut()).isTrue();
        assertThat(testRoom.isAvailable()).isTrue();
        assertThat(testReservation.isActive()).isFalse();
    }
    
    @Test
    @DisplayName("Should handle reservation cancellation")
    void testReservationCancellation() {
        // Create and confirm reservation
        testReservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        testRoom.setStatus(Room.RoomStatus.RESERVED);
        
        assertThat(testReservation.canCancel()).isTrue();
        
        // Cancel reservation
        testReservation.setStatus(Reservation.ReservationStatus.CANCELLED);
        testRoom.setStatus(Room.RoomStatus.AVAILABLE);
        
        assertThat(testReservation.isCancelled()).isTrue();
        assertThat(testRoom.isAvailable()).isTrue();
        assertThat(testReservation.isActive()).isFalse();
    }
    
    @Test
    @DisplayName("Should apply discount correctly")
    void testReservationWithDiscount() {
        // Set up reservation with discount
        testReservation.setDiscountAmount(new BigDecimal("100.00"));
        
        // Calculate amounts
        testReservation.calculateAmounts(
            testRoom.getPricePerNight(),
            10.0,
            5.0
        );
        
        // Total: 150 * 5 = 750
        // After discount: 750 - 100 = 650
        // Tax: 650 * 0.10 = 65
        // Service: 650 * 0.05 = 32.50
        // Final: 650 + 65 + 32.50 = 747.50
        
        assertThat(testReservation.getFinalAmount())
            .isEqualByComparingTo(new BigDecimal("747.50"));
    }
    
    @Test
    @DisplayName("Should validate business rules")
    void testReservationBusinessRules() {
        // Cannot check-in before check-in date
        testReservation.setCheckInDate(LocalDate.now().plusDays(1));
        testReservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(testReservation.canCheckIn()).isFalse();
        
        // Cannot check-out if not checked in
        testReservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(testReservation.canCheckOut()).isFalse();
        
        // Cannot cancel after check-in
        testReservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        assertThat(testReservation.canCancel()).isFalse();
        
        // Cannot cancel after check-out
        testReservation.setStatus(Reservation.ReservationStatus.CHECKED_OUT);
        assertThat(testReservation.canCancel()).isFalse();
    }
}
