# Ocean View Resort - JavaScript Modules Documentation

## 📁 Files Overview

| File | Size | Purpose |
|------|------|---------|
| `main.js` | 12.72 KB | Core utilities and common functions |
| `validation.js` | 13.78 KB | Advanced form validation |
| `dashboard.js` | 10.15 KB | Dashboard data management |
| `booking.js` | 18.35 KB | Booking system logic |
| `charts.js` | 9.70 KB | Chart.js wrapper and utilities |

**Total:** ~65 KB of JavaScript code

---

## 1️⃣ main.js - Core Module

### Purpose
Main JavaScript file with common utilities, UI components, and helper functions.

### Key Features
- ✅ Mobile menu toggle
- ✅ Dropdown management
- ✅ Modal windows
- ✅ Alert notifications
- ✅ Form validation integration
- ✅ Toast notifications
- ✅ AJAX helpers
- ✅ Loading spinners
- ✅ Date/Currency formatting

### Usage Example
```javascript
// Initialize (auto-runs on page load)
OceanViewResort.init();

// Show toast notification
OceanViewResort.showToast('Booking confirmed!', 'success');

// Open/close modal
OceanViewResort.openModal('myModal');
OceanViewResort.closeModal('myModal');

// Format currency
const formatted = OceanViewResort.formatCurrency(1234.56); // "$1,234.56"

// AJAX request
OceanViewResort.ajax('/api/rooms', {
    method: 'GET'
}).then(data => console.log(data));
```

### Available Methods
- `init()` - Initialize all components
- `showToast(message, type)` - Show notification
- `openModal(modalId)` - Open modal
- `closeModal(modalId)` - Close modal
- `formatCurrency(amount)` - Format as currency
- `formatDate(date, format)` - Format date
- `ajax(url, options)` - Make AJAX request
- `showLoading()` / `hideLoading()` - Loading spinner

---

## 2️⃣ validation.js - Validation Module

### Purpose
Comprehensive form validation with real-time feedback and custom rules.

### Key Features
- ✅ Email validation
- ✅ Phone number validation
- ✅ Password strength checking
- ✅ Credit card validation (Luhn algorithm)
- ✅ Date range validation
- ✅ Custom validation rules
- ✅ Real-time error display
- ✅ Password strength indicator
- ✅ Field matching (confirm password)

### Usage Example
```javascript
// Auto-validates forms with data-validate="true"
<form data-validate="true">
    <input type="email" name="email" required>
    <input type="password" name="password" 
           data-validate-password="true" 
           data-show-strength="true">
</form>

// Manual validation
const isValid = Validation.validateField(inputElement);

// Add custom validator
Validation.customValidators.customRule = function(value) {
    if (/* your condition */) {
        return 'Error message';
    }
    return true;
};
```

### Validation Rules
- `required` - Field is required
- `email` - Valid email format
- `phone` - Valid phone number
- `password` - Strong password (8+ chars, uppercase, lowercase, number, special)
- `minLength` - Minimum length
- `maxLength` - Maximum length
- `min` / `max` - Numeric range
- `match` - Match another field
- `pattern` - Custom regex pattern
- `creditCard` - Valid credit card

### Data Attributes
```html
<input type="text" 
       required 
       minlength="3" 
       maxlength="50"
       data-validation="email"
       data-pattern="^[A-Z]+$"
       data-pattern-error="Only uppercase letters"
       data-match="otherFieldId">
```

---

## 3️⃣ dashboard.js - Dashboard Module

### Purpose
Manages dashboard data loading, updates, and real-time statistics.

### Key Features
- ✅ Auto-refresh data
- ✅ Animated stat updates
- ✅ Chart data updates
- ✅ Table data rendering
- ✅ Notifications
- ✅ Export functionality
- ✅ Date range filters

