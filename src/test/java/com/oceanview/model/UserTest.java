package com.oceanview.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for User model
 */
@DisplayName("User Model Tests")
class UserTest {
    
    private User user;
    
    @BeforeEach
    void setUp() {
        user = new User();
    }
    
    @Test
    @DisplayName("Should create user with default values")
    void testDefaultConstructor() {
        assertThat(user.getRole()).isEqualTo(User.Role.GUEST);
        assertThat(user.getStatus()).isEqualTo(User.Status.ACTIVE);
        assertThat(user.getCreatedAt()).isNotNull();
    }
    
    @Test
    @DisplayName("Should create user with parameters")
    void testParameterizedConstructor() {
        User user = new User("testuser", "password123", "test@example.com", "Test User", User.Role.ADMIN);
        
        assertThat(user.getUsername()).isEqualTo("testuser");
        assertThat(user.getPassword()).isEqualTo("password123");
        assertThat(user.getEmail()).isEqualTo("test@example.com");
        assertThat(user.getFullName()).isEqualTo("Test User");
        assertThat(user.getRole()).isEqualTo(User.Role.ADMIN);
    }
    
    @Test
    @DisplayName("Should correctly identify admin role")
    void testIsAdmin() {
        user.setRole(User.Role.ADMIN);
        assertThat(user.isAdmin()).isTrue();
        assertThat(user.isStaff()).isFalse();
        assertThat(user.isGuest()).isFalse();
    }
    
    @Test
    @DisplayName("Should correctly identify staff role")
    void testIsStaff() {
        user.setRole(User.Role.STAFF);
        assertThat(user.isStaff()).isTrue();
        assertThat(user.isAdmin()).isFalse();
        assertThat(user.isGuest()).isFalse();
    }
    
    @Test
    @DisplayName("Should correctly identify guest role")
    void testIsGuest() {
        user.setRole(User.Role.GUEST);
        assertThat(user.isGuest()).isTrue();
        assertThat(user.isAdmin()).isFalse();
        assertThat(user.isStaff()).isFalse();
    }
    
    @Test
    @DisplayName("Should correctly identify active status")
    void testIsActive() {
        user.setStatus(User.Status.ACTIVE);
        assertThat(user.isActive()).isTrue();
        assertThat(user.isSuspended()).isFalse();
    }
    
    @Test
    @DisplayName("Should correctly identify suspended status")
    void testIsSuspended() {
        user.setStatus(User.Status.SUSPENDED);
        assertThat(user.isSuspended()).isTrue();
        assertThat(user.isActive()).isFalse();
    }
    
    @Test
    @DisplayName("Should set and get all properties")
    void testGettersAndSetters() {
        user.setUserId(1);
        user.setUsername("johndoe");
        user.setPassword("hashed_password");
        user.setEmail("john@example.com");
        user.setFullName("John Doe");
        user.setPhone("+1234567890");
        user.setRole(User.Role.STAFF);
        user.setStatus(User.Status.ACTIVE);
        
        LocalDateTime now = LocalDateTime.now();
        user.setLastLogin(now);
        user.setUpdatedAt(now);
        
        assertThat(user.getUserId()).isEqualTo(1);
        assertThat(user.getUsername()).isEqualTo("johndoe");
        assertThat(user.getPassword()).isEqualTo("hashed_password");
        assertThat(user.getEmail()).isEqualTo("john@example.com");
        assertThat(user.getFullName()).isEqualTo("John Doe");
        assertThat(user.getPhone()).isEqualTo("+1234567890");
        assertThat(user.getRole()).isEqualTo(User.Role.STAFF);
        assertThat(user.getStatus()).isEqualTo(User.Status.ACTIVE);
        assertThat(user.getLastLogin()).isEqualTo(now);
        assertThat(user.getUpdatedAt()).isEqualTo(now);
    }
    
    @Test
    @DisplayName("Should implement equals correctly")
    void testEquals() {
        User user1 = new User();
        user1.setUserId(1);
        user1.setUsername("testuser");
        
        User user2 = new User();
        user2.setUserId(1);
        user2.setUsername("testuser");
        
        User user3 = new User();
        user3.setUserId(2);
        user3.setUsername("otheruser");
        
        assertThat(user1).isEqualTo(user2);
        assertThat(user1).isNotEqualTo(user3);
        assertThat(user1).isNotEqualTo(null);
        assertThat(user1).isEqualTo(user1);
    }
    
    @Test
    @DisplayName("Should implement hashCode correctly")
    void testHashCode() {
        User user1 = new User();
        user1.setUserId(1);
        user1.setUsername("testuser");
        
        User user2 = new User();
        user2.setUserId(1);
        user2.setUsername("testuser");
        
        assertThat(user1.hashCode()).isEqualTo(user2.hashCode());
    }
    
    @Test
    @DisplayName("Should generate meaningful toString")
    void testToString() {
        user.setUserId(1);
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        user.setFullName("Test User");
        user.setRole(User.Role.GUEST);
        user.setStatus(User.Status.ACTIVE);
        
        String result = user.toString();
        
        assertThat(result)
            .contains("userId=1")
            .contains("username='testuser'")
            .contains("email='test@example.com'")
            .contains("role=GUEST")
            .contains("status=ACTIVE");
    }
}
