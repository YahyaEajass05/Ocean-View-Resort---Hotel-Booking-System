<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Rooms & Suites" />
    <jsp:param name="css" value="rooms" />
    <jsp:param name="active" value="rooms" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1>Rooms & Suites</h1>
        <p>Discover your perfect accommodation</p>
    </div>
</div>

<div class="rooms-page">
    <div class="container">
        <!-- Search & Filter Section -->
        <div class="search-filter-section">
            <form action="${pageContext.request.contextPath}/rooms" method="get" class="search-form-horizontal">
                <div class="form-group">
                    <label for="checkIn">Check-in Date</label>
                    <input type="date" id="checkIn" name="checkIn" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="checkOut">Check-out Date</label>
                    <input type="date" id="checkOut" name="checkOut" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="guests">Guests</label>
                    <select id="guests" name="guests" class="form-control">
                        <option value="1">1 Guest</option>
                        <option value="2" selected>2 Guests</option>
                        <option value="3">3 Guests</option>
                        <option value="4">4 Guests</option>
                        <option value="5">5+ Guests</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="roomType">Room Type</label>
                    <select id="roomType" name="roomType" class="form-control">
                        <option value="">All Types</option>
                        <option value="STANDARD">Standard</option>
                        <option value="DELUXE">Deluxe</option>
                        <option value="SUITE">Suite</option>
                        <option value="PRESIDENTIAL">Presidential</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </form>
            
            <!-- Filter Options -->
            <div class="filter-options">
                <button class="filter-btn" onclick="toggleFilters()">
                    <i class="fas fa-filter"></i> More Filters
                </button>
                <div class="sort-options">
                    <label>Sort by:</label>
                    <select id="sortBy" onchange="sortRooms(this.value)">
                        <option value="recommended">Recommended</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="rating">Highest Rated</option>
                    </select>
                </div>
            </div>
            
            <!-- Advanced Filters (Initially Hidden) -->
            <div class="advanced-filters" id="advancedFilters" style="display: none;">
                <div class="filter-group">
                    <h4>Price Range</h4>
                    <input type="range" min="50" max="1000" value="500" class="slider" id="priceRange">
                    <div class="range-values">
                        <span>$50</span>
                        <span id="priceValue">$500</span>
                        <span>$1000</span>
                    </div>
                </div>
                
                <div class="filter-group">
                    <h4>Amenities</h4>
                    <label class="checkbox-label">
                        <input type="checkbox" name="amenity" value="wifi">
                        <span>Free WiFi</span>
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" name="amenity" value="oceanview">
                        <span>Ocean View</span>
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" name="amenity" value="balcony">
                        <span>Private Balcony</span>
                    </label>
                    <label class="checkbox-label">
                        <input type="checkbox" name="amenity" value="minibar">
                        <span>Mini Bar</span>
                    </label>
                </div>
            </div>
        </div>
        
        <!-- Rooms Grid -->
        <c:choose>
            <c:when test="${not empty rooms}">
                <div class="rooms-grid">
                    <c:forEach items="${rooms}" var="room">
                        <div class="room-card-full" data-price="${room.pricePerNight}" data-type="${room.roomType}">
                            <div class="room-card-image">
                                <img src="${pageContext.request.contextPath}/assets/images/rooms/${room.roomType.name().toLowerCase()}.jpg" 
                                     alt="${room.roomType}">
                                <c:if test="${room.status == 'AVAILABLE'}">
                                    <span class="availability-badge available">Available</span>
                                </c:if>
                                <c:if test="${room.status == 'MAINTENANCE'}">
                                    <span class="availability-badge maintenance">Under Maintenance</span>
                                </c:if>
                                <div class="room-overlay">
                                    <button class="btn btn-white" onclick="viewRoom(${room.id})">
                                        <i class="fas fa-eye"></i> View Details
                                    </button>
                                </div>
                            </div>
                            
                            <div class="room-card-content">
                                <div class="room-card-header">
                                    <div>
                                        <h3>${room.roomType}</h3>
                                        <p class="room-number">Room ${room.roomNumber}</p>
                                    </div>
                                    <div class="room-rating">
                                        <i class="fas fa-star"></i>
                                        <span>4.8</span>
                                    </div>
                                </div>
                                
                                <p class="room-description">
                                    ${room.description != null ? room.description : 'Luxurious accommodation with modern amenities and stunning views.'}
                                </p>
                                
                                <div class="room-features-list">
                                    <span class="feature-badge">
                                        <i class="fas fa-bed"></i> ${room.capacity} Guests
                                    </span>
                                    <span class="feature-badge">
                                        <i class="fas fa-ruler-combined"></i> ${room.size != null ? room.size : '35'} m²
                                    </span>
                                    <span class="feature-badge">
                                        <i class="fas fa-wifi"></i> Free WiFi
                                    </span>
                                    <span class="feature-badge">
                                        <i class="fas fa-tv"></i> Smart TV
                                    </span>
                                </div>
                                
                                <div class="amenities-icons">
                                    <i class="fas fa-swimming-pool" title="Pool Access"></i>
                                    <i class="fas fa-dumbbell" title="Gym Access"></i>
                                    <i class="fas fa-concierge-bell" title="Room Service"></i>
                                    <i class="fas fa-spa" title="Spa Access"></i>
                                    <i class="fas fa-utensils" title="Restaurant"></i>
                                </div>
                                
                                <div class="room-card-footer">
                                    <div class="room-price">
                                        <span class="price-amount">$<fmt:formatNumber value="${room.pricePerNight}" pattern="#,##0" /></span>
                                        <span class="price-period">/ night</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${room.status == 'AVAILABLE'}">
                                            <button class="btn btn-primary" onclick="bookRoom(${room.id})">
                                                <i class="fas fa-calendar-check"></i> Book Now
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary" disabled>
                                                Not Available
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-bed"></i>
                    <h2>No Rooms Available</h2>
                    <p>Sorry, no rooms match your search criteria. Please try different dates or filters.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Room Details Modal -->
