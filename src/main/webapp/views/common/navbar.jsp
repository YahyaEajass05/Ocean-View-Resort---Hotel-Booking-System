<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
    String activeMenu = request.getParameter("active");
    if (activeMenu == null) activeMenu = "";
    
    String userRole = "";
    String userFullName = "";
    String userInitials = "";
    
    if (currentUser != null) {
        userRole = currentUser.getRole() != null ? currentUser.getRole().toString() : "";
        userFullName = currentUser.getFirstName() + " " + currentUser.getLastName();
        userInitials = String.valueOf(currentUser.getFirstName().charAt(0)) + 
                      String.valueOf(currentUser.getLastName().charAt(0));
    }
%>

<!-- Navigation Bar Component -->
<nav class="navbar" role="navigation" aria-label="Main navigation">
    <div class="navbar-container">
        <!-- Brand/Logo Section -->
        <div class="navbar-brand">
            <a href="<%= contextPath %>/" class="brand-link" aria-label="Ocean View Resort Home">
                <img src="<%= contextPath %>/assets/images/logo/logo.png" 
                     alt="Ocean View Resort Logo" 
                     class="brand-logo"
                     onerror="this.style.display='none'">
                <span class="brand-text">Ocean View Resort</span>
            </a>
        </div>
        
        <!-- Mobile Menu Toggle -->
        <button class="navbar-toggle" 
                id="navbarToggle" 
                aria-label="Toggle navigation"
                aria-expanded="false"
                aria-controls="navbarMenu">
            <span class="toggle-icon"></span>
            <span class="toggle-icon"></span>
            <span class="toggle-icon"></span>
        </button>
        
        <!-- Navigation Menu -->
        <div class="navbar-menu" id="navbarMenu">
            <ul class="navbar-nav" role="menubar">
                <!-- Public Navigation Items -->
                <li class="nav-item" role="none">
                    <a href="<%= contextPath %>/" 
                       class="nav-link <%= "home".equals(activeMenu) ? "active" : "" %>"
                       role="menuitem">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                
                <li class="nav-item" role="none">
                    <a href="<%= contextPath %>/rooms" 
                       class="nav-link <%= "rooms".equals(activeMenu) ? "active" : "" %>"
                       role="menuitem">
                        <i class="fas fa-bed"></i>
                        <span>Rooms & Suites</span>
                    </a>
                </li>
                
                <li class="nav-item" role="none">
                    <a href="<%= contextPath %>/offers" 
                       class="nav-link <%= "offers".equals(activeMenu) ? "active" : "" %>"
                       role="menuitem">
                        <i class="fas fa-tags"></i>
                        <span>Special Offers</span>
                    </a>
                </li>
                
                <li class="nav-item" role="none">
                    <a href="<%= contextPath %>/about" 
                       class="nav-link <%= "about".equals(activeMenu) ? "active" : "" %>"
                       role="menuitem">
                        <i class="fas fa-info-circle"></i>
                        <span>About Us</span>
                    </a>
                </li>
                
                <li class="nav-item" role="none">
                    <a href="<%= contextPath %>/contact" 
                       class="nav-link <%= "contact".equals(activeMenu) ? "active" : "" %>"
                       role="menuitem">
                        <i class="fas fa-envelope"></i>
                        <span>Contact</span>
                    </a>
                </li>
                
                <!-- Role-Based Navigation -->
                <% if (currentUser != null) {
                    if ("ADMIN".equals(userRole)) { %>
                        <li class="nav-item nav-item-special" role="none">
                            <a href="<%= contextPath %>/admin/dashboard" 
                               class="nav-link <%= "admin-dashboard".equals(activeMenu) ? "active" : "" %>"
                               role="menuitem">
                                <i class="fas fa-shield-alt"></i>
                                <span>Admin Panel</span>
                            </a>
                        </li>
                    <% } else if ("STAFF".equals(userRole)) { %>
                        <li class="nav-item nav-item-special" role="none">
                            <a href="<%= contextPath %>/staff/dashboard" 
                               class="nav-link <%= "staff-dashboard".equals(activeMenu) ? "active" : "" %>"
                               role="menuitem">
                                <i class="fas fa-user-tie"></i>
                                <span>Staff Panel</span>
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item nav-item-special" role="none">
                            <a href="<%= contextPath %>/guest/dashboard" 
                               class="nav-link <%= "guest-dashboard".equals(activeMenu) ? "active" : "" %>"
                               role="menuitem">
                                <i class="fas fa-user"></i>
                                <span>My Dashboard</span>
                            </a>
                        </li>
                    <% }
                } %>
            </ul>
            
            <!-- User Section or Auth Buttons -->
            <div class="navbar-actions">
                <% if (currentUser != null) { %>
                    <!-- User Dropdown -->
                    <div class="user-menu-container">
                        <button class="user-menu-toggle" 
                                id="userMenuToggle"
                                aria-label="User menu"
                                aria-expanded="false"
                                aria-haspopup="true">
                            <div class="user-avatar">
                                <%= userInitials %>
                            </div>
                            <div class="user-info">
                                <span class="user-name"><%= userFullName %></span>
                                <span class="user-role"><%= userRole %></span>
                            </div>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        
                        <div class="user-dropdown-menu" 
                             id="userDropdownMenu"
                             role="menu"
                             aria-hidden="true">
                            <div class="dropdown-header">
                                <div class="user-avatar-large">
                                    <%= userInitials %>
                                </div>
                                <div>
                                    <div class="dropdown-username"><%= userFullName %></div>
                                    <div class="dropdown-email"><%= currentUser.getEmail() %></div>
                                </div>
                            </div>
                            
                            <div class="dropdown-divider"></div>
                            
                            <a href="<%= contextPath %>/profile" 
                               class="dropdown-item" 
                               role="menuitem">
                                <i class="fas fa-user"></i>
                                <span>My Profile</span>
                            </a>
                            
                            <% if ("GUEST".equals(userRole)) { %>
                                <a href="<%= contextPath %>/guest/reservations" 
                                   class="dropdown-item" 
                                   role="menuitem">
                                    <i class="fas fa-calendar-check"></i>
                                    <span>My Reservations</span>
                                </a>
                                
                                <a href="<%= contextPath %>/guest/reviews" 
                                   class="dropdown-item" 
                                   role="menuitem">
                                    <i class="fas fa-star"></i>
                                    <span>My Reviews</span>
                                </a>
                            <% } %>
                            
                            <a href="<%= contextPath %>/settings" 
                               class="dropdown-item" 
                               role="menuitem">
                                <i class="fas fa-cog"></i>
                                <span>Settings</span>
                            </a>
                            
                            <div class="dropdown-divider"></div>
                            
                            <a href="<%= contextPath %>/logout" 
                               class="dropdown-item dropdown-item-danger" 
                               role="menuitem">
                                <i class="fas fa-sign-out-alt"></i>
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Authentication Buttons -->
                    <div class="auth-buttons">
                        <a href="<%= contextPath %>/login" 
                           class="btn btn-outline btn-sm">
                            <i class="fas fa-sign-in-alt"></i>
                            Login
                        </a>
                        <a href="<%= contextPath %>/register" 
                           class="btn btn-primary btn-sm">
                            <i class="fas fa-user-plus"></i>
                            Register
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- Navbar JavaScript -->
<script>
(function() {
    'use strict';
    
    // Mobile menu toggle
    const navbarToggle = document.getElementById('navbarToggle');
    const navbarMenu = document.getElementById('navbarMenu');
    
    if (navbarToggle && navbarMenu) {
        navbarToggle.addEventListener('click', function() {
            const isExpanded = navbarMenu.classList.toggle('active');
            navbarToggle.classList.toggle('active');
            navbarToggle.setAttribute('aria-expanded', isExpanded);
        });
    }
    
    // User menu dropdown toggle
    const userMenuToggle = document.getElementById('userMenuToggle');
    const userDropdownMenu = document.getElementById('userDropdownMenu');
    
    if (userMenuToggle && userDropdownMenu) {
        userMenuToggle.addEventListener('click', function(e) {
            e.stopPropagation();
            const isExpanded = userDropdownMenu.classList.toggle('active');
            userMenuToggle.setAttribute('aria-expanded', isExpanded);
            userDropdownMenu.setAttribute('aria-hidden', !isExpanded);
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!userMenuToggle.contains(e.target) && !userDropdownMenu.contains(e.target)) {
                userDropdownMenu.classList.remove('active');
                userMenuToggle.setAttribute('aria-expanded', 'false');
                userDropdownMenu.setAttribute('aria-hidden', 'true');
            }
        });
    }
    
    // Close mobile menu when clicking on a link
    const navLinks = document.querySelectorAll('.navbar-menu .nav-link');
    navLinks.forEach(function(link) {
        link.addEventListener('click', function() {
            if (navbarMenu && navbarMenu.classList.contains('active')) {
                navbarMenu.classList.remove('active');
                if (navbarToggle) {
                    navbarToggle.classList.remove('active');
                    navbarToggle.setAttribute('aria-expanded', 'false');
                }
            }
        });
    });
    
    // Highlight active menu item on scroll (for single-page sections)
    window.addEventListener('scroll', function() {
        const sections = document.querySelectorAll('section[id]');
        const scrollY = window.pageYOffset;
        
        sections.forEach(function(section) {
            const sectionHeight = section.offsetHeight;
            const sectionTop = section.offsetTop - 100;
            const sectionId = section.getAttribute('id');
            
            if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                const activeLink = document.querySelector('.navbar-menu a[href*="' + sectionId + '"]');
                if (activeLink) {
                    document.querySelectorAll('.navbar-menu .nav-link').forEach(function(link) {
                        link.classList.remove('active');
                    });
                    activeLink.classList.add('active');
                }
            }
        });
    });
})();
</script>

