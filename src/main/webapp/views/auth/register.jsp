<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Ocean View Resort</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* ===================================
           REGISTER PAGE STYLES
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
            --danger: #DC3545;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --radius-sm: 0.25rem;
            --radius-md: 0.5rem;
            --radius-lg: 1rem;
            --transition-fast: 0.15s ease-in-out;
            --transition-base: 0.3s ease-in-out;
        }
        
        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--black);
            background: linear-gradient(135deg, var(--ocean-light) 0%, var(--ocean-dark) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        
        /* Auth Page Container */
        .auth-page {
            width: 100%;
            max-width: 1200px;
        }
        
        .auth-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }
        
        /* Auth Card */
        .auth-card {
            padding: 3rem;
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .auth-header h1 {
            color: var(--ocean-dark);
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .auth-header p {
            color: var(--gray);
            font-size: 1rem;
        }
        
        /* Form Styles */
        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-gray);
            font-size: 0.95rem;
        }
        
        .form-label i {
            color: var(--ocean-blue);
            margin-right: 0.25rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.875rem 1rem;
            font-size: 1rem;
            border: 2px solid #E0E0E0;
            border-radius: var(--radius-md);
            transition: all var(--transition-fast);
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--ocean-blue);
            box-shadow: 0 0 0 3px rgba(0, 105, 148, 0.1);
        }
        
        .form-control.error {
            border-color: var(--danger);
        }
        
        .form-control.error:focus {
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }
        
        /* Password Input with Toggle */
        .password-input {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .password-input .form-control {
            padding-right: 3rem;
        }
        
        .password-toggle {
            position: absolute;
            right: 1rem;
            background: none;
            border: none;
            color: var(--gray);
            cursor: pointer;
            padding: 0.5rem;
            transition: color var(--transition-fast);
        }
        
        .password-toggle:hover {
            color: var(--ocean-blue);
        }
        
        /* Form Text */
        .form-text {
            font-size: 0.875rem;
            color: var(--gray);
            margin-top: -0.25rem;
        }
        
        /* Error Message */
        .error-message {
            color: var(--danger);
            font-size: 0.875rem;
            margin-top: -0.25rem;
            display: block;
            min-height: 1.25rem;
        }
        
        /* Checkbox Label */
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            font-size: 0.95rem;
            color: var(--dark-gray);
        }
        
        .checkbox-label input[type="checkbox"] {
            width: 1.25rem;
            height: 1.25rem;
            cursor: pointer;
            accent-color: var(--ocean-blue);
        }
        
        .checkbox-label a {
            color: var(--ocean-blue);
            text-decoration: none;
        }
        
        .checkbox-label a:hover {
            text-decoration: underline;
        }
        
        /* Buttons */
        .btn {
            padding: 1rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all var(--transition-base);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-family: inherit;
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
        
        .btn-block {
            width: 100%;
        }
        
        /* Auth Footer */
        .auth-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #E0E0E0;
        }
        
        .auth-footer p {
            color: var(--gray);
        }
        
        .auth-footer a {
            color: var(--ocean-blue);
            font-weight: 600;
            text-decoration: none;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
        
        /* Auth Info Section */
        .auth-info {
            background: linear-gradient(135deg, var(--ocean-blue) 0%, var(--ocean-dark) 100%);
            color: var(--white);
            padding: 3rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .info-content h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--white);
        }
        
        .info-content p {
            font-size: 1.125rem;
            margin-bottom: 2rem;
            color: var(--sand-beige);
            line-height: 1.6;
        }
        
        .info-features {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .info-features li {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.05rem;
        }
        
        .info-features i {
            color: var(--gold-accent);
            font-size: 1.25rem;
        }
        
        /* Alert Messages */
        .alert {
            padding: 1rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-danger {
            background-color: #F8D7DA;
            color: #721C24;
            border: 1px solid #F5C6CB;
        }
        
        .alert-success {
            background-color: #D4EDDA;
            color: #155724;
            border: 1px solid #C3E6CB;
        }
        
        /* Responsive Design */
        @media (max-width: 968px) {
            .auth-container {
                grid-template-columns: 1fr;
            }
            
            .auth-info {
                order: -1;
                padding: 2rem;
            }
            
            .info-content h2 {
                font-size: 1.5rem;
            }
            
            .info-content p {
                font-size: 1rem;
            }
        }
        
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .auth-card {
                padding: 2rem 1.5rem;
            }
            
            .auth-header h1 {
                font-size: 1.75rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .auth-info {
                padding: 1.5rem;
            }
        }
        
        /* Back to Home Link */
        .back-home {
            position: fixed;
            top: 2rem;
            left: 2rem;
            color: var(--white);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            padding: 0.75rem 1.25rem;
            background: rgba(255, 255, 255, 0.2);
            border-radius: var(--radius-md);
            backdrop-filter: blur(10px);
            transition: all var(--transition-base);
        }
        
        .back-home:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-5px);
        }
        
        @media (max-width: 768px) {
            .back-home {
                top: 1rem;
                left: 1rem;
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body>

<!-- Back to Home Link -->
<a href="<%= contextPath %>/" class="back-home">
    <i class="fas fa-arrow-left"></i> Back to Home
</a>

<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Create Account</h1>
                <p>Join us for an amazing experience</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            
            <form action="<%= contextPath %>/register" method="post" class="auth-form" id="registerForm">
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
                    <label for="username" class="form-label">
                        <i class="fas fa-at"></i> Username
                    </label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="Choose a username" required>
                    <span class="error-message" id="usernameError"></span>
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
                            <a href="<%= contextPath %>/terms" target="_blank">Terms & Conditions</a> 
                            and 
                            <a href="<%= contextPath %>/privacy-policy" target="_blank">Privacy Policy</a>
                        </span>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
                
                <div class="auth-footer">
                    <p>Already have an account? 
                        <a href="<%= contextPath %>/login">Login here</a>
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
    
    // Username validation
    const username = document.getElementById('username');
    if (username.value.trim().length < 3) {
        document.getElementById('usernameError').textContent = 'Username must be at least 3 characters';
        username.classList.add('error');
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
</script>

</body>
</html>
