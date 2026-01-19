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
    <jsp:param name="title" value="Guest Check-Out" />
    <jsp:param name="css" value="staff,dashboard" />
    <jsp:param name="active" value="staff" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="check-out" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="staff-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-sign-out-alt"></i> Guest Check-Out</h1>
                    <p class="text-muted">Process guest departures and final billing</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-outline" onclick="location.href='<%= contextPath %>/staff/dashboard'">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </button>
                </div>
            </div>
            
            <!-- Quick Search -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-search"></i> Quick Search</h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Room Number</label>
                            <input type="text" class="form-control" id="roomNumber" placeholder="e.g., 101">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Guest Name</label>
                            <input type="text" class="form-control" id="guestName" placeholder="Enter guest name">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Booking ID</label>
                            <input type="text" class="form-control" id="bookingId" placeholder="e.g., B001">
                        </div>
                    </div>
                    <div class="mt-3">
                        <button class="btn btn-primary" onclick="searchGuest()">
                            <i class="fas fa-search"></i> Search Guest
                        </button>
                        <button class="btn btn-secondary" onclick="clearSearch()">
                            <i class="fas fa-times"></i> Clear
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Today's Expected Check-Outs -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-calendar-times"></i> Expected Check-Outs Today (<%= today %>)</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Guest Name</th>
                                    <th>Room</th>
                                    <th>Check-Out Time</th>
                                    <th>Total Days</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String[][] expectedCheckOuts = {
                                    {"B001", "John Smith", "101", "12:00", "3", "45000", "pending"},
                                    {"B002", "Emma Davis", "205", "11:30", "4", "72000", "completed"},
                                    {"B003", "Lisa Anderson", "201", "12:00", "3", "45000", "pending"},
                                    {"B004", "Robert Taylor", "305", "11:00", "3", "36000", "pending"},
                                    {"B005", "Michael Chen", "203", "12:30", "5", "75000", "pending"}
                                };
                                
                                for (String[] checkOut : expectedCheckOuts) {
                                    String status = checkOut[6];
                                    boolean isCompleted = "completed".equals(status);
                                %>
                                <tr class="<%= isCompleted ? "table-success" : "" %>">
                                    <td><strong>#<%= checkOut[0] %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar-sm"><%= checkOut[1].charAt(0) %></div>
                                            <span class="ms-2"><%= checkOut[1] %></span>
                                        </div>
                                    </td>
                                    <td><span class="badge badge-primary">Room <%= checkOut[2] %></span></td>
                                    <td><i class="fas fa-clock"></i> <%= checkOut[3] %></td>
                                    <td><%= checkOut[4] %> days</td>
                                    <td><strong>Rs. <%= checkOut[5] %></strong></td>
                                    <td>
                                        <% if (isCompleted) { %>
                                        <span class="badge badge-success"><i class="fas fa-check"></i> Completed</span>
                                        <% } else { %>
                                        <span class="badge badge-warning"><i class="fas fa-clock"></i> Pending</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (!isCompleted) { %>
                                        <button class="btn btn-sm btn-success" onclick="processCheckOut('<%= checkOut[0] %>', '<%= checkOut[1] %>', '<%= checkOut[2] %>', '<%= checkOut[5] %>')">
                                            <i class="fas fa-sign-out-alt"></i> Check-Out
                                        </button>
                                        <% } else { %>
                                        <button class="btn btn-sm btn-info" onclick="viewReceipt('<%= checkOut[0] %>')">
                                            <i class="fas fa-receipt"></i> Receipt
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

<!-- Check-Out Modal -->
<div class="modal fade" id="checkOutModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="fas fa-sign-out-alt"></i> Process Check-Out</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Booking Info -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="info-card">
                            <div class="info-label">Booking ID</div>
                            <div class="info-value" id="modalBookingId">-</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-card">
                            <div class="info-label">Guest Name</div>
                            <div class="info-value" id="modalGuestName">-</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-card">
                            <div class="info-label">Room Number</div>
                            <div class="info-value" id="modalRoomNumber">-</div>
                        </div>
                    </div>
                </div>
                
                <form id="checkOutForm">
                    <!-- Billing Summary -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-file-invoice-dollar"></i> Billing Summary</h5>
                    </div>
                    <div class="table-responsive mb-4">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Description</th>
                                    <th width="150">Amount (Rs.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Room Charges (3 nights @ Rs. 15,000)</td>
                                    <td class="text-end" id="roomCharges">45,000</td>
                                </tr>
                                <tr>
                                    <td>
                                        Minibar Charges
                                        <input type="number" class="form-control form-control-sm d-inline-block w-auto ms-2" 
                                               id="minibarCharges" value="0" min="0" onchange="calculateTotal()">
                                    </td>
                                    <td class="text-end" id="minibarTotal">0</td>
                                </tr>
                                <tr>
                                    <td>
                                        Room Service
                                        <input type="number" class="form-control form-control-sm d-inline-block w-auto ms-2" 
                                               id="roomServiceCharges" value="0" min="0" onchange="calculateTotal()">
                                    </td>
                                    <td class="text-end" id="roomServiceTotal">0</td>
                                </tr>
                                <tr>
                                    <td>Service Charge (10%)</td>
                                    <td class="text-end" id="serviceCharge">4,500</td>
                                </tr>
                                <tr>
                                    <td>Tax (15%)</td>
                                    <td class="text-end" id="taxAmount">6,750</td>
                                </tr>
                                <tr class="table-primary">
                                    <td><strong>Total Amount</strong></td>
                                    <td class="text-end"><strong id="totalAmount">56,250</strong></td>
                                </tr>
                                <tr>
                                    <td>Deposit Paid</td>
                                    <td class="text-end text-success">-10,000</td>
                                </tr>
                                <tr class="table-warning">
                                    <td><strong>Amount Due</strong></td>
                                    <td class="text-end"><strong id="amountDue">46,250</strong></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Payment Details -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-credit-card"></i> Payment Details</h5>
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
                            <label class="form-label">Amount Received (Rs.)</label>
                            <input type="number" class="form-control" id="amountReceived" required>
                        </div>
                    </div>
                    
                    <!-- Room Inspection -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-clipboard-check"></i> Room Inspection</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="roomCleanliness" checked>
                                <label class="form-check-label" for="roomCleanliness">
                                    Room Cleanliness Check
                                </label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="minibarCheck" checked>
                                <label class="form-check-label" for="minibarCheck">
                                    Minibar Items Check
                                </label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="damageCheck" checked>
                                <label class="form-check-label" for="damageCheck">
                                    No Damage Found
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Key Return -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-key"></i> Key Card Return</h5>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Key Cards Returned</label>
                            <input type="number" class="form-control" id="keysReturned" value="2" min="0" required>
                        </div>
                        <div class="col-md-6">
                            <div class="form-check mt-4">
                                <input class="form-check-input" type="checkbox" id="allKeysReturned" checked>
                                <label class="form-check-label" for="allKeysReturned">
                                    All key cards returned
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Feedback -->
                    <div class="section-header mb-3">
                        <h5><i class="fas fa-comment"></i> Guest Feedback</h5>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Overall Rating</label>
                        <div class="rating-stars mb-2">
                            <i class="fas fa-star text-warning fs-4" onclick="setRating(1)"></i>
                            <i class="fas fa-star text-warning fs-4" onclick="setRating(2)"></i>
                            <i class="fas fa-star text-warning fs-4" onclick="setRating(3)"></i>
                            <i class="fas fa-star text-warning fs-4" onclick="setRating(4)"></i>
                            <i class="fas fa-star text-warning fs-4" onclick="setRating(5)"></i>
                        </div>
                        <textarea class="form-control" id="guestFeedback" rows="2" placeholder="Any feedback or comments..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-success" onclick="confirmCheckOut()">
                    <i class="fas fa-check"></i> Complete Check-Out
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let baseAmount = 45000;

function searchGuest() {
    const room = document.getElementById('roomNumber').value;
    const name = document.getElementById('guestName').value;
    const booking = document.getElementById('bookingId').value;
    
    if (!room && !name && !booking) {
        alert('Please enter at least one search criteria');
        return;
    }
    
    console.log('Searching:', { room, name, booking });
}

function clearSearch() {
    document.getElementById('roomNumber').value = '';
    document.getElementById('guestName').value = '';
    document.getElementById('bookingId').value = '';
}

function processCheckOut(bookingId, guestName, roomNumber, amount) {
    baseAmount = parseInt(amount);
    document.getElementById('modalBookingId').textContent = bookingId;
    document.getElementById('modalGuestName').textContent = guestName;
    document.getElementById('modalRoomNumber').textContent = roomNumber;
    
    calculateTotal();
    
    const modal = new bootstrap.Modal(document.getElementById('checkOutModal'));
    modal.show();
}

function calculateTotal() {
    const minibar = parseInt(document.getElementById('minibarCharges').value) || 0;
    const roomService = parseInt(document.getElementById('roomServiceCharges').value) || 0;
    
    document.getElementById('minibarTotal').textContent = minibar.toLocaleString();
    document.getElementById('roomServiceTotal').textContent = roomService.toLocaleString();
    
    const subtotal = baseAmount + minibar + roomService;
    const serviceCharge = subtotal * 0.10;
    const tax = subtotal * 0.15;
    const total = subtotal + serviceCharge + tax;
    const due = total - 10000;
    
    document.getElementById('serviceCharge').textContent = serviceCharge.toLocaleString();
    document.getElementById('taxAmount').textContent = tax.toLocaleString();
    document.getElementById('totalAmount').textContent = total.toLocaleString();
    document.getElementById('amountDue').textContent = due.toLocaleString();
    document.getElementById('amountReceived').value = due;
}

function confirmCheckOut() {
    const form = document.getElementById('checkOutForm');
    
    if (form.checkValidity()) {
        const bookingId = document.getElementById('modalBookingId').textContent;
        const guestName = document.getElementById('modalGuestName').textContent;
        
        if (confirm('Confirm check-out for ' + guestName + '?')) {
            alert('Check-out completed successfully!\n\nBooking ID: ' + bookingId + '\nReceipt will be generated.');
            bootstrap.Modal.getInstance(document.getElementById('checkOutModal')).hide();
            setTimeout(() => location.reload(), 500);
        }
    } else {
        form.reportValidity();
    }
}

function viewReceipt(bookingId) {
    window.location.href = '<%= contextPath %>/staff/receipt/' + bookingId;
}

function setRating(stars) {
    console.log('Rating:', stars);
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

.info-card {
    padding: 1rem;
    background-color: #f8f9fa;
    border-radius: var(--radius-md);
    text-align: center;
}

.info-label {
    font-size: 0.875rem;
    color: #666;
    margin-bottom: 0.5rem;
}

.info-value {
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--ocean-dark);
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

.rating-stars i {
    cursor: pointer;
    margin: 0 0.25rem;
}

.rating-stars i:hover {
    transform: scale(1.2);
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