### Usage Example
```javascript
// Initialize dashboard
Dashboard.init({
    refreshInterval: 30000, // 30 seconds
    animationDuration: 500
});

// Manual refresh
Dashboard.loadDashboardData();

// Start/stop auto-refresh
Dashboard.startAutoRefresh();
Dashboard.stopAutoRefresh();

// Export data
Dashboard.exportData('csv'); // or 'excel', 'pdf'

// Get current stats
const stats = Dashboard.getStats();
```

### API Endpoints Expected
- `GET /api/dashboard/data` - Load dashboard data

### Data Format
```javascript
{
    stats: {
        totalRevenue: 125000,
        totalBookings: 450,
        avgOccupancy: 75.5
    },
    charts: {
        revenueChart: { labels: [...], datasets: [...] }
    },
    tables: {
        recentBookings: [ { id: 1, guest: 'John Doe', ... } ]
    },
    notifications: [
        { type: 'info', message: 'New booking received' }
    ]
}
```

---

## 4️⃣ booking.js - Booking Module

### Purpose
Complete booking system with date selection, pricing calculation, and reservation.

### Key Features
- ✅ Date picker setup
- ✅ Room availability checking
- ✅ Dynamic pricing calculation
- ✅ Seasonal pricing
- ✅ Promo code application
- ✅ Discount calculation
- ✅ Tax calculation
- ✅ Guest capacity filtering
- ✅ Booking confirmation

### Usage Example
```javascript
// Initialize booking
Booking.init({
    minNights: 1,
    maxNights: 30,
    taxRate: 0.10,
    serviceFee: 25
});

// Select room
Booking.selectRoom(roomId);

// Apply promo code
await Booking.applyPromoCode('SUMMER2024');

// Confirm booking
await Booking.confirmBooking();

// Reset booking
Booking.reset();
```

### Pricing Logic
```javascript
// Base calculation
basePrice = roomPrice * numberOfNights * seasonalMultiplier

// Add taxes and fees
taxes = basePrice * taxRate
serviceFee = fixed amount

// Apply discounts
- Early bird (30+ days advance): 10% off
- Extended stay (7+ nights): 5% off
- Promo code discount

totalPrice = basePrice + taxes + serviceFee - discounts
```

### API Endpoints Expected
- `GET /api/rooms/available` - Get available rooms
- `POST /api/promo/validate` - Validate promo code
- `POST /api/bookings` - Create booking

---

## 5️⃣ charts.js - Charts Module

### Purpose
Wrapper for Chart.js with pre-configured chart types and utilities.

### Key Features
- ✅ Line charts (Revenue)
- ✅ Bar charts (Occupancy)
- ✅ Doughnut charts (Bookings status)
- ✅ Pie charts (Room types)
- ✅ Polar area charts (Demographics)
- ✅ Dynamic data updates
- ✅ Chart export
- ✅ Consistent theming

### Usage Example
```javascript
// Auto-initializes on page load
// Looks for canvas elements with specific IDs

// Update chart data
Charts.updateChart('revenueChart', {
    labels: ['Mon', 'Tue', 'Wed'],
    datasets: [{
        data: [100, 200, 150]
    }]
});

// Export chart
Charts.exportChart('revenueChart');

// Destroy chart
Charts.destroyChart('revenueChart');

// Destroy all
Charts.destroyAll();
```

### Required Canvas IDs
```html
<canvas id="revenueChart"></canvas>
<canvas id="occupancyChart"></canvas>
<canvas id="bookingsChart"></canvas>
<canvas id="roomTypeChart"></canvas>
<canvas id="demographicsChart"></canvas>
```

### Color Scheme
```javascript
colors: {
    primary: '#006994',   // Ocean Blue
    success: '#28A745',   // Green
    warning: '#FFC107',   // Yellow
    danger: '#DC3545',    // Red
    info: '#17A2B8',      // Cyan
    secondary: '#6C757D', // Gray
    gold: '#D4AF37'       // Gold
}
```

---

## 🔧 Integration Guide

### 1. Include in JSP Pages

