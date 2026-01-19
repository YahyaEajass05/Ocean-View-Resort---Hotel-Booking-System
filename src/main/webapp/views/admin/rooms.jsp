<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.oceanview.model.*" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Get data from servlet
    @SuppressWarnings("unchecked")
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    if (rooms == null) {
        rooms = new ArrayList<>();
    }
    
    // Calculate statistics
    int availableCount = 0;
    int occupiedCount = 0;
    int maintenanceCount = 0;
    
    for (Room room : rooms) {
        if (room.getStatus() == Room.RoomStatus.AVAILABLE) availableCount++;
        else if (room.getStatus() == Room.RoomStatus.OCCUPIED) occupiedCount++;
        else if (room.getStatus() == Room.RoomStatus.MAINTENANCE) maintenanceCount++;
    }
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Manage Rooms" />
    <jsp:param name="css" value="admin" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="rooms" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="admin-page">
        <div class="container-fluid py-4">
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-bed"></i> Manage Rooms</h1>
                    <p class="text-muted">Configure rooms, pricing, and availability</p>
                </div>
            </div>
            
            <!-- Room Statistics -->
            <div class="stats-grid mb-4">
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #28A745, #20c997);">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= availableCount %></h3>
                        <p>Available Rooms</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #DC3545, #c82333);">
                        <i class="fas fa-door-closed"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= occupiedCount %></h3>
                        <p>Occupied Rooms</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #FFC107, #FF9800);">
                        <i class="fas fa-tools"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= maintenanceCount %></h3>
                        <p>Under Maintenance</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #006994, #4A90A4);">
                        <i class="fas fa-bed"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= rooms.size() %></h3>
                        <p>Total Rooms</p>
                    </div>
                </div>
            </div>
        
        <!-- Filter and Actions -->
        <div class="search-filter-section">
            <form class="search-form-admin" id="filterForm">
                <div class="form-group">
                    <input type="text" id="searchRoom" class="form-control" 
                           placeholder="Search by room number or type">
                </div>
                
                <div class="form-group">
                    <select id="filterType" class="form-control">
                        <option value="">All Room Types</option>
                        <option value="STANDARD">Standard</option>
                        <option value="DELUXE">Deluxe</option>
                        <option value="SUITE">Suite</option>
                        <option value="PRESIDENTIAL">Presidential</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <select id="filterStatus" class="form-control">
                        <option value="">All Status</option>
                        <option value="AVAILABLE">Available</option>
                        <option value="OCCUPIED">Occupied</option>
                        <option value="MAINTENANCE">Maintenance</option>
                        <option value="CLEANING">Cleaning</option>
                    </select>
                </div>
            </form>
            
            <div class="header-actions">
                <button class="btn btn-success" onclick="openAddRoomModal()">
                    <i class="fas fa-plus"></i> Add New Room
                </button>
                <button class="btn btn-secondary" onclick="bulkUpdatePricing()">
                    <i class="fas fa-dollar-sign"></i> Update Pricing
                </button>
            </div>
        </div>
        
        <!-- Rooms Grid -->
        <div class="admin-section">
            <div class="rooms-management-grid" id="roomsGrid">
                <%
                if (rooms != null && !rooms.isEmpty()) {
                    for (Room room : rooms) {
                        String statusClass = room.getStatus().name().toLowerCase();
                        String statusBadgeClass = "";
                        if (room.getStatus() == Room.RoomStatus.AVAILABLE) statusBadgeClass = "available";
                        else if (room.getStatus() == Room.RoomStatus.OCCUPIED) statusBadgeClass = "occupied";
                        else if (room.getStatus() == Room.RoomStatus.MAINTENANCE) statusBadgeClass = "maintenance";
                        else statusBadgeClass = "cleaning";
                %>
                <div class="room-management-card" data-room-id="<%= room.getRoomId() %>">
                    <div class="room-card-header">
                        <h3 class="room-card-number"><%= room.getRoomNumber() %></h3>
                        <p class="room-card-type"><%= room.getRoomType() %></p>
                        <span class="room-status-badge <%= statusBadgeClass %>"><%= room.getStatus() %></span>
                    </div>
                    <div class="room-card-body">
                        <div class="room-info-item">
                            <span><i class="fas fa-users"></i> Capacity</span>
                            <strong><%= room.getCapacity() %> Guests</strong>
                        </div>
                        <div class="room-info-item">
                            <span><i class="fas fa-building"></i> Floor</span>
                            <strong><%= room.getFloorNumber() != null ? room.getFloorNumber() : "N/A" %></strong>
                        </div>
                        <div class="room-info-item">
                            <span><i class="fas fa-ruler-combined"></i> Size</span>
                            <strong><%= room.getSize() != null ? room.getSize() + " m²" : "N/A" %></strong>
                        </div>
                        <div class="room-price-display">
                            Rs. <%= room.getPricePerNight() %> <small style="font-size:0.5em;">/ night</small>
                        </div>
                        <div class="room-card-actions">
                            <a href="<%= request.getContextPath() %>/room?action=edit&id=<%= room.getRoomId() %>" 
                               class="btn btn-sm btn-primary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <button class="btn btn-sm btn-warning" onclick="changeRoomStatus(<%= room.getRoomId() %>, '<%= room.getStatus() %>')">
                                <i class="fas fa-exchange-alt"></i> Status
                            </button>
                            <a href="<%= request.getContextPath() %>/room?action=delete&id=<%= room.getRoomId() %>" 
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this room?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="empty-state" style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
                    <i class="fas fa-bed fa-3x text-muted mb-3"></i>
                    <h3 class="text-muted">No Rooms Found</h3>
                    <p class="text-muted">Click "Add New Room" to create your first room</p>
                </div>
                <%
                }
                %>
            </div>
        </div>
        </div>
    </div>
</div>

<!-- Add/Edit Room Modal -->
<div class="modal-overlay" id="roomModal">
    <div class="modal modal-large">
        <div class="modal-header">
            <h2 class="modal-title" id="modalTitle">Add New Room</h2>
            <button class="modal-close" onclick="closeRoomModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="roomForm" onsubmit="saveRoom(event)">
                <input type="hidden" id="roomId">
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="roomNumber" class="form-label">Room Number *</label>
                            <input type="text" id="roomNumber" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="roomType" class="form-label">Room Type *</label>
                            <select id="roomType" class="form-control" required>
                                <option value="">Select Type</option>
                                <option value="STANDARD">Standard</option>
                                <option value="DELUXE">Deluxe</option>
                                <option value="SUITE">Suite</option>
                                <option value="PRESIDENTIAL">Presidential</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="pricePerNight" class="form-label">Price per Night ($) *</label>
                            <input type="number" id="pricePerNight" class="form-control" 
                                   min="0" step="0.01" required>
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="capacity" class="form-label">Capacity *</label>
                            <input type="number" id="capacity" class="form-control" 
                                   min="1" max="10" required>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-6">
                        <div class="form-group">
                            <label for="floor" class="form-label">Floor</label>
                            <input type="number" id="floor" class="form-control" min="1" max="50">
                        </div>
                    </div>
                    
                    <div class="col-6">
                        <div class="form-group">
                            <label for="size" class="form-label">Size (m²)</label>
                            <input type="number" id="size" class="form-control" min="10">
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="status" class="form-label">Status *</label>
                    <select id="status" class="form-control" required>
                        <option value="AVAILABLE">Available</option>
                        <option value="OCCUPIED">Occupied</option>
                        <option value="MAINTENANCE">Maintenance</option>
                        <option value="CLEANING">Cleaning</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <textarea id="description" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Amenities</label>
                    <div class="amenities-checkboxes">
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="wifi"> Free WiFi
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="tv"> Smart TV
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="minibar"> Mini Bar
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="safe"> Safe
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="balcony"> Balcony
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="amenity" value="oceanview"> Ocean View
                        </label>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeRoomModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Room
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
.rooms-management-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.5rem;
}

