<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Get dashboard data from request attributes
    Integer totalRooms = (Integer) request.getAttribute("totalRooms");
    Integer activeReservations = (Integer) request.getAttribute("activeReservations");
    Integer totalGuests = (Integer) request.getAttribute("totalGuests");
    Double monthlyRevenue = (Double) request.getAttribute("monthlyRevenue");
    Integer pendingReviews = (Integer) request.getAttribute("pendingReviews");
    Double occupancyRate = (Double) request.getAttribute("occupancyRate");
    
    // Default values if null
    if (totalRooms == null) totalRooms = 0;
    if (activeReservations == null) activeReservations = 0;
    if (totalGuests == null) totalGuests = 0;
    if (monthlyRevenue == null) monthlyRevenue = 0.0;
    if (pendingReviews == null) pendingReviews = 0;
    if (occupancyRate == null) occupancyRate = 0.0;
    
    // Format currency
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "LK"));
    String formattedRevenue = currencyFormat.format(monthlyRevenue);
    
    // Format percentage
    DecimalFormat percentFormat = new DecimalFormat("#0.0");
    String formattedOccupancy = percentFormat.format(occupancyRate);
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Admin Dashboard" />
    <jsp:param name="css" value="admin,dashboard" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="admin-dashboard">
        <div class="container-fluid py-4">
            <!-- Dashboard Header -->
            <div class="dashboard-header mb-4">
                <div>
                    <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
                    <p class="text-muted">Welcome back, <%= currentUser.getFirstName() %>! Here's your system overview.</p>
                </div>
                <div class="header-actions">
                    <a href="<%= request.getContextPath() %>/admin/reports" class="btn btn-primary">
                        <i class="fas fa-chart-bar"></i> View Reports
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/settings" class="btn btn-outline">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </div>
            </div>
            
            <!-- Key Metrics -->
            <div class="metrics-grid mb-4">
                <div class="metric-card metric-primary">
                    <div class="metric-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="metric-content">
                        <div class="metric-label">Monthly Revenue</div>
                        <div class="metric-value"><%= formattedRevenue %></div>
                        <div class="metric-footer">
                            <span class="metric-change positive">
                                <i class="fas fa-arrow-up"></i> 12.5%
                            </span>
                            <span class="metric-description">vs last month</span>
                        </div>
                    </div>
                </div>
                
                <div class="metric-card metric-success">
                    <div class="metric-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="metric-content">
                        <div class="metric-label">Active Reservations</div>
                        <div class="metric-value"><%= activeReservations %></div>
                        <div class="metric-footer">
                            <span class="metric-change positive">
                                <i class="fas fa-arrow-up"></i> 8.2%
                            </span>
                            <span class="metric-description">from yesterday</span>
                        </div>
                    </div>
                </div>
                
                <div class="metric-card metric-info">
                    <div class="metric-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="metric-content">
                        <div class="metric-label">Total Guests</div>
                        <div class="metric-value"><%= totalGuests %></div>
                        <div class="metric-footer">
                            <span class="metric-change positive">
                                <i class="fas fa-arrow-up"></i> 15.3%
                            </span>
                            <span class="metric-description">this month</span>
                        </div>
                    </div>
                </div>
                
                <div class="metric-card metric-warning">
                    <div class="metric-icon">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="metric-content">
                        <div class="metric-label">Occupancy Rate</div>
                        <div class="metric-value"><%= formattedOccupancy %>%</div>
                        <div class="metric-footer">
                            <span class="metric-change negative">
                                <i class="fas fa-arrow-down"></i> 2.1%
                            </span>
                            <span class="metric-description">vs target</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Secondary Metrics -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-primary">
                            <i class="fas fa-bed"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= totalRooms %></div>
                            <div class="stat-label">Total Rooms</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= totalRooms - (int)(totalRooms * 0.15) %></div>
                            <div class="stat-label">Available Rooms</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-warning">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value"><%= pendingReviews %></div>
                            <div class="stat-label">Pending Reviews</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-info">
                            <i class="fas fa-concierge-bell"></i>
                        </div>
                        <div class="stat-details">
                            <div class="stat-value">24/7</div>
                            <div class="stat-label">Service Status</div>
                        </div>
                    </div>
                </div>
            </div>
        
        <!-- Charts Section -->
        <div class="charts-section">
            <div class="chart-card">
                <div class="chart-header">
                    <h3>Revenue Overview</h3>
                    <select class="chart-filter">
                        <option>Last 7 Days</option>
                        <option>Last 30 Days</option>
                        <option>Last 3 Months</option>
                        <option>Last Year</option>
                    </select>
                </div>
                <div class="chart-body">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
            
            <div class="chart-card">
                <div class="chart-header">
                    <h3>Reservation Status</h3>
                </div>
                <div class="chart-body">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
        
            <!-- Main Content Grid -->
            <div class="row mb-4">
                <!-- Recent Reservations -->
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3><i class="fas fa-calendar-alt"></i> Recent Reservations</h3>
                            <a href="<%= request.getContextPath() %>/admin/reservations" class="btn btn-sm btn-primary">
                                View All <i class="fas fa-arrow-right"></i>
                            </a>
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
                                            <th>Status</th>
                                            <th>Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        // Sample data - Replace with actual data from servlet
                                        String[][] sampleReservations = {
                                            {"1234", "John Doe", "101", "Jan 25", "CONFIRMED", "15000"},
                                            {"1235", "Jane Smith", "205", "Jan 26", "PENDING", "18000"},
                                            {"1236", "Mike Johnson", "310", "Jan 27", "CONFIRMED", "22000"},
                                            {"1237", "Sarah Williams", "102", "Jan 28", "CHECKED_IN", "16000"},
                                            {"1238", "David Brown", "408", "Jan 29", "CONFIRMED", "25000"}
                                        };
                                        
                                        for (String[] reservation : sampleReservations) {
                                            String badgeClass = "";
                                            if ("CONFIRMED".equals(reservation[4])) badgeClass = "badge-success";
                                            else if ("PENDING".equals(reservation[4])) badgeClass = "badge-warning";
                                            else if ("CHECKED_IN".equals(reservation[4])) badgeClass = "badge-info";
                                            else badgeClass = "badge-secondary";
                                        %>
                                        <tr>
                                            <td><strong>#<%= reservation[0] %></strong></td>
                                            <td><%= reservation[1] %></td>
                                            <td><span class="badge badge-secondary">Room <%= reservation[2] %></span></td>
                                            <td><%= reservation[3] %></td>
                                            <td><span class="badge <%= badgeClass %>"><%= reservation[4] %></span></td>
                                            <td><strong>Rs. <%= reservation[5] %></strong></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- System Alerts -->
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-bell"></i> System Alerts</h3>
                        </div>
                        <div class="card-body">
                            <div class="alerts-list">
                                <div class="alert-item alert-warning">
                                    <div class="alert-icon">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </div>
                                    <div class="alert-content">
                                        <div class="alert-title">Maintenance Required</div>
                                        <div class="alert-text">Room 305 needs maintenance</div>
                                        <div class="alert-time"><i class="fas fa-clock"></i> 2 hours ago</div>
                                    </div>
                                </div>
                                
                                <div class="alert-item alert-info">
                                    <div class="alert-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <div class="alert-content">
                                        <div class="alert-title">New Registrations</div>
                                        <div class="alert-text"><%= pendingReviews %> new users today</div>
                                        <div class="alert-time"><i class="fas fa-clock"></i> 4 hours ago</div>
                                    </div>
                                </div>
                                
                                <div class="alert-item alert-success">
                                    <div class="alert-icon">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                    <div class="alert-content">
                                        <div class="alert-title">Payment Received</div>
                                        <div class="alert-text">Booking #1245 confirmed</div>
                                        <div class="alert-time"><i class="fas fa-clock"></i> 6 hours ago</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions Grid -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                </div>
                <div class="card-body">
                    <div class="quick-actions-grid">
                        <a href="<%= request.getContextPath() %>/admin/users" class="quick-action-card">
                            <div class="quick-action-icon bg-primary">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>Manage Users</h4>
                                <p>View and manage all users</p>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/admin/rooms" class="quick-action-card">
                            <div class="quick-action-icon bg-success">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>Manage Rooms</h4>
                                <p>Configure rooms and pricing</p>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/admin/offers" class="quick-action-card">
                            <div class="quick-action-icon bg-warning">
                                <i class="fas fa-tags"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>Special Offers</h4>
                                <p>Create and manage offers</p>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/admin/reviews" class="quick-action-card">
                            <div class="quick-action-icon bg-info">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>Manage Reviews</h4>
                                <p>Moderate guest reviews</p>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/admin/reports" class="quick-action-card">
                            <div class="quick-action-icon bg-danger">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>View Reports</h4>
                                <p>Analytics and reports</p>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/admin/settings" class="quick-action-card">
                            <div class="quick-action-icon bg-secondary">
                                <i class="fas fa-cog"></i>
                            </div>
                            <div class="quick-action-content">
                                <h4>Settings</h4>
                                <p>System configuration</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script>
// Revenue Chart
const revenueCtx = document.getElementById('revenueChart');
if (revenueCtx) {
    new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Revenue',
                data: [1200, 1900, 1500, 2200, 2800, 3200, 2900],
                borderColor: '#006994',
                backgroundColor: 'rgba(0, 105, 148, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

// Status Chart
const statusCtx = document.getElementById('statusChart');
if (statusCtx) {
    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Confirmed', 'Pending', 'Checked In', 'Cancelled'],
            datasets: [{
                data: [45, 15, 25, 15],
                backgroundColor: ['#28A745', '#FFC107', '#17A2B8', '#DC3545']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