<style>
/* Navbar Component Styles */
.navbar {
    background-color: var(--white);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
    width: 100%;
}

.navbar-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 var(--spacing-lg);
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 70px;
}

.navbar-brand .brand-link {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    text-decoration: none;
    color: var(--ocean-dark);
}

.brand-logo {
    height: 45px;
    width: auto;
}

.brand-text {
    font-size: 1.5rem;
    font-weight: 700;
    background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.navbar-toggle {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
    z-index: 1001;
}

.toggle-icon {
    width: 25px;
    height: 3px;
    background-color: var(--ocean-dark);
    transition: all 0.3s ease;
    border-radius: 2px;
}

.navbar-toggle.active .toggle-icon:nth-child(1) {
    transform: rotate(45deg) translate(8px, 8px);
}

.navbar-toggle.active .toggle-icon:nth-child(2) {
    opacity: 0;
}

.navbar-toggle.active .toggle-icon:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -7px);
}

.navbar-menu {
    display: flex;
    align-items: center;
    gap: var(--spacing-xl);
    flex: 1;
    margin-left: var(--spacing-xl);
}

.navbar-nav {
    display: flex;
    list-style: none;
    gap: var(--spacing-sm);
    margin: 0;
    padding: 0;
}

.nav-item {
    position: relative;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: var(--spacing-xs);
    padding: var(--spacing-sm) var(--spacing-md);
    color: var(--text-color);
    text-decoration: none;
    font-weight: 500;
    border-radius: var(--radius-md);
    transition: all var(--transition-fast);
    white-space: nowrap;
}