.room-management-card {
    background: white;
    border-radius: 1rem;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s;
    position: relative;
}

.room-management-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 15px rgba(0,0,0,0.2);
}

.room-card-header {
    background: linear-gradient(135deg, #006994, #4A90A4);
    color: white;
    padding: 1.5rem;
    position: relative;
}

.room-card-number {
    font-size: 2rem;
    font-weight: bold;
    margin: 0;
}

.room-card-type {
    font-size: 0.875rem;
    opacity: 0.9;
}

.room-status-badge {
    position: absolute;
    top: 1rem;
    right: 1rem;
    padding: 0.25rem 0.75rem;
    border-radius: 1rem;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
}

.room-status-badge.available { background: #28A745; }
.room-status-badge.occupied { background: #DC3545; }
.room-status-badge.maintenance { background: #FFC107; color: #000; }
.room-status-badge.cleaning { background: #17A2B8; }

.room-card-body {
    padding: 1.5rem;
}

.room-info-item {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.75rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #eee;
}

.room-info-item:last-child {
    border-bottom: none;
}

.room-price-display {
    font-size: 1.75rem;
    color: #006994;
    font-weight: bold;
    text-align: center;
    padding: 1rem 0;
    background: #f8f9fa;
    border-radius: 0.5rem;
    margin: 1rem 0;
}

.room-card-actions {
    display: flex;
    gap: 0.5rem;
}

.amenities-checkboxes {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
}

.loading-spinner {
    grid-column: 1 / -1;
    text-align: center;
    padding: 3rem;
    color: #6c757d;
}
</style>

<script>
// Filter functionality
document.getElementById('searchRoom')?.addEventListener('input', filterRooms);
document.getElementById('filterType')?.addEventListener('change', filterRooms);
document.getElementById('filterStatus')?.addEventListener('change', filterRooms);

function filterRooms() {
    const search = document.getElementById('searchRoom').value.toLowerCase();
    const type = document.getElementById('filterType').value;
    const status = document.getElementById('filterStatus').value;
    
    const cards = document.querySelectorAll('.room-management-card');
    cards.forEach(card => {
        const roomText = card.textContent.toLowerCase();
        const roomStatus = card.querySelector('.room-status-badge')?.textContent.trim();
        const roomType = card.querySelector('.room-card-type')?.textContent.trim();
        
        const matchesSearch = roomText.includes(search);
        const matchesType = !type || roomType === type;
        const matchesStatus = !status || roomStatus === status;
        
        card.style.display = matchesSearch && matchesType && matchesStatus ? 'block' : 'none';
    });
}

function openAddRoomModal() {
    window.location.href = '<%= request.getContextPath() %>/room?action=new';
}

function changeRoomStatus(roomId, currentStatus) {
    const statuses = ['AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'CLEANING'];
    const currentIndex = statuses.indexOf(currentStatus);
    const newStatus = statuses[(currentIndex + 1) % statuses.length];
    
    // In a real application, this would make an AJAX call to update the status
    if (confirm('Change room status to ' + newStatus + '?')) {
        window.location.href = '<%= request.getContextPath() %>/room?action=updateStatus&id=' + roomId + '&status=' + newStatus;
    }
}

function bulkUpdatePricing() {
    const percentage = prompt('Enter percentage increase (e.g., 10 for 10% increase):');
    if (percentage && !isNaN(percentage)) {
        window.location.href = '<%= request.getContextPath() %>/room?action=bulkUpdatePrice&percentage=' + percentage;
    }
}
</script>

<jsp:include page="../common/footer.jsp" />
