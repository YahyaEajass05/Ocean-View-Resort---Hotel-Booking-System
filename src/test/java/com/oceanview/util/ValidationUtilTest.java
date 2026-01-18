package com.oceanview.util;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for ValidationUtil
 */
@DisplayName("ValidationUtil Tests")
class ValidationUtilTest {
    
    @Test
    @DisplayName("Should accept valid email addresses")
    void testValidEmails() {
        assertThat(ValidationUtil.isValidEmail("test@example.com")).isTrue();
        assertThat(ValidationUtil.isValidEmail("user.name@example.com")).isTrue();
        assertThat(ValidationUtil.isValidEmail("user+tag@example.co.uk")).isTrue();
        assertThat(ValidationUtil.isValidEmail("user_123@test-domain.com")).isTrue();
    }
    
    @Test
    @DisplayName("Should reject invalid email addresses")
    void testInvalidEmails() {
        assertThat(ValidationUtil.isValidEmail("invalid.email")).isFalse();
        assertThat(ValidationUtil.isValidEmail("@example.com")).isFalse();
        assertThat(ValidationUtil.isValidEmail("user@")).isFalse();
        assertThat(ValidationUtil.isValidEmail("user @example.com")).isFalse();
        assertThat(ValidationUtil.isValidEmail("user@example")).isFalse();
        assertThat(ValidationUtil.isValidEmail("")).isFalse();
    }
    
    @Test
    @DisplayName("Should reject null email")
    void testNullEmail() {
        assertThat(ValidationUtil.isValidEmail(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should accept valid phone numbers")
    void testValidPhoneNumbers() {
        assertThat(ValidationUtil.isValidPhone("+1234567890")).isTrue();
        assertThat(ValidationUtil.isValidPhone("1234567890")).isTrue();
        assertThat(ValidationUtil.isValidPhone("+12345678901234")).isTrue();
    }
    
    @Test
    @DisplayName("Should reject invalid phone numbers")
    void testInvalidPhoneNumbers() {
        assertThat(ValidationUtil.isValidPhone("123")).isFalse(); // Too short
        assertThat(ValidationUtil.isValidPhone("abc1234567")).isFalse(); // Contains letters
        assertThat(ValidationUtil.isValidPhone("+123 456 789")).isFalse(); // Contains spaces
    }
    
    @Test
    @DisplayName("Should accept null or empty phone (optional field)")
    void testOptionalPhone() {
        assertThat(ValidationUtil.isValidPhone(null)).isTrue();
        assertThat(ValidationUtil.isValidPhone("")).isTrue();
    }
    
    @Test
    @DisplayName("Should accept valid usernames")
    void testValidUsernames() {
        assertThat(ValidationUtil.isValidUsername("user123")).isTrue();
        assertThat(ValidationUtil.isValidUsername("test_user")).isTrue();
        assertThat(ValidationUtil.isValidUsername("user.name")).isTrue();
        assertThat(ValidationUtil.isValidUsername("user-name")).isTrue();
        assertThat(ValidationUtil.isValidUsername("abc")).isTrue();
    }
    
    @Test
    @DisplayName("Should reject invalid usernames")
    void testInvalidUsernames() {
        assertThat(ValidationUtil.isValidUsername("ab")).isFalse(); // Too short
        assertThat(ValidationUtil.isValidUsername("a")).isFalse(); // Too short
        assertThat(ValidationUtil.isValidUsername("user@name")).isFalse(); // Invalid character
        assertThat(ValidationUtil.isValidUsername("user name")).isFalse(); // Contains space
        assertThat(ValidationUtil.isValidUsername("verylongusernamethatexceedstwentycharacters")).isFalse(); // Too long
    }
    
    @Test
    @DisplayName("Should validate password minimum length")
    void testPasswordValidation() {
        assertThat(ValidationUtil.isValidPassword("12345678")).isTrue();
        assertThat(ValidationUtil.isValidPassword("password")).isTrue();
        assertThat(ValidationUtil.isValidPassword("short")).isFalse();
        assertThat(ValidationUtil.isValidPassword(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should validate date range correctly")
    void testValidDateRange() {
        LocalDate start = LocalDate.of(2024, 1, 15);
        LocalDate end = LocalDate.of(2024, 1, 20);
        
        assertThat(ValidationUtil.isValidDateRange(start, end)).isTrue();
        assertThat(ValidationUtil.isValidDateRange(start, start)).isTrue(); // Same day valid
        assertThat(ValidationUtil.isValidDateRange(end, start)).isFalse(); // End before start
    }
    
    @Test
    @DisplayName("Should check if string is empty")
    void testIsEmpty() {
        assertThat(ValidationUtil.isEmpty(null)).isTrue();
        assertThat(ValidationUtil.isEmpty("")).isTrue();
        assertThat(ValidationUtil.isEmpty("   ")).isTrue();
        assertThat(ValidationUtil.isEmpty("text")).isFalse();
    }
    
    @Test
    @DisplayName("Should sanitize input strings")
    void testSanitize() {
        assertThat(ValidationUtil.sanitize("<script>alert('xss')</script>"))
            .isEqualTo("&lt;script&gt;alert(&#x27;xss&#x27;)&lt;&#x2F;script&gt;");
        
        assertThat(ValidationUtil.sanitize("normal text")).isEqualTo("normal text");
        assertThat(ValidationUtil.sanitize(null)).isNull();
    }
    
    @Test
    @DisplayName("Should validate integer strings")
    void testIsValidInteger() {
        assertThat(ValidationUtil.isValidInteger("123")).isTrue();
        assertThat(ValidationUtil.isValidInteger("-456")).isTrue();
        assertThat(ValidationUtil.isValidInteger("abc")).isFalse();
        assertThat(ValidationUtil.isValidInteger("12.34")).isFalse();
        assertThat(ValidationUtil.isValidInteger(null)).isFalse();
    }
    
    @Test
    @DisplayName("Should validate double strings")
    void testIsValidDouble() {
        assertThat(ValidationUtil.isValidDouble("123.45")).isTrue();
        assertThat(ValidationUtil.isValidDouble("-67.89")).isTrue();
        assertThat(ValidationUtil.isValidDouble("100")).isTrue();
        assertThat(ValidationUtil.isValidDouble("abc")).isFalse();
        assertThat(ValidationUtil.isValidDouble(null)).isFalse();
    }
}
