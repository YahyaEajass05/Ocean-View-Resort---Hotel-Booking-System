<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"GUEST".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
    String guestName = currentUser.getFirstName() + " " + currentUser.getLastName();
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Guest Home" />
    <jsp:param name="css" value="dashboard,home" />
    <jsp:param name="active" value="guest" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="guest-home">
        <div class="container-fluid py-4">
            <!-- Welcome Section -->
            <div class="welcome-banner mb-4">
                <div class="welcome-content">
                    <h1><i class="fas fa-home"></i> Welcome back, <%= currentUser.getFirstName() %>!</h1>
                    <p class="lead">Enjoy your stay at Ocean View Resort</p>
                </div>
                <div class="welcome-actions">
                    <a href="<%= contextPath %>/guest/search-rooms" class="btn btn-primary btn-lg">
                        <i class="fas fa-search"></i> Browse Rooms
                    </a>
                    <a href="<%= contextPath %>/guest/my-bookings" class="btn btn-outline btn-lg">
                        <i class="fas fa-calendar-check"></i> My Bookings
                    </a>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card stat-card-primary">
                        <div class="stat-icon bg-primary">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">2</div>
                            <div class="stat-label">Active Bookings</div>
                        </div>
                        <a href="<%= contextPath %>/guest/my-bookings" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-success">
                        <div class="stat-icon bg-success">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">5</div>
                            <div class="stat-label">Reviews Written</div>
                        </div>
                        <a href="<%= contextPath %>/guest/reviews" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-info">
                        <div class="stat-icon bg-info">
                            <i class="fas fa-bed"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">12</div>
                            <div class="stat-label">Total Stays</div>
                        </div>
                        <a href="#" class="stat-link">View History <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-warning">
                        <div class="stat-icon bg-warning">
                            <i class="fas fa-gift"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">250</div>
                            <div class="stat-label">Loyalty Points</div>
                        </div>
                        <a href="#" class="stat-link">Redeem <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            
            <!-- Current Booking -->
            <div class="row mb-4">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-calendar-alt"></i> Current Booking</h3>
                        </div>
                        <div class="card-body">
                            <div class="current-booking-card">
                                <div class="booking-image">
                                    <img src="<%= contextPath %>/assets/images/rooms/deluxe-room.jpg" alt="Room" onerror="this.src='https://via.placeholder.com/300x200?text=Deluxe+Room'">
                                    <span class="booking-status badge-success">Confirmed</span>
                                </div>
                                <div class="booking-details">
                                    <h4>Deluxe Ocean View Room</h4>
                                    <div class="booking-info">
                                        <div class="info-item">
                                            <i class="fas fa-door-open"></i>
                                            <span>Room 205</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-calendar"></i>
                                            <span>Jan 25 - Jan 28, 2026</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-moon"></i>
                                            <span>3 Nights</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-users"></i>
                                            <span>2 Guests</span>
                                        </div>
                                    </div>
                                    <div class="booking-actions mt-3">
                                        <a href="<%= contextPath %>/guest/my-bookings" class="btn btn-primary">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                        <button class="btn btn-outline" onclick="alert('Modification requested')">
                                            <i class="fas fa-edit"></i> Modify
                                        </button>
                                        <button class="btn btn-danger" onclick="confirmCancel()">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <div class="card mb-3">
                        <div class="card-header">
                            <h3><i class="fas fa-tags"></i> Special Offers</h3>
                        </div>
                        <div class="card-body p-0">
                            <div class="offers-list">
                                <div class="offer-item">
                                    <div class="offer-icon bg-danger">
                                        <i class="fas fa-percent"></i>
                                    </div>
                                    <div class="offer-content">
                                        <div class="offer-title">20% Off Weekend Stay</div>
                                        <div class="offer-desc">Book 2 nights, save 20%</div>
                                    </div>
                                </div>
                                <div class="offer-item">
                                    <div class="offer-icon bg-success">
                                        <i class="fas fa-gift"></i>
                                    </div>
                                    <div class="offer-content">
                                        <div class="offer-title">Free Spa Treatment</div>
                                        <div class="offer-desc">On stays over 5 nights</div>
                                    </div>
                                </div>
                                <div class="offer-item">
                                    <div class="offer-icon bg-info">
                                        <i class="fas fa-utensils"></i>
                                    </div>
                                    <div class="offer-content">
                                        <div class="offer-title">Complimentary Breakfast</div>
                                        <div class="offer-desc">For all room types</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                </div>
                <div class="card-body">
                    <div class="quick-actions-grid">
                        <a href="<%= contextPath %>/guest/search-rooms" class="quick-action-card">
                            <div class="quick-action-icon bg-primary">
                                <i class="fas fa-search"></i>
                            </div>
                            <div class="quick-action-content">
                                <h5>Search Rooms</h5>
                                <p>Find your perfect room</p>
                            </div>
                        </a>
                        
                        <a href="<%= contextPath %>/guest/my-bookings" class="quick-action-card">
                            <div class="quick-action-icon bg-success">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="quick-action-content">
                                <h5>My Bookings</h5>
                                <p>View all reservations</p>
                            </div>
                        </a>
                        
                        <a href="<%= contextPath %>/guest/profile" class="quick-action-card">
                            <div class="quick-action-icon bg-info">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="quick-action-content">
                                <h5>My Profile</h5>
                                <p>Update your information</p>
                            </div>
                        </a>
                        
                        <a href="<%= contextPath %>/guest/reviews" class="quick-action-card">
                            <div class="quick-action-icon bg-warning">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="quick-action-content">
                                <h5>My Reviews</h5>
                                <p>Rate your experiences</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function confirmCancel() {
    if (confirm('Are you sure you want to cancel this booking? This action cannot be undone.')) {
        alert('Cancellation request submitted. You will receive a confirmation email shortly.');
    }
}
</script>

