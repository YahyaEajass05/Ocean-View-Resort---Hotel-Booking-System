package com.oceanview.util;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for PasswordUtil
 */
@DisplayName("PasswordUtil Tests")
class PasswordUtilTest {
    
    @Test
    @DisplayName("Should hash password successfully")
    void testHashPassword() {
        String plainPassword = "MySecurePassword123";
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        
        assertThat(hashedPassword).isNotNull();
        assertThat(hashedPassword).isNotEqualTo(plainPassword);
        assertThat(hashedPassword).startsWith("$2a$");
    }
    
    @Test
    @DisplayName("Should verify correct password")
    void testVerifyCorrectPassword() {
        String plainPassword = "MySecurePassword123";
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        
        boolean result = PasswordUtil.verifyPassword(plainPassword, hashedPassword);
        
        assertThat(result).isTrue();
    }
    
    @Test
    @DisplayName("Should reject incorrect password")
    void testVerifyIncorrectPassword() {
        String plainPassword = "MySecurePassword123";
        String wrongPassword = "WrongPassword456";
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        
        boolean result = PasswordUtil.verifyPassword(wrongPassword, hashedPassword);
        
        assertThat(result).isFalse();
    }
    
    @Test
    @DisplayName("Should generate different hashes for same password")
    void testDifferentHashesForSamePassword() {
        String plainPassword = "MySecurePassword123";
        String hash1 = PasswordUtil.hashPassword(plainPassword);
        String hash2 = PasswordUtil.hashPassword(plainPassword);
        
        // BCrypt uses salt, so hashes should be different
        assertThat(hash1).isNotEqualTo(hash2);
        
        // But both should verify correctly
        assertThat(PasswordUtil.verifyPassword(plainPassword, hash1)).isTrue();
        assertThat(PasswordUtil.verifyPassword(plainPassword, hash2)).isTrue();
    }
    
    @Test
    @DisplayName("Should handle empty password verification gracefully")
    void testEmptyPasswordVerification() {
        String hashedPassword = PasswordUtil.hashPassword("test");
        
        boolean result = PasswordUtil.verifyPassword("", hashedPassword);
        
        assertThat(result).isFalse();
    }
}
