# Common Components Documentation

This directory contains reusable JSP components for the Ocean View Resort Hotel Booking System. All components are built with pure JSP (no JSTL dependencies) and feature responsive, accessible designs.

## Table of Contents

1. [Available Components](#available-components)
2. [Component Details](#component-details)
3. [Usage Examples](#usage-examples)
4. [Styling](#styling)
5. [Best Practices](#best-practices)

---

## Available Components

| Component | File | Description | CSS File |
|-----------|------|-------------|----------|
| **Header** | `header.jsp` | Full page header with top bar, navigation, and alerts | `header.css` |
| **Footer** | `footer.jsp` | Multi-section footer with links and newsletter | `footer.css` |
| **Navbar** | `navbar.jsp` | Standalone navigation bar component | `navbar.css` |
| **Sidebar** | `sidebar.jsp` | Fixed sidebar navigation for dashboards | `sidebar.css` |

---

## Component Details

### 1. Header Component (`header.jsp`)

**Purpose:** Primary page header with complete navigation and messaging system.

**Features:**
- Top bar with contact information and login/register links
- Logo and brand section
- Dynamic navigation menu
- Role-based menu items (Admin, Staff, Guest)
- User dropdown menu with profile actions
- Alert message display (success, error, info)
- Mobile hamburger menu
- Responsive design

**Parameters:**
- `title` - Page title (default: "Ocean View Resort")
- `css` - Additional CSS file to load
- `active` - Active menu item identifier

**Session Attributes:**
- `user` - Current logged-in user object
- `successMessage` - Success alert message
- `errorMessage` - Error alert message
- `infoMessage` - Info alert message

**Example:**
```jsp
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="title" value="Dashboard" />
    <jsp:param name="css" value="dashboard" />
    <jsp:param name="active" value="dashboard" />
</jsp:include>
```

**Related Files:**
- CSS: `/assets/css/header.css`
- CSS: `/assets/css/main.css`

---

### 2. Footer Component (`footer.jsp`)

**Purpose:** Standard page footer with site information and links.

**Features:**
- About section with social media links
- Quick links navigation
- Services list
- Contact information
- Newsletter subscription form
- Copyright and legal links
- Auto-hide JavaScript for alerts
- Mobile menu toggle script

**Parameters:**
- `js` - Additional JavaScript file to load

**Example:**
```jsp
<jsp:include page="/views/common/footer.jsp">
    <jsp:param name="js" value="dashboard" />
</jsp:include>
```

**Related Files:**
- CSS: `/assets/css/footer.css`
- JS: `/assets/js/main.js`

---

### 3. Navbar Component (`navbar.jsp`)

**Purpose:** Standalone navigation bar for pages that need independent navigation.

**Features:**
- Sticky top navigation
- Role-based menu items
- User profile dropdown
- Authentication buttons (Login/Register)
- Mobile-responsive toggle menu
- Active menu highlighting
- Smooth animations
- Accessible ARIA attributes

**Parameters:**
- `active` - Active menu item identifier

**Navigation by Role:**

**Admin:**
- Home, Rooms, Offers, About, Contact
- Admin Panel (special styling)

**Staff:**
- Home, Rooms, Offers, About, Contact
- Staff Panel (special styling)

**Guest:**
- Home, Rooms, Offers, About, Contact
- My Dashboard (special styling)

**Public (Not logged in):**
- Home, Rooms, Offers, About, Contact
- Login & Register buttons

**Example:**
```jsp
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/navbar.css">
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp">
        <jsp:param name="active" value="home" />
    </jsp:include>
    
    <main>
        <!-- Your content -->
    </main>
</body>
</html>
```

**Related Files:**
- CSS: `/assets/css/navbar.css`
- Icons: Font Awesome 6

---

### 4. Sidebar Component (`sidebar.jsp`)

**Purpose:** Fixed sidebar navigation for dashboard and admin pages.

**Features:**
- Fixed left sidebar
- User profile section
- Organized menu sections
- Role-based navigation
- Collapsible sidebar
- Mobile overlay
- Settings and logout footer
- Smooth animations
- Custom scrollbar

**Parameters:**
- `active` - Active page identifier

**Navigation by Role:**

**Admin Sections:**
1. **Dashboard** - Overview
2. **Management** - Rooms, Users, Reservations, Reviews, Offers
3. **Reports & Analytics** - Reports, Analytics, Billing
4. **System** - Settings, Audit Logs

**Staff Sections:**
1. **Dashboard** - Overview
2. **Operations** - Reservations, Check-In, Check-Out, Room Status
3. **Guest Services** - Guest Directory, Guest Requests

**Guest Sections:**
1. **My Account** - Dashboard, My Profile
2. **Bookings** - Browse Rooms, My Reservations, New Booking
3. **Activity** - My Reviews, Payment History

**Public:**
1. **Explore** - Home, Rooms & Suites, Special Offers, About Us, Contact

**Example:**
```jsp
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="title" value="Admin Dashboard" />
    <jsp:param name="css" value="admin,dashboard" />
</jsp:include>

<jsp:include page="/views/common/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="container py-4">
        <h1>Dashboard Content</h1>
        <!-- Your content here -->
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
```

**CSS Classes:**
- `.content-with-sidebar` - Apply to main content wrapper
- `.sidebar` - The sidebar element
- `.sidebar.collapsed` - Collapsed state
- `.sidebar.open` - Open state (mobile)
- `.sidebar-overlay` - Mobile backdrop

**Related Files:**
- CSS: `/assets/css/sidebar.css`
- Icons: Font Awesome 6

---

## Usage Examples

### Example 1: Simple Public Page

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="title" value="Rooms & Suites" />
    <jsp:param name="css" value="rooms" />
    <jsp:param name="active" value="rooms" />
</jsp:include>

<div class="container py-4">
    <h1>Available Rooms</h1>
    <!-- Room listing content -->
</div>

<jsp:include page="/views/common/footer.jsp" />
```

### Example 2: Admin Dashboard with Sidebar

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.User" %>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="title" value="Admin Dashboard" />
    <jsp:param name="css" value="admin" />
</jsp:include>

<jsp:include page="/views/common/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="container-fluid py-4">
        <div class="page-header mb-4">
            <h1>Admin Dashboard</h1>
        </div>
        
        <div class="row">
            <!-- Dashboard cards -->
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp">
    <jsp:param name="js" value="dashboard,charts" />
</jsp:include>
```

### Example 3: Guest Profile Page

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/views/common/header.jsp">
    <jsp:param name="title" value="My Profile" />
    <jsp:param name="active" value="guest-dashboard" />
</jsp:include>

<jsp:include page="/views/common/sidebar.jsp">
    <jsp:param name="active" value="profile" />
</jsp:include>

<div class="content-with-sidebar">
    <div class="container py-4">
        <h1>My Profile</h1>
        <form action="<%= request.getContextPath() %>/profile/update" method="post">
            <!-- Profile form fields -->
        </form>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
```

### Example 4: Using Navbar Instead of Header

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landing Page</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/navbar.css">
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp">
        <jsp:param name="active" value="home" />
    </jsp:include>
    
    <main>
        <section class="hero">
            <!-- Hero content -->
        </section>
    </main>
    
    <jsp:include page="/views/common/footer.jsp" />
</body>
</html>
```

---

## Styling

### CSS Files

All components have dedicated CSS files in `/assets/css/`:

- `main.css` - Global styles, variables, utilities
- `header.css` - Header component styles
- `footer.css` - Footer component styles
- `navbar.css` - Navbar component styles
- `sidebar.css` - Sidebar component styles

### CSS Variables

Components use CSS custom properties for consistent theming:

```css
:root {
    /* Colors */
    --ocean-blue: #2196F3;
    --ocean-dark: #1565C0;
    --ocean-light: #E3F2FD;
    --gold-accent: #DAA520;
    --sand-beige: #F5DEB3;
    
    /* Spacing */
    --spacing-xs: 0.25rem;
    --spacing-sm: 0.5rem;
    --spacing-md: 1rem;
    --spacing-lg: 1.5rem;
    --spacing-xl: 2rem;
    --spacing-xxl: 3rem;
    
    /* Border Radius */
    --radius-sm: 4px;
    --radius-md: 8px;
    --radius-lg: 12px;
    
    /* Transitions */
    --transition-fast: 0.2s ease;
}
```

### Responsive Breakpoints

- Mobile: `max-width: 576px`
- Tablet: `max-width: 768px`
- Desktop: `max-width: 992px`
- Large Desktop: `max-width: 1200px`

---

## Best Practices

### 1. Always Include Context Path

```jsp
<a href="<%= request.getContextPath() %>/rooms">Rooms</a>
```

### 2. Set Appropriate Active Menu Item

```jsp
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="active" value="rooms" />
</jsp:include>
```

### 3. Load Page-Specific CSS

```jsp
<jsp:include page="/views/common/header.jsp">
    <jsp:param name="css" value="dashboard" />
</jsp:include>
```

### 4. Use Sidebar with Content Wrapper

```jsp
<jsp:include page="/views/common/sidebar.jsp" />
<div class="content-with-sidebar">
    <!-- Content -->
</div>
```

### 5. Set Session Messages for Alerts

```java
// In your servlet
session.setAttribute("successMessage", "Reservation created successfully!");
response.sendRedirect(request.getContextPath() + "/guest/reservations");
```

### 6. Check User Authentication

```jsp
<%
User currentUser = (User) session.getAttribute("user");
if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
%>
```

### 7. Role-Based Access Control

```jsp
<%
String role = currentUser.getRole().toString();
if (!"ADMIN".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/access-denied");
    return;
}
%>
```

---

## Technical Notes

### No JSTL Dependencies

All components use pure JSP scriptlets instead of JSTL tags:

**❌ Don't use:**
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${user != null}">
```

**✅ Do use:**
```jsp
<% if (currentUser != null) { %>
    <!-- Content -->
<% } %>
```

### Session Attributes

Components expect these session attributes:

- `user` (User object) - Currently logged-in user
- `successMessage` (String) - Success alert
- `errorMessage` (String) - Error alert
- `infoMessage` (String) - Info alert

### JavaScript Dependencies

- Font Awesome 6.4.0 (CDN)
- No jQuery or other libraries required
- Vanilla JavaScript for all interactions

### Accessibility

All components include:
- ARIA labels and roles
- Semantic HTML5 elements
- Keyboard navigation support
- Screen reader friendly

---

## Troubleshooting

### Issue: Sidebar not showing
**Solution:** Ensure you've included `sidebar.css` in the header:
```jsp
<jsp:param name="css" value="sidebar" />
```

### Issue: Mobile menu not working
**Solution:** Check that Font Awesome is loaded and JavaScript is not blocked.

### Issue: User dropdown not appearing
**Solution:** Verify that user is in session:
```jsp
<% User currentUser = (User) session.getAttribute("user"); %>
```

### Issue: Alert messages not showing
**Solution:** Set messages in session before redirect:
```java
session.setAttribute("successMessage", "Your message");
```

---

## Demo Page

Visit `/views/common/component-demo.jsp` for a live demonstration of all components with usage examples.

---

## Support

For questions or issues with common components:
1. Check this documentation
2. Review the demo page
3. Inspect browser console for JavaScript errors
4. Verify CSS files are loading correctly

---

**Last Updated:** January 2026  
**Version:** 1.0.0  
**Author:** Ocean View Resort Development Team
