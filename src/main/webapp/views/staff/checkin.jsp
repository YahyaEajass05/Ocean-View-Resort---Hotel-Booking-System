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
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new Date());
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Guest Check-In" />
    <jsp:param name="css" value="staff,dashboard" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="check-in" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="staff-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-sign-in-alt"></i> Guest Check-In</h1>
                    <p class="text-muted">Process guest arrivals and room assignments</p>
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
                    <h3><i class="fas fa-search"></i> Search Reservation</h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Booking ID</label>
                            <input type="text" class="form-control" id="bookingId" placeholder="e.g., B001">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Guest Name</label>
                            <input type="text" class="form-control" id="guestName" placeholder="Enter guest name">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phone Number</label>
                            <input type="text" class="form-control" id="phoneNumber" placeholder="+94 XX XXX XXXX">
                        </div>
                    </div>
                    <div class="mt-3">
                        <button class="btn btn-primary" onclick="searchReservation()">
                            <i class="fas fa-search"></i> Search Reservation
                        </button>
                        <button class="btn btn-secondary" onclick="clearSearch()">
                            <i class="fas fa-times"></i> Clear
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Today's Expected Check-Ins -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-calendar-check"></i> Expected Check-Ins Today (<%= today %>)</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Guest Name</th>
                                    <th>Room</th>
                                    <th>Expected Time</th>
                                    <th>Nights</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String[][] expectedCheckIns = {
                                    {"B001", "John Smith", "101", "14:00", "3", "+94 77 123 4567", "pending"},
                                    {"B002", "Emma Davis", "205", "14:30", "4", "+94 77 234 5678", "pending"},
                                    {"B003", "Mike Johnson", "310", "15:00", "3", "+94 77 345 6789", "completed"},
                                    {"B004", "Sarah Williams", "102", "15:30", "2", "+94 77 456 7890", "pending"},
                                    {"B005", "David Brown", "408", "16:00", "5", "+94 77 567 8901", "pending"},
                                    {"B006", "Lisa Anderson", "201", "16:30", "3", "+94 77 678 9012", "completed"},
                                    {"B007", "Michael Chen", "203", "14:00", "5", "+94 77 789 0123", "pending"}
                                };
                                
                                for (String[] checkIn : expectedCheckIns) {
                                    String status = checkIn[6];
                                    boolean isCompleted = "completed".equals(status);
                                %>
                                <tr class="<%= isCompleted ? "table-success" : "" %>">
                                    <td><strong>#<%= checkIn[0] %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar-sm"><%= checkIn[1].charAt(0) %></div>
                                            <span class="ms-2"><%= checkIn[1] %></span>
                                        </div>
                                    </td>
                                    <td><span class="badge badge-primary">Room <%= checkIn[2] %></span></td>
                                    <td><i class="fas fa-clock"></i> <%= checkIn[3] %></td>
                                    <td><%= checkIn[4] %> nights</td>
                                    <td><%= checkIn[5] %></td>
                                    <td>
                                        <% if (isCompleted) { %>
                                        <span class="badge badge-success"><i class="fas fa-check"></i> Completed</span>
                                        <% } else { %>
                                        <span class="badge badge-warning"><i class="fas fa-clock"></i> Pending</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (!isCompleted) { %>
                                        <button class="btn btn-sm btn-primary" onclick="processCheckIn('<%= checkIn[0] %>', '<%= checkIn[1] %>', '<%= checkIn[2] %>')">
                                            <i class="fas fa-sign-in-alt"></i> Check-In
                                        </button>
                                        <% } else { %>
                                        <button class="btn btn-sm btn-info" onclick="viewDetails('<%= checkIn[0] %>')">
                                            <i class="fas fa-eye"></i> View
                                        </button>
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
</div>

<!-- Check-In Modal -->
<div class="modal fade" id="checkInModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fas fa-sign-in-alt"></i> Process Check-In</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="checkInForm">
                    <!-- Guest Information -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-user"></i> Guest Information</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Booking ID</label>
                            <input type="text" class="form-control" id="modalBookingId" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Guest Name</label>
                            <input type="text" class="form-control" id="modalGuestName" readonly>
                        </div>
                    </div>
                    
                    <!-- Room Information -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-door-open"></i> Room Information</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Room Number</label>
                            <input type="text" class="form-control" id="modalRoomNumber" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Room Type</label>
                            <input type="text" class="form-control" value="Deluxe" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Room Status</label>
                            <select class="form-control" id="roomStatus" required>
                                <option value="CLEAN">Clean & Ready</option>
                                <option value="NEEDS_CLEANING">Needs Cleaning</option>
                                <option value="MAINTENANCE">Under Maintenance</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Stay Details -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-calendar-alt"></i> Stay Details</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Check-In Date</label>
                            <input type="date" class="form-control" id="actualCheckInDate" value="<%= today %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Check-In Time</label>
                            <input type="time" class="form-control" id="checkInTime" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Number of Guests</label>
                            <input type="number" class="form-control" id="numberOfGuests" value="2" min="1" required>
                        </div>
                    </div>
                    
                    <!-- Payment & Documents -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-file-invoice-dollar"></i> Payment & Documents</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Payment Method</label>
                            <select class="form-control" id="paymentMethod" required>
                                <option value="">Select Payment Method</option>
                                <option value="CREDIT_CARD">Credit Card</option>
                                <option value="DEBIT_CARD">Debit Card</option>
                                <option value="CASH">Cash</option>
                                <option value="BANK_TRANSFER">Bank Transfer</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">ID Document Type</label>
                            <select class="form-control" id="idDocumentType" required>
                                <option value="">Select ID Type</option>
                                <option value="PASSPORT">Passport</option>
                                <option value="NATIONAL_ID">National ID</option>
                                <option value="DRIVING_LICENSE">Driving License</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="form-label">ID Document Number</label>
                            <input type="text" class="form-control" id="idDocumentNumber" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Deposit Amount (Rs.)</label>
                            <input type="number" class="form-control" id="depositAmount" value="10000" required>
                        </div>
                    </div>
                    
                    <!-- Special Requests -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-comment"></i> Special Requests & Notes</h5>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Additional Notes</label>
                        <textarea class="form-control" id="checkInNotes" rows="3" placeholder="Any special requests or notes..."></textarea>
                    </div>
                    
                    <!-- Key Assignment -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-key"></i> Key Card Assignment</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Key Card Number</label>
                            <input type="text" class="form-control" id="keyCardNumber" placeholder="e.g., KEY-101-A" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Number of Keys</label>
                            <input type="number" class="form-control" id="numberOfKeys" value="2" min="1" max="4" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-primary" onclick="confirmCheckIn()">
                    <i class="fas fa-check"></i> Complete Check-In
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function searchReservation() {
    const bookingId = document.getElementById('bookingId').value;
    const guestName = document.getElementById('guestName').value;
    const phoneNumber = document.getElementById('phoneNumber').value;
    
    if (!bookingId && !guestName && !phoneNumber) {
        alert('Please enter at least one search criteria');
        return;
    }
    
    console.log('Searching:', { bookingId, guestName, phoneNumber });
    // Implement search logic
}

function clearSearch() {
    document.getElementById('bookingId').value = '';
    document.getElementById('guestName').value = '';
    document.getElementById('phoneNumber').value = '';
}

function processCheckIn(bookingId, guestName, roomNumber) {
    // Populate modal with data
    document.getElementById('modalBookingId').value = bookingId;
    document.getElementById('modalGuestName').value = guestName;
    document.getElementById('modalRoomNumber').value = roomNumber;
    
    // Set current time
    const now = new Date();
    const timeString = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
    document.getElementById('checkInTime').value = timeString;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('checkInModal'));
    modal.show();
}

function confirmCheckIn() {
    const form = document.getElementById('checkInForm');
    
    if (form.checkValidity()) {
        const bookingId = document.getElementById('modalBookingId').value;
        const guestName = document.getElementById('modalGuestName').value;
        const roomNumber = document.getElementById('modalRoomNumber').value;
        
        if (confirm('Confirm check-in for ' + guestName + ' to Room ' + roomNumber + '?')) {
            // Submit form via AJAX
            alert('Check-in completed successfully!\n\nBooking ID: ' + bookingId + '\nGuest: ' + guestName + '\nRoom: ' + roomNumber);
            
            // Close modal and reload
            bootstrap.Modal.getInstance(document.getElementById('checkInModal')).hide();
            setTimeout(() => location.reload(), 500);
        }
    } else {
        form.reportValidity();
    }
}

function viewDetails(bookingId) {
    window.location.href = '<%= contextPath %>/staff/bookings/' + bookingId;
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

.section-header {
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--ocean-blue);
    margin-bottom: 1rem;
}

.section-header h5 {
    margin: 0;
    color: var(--ocean-dark);
    font-weight: 600;
}

.table-success {
    background-color: rgba(40, 167, 69, 0.1);
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
    .modal-dialog {
        max-width: 95%;
        margin: 1rem auto;
    }
}
</style>

<jsp:include page="../common/footer.jsp" />
