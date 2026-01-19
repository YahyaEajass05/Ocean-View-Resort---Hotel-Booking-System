<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Register" />
    <jsp:param name="css" value="auth" />
</jsp:include>

<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Create Account</h1>
                <p>Join us for an amazing experience</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/register" method="post" class="auth-form" id="registerForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName" class="form-label">
                            <i class="fas fa-user"></i> First Name
                        </label>
                        <input type="text" id="firstName" name="firstName" class="form-control" 
                               placeholder="Enter first name" required>
                        <span class="error-message" id="firstNameError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName" class="form-label">
                            <i class="fas fa-user"></i> Last Name
                        </label>
                        <input type="text" id="lastName" name="lastName" class="form-control" 
                               placeholder="Enter last name" required>
                        <span class="error-message" id="lastNameError"></span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="Enter your email" required>
                    <span class="error-message" id="emailError"></span>
                </div>
                
                <div class="form-group">
                    <label for="phone" class="form-label">
                        <i class="fas fa-phone"></i> Phone Number
                    </label>
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           placeholder="Enter phone number" required>
                    <span class="error-message" id="phoneError"></span>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <div class="password-input">
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Create a password" required>
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="password-icon"></i>
                        </button>
                    </div>
                    <span class="form-text">Password must be at least 8 characters with uppercase, lowercase, and number</span>
                    <span class="error-message" id="passwordError"></span>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <div class="password-input">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Confirm your password" required>
                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye" id="confirmPassword-icon"></i>
                        </button>
                    </div>
                    <span class="error-message" id="confirmPasswordError"></span>
                </div>
                
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="terms" id="terms" required>
                        <span>I agree to the 
                            <a href="${pageContext.request.contextPath}/terms" target="_blank">Terms & Conditions</a> 
                            and 
                            <a href="${pageContext.request.contextPath}/privacy-policy" target="_blank">Privacy Policy</a>
                        </span>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
                
                <div class="auth-divider">
                    <span>OR</span>
                </div>
                
                <div class="social-login">
                    <button type="button" class="btn btn-social btn-google">
                        <i class="fab fa-google"></i> Sign up with Google
                    </button>
                    <button type="button" class="btn btn-social btn-facebook">
                        <i class="fab fa-facebook-f"></i> Sign up with Facebook
                    </button>
                </div>
                
                <div class="auth-footer">
                    <p>Already have an account? 
                        <a href="${pageContext.request.contextPath}/login">Login here</a>
                    </p>
                </div>
            </form>
        </div>
        
        <div class="auth-info">
            <div class="info-content">
                <h2>Why Choose Us?</h2>
                <p>Join thousands of satisfied guests who trust Ocean View Resort for their perfect getaway.</p>
                <ul class="info-features">
                    <li><i class="fas fa-check-circle"></i> Instant Booking Confirmation</li>
                    <li><i class="fas fa-check-circle"></i> Best Price Guarantee</li>
                    <li><i class="fas fa-check-circle"></i> Flexible Cancellation</li>
                    <li><i class="fas fa-check-circle"></i> Exclusive Member Benefits</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const icon = document.getElementById(fieldId + '-icon');
    
    if (field.type === 'password') {
        field.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        field.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Form validation
document.getElementById('registerForm').addEventListener('submit', function(e) {
    let isValid = true;
    
    // Clear previous errors
    document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
    document.querySelectorAll('.form-control').forEach(el => el.classList.remove('error'));
    
    // First name validation
    const firstName = document.getElementById('firstName');
    if (firstName.value.trim().length < 2) {
        document.getElementById('firstNameError').textContent = 'First name must be at least 2 characters';
        firstName.classList.add('error');
        isValid = false;
    }
    
    // Last name validation
    const lastName = document.getElementById('lastName');
    if (lastName.value.trim().length < 2) {
        document.getElementById('lastNameError').textContent = 'Last name must be at least 2 characters';
        lastName.classList.add('error');
        isValid = false;
    }
    
    // Email validation
    const email = document.getElementById('email');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.value)) {
        document.getElementById('emailError').textContent = 'Please enter a valid email address';
        email.classList.add('error');
        isValid = false;
    }
    
    // Phone validation
    const phone = document.getElementById('phone');
    const phoneRegex = /^[0-9+\-\s()]{10,}$/;
    if (!phoneRegex.test(phone.value)) {
        document.getElementById('phoneError').textContent = 'Please enter a valid phone number';
        phone.classList.add('error');
        isValid = false;
    }
    
    // Password validation
    const password = document.getElementById('password');
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    if (!passwordRegex.test(password.value)) {
        document.getElementById('passwordError').textContent = 'Password must meet the requirements';
        password.classList.add('error');
        isValid = false;
    }
    
    // Confirm password validation
    const confirmPassword = document.getElementById('confirmPassword');
    if (password.value !== confirmPassword.value) {
        document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
        confirmPassword.classList.add('error');
        isValid = false;
    }
    
    if (!isValid) {
        e.preventDefault();
    }
});

// Real-time password strength indicator
document.getElementById('password').addEventListener('input', function() {
    // Add password strength indicator logic here
});
</script>

<jsp:include page="../common/footer.jsp" />
