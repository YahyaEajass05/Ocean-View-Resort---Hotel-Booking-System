<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"STAFF".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Bookings" />
    <jsp:param name="css" value="staff,dashboard" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="reservations" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="staff-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-calendar-alt"></i> Manage Bookings</h1>
                    <p class="text-muted">View and manage all hotel reservations</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="createNewBooking()">
                        <i class="fas fa-plus"></i> New Booking
                    </button>
                    <button class="btn btn-outline" onclick="printBookings()">
                        <i class="fas fa-print"></i> Print
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
                                <option value="CONFIRMED">Confirmed</option>
                                <option value="PENDING">Pending</option>
                                <option value="CHECKED_IN">Checked In</option>
                                <option value="CHECKED_OUT">Checked Out</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Check-In Date</label>
                            <input type="date" class="form-control" id="filterCheckIn">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Room Number</label>
                            <input type="text" class="form-control" id="filterRoom" placeholder="e.g., 101">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Search Guest</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchGuest" placeholder="Name or ID">
                                <button class="btn btn-primary" onclick="filterBookings()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Statistics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">15</div>
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
                            <div class="stat-value">42</div>
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
                            <div class="stat-value">28</div>
                            <div class="stat-label">Checked In</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-danger">
                            <i class="fas fa-ban"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">3</div>
                            <div class="stat-label">Cancelled</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Bookings Table -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-list"></i> All Bookings</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Guest Name</th>
                                    <th>Room</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Nights</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String[][] bookings = {
                                    {"B001", "John Smith", "101", "2026-01-20", "2026-01-23", "3", "CONFIRMED", "45000"},
                                    {"B002", "Emma Davis", "205", "2026-01-21", "2026-01-25", "4", "CHECKED_IN", "72000"},
                                    {"B003", "Mike Johnson", "310", "2026-01-19", "2026-01-22", "3", "CHECKED_OUT", "30000"},
                                    {"B004", "Sarah Williams", "102", "2026-01-22", "2026-01-24", "2", "CONFIRMED", "30000"},
                                    {"B005", "David Brown", "408", "2026-01-23", "2026-01-28", "5", "PENDING", "150000"},
                                    {"B006", "Lisa Anderson", "201", "2026-01-18", "2026-01-21", "3", "CHECKED_OUT", "45000"},
                                    {"B007", "Robert Taylor", "305", "2026-01-20", "2026-01-23", "3", "CANCELLED", "36000"},
                                    {"B008", "Michael Chen", "203", "2026-01-21", "2026-01-26", "5", "CONFIRMED", "75000"}
                                };
                                
                                for (String[] booking : bookings) {
                                    String status = booking[6];
                                    String badgeClass = "";
                                    if ("CONFIRMED".equals(status)) badgeClass = "badge-success";
                                    else if ("PENDING".equals(status)) badgeClass = "badge-warning";
                                    else if ("CHECKED_IN".equals(status)) badgeClass = "badge-info";
                                    else if ("CHECKED_OUT".equals(status)) badgeClass = "badge-secondary";
                                    else if ("CANCELLED".equals(status)) badgeClass = "badge-danger";
                                %>
                                <tr>
                                    <td><strong>#<%= booking[0] %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar-sm"><%= booking[1].charAt(0) %></div>
                                            <span class="ms-2"><%= booking[1] %></span>
                                        </div>
                                    </td>
                                    <td><span class="badge badge-primary">Room <%= booking[2] %></span></td>
                                    <td><%= booking[3] %></td>
                                    <td><%= booking[4] %></td>
                                    <td><%= booking[5] %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td><strong>Rs. <%= booking[7] %></strong></td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-primary" onclick="viewBooking('<%= booking[0] %>')" title="View">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <% if ("CONFIRMED".equals(status)) { %>
                                            <button class="btn btn-sm btn-info" onclick="checkIn('<%= booking[0] %>')" title="Check-In">
                                                <i class="fas fa-sign-in-alt"></i>
                                            </button>
                                            <% } else if ("CHECKED_IN".equals(status)) { %>
                                            <button class="btn btn-sm btn-success" onclick="checkOut('<%= booking[0] %>')" title="Check-Out">
                                                <i class="fas fa-sign-out-alt"></i>
                                            </button>
                                            <% } %>
                                            <% if (!"CHECKED_OUT".equals(status) && !"CANCELLED".equals(status)) { %>
                                            <button class="btn btn-sm btn-warning" onclick="editBooking('<%= booking[0] %>')" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="cancelBooking('<%= booking[0] %>')" title="Cancel">
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
                        <div>Showing 1 to 8 of 8 bookings</div>
                        <nav>
                            <ul class="pagination mb-0">
                                <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">Next</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Booking Details Modal -->
<div class="modal fade" id="bookingModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-info-circle"></i> Booking Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="bookingModalBody">
                <!-- Details will be loaded dynamically -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printBookingDetails()">
                    <i class="fas fa-print"></i> Print
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function createNewBooking() {
    window.location.href = '<%= contextPath %>/staff/bookings/new';
}

function viewBooking(id) {
    // Load booking details via AJAX
    alert('View booking details: ' + id);
}

function editBooking(id) {
    window.location.href = '<%= contextPath %>/staff/bookings/edit/' + id;
}

function checkIn(id) {
    if (confirm('Check-in this guest?')) {
        window.location.href = '<%= contextPath %>/staff/checkin?booking=' + id;
    }
}

function checkOut(id) {
    if (confirm('Check-out this guest?')) {
        window.location.href = '<%= contextPath %>/staff/checkout?booking=' + id;
    }
}

function cancelBooking(id) {
    if (confirm('Are you sure you want to cancel this booking?')) {
        alert('Booking cancelled: ' + id);
        location.reload();
    }
}

function filterBookings() {
    const status = document.getElementById('filterStatus').value;
    const checkIn = document.getElementById('filterCheckIn').value;
    const room = document.getElementById('filterRoom').value;
    const guest = document.getElementById('searchGuest').value;
    console.log('Filtering:', { status, checkIn, room, guest });
}

function printBookings() {
    window.print();
}

function printBookingDetails() {
    window.print();
}
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
    font-size: 0.85rem;
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
