<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
    String pageTitle = request.getParameter("title");
    String pageCss = request.getParameter("css");
    String activeMenu = request.getParameter("active");
    
    if (pageTitle == null) pageTitle = "Ocean View Resort";
    
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg = (String) session.getAttribute("errorMessage");
    String infoMsg = (String) session.getAttribute("infoMessage");
    
    // Clear messages after reading
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    session.removeAttribute("infoMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Ocean View Resort - Luxury Hotel Booking System">
    <meta name="keywords" content="hotel, resort, booking, ocean view, luxury accommodation">
    <meta name="author" content="Ocean View Resort">
    
    <title><%= pageTitle %> - Hotel Booking System</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="<%= contextPath %>/assets/images/logo/favicon.ico">
    
    <!-- CSS Files -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/main.css">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/header.css">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/footer.css">
    
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Additional Page-Specific CSS -->
    <% if (pageCss != null && !pageCss.isEmpty()) { %>
        <link rel="stylesheet" href="<%= contextPath %>/assets/css/<%= pageCss %>.css">
    <% } %>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <!-- Top Bar -->
        <div class="header-top">
            <div class="container">
                <div class="header-contact">
                    <a href="tel:+94112345678">
                        <i class="fas fa-phone"></i>
                        <span>+94 11 234 5678</span>
                    </a>
                    <a href="mailto:info@oceanviewresort.com">
                        <i class="fas fa-envelope"></i>
                        <span>info@oceanviewresort.com</span>
                    </a>
                </div>
                <div class="header-links">
                    <% if (currentUser != null) { %>
                        <span>Welcome, <%= currentUser.getFirstName() %>!</span>
                    <% } else { %>
                        <a href="<%= contextPath %>/login">Login</a>
                        <span>|</span>
                        <a href="<%= contextPath %>/register">Register</a>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Main Header -->
        <div class="header-main">
            <div class="container">
                <a href="<%= contextPath %>/" class="logo">
                    <img src="<%= contextPath %>/assets/images/logo/logo.png" alt="Ocean View Resort" onerror="this.style.display='none'">
                    <span>Ocean View Resort</span>
                </a>
                
                <button class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                </button>
                
                <nav class="nav">
                    <ul class="nav-menu" id="navMenu">
                        <li><a href="<%= contextPath %>/" class="<%= "home".equals(activeMenu) ? "active" : "" %>">Home</a></li>
                        <li><a href="<%= contextPath %>/rooms" class="<%= "rooms".equals(activeMenu) ? "active" : "" %>">Rooms</a></li>
                        <li><a href="<%= contextPath %>/about" class="<%= "about".equals(activeMenu) ? "active" : "" %>">About</a></li>
                        <li><a href="<%= contextPath %>/contact" class="<%= "contact".equals(activeMenu) ? "active" : "" %>">Contact</a></li>
                        
                        <% if (currentUser != null) {
                            String role = currentUser.getRole() != null ? currentUser.getRole().toString() : "";
                            if ("ADMIN".equals(role)) { %>
                                <li><a href="<%= contextPath %>/admin/dashboard" class="<%= "admin".equals(activeMenu) ? "active" : "" %>">Admin</a></li>
                            <% } else if ("STAFF".equals(role)) { %>
                                <li><a href="<%= contextPath %>/staff/dashboard" class="<%= "staff".equals(activeMenu) ? "active" : "" %>">Staff</a></li>
                            <% } else { %>
                                <li><a href="<%= contextPath %>/guest/dashboard" class="<%= "guest".equals(activeMenu) ? "active" : "" %>">My Account</a></li>
                            <% }
                        } %>
                    </ul>
                    
                    <% if (currentUser != null) { %>
                        <div class="nav-user">
                            <div class="user-dropdown">
                                <div class="user-avatar">
                                    <%= currentUser.getFirstName().charAt(0) %><%= currentUser.getLastName().charAt(0) %>
                                </div>
                                <div class="dropdown-menu">
                                    <a href="<%= contextPath %>/profile">
                                        <i class="fas fa-user"></i> My Profile
                                    </a>
                                    <% if ("GUEST".equals(currentUser.getRole().toString())) { %>
                                        <a href="<%= contextPath %>/guest/reservations">
                                            <i class="fas fa-calendar-check"></i> My Reservations
                                        </a>
                                        <a href="<%= contextPath %>/guest/reviews">
                                            <i class="fas fa-star"></i> My Reviews
                                        </a>
                                    <% } %>
                                    <a href="<%= contextPath %>/settings">
                                        <i class="fas fa-cog"></i> Settings
                                    </a>
                                    <a href="<%= contextPath %>/logout">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </nav>
            </div>
        </div>
    </header>
    
    <!-- Alert Messages -->
    <% if (successMsg != null) { %>
        <div class="container mt-2">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= successMsg %>
            </div>
        </div>
    <% } %>
    
    <% if (errorMsg != null) { %>
        <div class="container mt-2">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= errorMsg %>
            </div>
        </div>
    <% } %>
    
    <% if (infoMsg != null) { %>
        <div class="container mt-2">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <%= infoMsg %>
            </div>
        </div>
    <% } %>
    
    <!-- Main Content Start -->
    <main>
