# Ocean View Resort - Library Files Documentation

## 📚 Library Overview

This folder contains custom JavaScript libraries and utilities that extend the functionality of the application.

| File | Size | Purpose |
|------|------|---------|
| `datepicker.js` | ~8 KB | Custom date picker component |
| `datepicker.css` | ~2 KB | Date picker styles |
| `notifications.js` | ~7 KB | Toast/notification system |
| `notifications.css` | ~4 KB | Notification styles |
| `modal.js` | ~10 KB | Advanced modal/dialog system |
| `utils.js` | ~12 KB | Common utility functions |
| `api.js` | ~6 KB | API request helper |

**Total:** ~49 KB

---

## 1️⃣ DatePicker.js

### Purpose
Lightweight, dependency-free date picker for form inputs.

### Features
- ✅ No external dependencies
- ✅ Keyboard navigation
- ✅ Min/max date restrictions
- ✅ Disabled dates
- ✅ Custom formatting
- ✅ Inline or popup mode
- ✅ Responsive design

### Usage

```html
<!-- HTML -->
<input type="text" id="checkIn" data-datepicker>
```

```javascript
// JavaScript - Auto-initialization
// Elements with [data-datepicker] are automatically initialized

// Manual initialization
const picker = new DatePicker(document.getElementById('checkIn'), {
    format: 'YYYY-MM-DD',
    minDate: '2024-01-01',
    maxDate: '2024-12-31',
    disabledDates: ['2024-07-04', '2024-12-25'],
    onChange: function(date) {
        console.log('Selected:', date);
    }
});

// Methods
picker.setDate('2024-06-15');
const date = picker.getDate();
picker.destroy();
```

### Options
```javascript
{
    format: 'YYYY-MM-DD',      // Date format
    minDate: null,              // Minimum selectable date
    maxDate: null,              // Maximum selectable date
    disabledDates: [],          // Array of disabled dates
    inline: false,              // Show inline instead of popup
    startDay: 0,                // Week start (0=Sunday, 1=Monday)
    onChange: null,             // Callback on date change
    onOpen: null,               // Callback on picker open
    onClose: null               // Callback on picker close
}
```

---

## 2️⃣ Notifications.js

### Purpose
Beautiful toast notifications with multiple types and animations.

### Features
- ✅ Multiple notification types (success, error, warning, info)
- ✅ Auto-dismiss with timer
- ✅ Stacking notifications
- ✅ Confirm dialogs
- ✅ Custom positioning
- ✅ Smooth animations
- ✅ Click handlers

### Usage

```javascript
// Initialize (auto-runs)
Notifications.init({
    position: 'top-right',  // top-right, top-left, bottom-right, etc.
    duration: 5000,         // Auto-dismiss time (ms)
    maxNotifications: 5     // Max simultaneous notifications
});

// Show notifications
Notifications.success('Booking confirmed!');
Notifications.error('Failed to save');
Notifications.warning('Please review your details');
Notifications.info('New message received');

// With options
Notifications.show('Custom message', 'info', {
    title: 'Important',
    duration: 0,  // No auto-dismiss
    onClick: function() {
        console.log('Notification clicked');
    }
});

// Confirmation dialog
Notifications.confirm(
    'Are you sure you want to delete?',
    function() { console.log('Confirmed'); },
    function() { console.log('Cancelled'); }
);

// Close specific notification
const id = Notifications.success('Message');
Notifications.close(id);

// Close all
Notifications.closeAll();
```

### Positions
- `top-right` (default)
- `top-left`
- `bottom-right`
- `bottom-left`
- `top-center`
- `bottom-center`

---

## 3️⃣ Modal.js

### Purpose
Flexible modal/dialog system with programmatic control.

### Features
- ✅ Create modals programmatically or from HTML
- ✅ Multiple sizes (small, medium, large)
- ✅ Confirm/Alert/Prompt dialogs
- ✅ Focus trap
- ✅ Keyboard support (ESC to close)
- ✅ Custom animations
- ✅ Event callbacks

### Usage