.nav-link i {
    font-size: 1rem;
}

.nav-link:hover {
    background-color: var(--ocean-light);
    color: var(--ocean-blue);
    transform: translateY(-2px);
}

.nav-link.active {
    background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
    color: var(--white);
}

.nav-item-special .nav-link {
    background-color: var(--gold-accent);
    color: var(--white);
}

.nav-item-special .nav-link:hover {
    background-color: #c19b2e;
}

.navbar-actions {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    margin-left: auto;
}

/* User Menu */
.user-menu-container {
    position: relative;
}

.user-menu-toggle {
    display: flex;
    align-items: center;
    gap: var(--spacing-sm);
    padding: var(--spacing-sm) var(--spacing-md);
    background-color: var(--ocean-light);
    border: 2px solid transparent;
    border-radius: var(--radius-lg);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.user-menu-toggle:hover {
    border-color: var(--ocean-blue);
    background-color: var(--white);
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
    color: var(--white);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 0.9rem;
}

.user-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.user-name {
    font-weight: 600;
    color: var(--text-color);
    font-size: 0.9rem;
}

.user-role {
    font-size: 0.75rem;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.user-dropdown-menu {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    min-width: 280px;
    background-color: var(--white);
    border-radius: var(--radius-lg);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all var(--transition-fast);
    overflow: hidden;
}

.user-dropdown-menu.active {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-header {
    padding: var(--spacing-lg);
    background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
    color: var(--white);
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
}

.user-avatar-large {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.2);
    color: var(--white);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 1.1rem;
}

.dropdown-username {
    font-weight: 600;
    font-size: 1rem;
}

.dropdown-email {
    font-size: 0.85rem;
    opacity: 0.9;
}

.dropdown-divider {
    height: 1px;
    background-color: var(--border-color);
    margin: var(--spacing-xs) 0;
}

.dropdown-item {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    padding: var(--spacing-md) var(--spacing-lg);
    color: var(--text-color);
    text-decoration: none;
    transition: all var(--transition-fast);
}

.dropdown-item:hover {
    background-color: var(--ocean-light);
    color: var(--ocean-blue);
}

.dropdown-item i {
    width: 20px;
    text-align: center;
}

.dropdown-item-danger {
    color: var(--danger);
}

.dropdown-item-danger:hover {
    background-color: rgba(220, 53, 69, 0.1);
    color: var(--danger);
}

/* Auth Buttons */
.auth-buttons {
    display: flex;
    gap: var(--spacing-sm);
}

/* Responsive Design */
@media (max-width: 992px) {
    .navbar-toggle {
        display: flex;
    }
    
    .navbar-menu {
        position: fixed;
        top: 70px;
        left: -100%;
        width: 80%;
        max-width: 350px;
        height: calc(100vh - 70px);
        background-color: var(--white);
        flex-direction: column;
        align-items: stretch;
        padding: var(--spacing-lg);
        box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1);
        transition: left 0.3s ease;
        overflow-y: auto;
        margin: 0;
        gap: var(--spacing-lg);
    }
    
    .navbar-menu.active {
        left: 0;
    }
    
    .navbar-nav {
        flex-direction: column;
        gap: var(--spacing-xs);
        width: 100%;
    }
    
    .nav-link {
        padding: var(--spacing-md);
        width: 100%;
    }
    
    .navbar-actions {
        width: 100%;
        margin: 0;
        flex-direction: column;
    }
    
    .user-menu-toggle {
        width: 100%;
        justify-content: flex-start;
    }
    
    .user-dropdown-menu {
        position: static;
        box-shadow: none;
        border-top: 1px solid var(--border-color);
        margin-top: var(--spacing-sm);
    }
    
    .auth-buttons {
        flex-direction: column;
        width: 100%;
    }
    
    .auth-buttons .btn {
        width: 100%;
        justify-content: center;
    }
    
    .user-info {
        flex: 1;
    }
}

@media (max-width: 480px) {
    .brand-text {
        font-size: 1.2rem;
    }
    
    .brand-logo {
        height: 35px;
    }
    
    .navbar-container {
        padding: 0 var(--spacing-md);
    }
}
</style>
