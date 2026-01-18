<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Ocean View Resort - Welcome</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    
    <style>
        /* Hero Section */
        .hero-section {
            background: linear-gradient(rgba(30, 58, 138, 0.7), rgba(30, 58, 138, 0.7)),
                        url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920') center/cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            animation: fadeIn 1s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .hero-content h1 {
            font-size: 4rem;
            font-weight: bold;
            margin-bottom: 1.5rem;
            animation: slideDown 1s ease-out;
        }
        
        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .hero-content p {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            animation: slideUp 1s ease-out;
        }
        
        @keyframes slideUp {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .btn-primary {
            background-color: #f59e0b;
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            border-radius: 30px;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background-color: #d97706;
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }
        
        /* Features Section */
        .features-section {
            padding: 80px 0;
            background-color: #f3f4f6;
        }
        
        .feature-card {
            text-align: center;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin: 20px 0;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        
        .feature-icon {
            font-size: 3rem;
            color: #1e3a8a;
            margin-bottom: 20px;
        }
        
        .feature-card h3 {
            color: #1e3a8a;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hotel"></i> Ocean View Resort
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#rooms">Rooms</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-warning text-dark ms-2" href="${pageContext.request.contextPath}/register">
                            Register
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-content">
            <h1><i class="fas fa-water"></i> Ocean View Resort</h1>
            <p>Experience Luxury by the Beach</p>
            <a href="${pageContext.request.contextPath}/views/guest/search-rooms.jsp" class="btn btn-primary btn-lg">
                <i class="fas fa-search"></i> Book Your Stay
            </a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <h2 class="text-center mb-5" style="color: #1e3a8a; font-weight: bold;">Why Choose Us?</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-umbrella-beach"></i>
                        </div>
                        <h3>Beachfront Location</h3>
                        <p>Direct access to pristine beaches with stunning ocean views from your room.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-concierge-bell"></i>
                        </div>
                        <h3>24/7 Service</h3>
                        <p>Round-the-clock concierge and room service for your convenience.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-wifi"></i>
                        </div>
                        <h3>Free WiFi</h3>
                        <p>High-speed internet throughout the resort to keep you connected.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-swimming-pool"></i>
                        </div>
                        <h3>Infinity Pool</h3>
                        <p>Relax in our stunning infinity pool with panoramic ocean views.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-utensils"></i>
                        </div>
                        <h3>Fine Dining</h3>
                        <p>Gourmet restaurants serving international and local cuisine.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-spa"></i>
                        </div>
                        <h3>Luxury Spa</h3>
                        <p>Rejuvenate with our world-class spa and wellness treatments.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-4">
        <div class="container">
            <p>&copy; 2026 Ocean View Resort. All rights reserved.</p>
            <p>
                <i class="fas fa-map-marker-alt"></i> Galle, Sri Lanka | 
                <i class="fas fa-phone"></i> +94 91 234 5678 | 
                <i class="fas fa-envelope"></i> info@oceanviewresort.com
            </p>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
