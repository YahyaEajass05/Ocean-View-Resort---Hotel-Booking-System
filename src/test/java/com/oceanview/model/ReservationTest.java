package com.oceanview.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for Reservation model
 */
@DisplayName("Reservation Model Tests")
class ReservationTest {
    
    private Reservation reservation;
    
    @BeforeEach
    void setUp() {
        reservation = new Reservation();
    }
    
    @Test
    @DisplayName("Should create reservation with default values")
    void testDefaultConstructor() {
        assertThat(reservation.getStatus()).isEqualTo(Reservation.ReservationStatus.PENDING);
        assertThat(reservation.getCreatedAt()).isNotNull();
        assertThat(reservation.getTotalAmount()).isEqualTo(BigDecimal.ZERO);
        assertThat(reservation.getNumberOfGuests()).isEqualTo(1);
    }
    
    @Test
    @DisplayName("Should create reservation with parameters")
    void testParameterizedConstructor() {
        LocalDate checkIn = LocalDate.of(2024, 1, 15);
        LocalDate checkOut = LocalDate.of(2024, 1, 20);
        
        Reservation res = new Reservation(1, 2, checkIn, checkOut);
        
        assertThat(res.getGuestId()).isEqualTo(1);
        assertThat(res.getRoomId()).isEqualTo(2);
        assertThat(res.getCheckInDate()).isEqualTo(checkIn);
        assertThat(res.getCheckOutDate()).isEqualTo(checkOut);
        assertThat(res.getNumberOfNights()).isEqualTo(5);
    }
    
    @Test
    @DisplayName("Should calculate number of nights correctly")
    void testCalculateNights() {
        reservation.setCheckInDate(LocalDate.of(2024, 1, 15));
        reservation.setCheckOutDate(LocalDate.of(2024, 1, 20));
        
        assertThat(reservation.getNumberOfNights()).isEqualTo(5);
    }
    
    @Test
    @DisplayName("Should calculate amounts correctly")
    void testCalculateAmounts() {
        reservation.setCheckInDate(LocalDate.of(2024, 1, 15));
        reservation.setCheckOutDate(LocalDate.of(2024, 1, 20)); // 5 nights
        
        BigDecimal roomPrice = new BigDecimal("100.00");
        double taxPercentage = 10.0; // 10%
        double serviceCharge = 5.0;   // 5%
        
        reservation.calculateAmounts(roomPrice, taxPercentage, serviceCharge);
        
        // Total: 100 * 5 = 500
        assertThat(reservation.getTotalAmount()).isEqualTo(new BigDecimal("500.00"));
        
        // Tax: 500 * 0.10 = 50
        assertThat(reservation.getTaxAmount()).isEqualTo(new BigDecimal("50.00"));
        
        // Final: 500 + 50 + 25 = 575
        assertThat(reservation.getFinalAmount()).isEqualTo(new BigDecimal("575.00"));
    }
    
    @Test
    @DisplayName("Should calculate amounts with discount")
    void testCalculateAmountsWithDiscount() {
        reservation.setCheckInDate(LocalDate.of(2024, 1, 15));
        reservation.setCheckOutDate(LocalDate.of(2024, 1, 20)); // 5 nights
        reservation.setDiscountAmount(new BigDecimal("50.00"));
        
        BigDecimal roomPrice = new BigDecimal("100.00");
        double taxPercentage = 10.0;
        double serviceCharge = 5.0;
        
        reservation.calculateAmounts(roomPrice, taxPercentage, serviceCharge);
        
        // Total: 100 * 5 = 500
        // After discount: 500 - 50 = 450
        // Tax: 450 * 0.10 = 45
        // Service: 450 * 0.05 = 22.5
        // Final: 450 + 45 + 22.5 = 517.5
        
        assertThat(reservation.getFinalAmount()).isEqualByComparingTo(new BigDecimal("517.50"));
    }
    
    @Test
    @DisplayName("Should identify reservation status correctly")
    void testStatusChecks() {
        reservation.setStatus(Reservation.ReservationStatus.PENDING);
        assertThat(reservation.isPending()).isTrue();
        assertThat(reservation.isConfirmed()).isFalse();
        
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(reservation.isConfirmed()).isTrue();
        assertThat(reservation.isPending()).isFalse();
        
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        assertThat(reservation.isCheckedIn()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_OUT);
        assertThat(reservation.isCheckedOut()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CANCELLED);
        assertThat(reservation.isCancelled()).isTrue();
    }
    
    @Test
    @DisplayName("Should check if reservation is active")
    void testIsActive() {
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(reservation.isActive()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        assertThat(reservation.isActive()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.PENDING);
        assertThat(reservation.isActive()).isFalse();
        
        reservation.setStatus(Reservation.ReservationStatus.CANCELLED);
        assertThat(reservation.isActive()).isFalse();
    }
    
    @Test
    @DisplayName("Should check if can check-in")
    void testCanCheckIn() {
        LocalDate today = LocalDate.now();
        reservation.setCheckInDate(today);
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        
        assertThat(reservation.canCheckIn()).isTrue();
        
        // Cannot check in if not confirmed
        reservation.setStatus(Reservation.ReservationStatus.PENDING);
        assertThat(reservation.canCheckIn()).isFalse();
        
        // Cannot check in if date is in future
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        reservation.setCheckInDate(today.plusDays(1));
        assertThat(reservation.canCheckIn()).isFalse();
    }
    
    @Test
    @DisplayName("Should check if can check-out")
    void testCanCheckOut() {
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        assertThat(reservation.canCheckOut()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(reservation.canCheckOut()).isFalse();
    }
    
    @Test
    @DisplayName("Should check if can cancel")
    void testCanCancel() {
        reservation.setStatus(Reservation.ReservationStatus.PENDING);
        assertThat(reservation.canCancel()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CONFIRMED);
        assertThat(reservation.canCancel()).isTrue();
        
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_IN);
        assertThat(reservation.canCancel()).isFalse();
        
        reservation.setStatus(Reservation.ReservationStatus.CHECKED_OUT);
        assertThat(reservation.canCancel()).isFalse();
    }
    
    @Test
    @DisplayName("Should set associated objects correctly")
    void testAssociatedObjects() {
        Room room = new Room();
        room.setRoomId(10);
        reservation.setRoom(room);
        
        assertThat(reservation.getRoomId()).isEqualTo(10);
        assertThat(reservation.getRoom()).isEqualTo(room);
        
        Guest guest = new Guest();
        guest.setGuestId(5);
        reservation.setGuest(guest);
        
        assertThat(reservation.getGuestId()).isEqualTo(5);
        assertThat(reservation.getGuest()).isEqualTo(guest);
    }
}
