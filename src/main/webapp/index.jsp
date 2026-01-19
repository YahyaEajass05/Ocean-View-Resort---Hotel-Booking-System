<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>

<jsp:include page="views/common/header.jsp">
    <jsp:param name="title" value="Home" />
    <jsp:param name="css" value="home" />
    <jsp:param name="active" value="home" />
</jsp:include>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-content">
        <h1 class="hero-title">Welcome to Ocean View Resort</h1>
        <p class="hero-subtitle">Experience Luxury by the Ocean</p>
        <div class="hero-cta">
            <a href="<%= contextPath %>/rooms" class="btn btn-primary btn-lg">
                <i class="fas fa-search"></i> Explore Rooms
            </a>
            <a href="<%= contextPath %>/about" class="btn btn-outline btn-lg">
                <i class="fas fa-info-circle"></i> Learn More
            </a>
        </div>
    </div>
</section>

<!-- Search Section -->
<section class="search-section">
    <div class="container">
        <form action="<%= contextPath %>/rooms" method="get" class="search-form">
            <div class="form-group">
                <label for="checkIn" class="form-label">Check-in</label>
                <input type="date" id="checkIn" name="checkIn" class="form-control" 
                       data-min-date="today" required>
            </div>
            
            <div class="form-group">
                <label for="checkOut" class="form-label">Check-out</label>
                <input type="date" id="checkOut" name="checkOut" class="form-control" 
                       data-min-date="today" required>
            </div>
            
            <div class="form-group">
                <label for="guests" class="form-label">Guests</label>
                <select id="guests" name="guests" class="form-control">
                    <option value="1">1 Guest</option>
                    <option value="2" selected>2 Guests</option>
                    <option value="3">3 Guests</option>
                    <option value="4">4 Guests</option>
                    <option value="5">5+ Guests</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary btn-lg">
                <i class="fas fa-search"></i> Search Rooms
            </button>
        </form>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="container">
        <div class="section-title">
            <h2>Why Choose Ocean View Resort</h2>
            <p>Experience world-class hospitality and luxury amenities</p>
        </div>
        
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-concierge-bell"></i>
                </div>
                <h3>24/7 Service</h3>
                <p>Round-the-clock assistance to make your stay comfortable and memorable.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-swimming-pool"></i>
                </div>
                <h3>Infinity Pool</h3>
                <p>Stunning infinity pool with breathtaking ocean views.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-spa"></i>
                </div>
                <h3>Spa & Wellness</h3>
                <p>Rejuvenate your body and mind with our premium spa services.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-utensils"></i>
                </div>
                <h3>Fine Dining</h3>
                <p>Exquisite culinary experiences from our award-winning chefs.</p>
            </div>
        </div>
    </div>
</section>

<!-- Rooms Section -->
<section class="rooms">
    <div class="container">
        <div class="section-title">
            <h2>Our Rooms & Suites</h2>
            <p>Choose from our selection of luxurious accommodations</p>
        </div>
        
        <div class="rooms-grid">
            <div class="room-card">
                <div class="room-image">
                    <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400" 
                         alt="Deluxe Room">
                    <span class="room-badge">Popular</span>
                </div>
                <div class="room-info">
                    <h3 class="room-title">Deluxe Room</h3>
                    <div class="room-features">
                        <span class="room-feature">
                            <i class="fas fa-bed"></i> King Bed
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-users"></i> 2 Guests
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-ruler-combined"></i> 35 m²
                        </span>
                    </div>
                    <p>Spacious room with modern amenities and partial ocean view.</p>
                    <div class="room-price">
                        <div class="price">$150 <span>/ night</span></div>
                        <a href="<%= contextPath %>/rooms?type=DELUXE" class="btn btn-primary">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-image">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400" 
                         alt="Ocean Suite">
                    <span class="room-badge">Luxury</span>
                </div>
                <div class="room-info">
                    <h3 class="room-title">Ocean Suite</h3>
                    <div class="room-features">
                        <span class="room-feature">
                            <i class="fas fa-bed"></i> King Bed
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-users"></i> 4 Guests
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-ruler-combined"></i> 65 m²
                        </span>
                    </div>
                    <p>Luxurious suite with panoramic ocean views and private balcony.</p>
                    <div class="room-price">
                        <div class="price">$299 <span>/ night</span></div>
                        <a href="<%= contextPath %>/rooms?type=SUITE" class="btn btn-primary">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="room-card">
                <div class="room-image">
                    <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400" 
                         alt="Presidential Suite">
                    <span class="room-badge">Premium</span>
                </div>
                <div class="room-info">
                    <h3 class="room-title">Presidential Suite</h3>
                    <div class="room-features">
                        <span class="room-feature">
                            <i class="fas fa-bed"></i> 2 King Beds
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-users"></i> 6 Guests
                        </span>
                        <span class="room-feature">
                            <i class="fas fa-ruler-combined"></i> 120 m²
                        </span>
                    </div>
                    <p>Ultimate luxury with private pool and stunning ocean views.</p>
                    <div class="room-price">
                        <div class="price">$599 <span>/ night</span></div>
                        <a href="<%= contextPath %>/rooms?type=PRESIDENTIAL" class="btn btn-primary">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <a href="<%= contextPath %>/rooms" class="btn btn-outline btn-lg">
                View All Rooms <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2>Ready for Your Perfect Getaway?</h2>
        <p>Book your stay today and experience luxury like never before</p>
        <a href="<%= contextPath %>/rooms" class="btn btn-white btn-lg">
            <i class="fas fa-calendar-check"></i> Book Now
        </a>
    </div>
</section>

<jsp:include page="views/common/footer.jsp" />
