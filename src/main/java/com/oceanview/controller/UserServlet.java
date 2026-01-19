package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import com.oceanview.service.AuthenticationService;
import com.oceanview.util.Constants;
import com.oceanview.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * User Servlet
 * Handles user management operations (Admin only)
 * URL Mapping: /user (configured in web.xml)
 * 
 * @author Ocean View Resort Development Team
 * @version 1.0.0
 */
public class UserServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(UserServlet.class);
    private UserDAO userDAO;
    private AuthenticationService authService;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        authService = new AuthenticationService();
        logger.info("UserServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "view":
                viewUser(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "profile":
                viewProfile(request, response);
                break;
            default:
                listUsers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            updateUser(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * List all users
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<User> users = userDAO.findAll();
            request.setAttribute("users", users);
            
            // Calculate statistics for dashboard
            long totalUsers = users.size();
            long adminCount = users.stream().filter(u -> u.getRole() == User.Role.ADMIN).count();
            long staffCount = users.stream().filter(u -> u.getRole() == User.Role.STAFF).count();
            long guestCount = users.stream().filter(u -> u.getRole() == User.Role.GUEST).count();
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("staffCount", staffCount);
            request.setAttribute("guestCount", guestCount);
            
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
            
        } catch (SQLException e) {
            logger.error("Error listing users", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading users");
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
        }
    }
    
    /**
     * View user details
     */
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            return;
        }
        
        try {
            int userId = Integer.parseInt(idStr);
            Optional<User> userOpt = userDAO.findById(userId);
            
            if (userOpt.isPresent()) {
                request.setAttribute("viewUser", userOpt.get());
                request.getRequestDispatcher("/views/admin/user-details.jsp").forward(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "User not found");
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            logger.error("Error viewing user", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading user");
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
        }
    }
    
    /**
     * Show edit form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            return;
        }
        
        try {
            int userId = Integer.parseInt(idStr);
            Optional<User> userOpt = userDAO.findById(userId);
            
            if (userOpt.isPresent()) {
                request.setAttribute("editUser", userOpt.get());
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "User not found");
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            logger.error("Error loading user for edit", e);
            request.setAttribute(Constants.ATTR_ERROR, "Error loading user");
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
        }
    }
    
    /**
     * Update user
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String userIdStr = request.getParameter("userId");
            
            if (!ValidationUtil.isValidInteger(userIdStr)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
                return;
            }
            
            int userId = Integer.parseInt(userIdStr);
            Optional<User> userOpt = userDAO.findById(userId);
            
            if (userOpt.isEmpty()) {
                request.setAttribute(Constants.ATTR_ERROR, "User not found");
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
                return;
            }
            
            User user = userOpt.get();
            
            // Update user properties
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            user.setFullName(request.getParameter("fullName"));
            user.setPhone(request.getParameter("phone"));
            user.setRole(User.Role.valueOf(request.getParameter("role")));
            user.setStatus(User.Status.valueOf(request.getParameter("status")));
            
            boolean success = userDAO.update(user);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute(Constants.ATTR_SUCCESS, Constants.MSG_PROFILE_UPDATED);
                response.sendRedirect(request.getContextPath() + "/user?action=view&id=" + userId);
            } else {
                request.setAttribute(Constants.ATTR_ERROR, "Failed to update user");
                request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            logger.error("Error updating user", e);
            request.setAttribute(Constants.ATTR_ERROR, "Failed to update user");
            request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete user
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (!ValidationUtil.isValidInteger(idStr)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            return;
        }
        
        try {
            int userId = Integer.parseInt(idStr);
            boolean success = userDAO.delete(userId);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute(Constants.ATTR_SUCCESS, "User deleted successfully!");
            } else {
                session.setAttribute(Constants.ATTR_ERROR, "Failed to delete user");
            }
            
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            
        } catch (SQLException e) {
            logger.error("Error deleting user", e);
            HttpSession session = request.getSession();
            session.setAttribute(Constants.ATTR_ERROR, "Failed to delete user");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    /**
     * View current user profile
     */
    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }
    
    /**
     * Change password
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate
        if (ValidationUtil.isEmpty(oldPassword) || ValidationUtil.isEmpty(newPassword)) {
            request.setAttribute(Constants.ATTR_ERROR, "All fields are required");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute(Constants.ATTR_ERROR, "New passwords do not match");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }
        
        boolean success = authService.changePassword(user.getUserId(), oldPassword, newPassword);
        
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS, "Password changed successfully!");
            response.sendRedirect(request.getContextPath() + "/user?action=profile");
        } else {
            request.setAttribute(Constants.ATTR_ERROR, "Failed to change password. Check your old password.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
        }
    }
}
