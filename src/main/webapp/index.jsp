<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Luxury Hotel & Spa</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* ===================================
           MAIN STYLES
           =================================== */
        
        /* CSS Variables */
        :root {
            --ocean-blue: #006994;
            --ocean-light: #4A90A4;
            --ocean-dark: #003d5c;
            --sand-beige: #F5E6D3;
            --coral-accent: #FF6B6B;
            --gold-accent: #D4AF37;
            --white: #FFFFFF;
            --light-gray: #F8F9FA;
            --gray: #6C757D;
            --dark-gray: #343A40;
            --black: #212529;
            --success: #28A745;
            --warning: #FFC107;
            --danger: #DC3545;
            --info: #17A2B8;
            --spacing-xs: 0.25rem;
            --spacing-sm: 0.5rem;
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
            --spacing-xxl: 3rem;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --radius-sm: 0.25rem;
            --radius-md: 0.5rem;
            --radius-lg: 1rem;
            --transition-fast: 0.15s ease-in-out;
            --transition-base: 0.3s ease-in-out;
            --transition-slow: 0.5s ease-in-out;
        }
        
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        html {
            font-size: 16px;
            scroll-behavior: smooth;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--black);
            background-color: var(--light-gray);
            line-height: 1.6;
        }
        
        a {
            text-decoration: none;
            color: var(--ocean-blue);
            transition: color var(--transition-fast);
        }
        
        a:hover {
            color: var(--ocean-dark);
        }
        
        img {
            max-width: 100%;
            height: auto;
            display: block;
        }
        
        /* Container */
        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-md);
        }
        
        /* Buttons */
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
            text-align: center;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all var(--transition-base);
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--ocean-blue);
            color: var(--white);
        }
        
        .btn-primary:hover {
            background-color: var(--ocean-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .btn-outline {
            background-color: transparent;
            border: 2px solid var(--ocean-blue);
            color: var(--ocean-blue);
        }
        
        .btn-outline:hover {
            background-color: var(--ocean-blue);
            color: var(--white);
        }
        
        .btn-white {
            background-color: var(--white);
            color: var(--ocean-blue);
        }
        
        .btn-white:hover {
            background-color: var(--sand-beige);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .btn-lg {
            padding: 1rem 2rem;
            font-size: 1.125rem;
        }
        
        /* Header/Navigation */
        .navbar {
            background-color: var(--white);
            box-shadow: var(--shadow-md);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--ocean-blue);
        }
        
        .navbar-nav {
            display: flex;
            list-style: none;
            gap: 2rem;
            align-items: center;
        }
        
        .nav-link {
            color: var(--dark-gray);
            font-weight: 500;
        }
        
        .nav-link:hover {
            color: var(--ocean-blue);
        }
        
        /* Hero Section */
        .hero {
            position: relative;
            height: 600px;
            background: linear-gradient(rgba(0, 61, 92, 0.5), rgba(0, 61, 92, 0.7)),
                        url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: var(--white);
        }
        
        .hero-content {
            max-width: 800px;
            padding: var(--spacing-xl);
        }
        
        .hero-title {
            font-size: 3rem;
            margin-bottom: var(--spacing-lg);
            color: var(--white);
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .hero-subtitle {
            font-size: 1.5rem;
            margin-bottom: var(--spacing-xl);
            color: var(--sand-beige);
        }
        
        .hero-cta {
            display: flex;
            gap: var(--spacing-md);
            justify-content: center;
            flex-wrap: wrap;
        }
        
        /* Search Section */
        .search-section {
            background-color: var(--white);
            padding: var(--spacing-xl) 0;
            box-shadow: var(--shadow-lg);
            margin-top: -80px;
            position: relative;
            z-index: 10;
        }
        
        .search-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-md);
            align-items: end;
        }
        
        .form-group {
            margin-bottom: 0;
        }
        
        .form-label {
            display: block;
            margin-bottom: var(--spacing-sm);
            font-weight: 500;
            color: var(--dark-gray);
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            font-size: 1rem;
            border: 1px solid #ced4da;
            border-radius: var(--radius-md);
            transition: border-color var(--transition-fast);
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--ocean-blue);
            box-shadow: 0 0 0 3px rgba(0, 105, 148, 0.1);
        }
        
        /* Features Section */
        .features {
            padding: var(--spacing-xxl) 0;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .section-title h2 {
            font-size: 2.5rem;
            color: var(--ocean-dark);
        }
        
        .section-title p {
            font-size: 1.125rem;
            color: var(--gray);
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-xl);
        }
        
        .feature-card {
            text-align: center;
            padding: var(--spacing-xl);
            border-radius: var(--radius-lg);
            transition: all var(--transition-base);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto var(--spacing-lg);
            background: linear-gradient(135deg, var(--ocean-blue), var(--ocean-light));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: var(--white);
        }
        
        .feature-card h3 {
            margin-bottom: var(--spacing-md);
            color: var(--ocean-dark);
        }
        
        /* Rooms Section */
        .rooms {
            padding: var(--spacing-xxl) 0;
            background-color: var(--light-gray);
        }
        
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--spacing-xl);
        }
        
        .room-card {
            background-color: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: all var(--transition-base);
        }
        
        .room-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
        }
        
        .room-image {
            height: 250px;
            overflow: hidden;
            position: relative;
        }
        
        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform var(--transition-slow);
        }
        
        .room-card:hover .room-image img {
            transform: scale(1.1);
        }
        
        .room-badge {
            position: absolute;
            top: var(--spacing-md);
            right: var(--spacing-md);
            background-color: var(--gold-accent);
            color: var(--white);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--radius-md);
            font-weight: 600;
        }
        
        .room-info {
            padding: var(--spacing-lg);
        }
        
        .room-title {
            font-size: 1.5rem;
            margin-bottom: var(--spacing-sm);
            color: var(--ocean-dark);
        }
        
        .room-features {
            display: flex;
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            flex-wrap: wrap;
        }
        
        .room-feature {
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
            color: var(--gray);
            font-size: 0.875rem;
        }
        
        .room-price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: var(--spacing-lg);
        }
        
        .price {
            font-size: 1.75rem;
            color: var(--ocean-blue);
            font-weight: 700;
        }
        
        .price span {
            font-size: 1rem;
            color: var(--gray);
            font-weight: 400;
        }
        
        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
            color: var(--white);
            padding: var(--spacing-xxl) 0;
            text-align: center;
        }
        
        .cta-section h2 {
            color: var(--white);
            font-size: 2.5rem;
            margin-bottom: var(--spacing-lg);
        }
        
        .cta-section p {
            font-size: 1.25rem;
            margin-bottom: var(--spacing-xl);
            color: var(--sand-beige);
        }
        
        /* Footer */
        .footer {
            background-color: var(--ocean-dark);
            color: var(--white);
            padding: var(--spacing-xxl) 0 var(--spacing-lg);
        }
        
        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-xl);
            margin-bottom: var(--spacing-xl);
        }
        
        .footer-section h3 {
            color: var(--white);
            margin-bottom: var(--spacing-md);
        }
        
        .footer-links {
            list-style: none;
        }
        
        .footer-links li {
            margin-bottom: var(--spacing-sm);
        }
        
        .footer-links a {
            color: var(--sand-beige);
        }
        
        .footer-links a:hover {
            color: var(--white);
        }
        
        .footer-bottom {
            text-align: center;
            padding-top: var(--spacing-lg);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--sand-beige);
        }
        
        .text-center {
            text-align: center;
        }
        
        .mt-4 {
            margin-top: var(--spacing-xl);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                height: 400px;
            }
            
            .hero-title {
                font-size: 2rem;
            }
            
            .hero-subtitle {
                font-size: 1.125rem;
            }
            
            .hero-cta {
                flex-direction: column;
            }
            
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .section-title h2 {
                font-size: 2rem;
            }
            
            .navbar-nav {
                gap: 1rem;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="navbar">
    <div class="container">
        <a href="<%= contextPath %>/" class="navbar-brand">
            <i class="fas fa-hotel"></i> Ocean View Resort
        </a>
        <ul class="navbar-nav">
            <li><a href="<%= contextPath %>/" class="nav-link">Home</a></li>
            <li><a href="<%= contextPath %>/rooms" class="nav-link">Rooms</a></li>
            <li><a href="<%= contextPath %>/login" class="nav-link">Login</a></li>
            <li><a href="<%= contextPath %>/register" class="btn btn-primary">Book Now</a></li>
        </ul>
    </div>
</nav>

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

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3><i class="fas fa-hotel"></i> Ocean View Resort</h3>
                <p>Experience luxury by the ocean with world-class amenities and exceptional service.</p>
            </div>
            
            <div class="footer-section">
                <h3>Quick Links</h3>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="<%= contextPath %>/rooms"><i class="fas fa-bed"></i> Rooms</a></li>
                    <li><a href="<%= contextPath %>/about"><i class="fas fa-info-circle"></i> About Us</a></li>
                    <li><a href="<%= contextPath %>/contact"><i class="fas fa-envelope"></i> Contact</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Contact Info</h3>
                <ul class="footer-links">
                    <li><i class="fas fa-map-marker-alt"></i> 123 Beach Road, Paradise Island</li>
                    <li><i class="fas fa-phone"></i> +1 (555) 123-4567</li>
                    <li><i class="fas fa-envelope"></i> info@oceanviewresort.com</li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Follow Us</h3>
                <ul class="footer-links">
                    <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="#"><i class="fab fa-instagram"></i> Instagram</a></li>
                    <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2026 Ocean View Resort. All rights reserved.</p>
        </div>
    </div>
</footer>

</body>
</html>