<div class="modal-overlay" id="roomModal">
    <div class="modal modal-large">
        <div class="modal-header">
            <h2 class="modal-title" id="modalRoomTitle">Room Details</h2>
            <button class="modal-close" onclick="closeRoomModal()">&times;</button>
        </div>
        <div class="modal-body" id="modalRoomContent">
            <!-- Room details will be loaded here -->
        </div>
    </div>
</div>

<script>
// Set minimum date to today
document.getElementById('checkIn').min = new Date().toISOString().split('T')[0];
document.getElementById('checkOut').min = new Date().toISOString().split('T')[0];

// Update checkout min date when checkin changes
document.getElementById('checkIn').addEventListener('change', function() {
    const checkInDate = new Date(this.value);
    checkInDate.setDate(checkInDate.getDate() + 1);
    document.getElementById('checkOut').min = checkInDate.toISOString().split('T')[0];
});

function toggleFilters() {
    const filters = document.getElementById('advancedFilters');
    filters.style.display = filters.style.display === 'none' ? 'block' : 'none';
}

function sortRooms(sortBy) {
    const roomsGrid = document.querySelector('.rooms-grid');
    const rooms = Array.from(roomsGrid.children);
    
    rooms.sort((a, b) => {
        switch(sortBy) {
            case 'price-low':
                return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
            case 'price-high':
                return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
            default:
                return 0;
        }
    });
    
    rooms.forEach(room => roomsGrid.appendChild(room));
}

function viewRoom(roomId) {
    // Load room details via AJAX
    fetch('${pageContext.request.contextPath}/api/rooms/' + roomId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('modalRoomTitle').textContent = data.roomType + ' - Room ' + data.roomNumber;
            document.getElementById('modalRoomContent').innerHTML = generateRoomDetails(data);
            document.getElementById('roomModal').classList.add('active');
        })
        .catch(error => {
            console.error('Error loading room details:', error);
            alert('Failed to load room details. Please try again.');
        });
}

function closeRoomModal() {
    document.getElementById('roomModal').classList.remove('active');
}

function bookRoom(roomId) {
    const checkIn = document.getElementById('checkIn').value;
    const checkOut = document.getElementById('checkOut').value;
    const guests = document.getElementById('guests').value;
    
    if (!checkIn || !checkOut) {
        alert('Please select check-in and check-out dates');
        return;
    }
    
    window.location.href = '${pageContext.request.contextPath}/reservation/new?roomId=' + roomId + 
                          '&checkIn=' + checkIn + '&checkOut=' + checkOut + '&guests=' + guests;
}

function generateRoomDetails(room) {
    return `
        <div class="room-details-full">
            <img src="${pageContext.request.contextPath}/assets/images/rooms/` + room.roomType.toLowerCase() + `.jpg" alt="` + room.roomType + `">
            <h3>` + room.roomType + `</h3>
            <p>Room Number: ` + room.roomNumber + `</p>
            <p>Price: $` + room.pricePerNight + ` per night</p>
            <p>Capacity: ` + room.capacity + ` guests</p>
            <button class="btn btn-primary" onclick="bookRoom(` + room.id + `)">Book Now</button>
        </div>
    `;
}

// Price range slider
document.getElementById('priceRange')?.addEventListener('input', function() {
    document.getElementById('priceValue').textContent = '$' + this.value;
});
</script>

<jsp:include page="../common/footer.jsp" />
