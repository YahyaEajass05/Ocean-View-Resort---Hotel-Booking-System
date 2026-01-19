<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="My Reservations" />
    <jsp:param name="css" value="reservations" />
    <jsp:param name="active" value="guest" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>My Reservations</h1>
        <p>View and manage all your bookings</p>
    </div>
</div>

<div class="reservations-page">
    <div class="container">
        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <button class="tab-btn active" data-filter="all">All Reservations</button>
            <button class="tab-btn" data-filter="upcoming">Upcoming</button>
            <button class="tab-btn" data-filter="active">Active</button>
            <button class="tab-btn" data-filter="completed">Completed</button>
            <button class="tab-btn" data-filter="cancelled">Cancelled</button>
        </div>
        
        <!-- Reservations List -->
        <c:choose>
            <c:when test="${not empty reservations}">
                <div class="reservations-container">
                    <c:forEach items="${reservations}" var="reservation">
                        <div class="reservation-item" data-status="${reservation.status}">
                            <div class="reservation-card-full">
                                <div class="reservation-image-large">
                                    <img src="${pageContext.request.contextPath}/assets/images/rooms/${reservation.room.roomType.name().toLowerCase()}.jpg" 
                                         alt="${reservation.room.roomType}">
                                    <span class="status-badge badge-${reservation.status == 'CONFIRMED' ? 'success' : 
                                                                      reservation.status == 'PENDING' ? 'warning' : 
                                                                      reservation.status == 'CHECKED_IN' ? 'info' : 
                                                                      reservation.status == 'CHECKED_OUT' ? 'secondary' : 'danger'}">
                                        ${reservation.status}
                                    </span>
                                </div>
                                
                                <div class="reservation-content">
                                    <div class="reservation-header">
                                        <div>
                                            <h3>${reservation.room.roomType} - Room ${reservation.room.roomNumber}</h3>
                                            <p class="reservation-id">Booking ID: #${reservation.id}</p>
                                        </div>
                                        <div class="reservation-price">
                                            <span class="price-label">Total Amount</span>
                                            <span class="price-value">$<fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00" /></span>
                                        </div>
                                    </div>
                                    
                                    <div class="reservation-details-grid">
                                        <div class="detail-item">
                                            <i class="fas fa-calendar-check"></i>
                                            <div>
                                                <span class="detail-label">Check-in</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${reservation.checkInDate}" pattern="MMM dd, yyyy" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <i class="fas fa-calendar-times"></i>
                                            <div>
                                                <span class="detail-label">Check-out</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${reservation.checkOutDate}" pattern="MMM dd, yyyy" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <i class="fas fa-moon"></i>
                                            <div>
                                                <span class="detail-label">Nights</span>
                                                <span class="detail-value">${reservation.numberOfNights} night(s)</span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <i class="fas fa-users"></i>
                                            <div>
                                                <span class="detail-label">Guests</span>
                                                <span class="detail-value">${reservation.numberOfGuests} guest(s)</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty reservation.specialRequests}">
                                        <div class="special-requests">
                                            <strong>Special Requests:</strong>
                                            <p>${reservation.specialRequests}</p>
                                        </div>
                                    </c:if>
                                    
                                    <div class="reservation-actions">
                                        <a href="${pageContext.request.contextPath}/guest/reservations/${reservation.id}" 
                                           class="btn btn-primary">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                        
                                        <c:choose>
                                            <c:when test="${reservation.status == 'CONFIRMED'}">
                                                <button class="btn btn-warning" onclick="modifyReservation(${reservation.id})">
                                                    <i class="fas fa-edit"></i> Modify
                                                </button>
                                                <button class="btn btn-danger" onclick="cancelReservation(${reservation.id})">
                                                    <i class="fas fa-times"></i> Cancel
                                                </button>
                                            </c:when>
                                            <c:when test="${reservation.status == 'CHECKED_OUT'}">
                                                <a href="${pageContext.request.contextPath}/guest/reviews/new?reservationId=${reservation.id}" 
                                                   class="btn btn-success">
                                                    <i class="fas fa-star"></i> Write Review
                                                </a>
                                                <a href="${pageContext.request.contextPath}/billing/${reservation.id}/invoice" 
                                                   class="btn btn-secondary">
                                                    <i class="fas fa-file-invoice"></i> Download Invoice
                                                </a>
                                            </c:when>
                                            <c:when test="${reservation.status == 'CHECKED_IN'}">
                                                <a href="${pageContext.request.contextPath}/guest/reservations/${reservation.id}/services" 
                                                   class="btn btn-info">
                                                    <i class="fas fa-concierge-bell"></i> Request Service
                                                </a>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h2>No Reservations Found</h2>
                    <p>You haven't made any reservations yet. Start exploring our rooms!</p>
                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary btn-lg">
                        <i class="fas fa-bed"></i> Browse Rooms
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
// Filter tabs functionality
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        // Update active tab
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        
        const filter = this.getAttribute('data-filter');
        const items = document.querySelectorAll('.reservation-item');
        
        items.forEach(item => {
            if (filter === 'all') {
                item.style.display = 'block';
            } else {
                const status = item.getAttribute('data-status').toLowerCase();
                if (filter === 'upcoming' && (status === 'confirmed' || status === 'pending')) {
                    item.style.display = 'block';
                } else if (filter === 'active' && status === 'checked_in') {
                    item.style.display = 'block';
                } else if (filter === 'completed' && status === 'checked_out') {
                    item.style.display = 'block';
                } else if (filter === 'cancelled' && status === 'cancelled') {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            }
        });
    });
});

function cancelReservation(reservationId) {
    if (confirm('Are you sure you want to cancel this reservation? This action cannot be undone.')) {
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
            console.error('Error:', error);
            alert('An error occurred. Please try again.');
        });
    }
}

function modifyReservation(reservationId) {
    window.location.href = '${pageContext.request.contextPath}/guest/reservations/' + reservationId + '/modify';
}
</script>

<jsp:include page="../common/footer.jsp" />
