<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Guest Dashboard" />
    <jsp:param name="css" value="dashboard" />
    <jsp:param name="active" value="guest" />
</jsp:include>

<div class="dashboard-page">
    <div class="container">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div>
                <h1>Welcome back, ${sessionScope.user.firstName}!</h1>
                <p>Manage your reservations and explore our services</p>
            </div>
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Reservation
            </a>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #006994, #4A90A4);">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-info">
                    <h3>${upcomingReservations != null ? upcomingReservations : 0}</h3>
                    <p>Upcoming Reservations</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #28A745, #20c997);">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>${completedReservations != null ? completedReservations : 0}</h3>
                    <p>Completed Stays</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #D4AF37, #FFD700);">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-info">
                    <h3>${loyaltyPoints != null ? loyaltyPoints : 0}</h3>
                    <p>Loyalty Points</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #FF6B6B, #ee5a6f);">
                    <i class="fas fa-tags"></i>
                </div>
                <div class="stat-info">
                    <h3>${availableOffers != null ? availableOffers : 0}</h3>
                    <p>Special Offers</p>
                </div>
            </div>
        </div>
        
        <!-- Main Content Grid -->
        <div class="dashboard-grid">
            <!-- Current Reservations -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2><i class="fas fa-calendar-alt"></i> Current Reservations</h2>
                    <a href="${pageContext.request.contextPath}/guest/reservations" class="btn btn-sm btn-outline">
                        View All
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${not empty currentReservations}">
                        <div class="reservations-list">
                            <c:forEach items="${currentReservations}" var="reservation" begin="0" end="2">
                                <div class="reservation-card">
                                    <div class="reservation-image">
                                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${reservation.room.roomType.name().toLowerCase()}.jpg" 
                                             alt="${reservation.room.roomType}">
                                        <span class="badge badge-${reservation.status == 'CONFIRMED' ? 'success' : 
                                                                    reservation.status == 'PENDING' ? 'warning' : 'info'}">
                                            ${reservation.status}
                                        </span>
                                    </div>
                                    <div class="reservation-details">
                                        <h3>${reservation.room.roomType} - Room ${reservation.room.roomNumber}</h3>
                                        <div class="reservation-info">
                                            <div class="info-item">
                                                <i class="fas fa-calendar"></i>
                                                <span>Check-in: <fmt:formatDate value="${reservation.checkInDate}" pattern="MMM dd, yyyy" /></span>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-calendar"></i>
                                                <span>Check-out: <fmt:formatDate value="${reservation.checkOutDate}" pattern="MMM dd, yyyy" /></span>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-users"></i>
                                                <span>${reservation.numberOfGuests} Guest(s)</span>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-dollar-sign"></i>
                                                <span>Total: $<fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00" /></span>
                                            </div>
                                        </div>
                                        <div class="reservation-actions">
                                            <a href="${pageContext.request.contextPath}/guest/reservations/${reservation.id}" 
                                               class="btn btn-sm btn-primary">View Details</a>
                                            <c:if test="${reservation.status == 'CONFIRMED'}">
                                                <button class="btn btn-sm btn-secondary" onclick="cancelReservation(${reservation.id})">
                                                    Cancel
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h3>No Active Reservations</h3>
                            <p>You don't have any reservations at the moment.</p>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">
                                Browse Rooms
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Quick Actions -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
                </div>
                
                <div class="quick-actions">
                    <a href="${pageContext.request.contextPath}/rooms" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-bed"></i>
                        </div>
                        <div class="action-content">
                            <h4>Book a Room</h4>
                            <p>Find your perfect stay</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/guest/reservations" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-list"></i>
                        </div>
                        <div class="action-content">
                            <h4>My Reservations</h4>
                            <p>View all bookings</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/guest/reviews" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="action-content">
                            <h4>Write Review</h4>
                            <p>Share your experience</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/profile" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <div class="action-content">
                            <h4>Update Profile</h4>
                            <p>Manage your account</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/offers" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-gift"></i>
                        </div>
                        <div class="action-content">
                            <h4>Special Offers</h4>
                            <p>Exclusive deals for you</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/contact" class="action-card">
                        <div class="action-icon">
                            <i class="fas fa-headset"></i>
                        </div>
                        <div class="action-content">
                            <h4>Support</h4>
                            <p>Get help anytime</p>
                        </div>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Recent Reviews -->
        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-comment-dots"></i> Recent Reviews</h2>
                <a href="${pageContext.request.contextPath}/guest/reviews" class="btn btn-sm btn-outline">
                    View All
                </a>
            </div>
            
            <c:choose>
                <c:when test="${not empty recentReviews}">
                    <div class="reviews-grid">
                        <c:forEach items="${recentReviews}" var="review" begin="0" end="2">
                            <div class="review-card">
                                <div class="review-header">
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= review.rating ? '' : 'far'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="review-date">
                                        <fmt:formatDate value="${review.createdAt}" pattern="MMM dd, yyyy" />
                                    </span>
                                </div>
                                <h4>${review.title}</h4>
                                <p>${review.comment}</p>
                                <div class="review-footer">
                                    <span class="badge badge-${review.status == 'APPROVED' ? 'success' : 
                                                              review.status == 'PENDING' ? 'warning' : 'secondary'}">
                                        ${review.status}
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-small">
                        <i class="fas fa-star"></i>
                        <p>You haven't written any reviews yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
function cancelReservation(reservationId) {
    if (confirm('Are you sure you want to cancel this reservation?')) {
        fetch('${pageContext.request.contextPath}/guest/reservations/' + reservationId + '/cancel', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Reservation cancelled successfully');
                location.reload();
            } else {
                alert('Failed to cancel reservation: ' + data.message);
            }
        })
        .catch(error => {
            alert('An error occurred. Please try again.');
        });
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
