<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
    String pageJs = request.getParameter("js");
%>

    </main>
    <!-- Main Content End -->
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <!-- About Section -->
                <div class="footer-section">
                    <h3>About Ocean View Resort</h3>
                    <p>Experience luxury and comfort at Ocean View Resort. We offer world-class amenities, stunning ocean views, and exceptional service to make your stay unforgettable.</p>
                    <div class="footer-social">
                        <a href="https://facebook.com" target="_blank" title="Facebook">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="https://twitter.com" target="_blank" title="Twitter">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="https://instagram.com" target="_blank" title="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                        <a href="https://linkedin.com" target="_blank" title="LinkedIn">
                            <i class="fab fa-linkedin-in"></i>
                        </a>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul class="footer-links">
                        <li><a href="<%= contextPath %>/"><i class="fas fa-chevron-right"></i> Home</a></li>
                        <li><a href="<%= contextPath %>/rooms"><i class="fas fa-chevron-right"></i> Rooms & Suites</a></li>
                        <li><a href="<%= contextPath %>/about"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="<%= contextPath %>/offers"><i class="fas fa-chevron-right"></i> Special Offers</a></li>
                        <li><a href="<%= contextPath %>/contact"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                    </ul>
                </div>
                
                <!-- Services -->
                <div class="footer-section">
                    <h3>Our Services</h3>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Room Service</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Restaurant & Bar</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Spa & Wellness</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Swimming Pool</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Conference Rooms</a></li>
                    </ul>
                </div>
                
                <!-- Contact Info -->
                <div class="footer-section">
                    <h3>Contact Info</h3>
                    <ul class="footer-contact-info">
                        <li>
                            <i class="fas fa-map-marker-alt"></i>
                            <span>123 Beach Road, Colombo 03<br>Sri Lanka</span>
                        </li>
                        <li>
                            <i class="fas fa-phone"></i>
                            <span>+94 11 234 5678</span>
                        </li>
                        <li>
                            <i class="fas fa-envelope"></i>
                            <span>info@oceanviewresort.com</span>
                        </li>
                        <li>
                            <i class="fas fa-clock"></i>
                            <span>24/7 Support Available</span>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Newsletter -->
            <div class="newsletter-section mt-4">
                <div class="row align-center">
                    <div class="col-md-6">
                        <h3>Subscribe to Our Newsletter</h3>
                        <p>Get exclusive offers and updates delivered to your inbox.</p>
                    </div>
                    <div class="col-md-6">
                        <form class="newsletter-form" id="newsletterForm">
                            <input type="email" placeholder="Enter your email" required>
                            <button type="submit">Subscribe</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Footer Bottom -->
            <div class="footer-bottom">
                <p>&copy; <%= java.time.Year.now().getValue() %> Ocean View Resort. All rights reserved. | 
                    <a href="<%= contextPath %>/privacy-policy">Privacy Policy</a> | 
                    <a href="<%= contextPath %>/terms">Terms & Conditions</a>
                </p>
            </div>
        </div>
    </footer>
    
    <!-- JavaScript Files -->
    <script src="<%= contextPath %>/assets/js/main.js"></script>
    
    <!-- Additional Page-Specific JS -->
    <% if (pageJs != null && !pageJs.isEmpty()) { %>
        <script src="<%= contextPath %>/assets/js/<%= pageJs %>.js"></script>
    <% } %>
    
    <script>
        // Mobile menu toggle
        document.getElementById('menuToggle')?.addEventListener('click', function() {
            document.getElementById('navMenu').classList.toggle('active');
        });
        
        // Auto-hide alerts after 5 seconds
        document.querySelectorAll('.alert').forEach(function(alert) {
            setTimeout(function() {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            }, 5000);
        });
    </script>
</body>
</html>
