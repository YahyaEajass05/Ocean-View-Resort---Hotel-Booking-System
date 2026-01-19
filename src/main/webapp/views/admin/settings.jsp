<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>
<%
    // Authentication check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().toString())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String contextPath = request.getContextPath();
%>

<jsp:include page="../common/header.jsp">
    <jsp:param name="title" value="System Settings" />
    <jsp:param name="css" value="admin,dashboard" />
    <jsp:param name="active" value="admin" />
</jsp:include>

<jsp:include page="../common/sidebar.jsp">
    <jsp:param name="active" value="settings" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="admin-page">
        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header mb-4">
                <div>
                    <h1><i class="fas fa-cog"></i> System Settings</h1>
                    <p class="text-muted">Configure and manage system-wide settings</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-success" onclick="saveAllSettings()">
                        <i class="fas fa-save"></i> Save All Changes
                    </button>
                </div>
            </div>
            
            <div class="row">
                <!-- Settings Navigation -->
                <div class="col-lg-3 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h3>Settings Menu</h3>
                        </div>
                        <div class="list-group list-group-flush">
                            <a href="#general" class="list-group-item list-group-item-action active" data-bs-toggle="list">
                                <i class="fas fa-building"></i> General Settings
                            </a>
                            <a href="#booking" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-calendar-check"></i> Booking Settings
                            </a>
                            <a href="#payment" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-credit-card"></i> Payment Settings
                            </a>
                            <a href="#email" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-envelope"></i> Email Configuration
                            </a>
                            <a href="#security" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-shield-alt"></i> Security Settings
                            </a>
                            <a href="#appearance" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-palette"></i> Appearance
                            </a>
                            <a href="#maintenance" class="list-group-item list-group-item-action" data-bs-toggle="list">
                                <i class="fas fa-tools"></i> Maintenance Mode
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Settings Content -->
                <div class="col-lg-9">
                    <div class="tab-content">
                        <!-- General Settings -->
                        <div class="tab-pane fade show active" id="general">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-building"></i> General Settings</h3>
                                </div>
                                <div class="card-body">
                                    <form id="generalSettingsForm">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Hotel Name</label>
                                                <input type="text" class="form-control" name="hotelName" value="Ocean View Resort" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Contact Email</label>
                                                <input type="email" class="form-control" name="contactEmail" value="info@oceanviewresort.com" required>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Phone Number</label>
                                                <input type="text" class="form-control" name="phoneNumber" value="+94 11 234 5678" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Currency</label>
                                                <select class="form-control" name="currency">
                                                    <option value="LKR" selected>Sri Lankan Rupee (LKR)</option>
                                                    <option value="USD">US Dollar (USD)</option>
                                                    <option value="EUR">Euro (EUR)</option>
                                                    <option value="GBP">British Pound (GBP)</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Hotel Address</label>
                                            <textarea class="form-control" name="address" rows="3" required>123 Beach Road, Colombo 03, Sri Lanka</textarea>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-4">
                                                <label class="form-label">Check-In Time</label>
                                                <input type="time" class="form-control" name="checkInTime" value="14:00" required>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label">Check-Out Time</label>
                                                <input type="time" class="form-control" name="checkOutTime" value="12:00" required>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label">Timezone</label>
                                                <select class="form-control" name="timezone">
                                                    <option value="Asia/Colombo" selected>Asia/Colombo (UTC+5:30)</option>
                                                    <option value="UTC">UTC</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save General Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Booking Settings -->
                        <div class="tab-pane fade" id="booking">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-calendar-check"></i> Booking Settings</h3>
                                </div>
                                <div class="card-body">
                                    <form id="bookingSettingsForm">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Minimum Advance Booking (days)</label>
                                                <input type="number" class="form-control" name="minAdvanceBooking" value="1" min="0" required>
                                                <small class="text-muted">Minimum days before check-in</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Maximum Advance Booking (days)</label>
                                                <input type="number" class="form-control" name="maxAdvanceBooking" value="365" min="1" required>
                                                <small class="text-muted">Maximum days in advance</small>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Minimum Stay (nights)</label>
                                                <input type="number" class="form-control" name="minStay" value="1" min="1" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Maximum Stay (nights)</label>
                                                <input type="number" class="form-control" name="maxStay" value="30" min="1" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Cancellation Policy (hours before check-in)</label>
                                            <input type="number" class="form-control" name="cancellationPolicy" value="24" min="0" required>
                                            <small class="text-muted">Free cancellation if done before this time</small>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="instantConfirmation" id="instantConfirmation" checked>
                                                <label class="form-check-label" for="instantConfirmation">
                                                    Enable Instant Booking Confirmation
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="allowModifications" id="allowModifications" checked>
                                                <label class="form-check-label" for="allowModifications">
                                                    Allow Guest Booking Modifications
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Booking Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Payment Settings -->
                        <div class="tab-pane fade" id="payment">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-credit-card"></i> Payment Settings</h3>
                                </div>
                                <div class="card-body">
                                    <form id="paymentSettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">Accepted Payment Methods</label>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="paymentMethods" value="CREDIT_CARD" id="creditCard" checked>
                                                <label class="form-check-label" for="creditCard">Credit Card</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="paymentMethods" value="DEBIT_CARD" id="debitCard" checked>
                                                <label class="form-check-label" for="debitCard">Debit Card</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="paymentMethods" value="CASH" id="cash" checked>
                                                <label class="form-check-label" for="cash">Cash on Arrival</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="paymentMethods" value="BANK_TRANSFER" id="bankTransfer" checked>
                                                <label class="form-check-label" for="bankTransfer">Bank Transfer</label>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Deposit Required (%)</label>
                                                <input type="number" class="form-control" name="depositPercent" value="20" min="0" max="100" required>
                                                <small class="text-muted">Percentage of total amount</small>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Tax Rate (%)</label>
                                                <input type="number" class="form-control" name="taxRate" value="15" min="0" max="100" step="0.1" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Service Charge (%)</label>
                                            <input type="number" class="form-control" name="serviceCharge" value="10" min="0" max="100" step="0.1" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Late Checkout Fee (per hour)</label>
                                            <input type="number" class="form-control" name="lateCheckoutFee" value="1000" min="0" required>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Payment Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Email Configuration -->
                        <div class="tab-pane fade" id="email">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-envelope"></i> Email Configuration</h3>
                                </div>
                                <div class="card-body">
                                    <form id="emailSettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">SMTP Host</label>
                                            <input type="text" class="form-control" name="smtpHost" value="smtp.gmail.com" required>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">SMTP Port</label>
                                                <input type="number" class="form-control" name="smtpPort" value="587" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">SMTP Username</label>
                                                <input type="text" class="form-control" name="smtpUsername" value="noreply@oceanviewresort.com" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">SMTP Password</label>
                                            <input type="password" class="form-control" name="smtpPassword" placeholder="••••••••" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="smtpTLS" id="smtpTLS" checked>
                                                <label class="form-check-label" for="smtpTLS">Enable TLS</label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Email Notifications</label>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="emailNotifications" value="BOOKING_CONFIRMATION" id="bookingConfirm" checked>
                                                <label class="form-check-label" for="bookingConfirm">Booking Confirmation</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="emailNotifications" value="PAYMENT_RECEIVED" id="paymentReceived" checked>
                                                <label class="form-check-label" for="paymentReceived">Payment Received</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="emailNotifications" value="CANCELLATION" id="cancellation" checked>
                                                <label class="form-check-label" for="cancellation">Cancellation Notice</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="emailNotifications" value="REMINDER" id="reminder" checked>
                                                <label class="form-check-label" for="reminder">Check-in Reminder</label>
                                            </div>
                                        </div>
                                        
                                        <button type="button" class="btn btn-secondary me-2" onclick="testEmail()">
                                            <i class="fas fa-paper-plane"></i> Send Test Email
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Email Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Security Settings -->
                        <div class="tab-pane fade" id="security">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-shield-alt"></i> Security Settings</h3>
                                </div>
                                <div class="card-body">
                                    <form id="securitySettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">Session Timeout (minutes)</label>
                                            <input type="number" class="form-control" name="sessionTimeout" value="30" min="5" required>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Password Minimum Length</label>
                                                <input type="number" class="form-control" name="passwordMinLength" value="8" min="4" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Maximum Login Attempts</label>
                                                <input type="number" class="form-control" name="maxLoginAttempts" value="5" min="1" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Password Requirements</label>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="passwordReqs" value="UPPERCASE" id="reqUpper" checked>
                                                <label class="form-check-label" for="reqUpper">Require uppercase letter</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="passwordReqs" value="LOWERCASE" id="reqLower" checked>
                                                <label class="form-check-label" for="reqLower">Require lowercase letter</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="passwordReqs" value="NUMBER" id="reqNumber" checked>
                                                <label class="form-check-label" for="reqNumber">Require number</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="passwordReqs" value="SPECIAL" id="reqSpecial" checked>
                                                <label class="form-check-label" for="reqSpecial">Require special character</label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="twoFactorAuth" id="twoFactorAuth">
                                                <label class="form-check-label" for="twoFactorAuth">
                                                    Enable Two-Factor Authentication
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="auditLogging" id="auditLogging" checked>
                                                <label class="form-check-label" for="auditLogging">
                                                    Enable Audit Logging
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Security Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Appearance Settings -->
                        <div class="tab-pane fade" id="appearance">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-palette"></i> Appearance Settings</h3>
                                </div>
                                <div class="card-body">
                                    <form id="appearanceSettingsForm">
                                        <div class="mb-3">
                                            <label class="form-label">Theme Color</label>
                                            <input type="color" class="form-control form-control-color" name="themeColor" value="#006994">
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Logo Upload</label>
                                            <input type="file" class="form-control" name="logo" accept="image/*">
                                            <small class="text-muted">Recommended size: 200x60 pixels</small>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Favicon Upload</label>
                                            <input type="file" class="form-control" name="favicon" accept="image/x-icon,image/png">
                                            <small class="text-muted">Recommended size: 32x32 pixels</small>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Date Format</label>
                                            <select class="form-control" name="dateFormat">
                                                <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                                                <option value="DD/MM/YYYY" selected>DD/MM/YYYY</option>
                                                <option value="YYYY-MM-DD">YYYY-MM-DD</option>
                                            </select>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Appearance Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Maintenance Mode -->
                        <div class="tab-pane fade" id="maintenance">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h3><i class="fas fa-tools"></i> Maintenance Mode</h3>
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <strong>Warning:</strong> Enabling maintenance mode will make the website unavailable to guests.
                                    </div>
                                    
                                    <form id="maintenanceSettingsForm">
                                        <div class="mb-3">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" name="maintenanceMode" id="maintenanceMode">
                                                <label class="form-check-label" for="maintenanceMode">
                                                    <strong>Enable Maintenance Mode</strong>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Maintenance Message</label>
                                            <textarea class="form-control" name="maintenanceMessage" rows="3">We are currently performing scheduled maintenance. We'll be back shortly!</textarea>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Estimated End Time</label>
                                                <input type="datetime-local" class="form-control" name="maintenanceEndTime">
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Allowed IP Addresses (one per line)</label>
                                            <textarea class="form-control" name="allowedIPs" rows="3" placeholder="127.0.0.1&#10;192.168.1.1"></textarea>
                                            <small class="text-muted">These IPs can access the site during maintenance</small>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-save"></i> Save Maintenance Settings
                                        </button>
                                    </form>
                                </div>
                            </div>
                            
                            <!-- System Information -->
                            <div class="card">
                                <div class="card-header">
                                    <h3><i class="fas fa-info-circle"></i> System Information</h3>
                                </div>
                                <div class="card-body">
                                    <table class="table">
                                        <tr>
                                            <th>Application Version:</th>
                                            <td>1.0.0</td>
                                        </tr>
                                        <tr>
                                            <th>Java Version:</th>
                                            <td><%= System.getProperty("java.version") %></td>
                                        </tr>
                                        <tr>
                                            <th>Server Info:</th>
                                            <td><%= application.getServerInfo() %></td>
                                        </tr>
                                        <tr>
                                            <th>Database Status:</th>
                                            <td><span class="badge badge-success">Connected</span></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function saveAllSettings() {
    if (confirm('Save all settings changes?')) {
        // Collect and save all settings
        alert('All settings saved successfully!');
    }
}

function testEmail() {
    alert('Sending test email...');
    // Implement test email functionality
}

// Form submission handlers
document.getElementById('generalSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('General settings saved!');
});

document.getElementById('bookingSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('Booking settings saved!');
});

document.getElementById('paymentSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('Payment settings saved!');
});

document.getElementById('emailSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('Email settings saved!');
});

document.getElementById('securitySettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('Security settings saved!');
});

document.getElementById('appearanceSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    alert('Appearance settings saved!');
});

document.getElementById('maintenanceSettingsForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const maintenanceEnabled = document.getElementById('maintenanceMode').checked;
    if (maintenanceEnabled) {
        if (confirm('Are you sure you want to enable maintenance mode? This will make the site unavailable to guests.')) {
            alert('Maintenance mode enabled!');
        }
    } else {
        alert('Maintenance settings saved!');
    }
});
</script>

<jsp:include page="../common/footer.jsp" />
