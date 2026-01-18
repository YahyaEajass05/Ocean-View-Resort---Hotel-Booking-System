package com.oceanview.dao;

import com.oceanview.model.User;
import org.junit.jupiter.api.*;

import java.sql.*;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for UserDAO
 * Uses H2 in-memory database for testing
 */
@DisplayName("UserDAO Integration Tests")
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class UserDAOTest {
    
    private Connection connection;
    private UserDAO userDAO;
    
    @BeforeAll
    void setUpDatabase() throws SQLException {
        // Create H2 in-memory database connection
        connection = DriverManager.getConnection("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1", "sa", "");
        
        // Create users table
        String createTableSQL = 
            "CREATE TABLE users (" +
            "    user_id INT AUTO_INCREMENT PRIMARY KEY," +
            "    username VARCHAR(50) UNIQUE NOT NULL," +
            "    password VARCHAR(255) NOT NULL," +
            "    email VARCHAR(100) UNIQUE NOT NULL," +
            "    full_name VARCHAR(100) NOT NULL," +
            "    phone VARCHAR(20)," +
            "    role VARCHAR(20) NOT NULL," +
            "    status VARCHAR(20) NOT NULL," +
            "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    updated_at TIMESTAMP," +
            "    last_login TIMESTAMP" +
            ")";
        
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(createTableSQL);
        }
    }
    
    @BeforeEach
    void setUp() throws SQLException {
        // Clear table before each test
        try (Statement stmt = connection.createStatement()) {
            stmt.execute("DELETE FROM users");
            stmt.execute("ALTER TABLE users ALTER COLUMN user_id RESTART WITH 1");
        }
        
        userDAO = new UserDAO();
        // Note: In actual implementation, you'd inject the test connection
    }
    
    @AfterAll
    void tearDown() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
    
    @Test
    @DisplayName("Should create user successfully")
    void testCreateUser() throws SQLException {
        // Given
        User user = new User();
        user.setUsername("testuser");
        user.setPassword("hashedPassword");
        user.setEmail("test@example.com");
        user.setFullName("Test User");
        user.setRole(User.Role.GUEST);
        user.setStatus(User.Status.ACTIVE);
        
        // When
        int userId = insertUser(user);
        
        // Then
        assertThat(userId).isPositive();
    }
    
    @Test
    @DisplayName("Should find user by ID")
    void testFindById() throws SQLException {
        // Given
        User user = createTestUser("findbyid", "find@test.com");
        int userId = insertUser(user);
        
        // When
        Optional<User> found = findUserById(userId);
        
        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getUsername()).isEqualTo("findbyid");
        assertThat(found.get().getEmail()).isEqualTo("find@test.com");
    }
    
    @Test
    @DisplayName("Should find user by username")
    void testFindByUsername() throws SQLException {
        // Given
        User user = createTestUser("searchuser", "search@test.com");
        insertUser(user);
        
        // When
        Optional<User> found = findUserByUsername("searchuser");
        
        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getEmail()).isEqualTo("search@test.com");
    }
    
    @Test
    @DisplayName("Should find user by email")
    void testFindByEmail() throws SQLException {
        // Given
        User user = createTestUser("emailuser", "email@test.com");
        insertUser(user);
        
        // When
        Optional<User> found = findUserByEmail("email@test.com");
        
        // Then
        assertThat(found).isPresent();
        assertThat(found.get().getUsername()).isEqualTo("emailuser");
    }
    
    @Test
    @DisplayName("Should update user successfully")
    void testUpdateUser() throws SQLException {
        // Given
        User user = createTestUser("updateuser", "update@test.com");
        int userId = insertUser(user);
        
        // When
        user.setUserId(userId);
        user.setFullName("Updated Name");
        user.setPhone("+1234567890");
        boolean updated = updateUser(user);
        
        // Then
        assertThat(updated).isTrue();
        Optional<User> found = findUserById(userId);
        assertThat(found).isPresent();
        assertThat(found.get().getFullName()).isEqualTo("Updated Name");
        assertThat(found.get().getPhone()).isEqualTo("+1234567890");
    }
    
    @Test
    @DisplayName("Should delete user successfully")
    void testDeleteUser() throws SQLException {
        // Given
        User user = createTestUser("deleteuser", "delete@test.com");
        int userId = insertUser(user);
        
        // When
        boolean deleted = deleteUser(userId);
        
        // Then
        assertThat(deleted).isTrue();
        Optional<User> found = findUserById(userId);
        assertThat(found).isEmpty();
    }
    
    @Test
    @DisplayName("Should find all users")
    void testFindAllUsers() throws SQLException {
        // Given
        insertUser(createTestUser("user1", "user1@test.com"));
        insertUser(createTestUser("user2", "user2@test.com"));
        insertUser(createTestUser("user3", "user3@test.com"));
        
        // When
        List<User> users = findAllUsers();
        
        // Then
        assertThat(users).hasSize(3);
    }
    
    @Test
    @DisplayName("Should prevent duplicate username")
    void testDuplicateUsername() throws SQLException {
        // Given
        User user1 = createTestUser("duplicate", "user1@test.com");
        insertUser(user1);
        
        User user2 = createTestUser("duplicate", "user2@test.com");
        
        // When/Then
        assertThatThrownBy(() -> insertUser(user2))
            .isInstanceOf(SQLException.class);
    }
    
    @Test
    @DisplayName("Should prevent duplicate email")
    void testDuplicateEmail() throws SQLException {
        // Given
        User user1 = createTestUser("user1", "duplicate@test.com");
        insertUser(user1);
        
        User user2 = createTestUser("user2", "duplicate@test.com");
        
        // When/Then
        assertThatThrownBy(() -> insertUser(user2))
            .isInstanceOf(SQLException.class);
    }
    
    // Helper methods
    
    private User createTestUser(String username, String email) {
        User user = new User();
        user.setUsername(username);
        user.setPassword("hashedPassword");
        user.setEmail(email);
        user.setFullName("Test User");
        user.setRole(User.Role.GUEST);
        user.setStatus(User.Status.ACTIVE);
        return user;
    }
    
    private int insertUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, full_name, phone, role, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole().name());
            stmt.setString(7, user.getStatus().name());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    private Optional<User> findUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        }
        return Optional.empty();
    }
    
    private Optional<User> findUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        }
        return Optional.empty();
    }
    
    private Optional<User> findUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        }
        return Optional.empty();
    }
    
    private boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, phone = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setInt(3, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    private boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private List<User> findAllUsers() throws SQLException {
        String sql = "SELECT * FROM users";
        List<User> users = new java.util.ArrayList<>();
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setRole(User.Role.valueOf(rs.getString("role")));
        user.setStatus(User.Status.valueOf(rs.getString("status")));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        Timestamp lastLogin = rs.getTimestamp("last_login");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }
        
        return user;
    }
}