```jsp
<!-- Base scripts -->
<script src="<%= contextPath %>/assets/js/main.js"></script>

<!-- Validation (optional, for forms) -->
<script src="<%= contextPath %>/assets/js/validation.js"></script>

<!-- Dashboard (for dashboard pages) -->
<script src="<%= contextPath %>/assets/js/dashboard.js"></script>

<!-- Booking (for booking pages) -->
<script src="<%= contextPath %>/assets/js/booking.js"></script>

<!-- Charts (for pages with charts) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script src="<%= contextPath %>/assets/js/charts.js"></script>
```

### 2. Initialize Modules

```javascript
// Auto-initialization
// All modules auto-initialize on DOMContentLoaded

// Manual initialization
document.addEventListener('DOMContentLoaded', function() {
    // Main is auto-initialized
    
    // Initialize specific modules if needed
    if (document.getElementById('dashboardContainer')) {
        Dashboard.init();
    }
    
    if (document.getElementById('bookingForm')) {
        Booking.init();
    }
});
```

### 3. Form Validation Setup

```html
<form data-validate="true" id="myForm">
    <div class="form-group">
        <label for="email">Email *</label>
        <input type="email" id="email" name="email" 
               class="form-control" required>
        <!-- Error will be inserted here automatically -->
    </div>
    
    <div class="form-group">
        <label for="password">Password *</label>
        <input type="password" id="password" name="password" 
               class="form-control" 
               data-validate-password="true"
               data-show-strength="true"
               required>
    </div>
    
    <button type="submit" class="btn btn-primary">Submit</button>
</form>
```

---

## 🎨 Styling Requirements

### Error States
```css
.form-control.error {
    border-color: var(--danger);
}

.error-message {
    color: var(--danger);
    font-size: 0.875rem;
    margin-top: 0.25rem;
}
```

### Password Strength
```css
.password-strength {
    height: 4px;
    background: #eee;
    margin-top: 0.5rem;
}

.password-strength-bar {
    height: 100%;
    transition: width 0.3s;
}

.password-strength-bar.weak { 
    width: 33%; 
    background: var(--danger); 
}

.password-strength-bar.medium { 
    width: 66%; 
    background: var(--warning); 
}

.password-strength-bar.strong { 
    width: 100%; 
    background: var(--success); 
}
```

---

## 🔐 Security Considerations

1. **XSS Prevention**: All user inputs are sanitized
2. **CSRF**: Include CSRF tokens in AJAX requests
3. **Validation**: Always validate server-side too
4. **Sensitive Data**: Never store sensitive info in JavaScript

### CSRF Token Example
```javascript
// Add to AJAX requests
headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': document.querySelector('[name=csrf-token]').content
}
```

---

## 📱 Browser Support

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

---

## 🐛 Debugging

### Enable Console Logging
```javascript
// Add to main.js
window.DEBUG = true;

// Use in code
if (window.DEBUG) {
    console.log('Debug info:', data);
}
```

### Common Issues

**Charts not showing:**
- Ensure Chart.js is loaded before charts.js
- Check canvas elements exist
- Verify data format

**Validation not working:**
- Check `data-validate="true"` attribute
- Ensure validation.js is loaded
- Check console for errors

**Booking not calculating:**
- Verify dates are selected
- Check room is selected
- Ensure price data is available

---

## 🚀 Performance Tips

1. **Lazy Load Charts**: Only load Chart.js on pages that need it
2. **Debounce Events**: Use debouncing for real-time validation
3. **Cache Data**: Store frequently accessed data
4. **Minimize Reflows**: Batch DOM updates

---

## 📝 Future Enhancements

- [ ] WebSocket support for real-time updates
- [ ] Offline mode with Service Workers
- [ ] Advanced analytics tracking
- [ ] Multi-language support
- [ ] Accessibility improvements (ARIA labels)
- [ ] Unit tests with Jest
- [ ] TypeScript conversion

---

## 📞 Support

For issues or questions:
- Check browser console for errors
- Review this documentation
- Contact development team

---

**Last Updated:** 2024
**Version:** 1.0.0
