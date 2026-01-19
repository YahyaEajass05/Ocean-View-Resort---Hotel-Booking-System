<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="Login" />
    <jsp:param name="css" value="auth" />
</jsp:include>

<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Welcome Back</h1>
                <p>Login to access your account</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form" id="loginForm">
                <div class="form-group">
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="Enter your email" required>
                    <span class="error-message" id="emailError"></span>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <div class="password-input">
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Enter your password" required>
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="password-icon"></i>
                        </button>
                    </div>
                    <span class="error-message" id="passwordError"></span>
                </div>
                
                <div class="form-group form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember" id="remember">
                        <span>Remember me</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="link">
                        Forgot Password?
                    </a>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
                
                <div class="auth-divider">
                    <span>OR</span>
                </div>
                
                <div class="social-login">
                    <button type="button" class="btn btn-social btn-google">
                        <i class="fab fa-google"></i> Continue with Google
                    </button>
                    <button type="button" class="btn btn-social btn-facebook">
                        <i class="fab fa-facebook-f"></i> Continue with Facebook
                    </button>
                </div>
                
                <div class="auth-footer">
                    <p>Don't have an account? 
                        <a href="${pageContext.request.contextPath}/register">Register here</a>
                    </p>
                </div>
            </form>
        </div>
        
        <div class="auth-info">
            <div class="info-content">
                <h2>Ocean View Resort</h2>
                <p>Your gateway to paradise. Experience luxury accommodation with breathtaking ocean views.</p>
                <ul class="info-features">
                    <li><i class="fas fa-check-circle"></i> Luxury Rooms & Suites</li>
                    <li><i class="fas fa-check-circle"></i> World-class Amenities</li>
                    <li><i class="fas fa-check-circle"></i> 24/7 Customer Support</li>
                    <li><i class="fas fa-check-circle"></i> Easy Online Booking</li>
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
document.getElementById('loginForm').addEventListener('submit', function(e) {
    let isValid = true;
    
    // Clear previous errors
    document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
    document.querySelectorAll('.form-control').forEach(el => el.classList.remove('error'));
    
    // Email validation
    const email = document.getElementById('email');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.value)) {
        document.getElementById('emailError').textContent = 'Please enter a valid email address';
        email.classList.add('error');
        isValid = false;
    }
    
    // Password validation
    const password = document.getElementById('password');
    if (password.value.length < 6) {
        document.getElementById('passwordError').textContent = 'Password must be at least 6 characters';
        password.classList.add('error');
        isValid = false;
    }
    
    if (!isValid) {
        e.preventDefault();
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
