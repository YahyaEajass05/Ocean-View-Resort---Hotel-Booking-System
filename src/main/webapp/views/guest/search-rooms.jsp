<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Search Rooms" />
    <jsp:param name="css" value="rooms,dashboard" />
    <jsp:param name="active" value="rooms" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="rooms" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="search-rooms-page">
        <div class="container-fluid py-4">
            <!-- Search Section -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3><i class="fas fa-search"></i> Search Available Rooms</h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Check-In Date</label>
                            <input type="date" class="form-control" id="checkInDate" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Check-Out Date</label>
                            <input type="date" class="form-control" id="checkOutDate" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Guests</label>
                            <input type="number" class="form-control" id="guests" value="2" min="1" max="4">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Room Type</label>
                            <select class="form-control" id="roomType">
                                <option value="">All Types</option>
                                <option value="STANDARD">Standard</option>
                                <option value="DELUXE">Deluxe</option>
                                <option value="SUITE">Suite</option>
                                <option value="PRESIDENTIAL">Presidential</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn btn-primary w-100" onclick="searchRooms()">
                                <i class="fas fa-search"></i> Search
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Available Rooms -->
            <div class="row">
                <%
                String[][] rooms = {
                    {"101", "STANDARD", "Standard Room", "35", "150", "2", "City View, WiFi, TV"},
                    {"205", "DELUXE", "Deluxe Ocean View", "45", "250", "2", "Ocean View, Balcony, WiFi, TV, Mini Bar"},
                    {"310", "SUITE", "Executive Suite", "60", "400", "4", "Ocean View, Living Room, Jacuzzi, WiFi"},
                    {"408", "PRESIDENTIAL", "Presidential Suite", "100", "800", "4", "Panoramic Ocean View, 2 Bedrooms, Butler Service"}
                };
                
                for (String[] room : rooms) {
                    String badgeClass = "";
                    if ("STANDARD".equals(room[1])) badgeClass = "badge-secondary";
                    else if ("DELUXE".equals(room[1])) badgeClass = "badge-primary";
                    else if ("SUITE".equals(room[1])) badgeClass = "badge-success";
                    else badgeClass = "badge-danger";
                %>
                <div class="col-lg-6 mb-4">
                    <div class="room-card">
                        <div class="room-image">
                            <img src="<%= contextPath %>/assets/images/rooms/<%= room[1].toLowerCase() %>.jpg" 
                                 alt="<%= room[2] %>" 
                                 onerror="this.src='https://via.placeholder.com/400x250?text=<%= room[2] %>'">
                            <span class="room-type-badge <%= badgeClass %>"><%= room[1] %></span>
                        </div>
                        <div class="room-details">
                            <div class="room-header">
                                <h4><%= room[2] %></h4>
                                <div class="room-price">
                                    <span class="price-value">$<%= room[4] %></span>
                                    <span class="price-unit">/night</span>
                                </div>
                            </div>
                            
                            <div class="room-info">
                                <div class="info-item">
                                    <i class="fas fa-ruler-combined"></i>
                                    <span><%= room[3] %> m²</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-users"></i>
                                    <span><%= room[5] %> Guests</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-bed"></i>
                                    <span>King Bed</span>
                                </div>
                            </div>
                            
                            <div class="room-amenities">
                                <% 
                                String[] amenities = room[6].split(", ");
                                for (String amenity : amenities) {
                                %>
                                <span class="amenity-tag"><i class="fas fa-check"></i> <%= amenity %></span>
                                <% } %>
                            </div>
                            
                            <div class="room-actions">
                                <button class="btn btn-outline btn-sm" onclick="viewRoomDetails('<%= room[0] %>')">
                                    <i class="fas fa-info-circle"></i> Details
                                </button>
                                <a href="<%= contextPath %>/guest/booking?room=<%= room[0] %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-calendar-check"></i> Book Now
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
function searchRooms() {
    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    
    if (!checkIn || !checkOut) {
        alert('Please select check-in and check-out dates');
        return;
    }
    
    console.log('Searching rooms:', { checkIn, checkOut });
    // Implement search logic
}

function viewRoomDetails(roomId) {
    alert('View details for room: ' + roomId);
}
</script>

<style>
.room-card {
    background: white;
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transition: all 0.3s;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.room-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.room-image {
    position: relative;
    height: 250px;
    overflow: hidden;
}

.room-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.room-type-badge {
    position: absolute;
    top: 1rem;
    left: 1rem;
    padding: 0.5rem 1rem;
    border-radius: var(--radius-md);
    color: white;
    font-weight: 600;
    font-size: 0.875rem;
}

.room-details {
    padding: 1.5rem;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.room-header {
    display: flex;
    justify-content: space-between;
    align-items: start;
    margin-bottom: 1rem;
}

.room-header h4 {
    margin: 0;
    color: var(--ocean-dark);
}

.room-price {
    text-align: right;
}

.price-value {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--ocean-blue);
}

.price-unit {
    font-size: 0.875rem;
    color: #666;
}

.room-info {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 1rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #e9ecef;
}

.info-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #666;
}

.info-item i {
    color: var(--ocean-blue);
}

.room-amenities {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-bottom: 1rem;
    flex: 1;
}

.amenity-tag {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.25rem 0.75rem;
    background-color: #e3f2fd;
    color: var(--ocean-blue);
    border-radius: var(--radius-sm);
    font-size: 0.875rem;
}

.amenity-tag i {
    font-size: 0.75rem;
}

.room-actions {
    display: flex;
    gap: 0.5rem;
    margin-top: auto;
}

.room-actions .btn {
    flex: 1;
}
</style>

<jsp:include page="../common/footer.jsp" />