```javascript
// Create modal programmatically
const id = Modal.create({
    title: 'Booking Details',
    content: '<p>Reservation confirmed!</p>',
    footer: '<button class="btn btn-primary" data-modal-action="close">OK</button>',
    size: 'medium',  // small, medium, large
    onOpen: function() { console.log('Opened'); },
    onClose: function() { console.log('Closed'); }
});

Modal.open(id);

// Confirm dialog
Modal.confirm({
    title: 'Delete Reservation',
    message: 'Are you sure you want to delete this reservation?',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    onConfirm: function() {
        console.log('Deleted');
    }
});

// Alert dialog
Modal.alert({
    title: 'Success',
    message: 'Your booking has been confirmed!',
    onOk: function() { console.log('OK clicked'); }
});

// Prompt dialog
Modal.prompt({
    title: 'Enter Promo Code',
    message: 'Please enter your promo code:',
    placeholder: 'PROMO2024',
    onSubmit: function(value) {
        console.log('Entered:', value);
    }
});

// Methods
Modal.close(id);
Modal.updateContent(id, '<p>New content</p>');
Modal.updateTitle(id, 'New Title');
Modal.destroy(id);
```

### HTML-based Modals

```html
<div class="modal-overlay" id="myModal">
    <div class="modal">
        <div class="modal-header">
            <h2 class="modal-title">Title</h2>
            <button class="modal-close">&times;</button>
        </div>
        <div class="modal-body">
            Content here
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary">OK</button>
        </div>
    </div>
</div>

<!-- Trigger -->
<button data-modal="myModal">Open Modal</button>
```

---

## 4️⃣ Utils.js

### Purpose
Collection of common utility functions for string, array, date, and number manipulation.

### Categories

#### String Utilities
```javascript
Utils.capitalize('hello world');  // "Hello world"
Utils.slugify('Hello World!');     // "hello-world"
Utils.truncate('Long text...', 10); // "Long te..."
Utils.string.escapeHtml('<script>'); // Escape HTML
Utils.string.camelCase('hello-world'); // "helloWorld"
Utils.string.snakeCase('helloWorld'); // "hello_world"
```

#### Array Utilities
```javascript
Utils.array.unique([1, 2, 2, 3]); // [1, 2, 3]
Utils.array.shuffle([1, 2, 3, 4]); // Randomized array
Utils.array.chunk([1, 2, 3, 4], 2); // [[1,2], [3,4]]
Utils.array.groupBy(items, 'category'); // Group by key
```

#### Date Utilities
```javascript
Utils.formatDate(new Date(), 'long'); // "January 15, 2024"
Utils.formatRelativeTime(date); // "2 hours ago"
```

#### Number Utilities
```javascript
Utils.number.random(1, 100); // Random number
Utils.number.clamp(150, 0, 100); // 100 (clamped)
Utils.number.round(3.14159, 2); // 3.14
```

#### Storage Utilities
```javascript
Utils.storage.set('key', { data: 'value' });
const data = Utils.storage.get('key');
Utils.storage.remove('key');
Utils.storage.clear();
```

#### Cookie Utilities
```javascript
Utils.setCookie('name', 'value', 7); // 7 days
const value = Utils.getCookie('name');
Utils.deleteCookie('name');
```

#### Validation
```javascript
Utils.validate.email('test@example.com'); // true
Utils.validate.phone('+1234567890'); // true
Utils.validate.url('https://example.com'); // true
```

#### Performance
```javascript
// Debounce (delay execution)
const debouncedFn = Utils.debounce(function() {
    console.log('Executed after delay');
}, 300);

// Throttle (limit execution rate)
const throttledFn = Utils.throttle(function() {
    console.log('Executed at most once per interval');
}, 1000);
```

#### DOM Utilities
```javascript
Utils.isInViewport(element); // Check if element visible
Utils.scrollTo('#section', 100); // Smooth scroll with offset
Utils.copyToClipboard('Text to copy');
```

#### Device Detection
```javascript
Utils.device.isMobile(); // true/false
Utils.device.isTablet(); // true/false
Utils.device.isDesktop(); // true/false
```

---

## 5️⃣ API.js

### Purpose
Simplified fetch wrapper with interceptors and error handling.

### Features
- ✅ Request/response interceptors
- ✅ Automatic error handling
- ✅ CSRF token support
- ✅ Timeout handling
- ✅ File upload/download
- ✅ Batch requests

### Usage

