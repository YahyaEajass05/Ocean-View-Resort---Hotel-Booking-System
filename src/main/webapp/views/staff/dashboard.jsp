<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"STAFF".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, MMMM dd, yyyy");
    String currentDate = sdf.format(new Date());
    
    // Get dashboard data from request attributes with defaults
    Integer todayCheckIns = (Integer) request.getAttribute("todayCheckIns");
    Integer todayCheckOuts = (Integer) request.getAttribute("todayCheckOuts");
    Integer occupiedRooms = (Integer) request.getAttribute("occupiedRooms");
    Integer pendingRequests = (Integer) request.getAttribute("pendingRequests");
    
    if (todayCheckIns == null) todayCheckIns = 8;
    if (todayCheckOuts == null) todayCheckOuts = 5;
    if (occupiedRooms == null) occupiedRooms = 42;
    if (pendingRequests == null) pendingRequests = 3;
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Staff Dashboard" />
    <jsp:param name="css" value="staff,dashboard" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="staff-dashboard">
        <div class="container-fluid py-4">
            <!-- Dashboard Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-tachometer-alt"></i> Staff Dashboard</h1>
                    <p class="text-muted">Welcome back, <%= currentUser.getFirstName() %>! Today is <%= currentDate %></p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="location.href='<%= contextPath %>/staff/checkin'">
                        <i class="fas fa-sign-in-alt"></i> Check-In Guest
                    </button>
                    <button class="btn btn-success" onclick="location.href='<%= contextPath %>/staff/checkout'">
                        <i class="fas fa-sign-out-alt"></i> Check-Out Guest
                    </button>
                </div>
            </div>
            
            <!-- Today's Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card stat-card-primary">
                        <div class="stat-icon bg-primary">
                            <i class="fas fa-sign-in-alt"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= todayCheckIns %></div>
                            <div class="stat-label">Check-Ins Today</div>
                        </div>
                        <a href="<%= contextPath %>/staff/checkin" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-success">
                        <div class="stat-icon bg-success">
                            <i class="fas fa-sign-out-alt"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= todayCheckOuts %></div>
                            <div class="stat-label">Check-Outs Today</div>
                        </div>
                        <a href="<%= contextPath %>/staff/checkout" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-info">
                        <div class="stat-icon bg-info">
                            <i class="fas fa-bed"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= occupiedRooms %></div>
                            <div class="stat-label">Occupied Rooms</div>
                        </div>
                        <a href="<%= contextPath %>/staff/reservations" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card stat-card-warning">
                        <div class="stat-icon bg-warning">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= pendingRequests %></div>
                            <div class="stat-label">Pending Requests</div>
                        </div>
                        <a href="<%= contextPath %>/staff/requests" class="stat-link">View All <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            
            <!-- Main Content Grid -->
            <div class="row">
                <!-- Today's Check-Ins -->
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-calendar-check"></i> Today's Check-Ins</h3>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Guest</th>
                                            <th>Room</th>
                                            <th>Time</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        String[][] checkIns = {
                                            {"John Smith", "101", "14:00", "pending"},
                                            {"Emma Davis", "205", "14:30", "pending"},
                                            {"Mike Johnson", "310", "15:00", "completed"},
                                            {"Sarah Williams", "102", "15:30", "pending"}
                                        };
                                        
                                        for (String[] checkIn : checkIns) {
                                            String statusClass = "completed".equals(checkIn[3]) ? "badge-success" : "badge-warning";
                                            String statusText = "completed".equals(checkIn[3]) ? "Completed" : "Pending";
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="user-avatar-sm"><%= checkIn[0].charAt(0) %></div>
                                                    <span class="ms-2"><%= checkIn[0] %></span>
                                                </div>
                                            </td>
                                            <td><span class="badge badge-primary">Room <%= checkIn[1] %></span></td>
                                            <td><%= checkIn[2] %></td>
                                            <td>
                                                <% if ("pending".equals(checkIn[3])) { %>
                                                <button class="btn btn-sm btn-primary" onclick="checkInGuest('<%= checkIn[0] %>', '<%= checkIn[1] %>')">
                                                    <i class="fas fa-check"></i> Check-In
                                                </button>
                                                <% } else { %>
                                                <span class="badge <%= statusClass %>"><%= statusText %></span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Today's Check-Outs -->
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-calendar-times"></i> Today's Check-Outs</h3>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Guest</th>
                                            <th>Room</th>
                                            <th>Time</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        String[][] checkOuts = {
                                            {"David Brown", "408", "12:00", "completed"},
                                            {"Lisa Anderson", "201", "11:30", "pending"},
                                            {"Robert Taylor", "305", "12:00", "pending"}
                                        };
                                        
                                        for (String[] checkOut : checkOuts) {
                                            String statusClass = "completed".equals(checkOut[3]) ? "badge-success" : "badge-warning";
                                            String statusText = "completed".equals(checkOut[3]) ? "Completed" : "Pending";
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="user-avatar-sm"><%= checkOut[0].charAt(0) %></div>
                                                    <span class="ms-2"><%= checkOut[0] %></span>
                                                </div>
                                            </td>
                                            <td><span class="badge badge-primary">Room <%= checkOut[1] %></span></td>
                                            <td><%= checkOut[2] %></td>
                                            <td>
                                                <% if ("pending".equals(checkOut[3])) { %>
                                                <button class="btn btn-sm btn-success" onclick="checkOutGuest('<%= checkOut[0] %>', '<%= checkOut[1] %>')">
                                                    <i class="fas fa-check"></i> Check-Out
                                                </button>
                                                <% } else { %>
                                                <span class="badge <%= statusClass %>"><%= statusText %></span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Room Status and Quick Actions -->
            <div class="row">
                <!-- Room Status Overview -->
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-door-open"></i> Room Status Overview</h3>
                        </div>
                        <div class="card-body">
                            <div class="room-status-grid">
                                <%
                                String[][] rooms = {
                                    {"101", "OCCUPIED", "John Smith", "Clean"},
                                    {"102", "OCCUPIED", "Sarah Williams", "Clean"},
                                    {"103", "AVAILABLE", "", "Clean"},
                                    {"104", "AVAILABLE", "", "Clean"},
                                    {"105", "MAINTENANCE", "", "Cleaning"},
                                    {"201", "OCCUPIED", "Lisa Anderson", "Clean"},
                                    {"202", "AVAILABLE", "", "Cleaning"},
                                    {"203", "OCCUPIED", "Michael Chen", "Clean"},
                                    {"204", "AVAILABLE", "", "Clean"},
                                    {"205", "RESERVED", "Emma Davis", "Clean"}
                                };
                                
                                for (String[] room : rooms) {
                                    String statusClass = "";
                                    String statusIcon = "";
                                    if ("OCCUPIED".equals(room[1])) {
                                        statusClass = "room-occupied";
                                        statusIcon = "fas fa-user";
                                    } else if ("AVAILABLE".equals(room[1])) {
                                        statusClass = "room-available";
                                        statusIcon = "fas fa-door-open";
                                    } else if ("MAINTENANCE".equals(room[1])) {
                                        statusClass = "room-maintenance";
                                        statusIcon = "fas fa-tools";
                                    } else {
                                        statusClass = "room-reserved";
                                        statusIcon = "fas fa-calendar";
                                    }
                                %>
                                <div class="room-card <%= statusClass %>" onclick="viewRoomDetails('<%= room[0] %>')">
                                    <div class="room-number"><%= room[0] %></div>
                                    <div class="room-status"><i class="<%= statusIcon %>"></i></div>
                                    <% if (!room[2].isEmpty()) { %>
                                    <div class="room-guest"><%= room[2] %></div>
                                    <% } %>
                                    <div class="room-cleaning"><%= room[3] %></div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions-list">
                                <a href="<%= contextPath %>/staff/checkin" class="quick-action-item">
                                    <div class="quick-action-icon bg-primary">
                                        <i class="fas fa-sign-in-alt"></i>
                                    </div>
                                    <div class="quick-action-text">
                                        <div class="quick-action-title">Check-In Guest</div>
                                        <div class="quick-action-desc">Process new arrivals</div>
                                    </div>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                                
                                <a href="<%= contextPath %>/staff/checkout" class="quick-action-item">
                                    <div class="quick-action-icon bg-success">
                                        <i class="fas fa-sign-out-alt"></i>
                                    </div>
                                    <div class="quick-action-text">
                                        <div class="quick-action-title">Check-Out Guest</div>
                                        <div class="quick-action-desc">Process departures</div>
                                    </div>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                                
                                <a href="<%= contextPath %>/staff/search" class="quick-action-item">
                                    <div class="quick-action-icon bg-info">
                                        <i class="fas fa-search"></i>
                                    </div>
                                    <div class="quick-action-text">
                                        <div class="quick-action-title">Search Guest</div>
                                        <div class="quick-action-desc">Find guest information</div>
                                    </div>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                                
                                <a href="<%= contextPath %>/staff/reservations" class="quick-action-item">
                                    <div class="quick-action-icon bg-warning">
                                        <i class="fas fa-calendar-alt"></i>
                                    </div>
                                    <div class="quick-action-text">
                                        <div class="quick-action-title">View Reservations</div>
                                        <div class="quick-action-desc">Manage bookings</div>
                                    </div>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                                
                                <a href="<%= contextPath %>/staff/rooms" class="quick-action-item">
                                    <div class="quick-action-icon bg-danger">
                                        <i class="fas fa-door-open"></i>
                                    </div>
                                    <div class="quick-action-text">
                                        <div class="quick-action-title">Room Status</div>
                                        <div class="quick-action-desc">Update room info</div>
                                    </div>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function checkInGuest(guestName, roomNumber) {
    if (confirm('Check-in ' + guestName + ' to Room ' + roomNumber + '?')) {
        // Make AJAX call to check-in endpoint
        window.location.href = '<%= contextPath %>/staff/checkin?guest=' + encodeURIComponent(guestName) + '&room=' + roomNumber;
    }
}

function checkOutGuest(guestName, roomNumber) {
    if (confirm('Check-out ' + guestName + ' from Room ' + roomNumber + '?')) {
        // Make AJAX call to check-out endpoint
        window.location.href = '<%= contextPath %>/staff/checkout?guest=' + encodeURIComponent(guestName) + '&room=' + roomNumber;
    }
}

function viewRoomDetails(roomNumber) {
    // Open room details modal or navigate to room details page
    window.location.href = '<%= contextPath %>/staff/rooms/' + roomNumber;
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

.stat-card {
    position: relative;
    overflow: hidden;
}

.stat-link {
    display: block;
    padding: 0.75rem 1rem;
    text-align: center;
    background-color: rgba(0, 0, 0, 0.05);
    color: inherit;
    text-decoration: none;
    font-size: 0.875rem;
    font-weight: 500;
    transition: all 0.3s ease;
}

.stat-link:hover {
    background-color: rgba(0, 0, 0, 0.1);
    color: inherit;
}

/* Room Status Grid */
.room-status-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
    gap: 1rem;
}

.room-card {
    padding: 1rem;
    border-radius: var(--radius-md);
    text-align: center;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 2px solid transparent;
}

.room-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.room-occupied {
    background-color: #ffebee;
    border-color: #ef5350;
}

.room-available {
    background-color: #e8f5e9;
    border-color: #66bb6a;
}

.room-maintenance {
    background-color: #fff3e0;
    border-color: #ffa726;
}

.room-reserved {
    background-color: #e3f2fd;
    border-color: #42a5f5;
}

.room-number {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
}

.room-status {
    font-size: 1.2rem;
    margin-bottom: 0.5rem;
}

.room-guest {
    font-size: 0.85rem;
    font-weight: 500;
    margin-bottom: 0.25rem;
}

.room-cleaning {
    font-size: 0.75rem;
    color: #666;
}

/* Quick Actions */
.quick-actions-list {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.quick-action-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background-color: #f8f9fa;
    border-radius: var(--radius-md);
    text-decoration: none;
    color: inherit;
    transition: all 0.3s ease;
}

.quick-action-item:hover {
    background-color: #e9ecef;
    transform: translateX(4px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.quick-action-icon {
    width: 48px;
    height: 48px;
    border-radius: var(--radius-md);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.25rem;
}

.quick-action-text {
    flex: 1;
}

.quick-action-title {
    font-weight: 600;
    font-size: 0.95rem;
    margin-bottom: 0.25rem;
}

.quick-action-desc {
    font-size: 0.8rem;
    color: #666;
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

@media (max-width: 768px) {
    .room-status-grid {
        grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
    }
    
    .header-actions {
        width: 100%;
    }
    
    .header-actions .btn {
        flex: 1;
    }
}
</style>

<jsp:include page="../common/footer.jsp" />
