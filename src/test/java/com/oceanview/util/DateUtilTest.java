package com.oceanview.util;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for DateUtil
 */
@DisplayName("DateUtil Tests")
class DateUtilTest {
    
    @Test
    @DisplayName("Should format date correctly")
    void testFormatDate() {
        LocalDate date = LocalDate.of(2024, 1, 15);
        String formatted = DateUtil.formatDate(date);
        
        assertThat(formatted).isEqualTo("2024-01-15");
    }
    
    @Test
    @DisplayName("Should format date for display")
    void testFormatDateForDisplay() {
        LocalDate date = LocalDate.of(2024, 1, 15);
        String formatted = DateUtil.formatDateForDisplay(date);
        
        assertThat(formatted).isEqualTo("15 Jan 2024");
    }
    
    @Test
    @DisplayName("Should parse date string correctly")
    void testParseDate() {
        LocalDate parsed = DateUtil.parseDate("2024-01-15");
        
        assertThat(parsed).isEqualTo(LocalDate.of(2024, 1, 15));
    }
    
    @Test
    @DisplayName("Should return null for invalid date string")
    void testParseInvalidDate() {
        assertThat(DateUtil.parseDate("invalid")).isNull();
        assertThat(DateUtil.parseDate(null)).isNull();
        assertThat(DateUtil.parseDate("")).isNull();
    }
    
    @Test
    @DisplayName("Should calculate days between dates")
    void testDaysBetween() {
        LocalDate start = LocalDate.of(2024, 1, 15);
        LocalDate end = LocalDate.of(2024, 1, 20);
        
        long days = DateUtil.daysBetween(start, end);
        
        assertThat(days).isEqualTo(5);
    }
    
    @Test
    @DisplayName("Should calculate number of nights")
    void testCalculateNights() {
        LocalDate checkIn = LocalDate.of(2024, 1, 15);
        LocalDate checkOut = LocalDate.of(2024, 1, 20);
        
        int nights = DateUtil.calculateNights(checkIn, checkOut);
        
        assertThat(nights).isEqualTo(5);
    }
    
    @Test
    @DisplayName("Should check if date is in past")
    void testIsPast() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        
        assertThat(DateUtil.isPast(yesterday)).isTrue();
        assertThat(DateUtil.isPast(tomorrow)).isFalse();
        assertThat(DateUtil.isPast(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should check if date is in future")
    void testIsFuture() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        
        assertThat(DateUtil.isFuture(tomorrow)).isTrue();
        assertThat(DateUtil.isFuture(yesterday)).isFalse();
        assertThat(DateUtil.isFuture(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should check if date is today")
    void testIsToday() {
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        
        assertThat(DateUtil.isToday(today)).isTrue();
        assertThat(DateUtil.isToday(yesterday)).isFalse();
        assertThat(DateUtil.isToday(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should add days to date")
    void testAddDays() {
        LocalDate date = LocalDate.of(2024, 1, 15);
        LocalDate result = DateUtil.addDays(date, 5);
        
        assertThat(result).isEqualTo(LocalDate.of(2024, 1, 20));
    }
    
    @Test
    @DisplayName("Should subtract days from date")
    void testSubtractDays() {
        LocalDate date = LocalDate.of(2024, 1, 20);
        LocalDate result = DateUtil.subtractDays(date, 5);
        
        assertThat(result).isEqualTo(LocalDate.of(2024, 1, 15));
    }
    
    @Test
    @DisplayName("Should validate date range")
    void testIsValidDateRange() {
        LocalDate start = LocalDate.of(2024, 1, 15);
        LocalDate end = LocalDate.of(2024, 1, 20);
        
        assertThat(DateUtil.isValidDateRange(start, end)).isTrue();
        assertThat(DateUtil.isValidDateRange(end, start)).isFalse();
        assertThat(DateUtil.isValidDateRange(null, end)).isFalse();
    }
    
    @Test
    @DisplayName("Should check if dates overlap")
    void testDatesOverlap() {
        LocalDate start1 = LocalDate.of(2024, 1, 15);
        LocalDate end1 = LocalDate.of(2024, 1, 20);
        LocalDate start2 = LocalDate.of(2024, 1, 18);
        LocalDate end2 = LocalDate.of(2024, 1, 25);
        
        assertThat(DateUtil.datesOverlap(start1, end1, start2, end2)).isTrue();
        
        LocalDate start3 = LocalDate.of(2024, 1, 25);
        LocalDate end3 = LocalDate.of(2024, 1, 30);
        
        assertThat(DateUtil.datesOverlap(start1, end1, start3, end3)).isFalse();
    }
    
    @Test
    @DisplayName("Should format date range as string")
    void testGetDateRangeString() {
        LocalDate start = LocalDate.of(2024, 1, 15);
        LocalDate end = LocalDate.of(2024, 1, 20);
        
        String result = DateUtil.getDateRangeString(start, end);
        
        assertThat(result).isEqualTo("15 Jan 2024 - 20 Jan 2024");
    }
    
    @Test
    @DisplayName("Should get current date")
    void testGetCurrentDate() {
        LocalDate current = DateUtil.getCurrentDate();
        
        assertThat(current).isEqualTo(LocalDate.now());
    }
    
    @Test
    @DisplayName("Should get current datetime")
    void testGetCurrentDateTime() {
        LocalDateTime current = DateUtil.getCurrentDateTime();
        
        assertThat(current).isNotNull();
        assertThat(current).isBeforeOrEqualTo(LocalDateTime.now());
    }
}
