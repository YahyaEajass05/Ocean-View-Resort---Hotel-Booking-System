package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import com.oceanview.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;

import java.sql.SQLException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for AuthenticationService
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("AuthenticationService Tests")
class AuthenticationServiceTest {
    
    @Mock
    private UserDAO userDAO;
    
    @InjectMocks
    private AuthenticationService authService;
    
    private User testUser;
    
    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setUserId(1);
        testUser.setUsername("testuser");
        testUser.setPassword("hashedPassword");
        testUser.setEmail("test@example.com");
        testUser.setFullName("Test User");
        testUser.setRole(User.Role.GUEST);
        testUser.setStatus(User.Status.ACTIVE);
    }
    
    @Test
    @DisplayName("Should authenticate user with correct credentials")
    void testAuthenticateSuccess() throws SQLException {
        // Given
        String plainPassword = "password123";
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        testUser.setPassword(hashedPassword);
        
        when(userDAO.findByUsername("testuser")).thenReturn(Optional.of(testUser));
        
        // When
        Optional<User> result = authService.authenticate("testuser", plainPassword);
        
        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getUsername()).isEqualTo("testuser");
        verify(userDAO).findByUsername("testuser");
        verify(userDAO).updateLastLogin(1);
    }
    
    @Test
    @DisplayName("Should fail authentication with incorrect password")
    void testAuthenticateWrongPassword() throws SQLException {
        // Given
        String correctPassword = "password123";
        String wrongPassword = "wrongpassword";
        String hashedPassword = PasswordUtil.hashPassword(correctPassword);
        testUser.setPassword(hashedPassword);
        
        when(userDAO.findByUsername("testuser")).thenReturn(Optional.of(testUser));
        
        // When
        Optional<User> result = authService.authenticate("testuser", wrongPassword);
        
        // Then
        assertThat(result).isEmpty();
        verify(userDAO).findByUsername("testuser");
        verify(userDAO, never()).updateLastLogin(anyInt());
    }
    
    @Test
    @DisplayName("Should fail authentication with non-existent user")
    void testAuthenticateNonExistentUser() throws SQLException {
        // Given
        when(userDAO.findByUsername("nonexistent")).thenReturn(Optional.empty());
        
        // When
        Optional<User> result = authService.authenticate("nonexistent", "password");
        
        // Then
        assertThat(result).isEmpty();
        verify(userDAO).findByUsername("nonexistent");
        verify(userDAO, never()).updateLastLogin(anyInt());
    }
    
    @Test
    @DisplayName("Should fail authentication for inactive user")
    void testAuthenticateInactiveUser() throws SQLException {
        // Given
        testUser.setStatus(User.Status.INACTIVE);
        when(userDAO.findByUsername("testuser")).thenReturn(Optional.of(testUser));
        
        // When
        Optional<User> result = authService.authenticate("testuser", "password");
        
        // Then
        assertThat(result).isEmpty();
    }
    
    @Test
    @DisplayName("Should fail authentication for suspended user")
    void testAuthenticateSuspendedUser() throws SQLException {
        // Given
        testUser.setStatus(User.Status.SUSPENDED);
        when(userDAO.findByUsername("testuser")).thenReturn(Optional.of(testUser));
        
        // When
        Optional<User> result = authService.authenticate("testuser", "password");
        
        // Then
        assertThat(result).isEmpty();
    }
    
    @Test
    @DisplayName("Should register new user successfully")
    void testRegisterSuccess() throws SQLException {
        // Given
        User newUser = new User();
        newUser.setUsername("newuser");
        newUser.setPassword("password123");
        newUser.setEmail("new@example.com");
        newUser.setFullName("New User");
        
        when(userDAO.findByUsername("newuser")).thenReturn(Optional.empty());
        when(userDAO.findByEmail("new@example.com")).thenReturn(Optional.empty());
        when(userDAO.create(any(User.class))).thenReturn(1);
        
        // When
        int result = authService.register(newUser);
        
        // Then
        assertThat(result).isEqualTo(1);
        verify(userDAO).findByUsername("newuser");
        verify(userDAO).findByEmail("new@example.com");
        verify(userDAO).create(any(User.class));
    }
    
    @Test
    @DisplayName("Should fail registration with duplicate username")
    void testRegisterDuplicateUsername() throws SQLException {
        // Given
        User newUser = new User();
        newUser.setUsername("testuser");
        newUser.setEmail("new@example.com");
        
        when(userDAO.findByUsername("testuser")).thenReturn(Optional.of(testUser));
        
        // When
        int result = authService.register(newUser);
        
        // Then
        assertThat(result).isEqualTo(-1); // Username exists
        verify(userDAO).findByUsername("testuser");
        verify(userDAO, never()).create(any(User.class));
    }
    
    @Test
    @DisplayName("Should fail registration with duplicate email")
    void testRegisterDuplicateEmail() throws SQLException {
        // Given
        User newUser = new User();
        newUser.setUsername("newuser");
        newUser.setEmail("test@example.com");
        
        when(userDAO.findByUsername("newuser")).thenReturn(Optional.empty());
        when(userDAO.findByEmail("test@example.com")).thenReturn(Optional.of(testUser));
        
        // When
        int result = authService.register(newUser);
        
        // Then
        assertThat(result).isEqualTo(-2); // Email exists
        verify(userDAO).findByUsername("newuser");
        verify(userDAO).findByEmail("test@example.com");
        verify(userDAO, never()).create(any(User.class));
    }
    
    @Test
    @DisplayName("Should change password successfully")
    void testChangePasswordSuccess() throws SQLException {
        // Given
        String oldPassword = "oldpass123";
        String newPassword = "newpass456";
        String hashedOldPassword = PasswordUtil.hashPassword(oldPassword);
        testUser.setPassword(hashedOldPassword);
        
        when(userDAO.findById(1)).thenReturn(Optional.of(testUser));
        when(userDAO.update(any(User.class))).thenReturn(true);
        
        // When
        boolean result = authService.changePassword(1, oldPassword, newPassword);
        
        // Then
        assertThat(result).isTrue();
        verify(userDAO).findById(1);
        verify(userDAO).update(any(User.class));
    }
    
    @Test
    @DisplayName("Should fail password change with incorrect old password")
    void testChangePasswordWrongOldPassword() throws SQLException {
        // Given
        String oldPassword = "oldpass123";
        String wrongOldPassword = "wrongpass";
        String newPassword = "newpass456";
        String hashedOldPassword = PasswordUtil.hashPassword(oldPassword);
        testUser.setPassword(hashedOldPassword);
        
        when(userDAO.findById(1)).thenReturn(Optional.of(testUser));
        
        // When
        boolean result = authService.changePassword(1, wrongOldPassword, newPassword);
        
        // Then
        assertThat(result).isFalse();
        verify(userDAO).findById(1);
        verify(userDAO, never()).update(any(User.class));
    }
}
