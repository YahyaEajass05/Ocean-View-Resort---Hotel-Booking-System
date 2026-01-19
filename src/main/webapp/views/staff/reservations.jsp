<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Reservations" />
    <jsp:param name="css" value="staff" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>Manage Reservations</h1>
        <p>View and manage all hotel reservations</p>
    </div>
</div>

<div class="staff-page">
    <div class="container">
        <!-- Search & Filter -->
        <div class="search-filter-section">
            <form class="search-form-staff" id="searchForm">
                <div class="form-group">
                    <label for="searchGuest">Search Guest</label>
                    <input type="text" id="searchGuest" class="form-control" 
                           placeholder="Name, Email, or Phone">
                </div>
                
                <div class="form-group">
                    <label for="searchRoom">Room Number</label>
                    <input type="text" id="searchRoom" class="form-control" 
                           placeholder="Room number">
                </div>
                
                <div class="form-group">
                    <label for="filterStatus">Status</label>
                    <select id="filterStatus" class="form-control">
                        <option value="">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="CONFIRMED">Confirmed</option>
                        <option value="CHECKED_IN">Checked In</option>
                        <option value="CHECKED_OUT">Checked Out</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="filterDate">Date Range</label>
                    <select id="filterDate" class="form-control">
                        <option value="all">All Dates</option>
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                        <option value="custom">Custom Range</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
                <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                    <i class="fas fa-redo"></i> Reset
                </button>
            </form>
        </div>
        
        <!-- Action Buttons -->
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/staff/reservations/new" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Reservation
            </a>
            <button class="btn btn-success" onclick="exportReservations()">
                <i class="fas fa-file-export"></i> Export
            </button>
        </div>
        
        <!-- Reservations Table -->
        <div class="dashboard-section">
            <div class="table-responsive">
                <table class="table" id="reservationsTable">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="selectAll" onclick="toggleSelectAll()">
                            </th>
                            <th>Booking ID</th>
                            <th>Guest Details</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Guests</th>
                            <th>Status</th>
                            <th>Amount</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <c:forEach items="${reservations}" var="reservation">
                                    <tr data-reservation-id="${reservation.id}">
                                        <td>
                                            <input type="checkbox" class="reservation-checkbox" value="${reservation.id}">
                                        </td>
                                        <td>
                                            <strong>#${reservation.id}</strong>
                                        </td>
                                        <td>
                                            <div class="guest-cell">
                                                <strong>${reservation.guest.firstName} ${reservation.guest.lastName}</strong><br>
                                                <small><i class="fas fa-envelope"></i> ${reservation.guest.email}</small><br>
                                                <small><i class="fas fa-phone"></i> ${reservation.guest.phone}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <strong>${reservation.room.roomNumber}</strong><br>
                                            <small>${reservation.room.roomType}</small>
                                        </td>
                                        <td><fmt:formatDate value="${reservation.checkInDate}" pattern="MMM dd, yyyy" /></td>
                                        <td><fmt:formatDate value="${reservation.checkOutDate}" pattern="MMM dd, yyyy" /></td>
                                        <td>${reservation.numberOfGuests}</td>
                                        <td>
                                            <span class="badge badge-${reservation.status == 'CONFIRMED' ? 'success' : 
                                                                        reservation.status == 'PENDING' ? 'warning' : 
                                                                        reservation.status == 'CHECKED_IN' ? 'info' : 
                                                                        reservation.status == 'CHECKED_OUT' ? 'secondary' : 'danger'}">
                                                ${reservation.status}
                                            </span>
                                        </td>
                                        <td>$<fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00" /></td>
                                        <td>
                                            <div class="action-buttons">
                                                <button class="btn btn-sm btn-primary" onclick="viewDetails(${reservation.id})" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-warning" onclick="editReservation(${reservation.id})" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <c:choose>
                                                    <c:when test="${reservation.status == 'CONFIRMED'}">
                                                        <button class="btn btn-sm btn-success" onclick="checkIn(${reservation.id})" title="Check-in">
                                                            <i class="fas fa-sign-in-alt"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${reservation.status == 'CHECKED_IN'}">
                                                        <button class="btn btn-sm btn-info" onclick="checkOut(${reservation.id})" title="Check-out">
                                                            <i class="fas fa-sign-out-alt"></i>
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                                <button class="btn btn-sm btn-danger" onclick="cancelReservation(${reservation.id})" title="Cancel">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10" class="text-center">
                                        <div class="empty-state-small">
                                            <i class="fas fa-calendar-times"></i>
                                            <p>No reservations found</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <c:if test="${not empty reservations && totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="page-link">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <a href="?page=${page}" class="page-link ${currentPage == page ? 'active' : ''}">
                            ${page}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="page-link">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
function toggleSelectAll() {
    const selectAll = document.getElementById('selectAll');
    const checkboxes = document.querySelectorAll('.reservation-checkbox');
    checkboxes.forEach(cb => cb.checked = selectAll.checked);
}

function viewDetails(reservationId) {
    window.location.href = '${pageContext.request.contextPath}/staff/reservations/' + reservationId;
}

function editReservation(reservationId) {
    window.location.href = '${pageContext.request.contextPath}/staff/reservations/' + reservationId + '/edit';
}

function checkIn(reservationId) {
    if (confirm('Confirm check-in for this reservation?')) {
        fetch('${pageContext.request.contextPath}/staff/reservations/' + reservationId + '/check-in', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'}
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Check-in successful');
                location.reload();
            } else {
                alert('Check-in failed: ' + data.message);
            }
        });
    }
}

function checkOut(reservationId) {
    if (confirm('Confirm check-out for this reservation?')) {
        fetch('${pageContext.request.contextPath}/staff/reservations/' + reservationId + '/check-out', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'}
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Check-out successful');
                location.reload();
            } else {
                alert('Check-out failed: ' + data.message);
            }
        });
    }
}

function cancelReservation(reservationId) {
    if (confirm('Are you sure you want to cancel this reservation?')) {
        fetch('${pageContext.request.contextPath}/staff/reservations/' + reservationId + '/cancel', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'}
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Reservation cancelled');
                location.reload();
            } else {
                alert('Cancellation failed: ' + data.message);
            }
        });
    }
}

function resetFilters() {
    document.getElementById('searchForm').reset();
    window.location.href = '${pageContext.request.contextPath}/staff/reservations';
}

function exportReservations() {
    const selectedIds = Array.from(document.querySelectorAll('.reservation-checkbox:checked'))
                             .map(cb => cb.value);
    
    const params = selectedIds.length > 0 ? '?ids=' + selectedIds.join(',') : '';
    window.location.href = '${pageContext.request.contextPath}/staff/reservations/export' + params;
}

// Real-time search
document.getElementById('searchGuest')?.addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#reservationsTable tbody tr');
    
    rows.forEach(row => {
        const guestCell = row.querySelector('.guest-cell');
        if (guestCell) {
            const text = guestCell.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        }
    });
});

// Status filter
document.getElementById('filterStatus')?.addEventListener('change', function(e) {
    const status = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#reservationsTable tbody tr');
    
    rows.forEach(row => {
        const badge = row.querySelector('.badge');
        if (badge) {
            const rowStatus = badge.textContent.toLowerCase();
            row.style.display = !status || rowStatus.includes(status) ? '' : 'none';
        }
    });
});
</script>

<jsp:include page="../common/footer.jsp" />
