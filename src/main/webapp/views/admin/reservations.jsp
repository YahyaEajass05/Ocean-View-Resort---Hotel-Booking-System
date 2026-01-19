<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Reservations" />
    <jsp:param name="css" value="admin,dashboard" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="reservations" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="admin-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-calendar-alt"></i> Manage Reservations</h1>
                    <p class="text-muted">View, manage, and track all hotel reservations</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="openNewReservationModal()">
                        <i class="fas fa-plus"></i> New Reservation
                    </button>
                    <button class="btn btn-outline" onclick="exportReservations()">
                        <i class="fas fa-download"></i> Export
                    </button>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-control" id="filterStatus">
                                <option value="">All Statuses</option>
                                <option value="PENDING">Pending</option>
                                <option value="CONFIRMED">Confirmed</option>
                                <option value="CHECKED_IN">Checked In</option>
                                <option value="CHECKED_OUT">Checked Out</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Room Type</label>
                            <select class="form-control" id="filterRoomType">
                                <option value="">All Room Types</option>
                                <option value="STANDARD">Standard</option>
                                <option value="DELUXE">Deluxe</option>
                                <option value="SUITE">Suite</option>
                                <option value="PRESIDENTIAL">Presidential</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Check-In Date</label>
                            <input type="date" class="form-control" id="filterCheckIn">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Search</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" placeholder="Guest name, ID...">
                                <button class="btn btn-primary" onclick="searchReservations()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value" id="pendingCount">12</div>
                            <div class="stat-label">Pending</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value" id="confirmedCount">45</div>
                            <div class="stat-label">Confirmed</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-info">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value" id="checkedInCount">28</div>
                            <div class="stat-label">Checked In</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-danger">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value" id="cancelledCount">5</div>
                            <div class="stat-label">Cancelled</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Reservations Table -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-list"></i> All Reservations</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Guest</th>
                                    <th>Room</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Nights</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="reservationsTableBody">
                                <%
                                // Sample data - Replace with actual data from servlet
                                String[][] reservations = {
                                    {"1001", "John Doe", "101 - Deluxe", "2026-01-25", "2026-01-28", "3", "45000", "CONFIRMED"},
                                    {"1002", "Jane Smith", "205 - Suite", "2026-01-26", "2026-01-30", "4", "80000", "PENDING"},
                                    {"1003", "Mike Johnson", "310 - Standard", "2026-01-24", "2026-01-27", "3", "30000", "CHECKED_IN"},
                                    {"1004", "Sarah Williams", "102 - Deluxe", "2026-01-27", "2026-01-29", "2", "30000", "CONFIRMED"},
                                    {"1005", "David Brown", "408 - Presidential", "2026-01-28", "2026-02-02", "5", "150000", "CONFIRMED"},
                                    {"1006", "Emma Davis", "201 - Suite", "2026-01-20", "2026-01-24", "4", "72000", "CHECKED_OUT"},
                                    {"1007", "James Wilson", "305 - Standard", "2026-01-22", "2026-01-25", "3", "27000", "CANCELLED"},
                                    {"1008", "Olivia Martinez", "103 - Deluxe", "2026-01-29", "2026-02-01", "3", "45000", "PENDING"}
                                };
                                
                                for (String[] reservation : reservations) {
                                    String status = reservation[7];
                                    String badgeClass = "";
                                    if ("CONFIRMED".equals(status)) badgeClass = "badge-success";
                                    else if ("PENDING".equals(status)) badgeClass = "badge-warning";
                                    else if ("CHECKED_IN".equals(status)) badgeClass = "badge-info";
                                    else if ("CHECKED_OUT".equals(status)) badgeClass = "badge-secondary";
                                    else if ("CANCELLED".equals(status)) badgeClass = "badge-danger";
                                %>
                                <tr>
                                    <td><strong>#<%= reservation[0] %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar-sm"><%= reservation[1].charAt(0) %></div>
                                            <span class="ms-2"><%= reservation[1] %></span>
                                        </div>
                                    </td>
                                    <td><%= reservation[2] %></td>
                                    <td><%= reservation[3] %></td>
                                    <td><%= reservation[4] %></td>
                                    <td><span class="badge badge-secondary"><%= reservation[5] %> nights</span></td>
                                    <td><strong>Rs. <%= reservation[6] %></strong></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-primary" onclick="viewReservation('<%= reservation[0] %>')" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" onclick="editReservation('<%= reservation[0] %>')" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <% if ("CONFIRMED".equals(status)) { %>
                                            <button class="btn btn-sm btn-info" onclick="checkIn('<%= reservation[0] %>')" title="Check In">
                                                <i class="fas fa-sign-in-alt"></i>
                                            </button>
                                            <% } else if ("CHECKED_IN".equals(status)) { %>
                                            <button class="btn btn-sm btn-secondary" onclick="checkOut('<%= reservation[0] %>')" title="Check Out">
                                                <i class="fas fa-sign-out-alt"></i>
                                            </button>
                                            <% } %>
                                            <% if (!"CANCELLED".equals(status) && !"CHECKED_OUT".equals(status)) { %>
                                            <button class="btn btn-sm btn-danger" onclick="cancelReservation('<%= reservation[0] %>')" title="Cancel">
                                                <i class="fas fa-times"></i>
                                            </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>Showing 1 to 8 of 8 reservations</div>
                        <nav>
                            <ul class="pagination mb-0">
                                <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item"><a class="page-link" href="#">Next</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Reservation Details Modal -->
<div class="modal fade" id="reservationModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-info-circle"></i> Reservation Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="reservationModalBody">
                <!-- Content will be loaded dynamically -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printReservation()">
                    <i class="fas fa-print"></i> Print
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function openNewReservationModal() {
    window.location.href = '<%= contextPath %>/admin/reservations/new';
}

function viewReservation(id) {
    // Load reservation details via AJAX
    alert('View reservation #' + id);
}

function editReservation(id) {
    window.location.href = '<%= contextPath %>/admin/reservations/edit/' + id;
}

function checkIn(id) {
    if (confirm('Confirm check-in for reservation #' + id + '?')) {
        // Make AJAX call to check-in endpoint
        alert('Checked in reservation #' + id);
    }
}

function checkOut(id) {
    if (confirm('Confirm check-out for reservation #' + id + '?')) {
        // Make AJAX call to check-out endpoint
        alert('Checked out reservation #' + id);
    }
}

function cancelReservation(id) {
    if (confirm('Are you sure you want to cancel reservation #' + id + '?')) {
        // Make AJAX call to cancel endpoint
        alert('Cancelled reservation #' + id);
    }
}

function searchReservations() {
    const searchTerm = document.getElementById('searchInput').value;
    // Implement search functionality
    console.log('Searching for:', searchTerm);
}

function exportReservations() {
    window.location.href = '<%= contextPath %>/admin/reservations/export';
}

function printReservation() {
    window.print();
}

// Filter listeners
document.getElementById('filterStatus').addEventListener('change', function() {
    // Filter reservations by status
    console.log('Filter by status:', this.value);
});

document.getElementById('filterRoomType').addEventListener('change', function() {
    // Filter reservations by room type
    console.log('Filter by room type:', this.value);
});

document.getElementById('filterCheckIn').addEventListener('change', function() {
    // Filter reservations by check-in date
    console.log('Filter by check-in:', this.value);
});
</script>

<style>
.user-avatar-sm {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--ocean-blue), var(--ocean-dark));
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 0.9rem;
}

.btn-group .btn {
    padding: 0.25rem 0.5rem;
    margin-right: 0.25rem;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
}

.header-actions {
    display: flex;
    gap: 0.5rem;
}
</style>

<jsp:include page="../common/footer.jsp" />