<style>
.welcome-banner {
    background: linear-gradient(135deg, var(--ocean-blue), var(--ocean-dark));
    color: white;
    padding: 3rem 2rem;
    border-radius: var(--radius-lg);
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 2rem;
}

.welcome-content h1 {
    color: white;
    margin-bottom: 0.5rem;
}

.welcome-actions {
    display: flex;
    gap: 1rem;
}

.stat-card {
    position: relative;
    overflow: hidden;
}

.stat-link {
    display: block;
    padding: 0.75rem;
    text-align: center;
    background-color: rgba(0, 0, 0, 0.05);
    color: inherit;
    text-decoration: none;
    font-size: 0.875rem;
    font-weight: 500;
    transition: all 0.3s;
}

.stat-link:hover {
    background-color: rgba(0, 0, 0, 0.1);
}

.current-booking-card {
    display: flex;
    gap: 2rem;
}

.booking-image {
    position: relative;
    width: 300px;
    height: 200px;
    border-radius: var(--radius-md);
    overflow: hidden;
}

.booking-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.booking-status {
    position: absolute;
    top: 1rem;
    right: 1rem;
    padding: 0.5rem 1rem;
    border-radius: var(--radius-md);
    color: white;
    font-weight: 600;
}

.booking-details {
    flex: 1;
}

.booking-details h4 {
    margin-bottom: 1rem;
    color: var(--ocean-dark);
}

.booking-info {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
    margin-bottom: 1rem;
}

.info-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #666;
}

.info-item i {
    color: var(--ocean-blue);
}

.booking-actions {
    display: flex;
    gap: 0.5rem;
}

.offers-list {
    display: flex;
    flex-direction: column;
}

.offer-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    border-bottom: 1px solid #e9ecef;
}

.offer-item:last-child {
    border-bottom: none;
}

.offer-icon {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.25rem;
}

.offer-title {
    font-weight: 600;
    margin-bottom: 0.25rem;
}

.offer-desc {
    font-size: 0.875rem;
    color: #666;
}

.quick-actions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
}

.quick-action-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 2rem;
    background-color: #f8f9fa;
    border-radius: var(--radius-lg);
    text-decoration: none;
    color: inherit;
    transition: all 0.3s;
    text-align: center;
}

.quick-action-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.quick-action-icon {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.75rem;
    margin-bottom: 1rem;
}

.quick-action-content h5 {
    margin-bottom: 0.5rem;
    color: var(--ocean-dark);
}

.quick-action-content p {
    margin: 0;
    font-size: 0.875rem;
    color: #666;
}

@media (max-width: 768px) {
    .welcome-banner {
        text-align: center;
        justify-content: center;
    }
    
    .welcome-actions {
        flex-direction: column;
        width: 100%;
    }
    
    .current-booking-card {
        flex-direction: column;
    }
    
    .booking-image {
        width: 100%;
    }
    
    .booking-info {
        grid-template-columns: 1fr;
    }
}
</style>

<jsp:include page="../common/footer.jsp" />
