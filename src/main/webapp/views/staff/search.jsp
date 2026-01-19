<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
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
    <jsp:param name="title" value="Search Guest" />
    <jsp:param name="css" value="staff,dashboard" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="guests" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="staff-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-search"></i> Search Guest</h1>
                    <p class="text-muted">Find guest information and booking history</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-outline" onclick="location.href='<%= contextPath %>/staff/dashboard'">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </button>
                </div>
            </div>
            
            <!-- Search Section -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-filter"></i> Search Criteria</h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Guest Name</label>
                            <input type="text" class="form-control" id="searchName" placeholder="First or last name">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="searchEmail" placeholder="guest@example.com">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phone Number</label>
                            <input type="text" class="form-control" id="searchPhone" placeholder="+94 XX XXX XXXX">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Booking ID</label>
                            <input type="text" class="form-control" id="searchBooking" placeholder="e.g., B001">
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-3">
                            <label class="form-label">Room Number</label>
                            <input type="text" class="form-control" id="searchRoom" placeholder="e.g., 101">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Check-In Date</label>
                            <input type="date" class="form-control" id="searchCheckIn">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-control" id="searchStatus">
                                <option value="">All Status</option>
                                <option value="CHECKED_IN">Checked In</option>
                                <option value="CHECKED_OUT">Checked Out</option>
                                <option value="CONFIRMED">Confirmed</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="performSearch()">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-secondary btn-sm" onclick="clearSearchForm()">
                            <i class="fas fa-times"></i> Clear All
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Search Results -->
            <div class="card" id="resultsCard" style="display: none;">
                <div class="card-header">
                    <h3><i class="fas fa-list"></i> Search Results <span class="badge badge-primary" id="resultCount">0</span></h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="resultsTable">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Guest Name</th>
                                    <th>Contact</th>
                                    <th>Room</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="resultsBody">
                                <!-- Results will be populated here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- Sample Data for Demo -->
            <div class="card mt-4">
                <div class="card-header">
                    <h3><i class="fas fa-database"></i> Current Guests</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Guest</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Room</th>
                                    <th>Check-In</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String[][] currentGuests = {
                                    {"Emma Davis", "emma.d@email.com", "+94 77 234 5678", "205", "2026-01-21", "CHECKED_IN"},
                                    {"Michael Chen", "michael.c@email.com", "+94 77 789 0123", "203", "2026-01-21", "CHECKED_IN"},
                                    {"Sarah Williams", "sarah.w@email.com", "+94 77 456 7890", "102", "2026-01-22", "CHECKED_IN"},
                                    {"David Brown", "david.b@email.com", "+94 77 567 8901", "408", "2026-01-20", "CHECKED_IN"}
                                };
                                
                                for (String[] guest : currentGuests) {
                                %>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar-sm"><%= guest[0].charAt(0) %></div>
                                            <span class="ms-2"><%= guest[0] %></span>
                                        </div>
                                    </td>
                                    <td><%= guest[1] %></td>
                                    <td><%= guest[2] %></td>
                                    <td><span class="badge badge-primary">Room <%= guest[3] %></span></td>
                                    <td><%= guest[4] %></td>
                                    <td><span class="badge badge-success"><%= guest[5] %></span></td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-primary" onclick="viewGuestDetails('<%= guest[0] %>')" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" onclick="viewBookingHistory('<%= guest[0] %>')" title="History">
                                                <i class="fas fa-history"></i>
                                            </button>
                                            <button class="btn btn-sm btn-info" onclick="contactGuest('<%= guest[2] %>')" title="Contact">
                                                <i class="fas fa-phone"></i>
                                            </button>
                                        </div>
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
</div>

<!-- Guest Details Modal -->
<div class="modal fade" id="guestDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user"></i> Guest Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="guestDetailsBody">
                <!-- Guest details will be loaded here -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="fw-bold">Name:</label>
                        <p id="guestName">-</p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-bold">Email:</label>
                        <p id="guestEmail">-</p>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="fw-bold">Phone:</label>
                        <p id="guestPhone">-</p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-bold">Room:</label>
                        <p id="guestRoom">-</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
const sampleData = [
    {id: "B001", name: "John Smith", email: "john.s@email.com", phone: "+94 77 123 4567", room: "101", checkIn: "2026-01-20", checkOut: "2026-01-23", status: "CHECKED_OUT"},
    {id: "B002", name: "Emma Davis", email: "emma.d@email.com", phone: "+94 77 234 5678", room: "205", checkIn: "2026-01-21", checkOut: "2026-01-25", status: "CHECKED_IN"},
    {id: "B003", name: "Mike Johnson", email: "mike.j@email.com", phone: "+94 77 345 6789", room: "310", checkIn: "2026-01-19", checkOut: "2026-01-22", status: "CHECKED_OUT"},
    {id: "B004", name: "Sarah Williams", email: "sarah.w@email.com", phone: "+94 77 456 7890", room: "102", checkIn: "2026-01-22", checkOut: "2026-01-24", status: "CHECKED_IN"},
    {id: "B005", name: "David Brown", email: "david.b@email.com", phone: "+94 77 567 8901", room: "408", checkIn: "2026-01-23", checkOut: "2026-01-28", status: "CONFIRMED"},
    {id: "B006", name: "Lisa Anderson", email: "lisa.a@email.com", phone: "+94 77 678 9012", room: "201", checkIn: "2026-01-18", checkOut: "2026-01-21", status: "CHECKED_OUT"},
    {id: "B007", name: "Robert Taylor", email: "robert.t@email.com", phone: "+94 77 789 0123", room: "305", checkIn: "2026-01-20", checkOut: "2026-01-23", status: "CANCELLED"},
    {id: "B008", name: "Michael Chen", email: "michael.c@email.com", phone: "+94 77 890 1234", room: "203", checkIn: "2026-01-21", checkOut: "2026-01-26", status: "CHECKED_IN"}
];

function performSearch() {
    const name = document.getElementById('searchName').value.toLowerCase();
    const email = document.getElementById('searchEmail').value.toLowerCase();
    const phone = document.getElementById('searchPhone').value;
    const booking = document.getElementById('searchBooking').value.toUpperCase();
    const room = document.getElementById('searchRoom').value;
    const checkIn = document.getElementById('searchCheckIn').value;
    const status = document.getElementById('searchStatus').value;
    
    // Filter sample data
    const results = sampleData.filter(item => {
        return (!name || item.name.toLowerCase().includes(name)) &&
               (!email || item.email.toLowerCase().includes(email)) &&
               (!phone || item.phone.includes(phone)) &&
               (!booking || item.id.includes(booking)) &&
               (!room || item.room.includes(room)) &&
               (!checkIn || item.checkIn === checkIn) &&
               (!status || item.status === status);
    });
    
    displayResults(results);
}

function displayResults(results) {
    const resultsCard = document.getElementById('resultsCard');
    const resultsBody = document.getElementById('resultsBody');
    const resultCount = document.getElementById('resultCount');
    
    resultsCard.style.display = 'block';
    resultCount.textContent = results.length;
    
    if (results.length === 0) {
        resultsBody.innerHTML = '<tr><td colspan="8" class="text-center py-4">No results found</td></tr>';
        return;
    }
    
    let html = '';
    results.forEach(item => {
        const statusClass = item.status === 'CHECKED_IN' ? 'badge-success' : 
                           item.status === 'CONFIRMED' ? 'badge-warning' :
                           item.status === 'CANCELLED' ? 'badge-danger' : 'badge-secondary';
        
        html += `
            <tr>
                <td><strong>#${item.id}</strong></td>
                <td>
                    <div class="d-flex align-items-center">
                        <div class="user-avatar-sm">${item.name.charAt(0)}</div>
                        <span class="ms-2">${item.name}</span>
                    </div>
                </td>
                <td>${item.email}<br><small>${item.phone}</small></td>
                <td><span class="badge badge-primary">Room ${item.room}</span></td>
                <td>${item.checkIn}</td>
                <td>${item.checkOut}</td>
                <td><span class="badge ${statusClass}">${item.status}</span></td>
                <td>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-primary" onclick="viewGuestDetails('${item.name}')" title="View">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-success" onclick="viewBookingHistory('${item.name}')" title="History">
                            <i class="fas fa-history"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `;
    });
    
    resultsBody.innerHTML = html;
}

function clearSearchForm() {
    document.getElementById('searchName').value = '';
    document.getElementById('searchEmail').value = '';
    document.getElementById('searchPhone').value = '';
    document.getElementById('searchBooking').value = '';
    document.getElementById('searchRoom').value = '';
    document.getElementById('searchCheckIn').value = '';
    document.getElementById('searchStatus').value = '';
    document.getElementById('resultsCard').style.display = 'none';
}

function viewGuestDetails(guestName) {
    document.getElementById('guestName').textContent = guestName;
    document.getElementById('guestEmail').textContent = 'guest@email.com';
    document.getElementById('guestPhone').textContent = '+94 XX XXX XXXX';
    document.getElementById('guestRoom').textContent = 'Room 101';
    
    const modal = new bootstrap.Modal(document.getElementById('guestDetailsModal'));
    modal.show();
}

function viewBookingHistory(guestName) {
    window.location.href = '<%= contextPath %>/staff/guest-history?name=' + encodeURIComponent(guestName);
}

function contactGuest(phone) {
    alert('Contact: ' + phone);
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