```javascript
// Initialize
API.init({
    baseURL: '/api',
    timeout: 30000,
    headers: {
        'Content-Type': 'application/json'
    }
});

// GET request
const { data } = await API.get('/rooms', { type: 'DELUXE' });

// POST request
const { data } = await API.post('/bookings', {
    roomId: 123,
    checkIn: '2024-06-15',
    checkOut: '2024-06-20'
});

// PUT request
await API.put('/bookings/123', { status: 'CONFIRMED' });

// DELETE request
await API.delete('/bookings/123');

// Upload file
const file = document.getElementById('file').files[0];
await API.upload('/upload', file, { category: 'profile' });

// Download file
await API.download('/reports/monthly.pdf', 'report.pdf');

// Batch requests
const results = await API.batch([
    { endpoint: '/rooms' },
    { endpoint: '/offers' },
    { endpoint: '/reviews' }
]);

// Add custom interceptor
API.addRequestInterceptor((config) => {
    config.headers['Authorization'] = 'Bearer ' + token;
    return config;
});

API.addResponseInterceptor((response) => {
    // Log all responses
    console.log('Response:', response);
    return response;
});
```

### Error Handling

```javascript
try {
    const { data } = await API.get('/bookings');
} catch (error) {
    if (error.response) {
        // HTTP error
        console.error('Status:', error.response.status);
    } else {
        // Network error or timeout
        console.error('Error:', error.message);
    }
}
```

---

## 🔧 Integration Guide

### 1. Include Libraries in HTML

```html
<!-- Date Picker -->
<link rel="stylesheet" href="/assets/lib/datepicker.css">
<script src="/assets/lib/datepicker.js"></script>

<!-- Notifications -->
<link rel="stylesheet" href="/assets/lib/notifications.css">
<script src="/assets/lib/notifications.js"></script>

<!-- Modal -->
<script src="/assets/lib/modal.js"></script>

<!-- Utils -->
<script src="/assets/lib/utils.js"></script>

<!-- API -->
<script src="/assets/lib/api.js"></script>
```

### 2. Include in JSP

```jsp
<!-- In header.jsp -->
<link rel="stylesheet" href="<%= contextPath %>/assets/lib/datepicker.css">
<link rel="stylesheet" href="<%= contextPath %>/assets/lib/notifications.css">

<!-- In footer.jsp -->
<script src="<%= contextPath %>/assets/lib/utils.js"></script>
<script src="<%= contextPath %>/assets/lib/datepicker.js"></script>
<script src="<%= contextPath %>/assets/lib/notifications.js"></script>
<script src="<%= contextPath %>/assets/lib/modal.js"></script>
<script src="<%= contextPath %>/assets/lib/api.js"></script>
```

---

## 🎯 Best Practices

1. **Load Order**: Load utils.js first as other libraries may depend on it
2. **Auto-initialization**: Most libraries auto-initialize, no manual setup needed
3. **Error Handling**: Always wrap API calls in try-catch blocks
4. **Memory Cleanup**: Call destroy() methods when removing components
5. **CSRF Tokens**: Include CSRF meta tag in HTML head

```html
<meta name="csrf-token" content="<%= csrfToken %>">
```

---

## 📱 Browser Support

All libraries support:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile browsers

---

## 🚀 Performance

- Total library size: ~49 KB (unminified)
- Zero external dependencies
- Efficient event handling
- Memory leak prevention
- Optimized DOM operations

---

## 📝 Examples

### Complete Booking Flow

```javascript
// Initialize
Notifications.init();
API.init({ baseURL: '/api' });

// Date selection
const checkIn = new DatePicker(document.getElementById('checkIn'), {
    minDate: new Date(),
    onChange: function(date) {
        checkOut.options.minDate = date;
    }
});

// Get available rooms
const { data: rooms } = await API.get('/rooms/available', {
    checkIn: '2024-06-15',
    checkOut: '2024-06-20'
});

// Confirm booking
Modal.confirm({
    title: 'Confirm Booking',
    message: 'Proceed with this reservation?',
    onConfirm: async function() {
        try {
            const { data } = await API.post('/bookings', bookingData);
            Notifications.success('Booking confirmed!');
            window.location.href = '/bookings/' + data.id;
        } catch (error) {
            Notifications.error('Booking failed');
        }
    }
});
```

---

**Last Updated:** 2024
**Version:** 1.0.0
