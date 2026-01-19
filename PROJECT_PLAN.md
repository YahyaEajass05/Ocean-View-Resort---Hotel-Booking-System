


# 🏨 OCEAN VIEW RESORT - DISTINCTION LEVEL PROJECT PLAN

## 📋 PROJECT OVERVIEW

**Project Name:** Ocean View Resort - Advanced Hotel Booking System  
**Technology Stack:** Java, JSP, Servlets, JDBC, MySQL, HTML5, CSS3, JavaScript, Bootstrap, Chart.js, JSTL  
**Architecture:** 3-Tier Architecture with Design Patterns  
**Assessment:** CIS6003 Advanced Programming (100% Weightage)

---

## 🎯 PROJECT OBJECTIVES (Distinction Features)

### Core Requirements (Base)
1. ✅ User Authentication System (3 Roles)
2. ✅ Reservation Management (CRUD Operations)
3. ✅ Bill Calculation & Invoicing
4. ✅ Reports & Analytics
5. ✅ Help Documentation System

### Advanced Features (Distinction Level)
1. 🌟 **Real-time Room Availability Dashboard** with Chart.js
2. 🌟 **Email & SMS Notifications** (Booking confirmations)
3. 🌟 **Payment Gateway Integration** (Simulated)
4. 🌟 **Advanced Search & Filtering**
5. 🌟 **Revenue Analytics Dashboard** with visual charts
6. 🌟 **Review & Rating System**
7. 🌟 **Promotional Offers Management**
8. 🌟 **Audit Trail & Activity Logs**
9. 🌟 **PDF Invoice Generation**
10. 🌟 **Responsive Design** with animations

---

## 👥 USER ROLES & PERMISSIONS

### 1. **Admin** (Super User)
- ✅ Full system access
- ✅ User management (Add/Edit/Delete Staff)
- ✅ Room management (Add/Edit/Delete rooms)
- ✅ View all reservations
- ✅ Generate reports & analytics
- ✅ Manage promotional offers
- ✅ System configuration
- ✅ View audit logs
- ✅ Dashboard with statistics

### 2. **Staff** (Receptionist)
- ✅ Manage reservations (Create/Update/Cancel)
- ✅ Guest check-in/check-out
- ✅ View room availability
- ✅ Generate bills & invoices
- ✅ Search reservations
- ✅ Update guest information
- ✅ View reports (limited)

### 3. **Guest (User)**
- ✅ Register account
- ✅ Login & profile management
- ✅ Search available rooms
- ✅ Make reservations
- ✅ View booking history
- ✅ Cancel reservations
- ✅ Download invoices
- ✅ Rate & review stays
- ✅ Contact support

---

## 🏗️ PROJECT STRUCTURE

```
OceanViewResort/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── oceanview/
│       │           ├── config/
│       │           │   ├── DatabaseConfig.java
│       │           │   └── AppConfig.java
│       │           │
│       │           ├── model/
│       │           │   ├── User.java
│       │           │   ├── Guest.java
│       │           │   ├── Room.java
│       │           │   ├── Reservation.java
│       │           │   ├── Payment.java
│       │           │   ├── Review.java
│       │           │   ├── Offer.java
│       │           │   └── AuditLog.java
│       │           │
│       │           ├── dao/
│       │           │   ├── BaseDAO.java
│       │           │   ├── UserDAO.java
│       │           │   ├── GuestDAO.java
│       │           │   ├── RoomDAO.java
│       │           │   ├── ReservationDAO.java
│       │           │   ├── PaymentDAO.java
│       │           │   ├── ReviewDAO.java
│       │           │   └── OfferDAO.java
│       │           │
│       │           ├── service/
│       │           │   ├── AuthenticationService.java
│       │           │   ├── ReservationService.java
│       │           │   ├── RoomService.java
│       │           │   ├── BillingService.java
│       │           │   ├── EmailService.java
│       │           │   ├── PDFService.java
│       │           │   └── AnalyticsService.java
│       │           │
│       │           ├── controller/
│       │           │   ├── LoginServlet.java
│       │           │   ├── LogoutServlet.java
│       │           │   ├── RegisterServlet.java
│       │           │   ├── ReservationServlet.java
│       │           │   ├── RoomServlet.java
│       │           │   ├── UserServlet.java
│       │           │   ├── BillingServlet.java
│       │           │   ├── DashboardServlet.java
│       │           │   ├── ReportServlet.java
│       │           │   └── ReviewServlet.java
│       │           │
│       │           ├── filter/
│       │           │   ├── AuthenticationFilter.java
│       │           │   ├── AuthorizationFilter.java
│       │           │   └── LoggingFilter.java
│       │           │
│       │           ├── util/
│       │           │   ├── ValidationUtil.java
│       │           │   ├── DateUtil.java
│       │           │   ├── PasswordUtil.java
│       │           │   ├── FileUploadUtil.java
│       │           │   └── Constants.java
│       │           │
│       │           └── factory/
│       │               ├── DAOFactory.java
│       │               └── ServiceFactory.java
│       │
│       ├── webapp/
│       │   ├── WEB-INF/
│       │   │   ├── web.xml
│       │   │   └── lib/
│       │   │
│       │   ├── assets/
│       │   │   ├── css/
│       │   │   │   ├── main.css
│       │   │   │   ├── admin.css
│       │   │   │   ├── staff.css
│       │   │   │   ├── guest.css
│       │   │   │   └── animations.css
│       │   │   │
│       │   │   ├── js/
│       │   │   │   ├── main.js
│       │   │   │   ├── validation.js
│       │   │   │   ├── dashboard.js
│       │   │   │   ├── booking.js
│       │   │   │   └── charts.js
│       │   │   │
│       │   │   ├── images/
│       │   │   │   ├── backgrounds/
│       │   │   │   ├── rooms/
│       │   │   │   ├── icons/
│       │   │   │   └── logo/
│       │   │   │
│       │   │   └── lib/
│       │   │       ├── bootstrap/
│       │   │       ├── jquery/
│       │   │       ├── chart.js/
│       │   │       └── fontawesome/
│       │   │
│       │   ├── views/
│       │   │   ├── common/
│       │   │   │   ├── header.jsp
│       │   │   │   ├── footer.jsp
│       │   │   │   ├── navbar.jsp
│       │   │   │   └── sidebar.jsp
│       │   │   │
│       │   │   ├── auth/
│       │   │   │   ├── login.jsp
│       │   │   │   ├── register.jsp
│       │   │   │   └── forgot-password.jsp
│       │   │   │
│       │   │   ├── admin/
│       │   │   │   ├── dashboard.jsp
│       │   │   │   ├── users.jsp
│       │   │   │   ├── rooms.jsp
│       │   │   │   ├── reservations.jsp
│       │   │   │   ├── reports.jsp
│       │   │   │   ├── offers.jsp
│       │   │   │   └── settings.jsp
│       │   │   │
│       │   │   ├── staff/
│       │   │   │   ├── dashboard.jsp
│       │   │   │   ├── bookings.jsp
│       │   │   │   ├── checkin.jsp
│       │   │   │   ├── checkout.jsp
│       │   │   │   └── search.jsp
│       │   │   │
│       │   │   └── guest/
│       │   │       ├── home.jsp
│       │   │       ├── search-rooms.jsp
│       │   │       ├── booking.jsp
│       │   │       ├── my-bookings.jsp
│       │   │       ├── profile.jsp
│       │   │       └── reviews.jsp
│       │   │
│       │   ├── index.jsp
│       │   └── error.jsp
│       │
│       └── resources/
│           ├── database/
│           │   ├── schema.sql
│           │   └── sample-data.sql
│           └── config/
│               └── application.properties
│
└── test/
    └── java/
        └── com/
            └── oceanview/
                ├── dao/
                ├── service/
                └── util/
```

---

## 🗄️ DATABASE DESIGN

### **Database Name:** `oceanview_resort`

### **Tables:**

#### 1. **users** (User Authentication)
```sql
- user_id (INT, PK, AUTO_INCREMENT)
- username (VARCHAR(50), UNIQUE, NOT NULL)
- password (VARCHAR(255), NOT NULL) -- Encrypted
- email (VARCHAR(100), UNIQUE, NOT NULL)
- full_name (VARCHAR(100), NOT NULL)
- phone (VARCHAR(20))
- role (ENUM: 'ADMIN', 'STAFF', 'GUEST')
- status (ENUM: 'ACTIVE', 'INACTIVE', 'SUSPENDED')
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
- last_login (TIMESTAMP)
```

#### 2. **guests** (Guest Details)
```sql
- guest_id (INT, PK, AUTO_INCREMENT)
- user_id (INT, FK -> users)
- address (TEXT)
- city (VARCHAR(50))
- country (VARCHAR(50))
- postal_code (VARCHAR(10))
- id_type (VARCHAR(20))
- id_number (VARCHAR(50))
- date_of_birth (DATE)
- gender (ENUM: 'MALE', 'FEMALE', 'OTHER')
- preferences (TEXT)
- created_at (TIMESTAMP)
```

#### 3. **rooms** (Room Inventory)
```sql
- room_id (INT, PK, AUTO_INCREMENT)
- room_number (VARCHAR(10), UNIQUE, NOT NULL)
- room_type (ENUM: 'SINGLE', 'DOUBLE', 'DELUXE', 'SUITE', 'FAMILY')
- floor (INT)
- capacity (INT)
- price_per_night (DECIMAL(10,2))
- description (TEXT)
- amenities (TEXT) -- JSON format
- image_url (VARCHAR(255))
- status (ENUM: 'AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED')
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### 4. **reservations** (Booking Records)
```sql
- reservation_id (INT, PK, AUTO_INCREMENT)
- reservation_number (VARCHAR(20), UNIQUE, NOT NULL)
- guest_id (INT, FK -> guests)
- room_id (INT, FK -> rooms)
- check_in_date (DATE, NOT NULL)
- check_out_date (DATE, NOT NULL)
- number_of_guests (INT)
- number_of_nights (INT)
- total_amount (DECIMAL(10,2))
- discount_amount (DECIMAL(10,2))
- tax_amount (DECIMAL(10,2))
- final_amount (DECIMAL(10,2))
- status (ENUM: 'PENDING', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED')
- special_requests (TEXT)
- created_by (INT, FK -> users)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### 5. **payments** (Payment Records)
```sql
- payment_id (INT, PK, AUTO_INCREMENT)
- reservation_id (INT, FK -> reservations)
- payment_number (VARCHAR(20), UNIQUE)
- amount (DECIMAL(10,2))
- payment_method (ENUM: 'CASH', 'CARD', 'BANK_TRANSFER', 'ONLINE')
- payment_status (ENUM: 'PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')
- transaction_id (VARCHAR(100))
- payment_date (TIMESTAMP)
- notes (TEXT)
```

#### 6. **reviews** (Guest Reviews)
```sql
- review_id (INT, PK, AUTO_INCREMENT)
- reservation_id (INT, FK -> reservations)
- guest_id (INT, FK -> guests)
- rating (INT) -- 1-5 stars
- cleanliness_rating (INT)
- service_rating (INT)
- value_rating (INT)
- comment (TEXT)
- response (TEXT) -- Admin response
- status (ENUM: 'PENDING', 'APPROVED', 'REJECTED')
- created_at (TIMESTAMP)
```

#### 7. **offers** (Promotional Offers)
```sql
- offer_id (INT, PK, AUTO_INCREMENT)
- title (VARCHAR(100))
- description (TEXT)
- discount_type (ENUM: 'PERCENTAGE', 'FIXED')
- discount_value (DECIMAL(10,2))
- start_date (DATE)
- end_date (DATE)
- applicable_rooms (TEXT) -- JSON array
- min_nights (INT)
- status (ENUM: 'ACTIVE', 'INACTIVE', 'EXPIRED')
- created_at (TIMESTAMP)
```

#### 8. **audit_logs** (Activity Tracking)
```sql
- log_id (INT, PK, AUTO_INCREMENT)
- user_id (INT, FK -> users)
- action (VARCHAR(50))
- entity_type (VARCHAR(50))
- entity_id (INT)
- details (TEXT) -- JSON format
- ip_address (VARCHAR(45))
- timestamp (TIMESTAMP)
```

---

## 🎨 FRONTEND DESIGN (Color Scheme)

### **Hotel Theme Colors:**
```css
:root {
    /* Primary Colors */
    --primary-blue: #1e3a8a;        /* Deep Ocean Blue */
    --secondary-blue: #3b82f6;      /* Sky Blue */
    --light-blue: #dbeafe;          /* Light Blue Background */
    
    /* Accent Colors */
    --gold: #f59e0b;                /* Luxury Gold */
    --dark-gold: #d97706;           /* Dark Gold */
    
    /* Neutrals */
    --white: #ffffff;
    --light-gray: #f3f4f6;
    --gray: #6b7280;
    --dark-gray: #374151;
    --charcoal: #1f2937;
    
    /* Status Colors */
    --success: #10b981;
    --warning: #f59e0b;
    --danger: #ef4444;
    --info: #3b82f6;
    
    /* Overlay */
    --overlay: rgba(30, 58, 138, 0.9);
}
```

### **Background Images:**
- **Homepage:** Beach/Ocean sunset view
- **Login Page:** Luxury hotel lobby
- **Dashboard:** Minimalist resort pool
- **Booking Pages:** Room interior shots

### **Animations:**
1. **Fade-in on page load**
2. **Slide-in cards**
3. **Hover effects on buttons**
4. **Smooth scroll transitions**
5. **Loading spinners**
6. **Success/Error toasts**
7. **Modal animations**
8. **Chart animations** (Chart.js)

---

## ⚙️ DESIGN PATTERNS (Distinction Requirement)

### 1. **Singleton Pattern**
- `DatabaseConfig.java` - Single DB connection pool
- `EmailService.java` - Single email service instance

### 2. **Factory Pattern**
- `DAOFactory.java` - Create DAO instances
- `ServiceFactory.java` - Create service instances

### 3. **DAO Pattern**
- Separate data access logic from business logic
- All DAO classes implementing base interface

### 4. **MVC Pattern**
- Model: POJOs in `model` package
- View: JSP files
- Controller: Servlets

### 5. **Front Controller Pattern**
- Single servlet handling authentication
- Filters for authorization

### 6. **Service Layer Pattern**
- Business logic separated in service classes

### 7. **Builder Pattern**
- Complex object creation (Reservation, Payment)

---

## ✅ VALIDATION MECHANISMS

### **Client-Side Validation (JavaScript):**
1. Email format validation
2. Phone number format
3. Password strength checker
4. Date range validation
5. Required field checks
6. Real-time feedback

### **Server-Side Validation (Java):**
1. Input sanitization
2. SQL injection prevention
3. XSS attack prevention
4. Business rule validation
5. Data type validation
6. Custom validation annotations

### **Database Constraints:**
1. Primary keys
2. Foreign keys
3. Unique constraints
4. NOT NULL constraints
5. Check constraints
6. Triggers for business rules

---

## 📊 REPORTS & ANALYTICS (Distinction Features)

### **Admin Reports:**
1. **Revenue Dashboard** (Chart.js)
   - Daily/Monthly/Yearly revenue charts
   - Room-wise revenue breakdown
   - Occupancy rate trends

2. **Booking Analytics**
   - Total bookings by status
   - Peak season analysis
   - Average stay duration

3. **Guest Analytics**
   - New vs returning guests
   - Guest demographics
   - Review ratings overview

4. **Room Performance**
   - Most booked rooms
   - Maintenance schedule
   - Revenue per room

### **Staff Reports:**
1. Daily check-in/check-out list
2. Room availability status
3. Pending reservations
4. Guest search results

### **Guest Features:**
1. Booking history
2. Expense summary
3. Downloadable invoices (PDF)

---

## 🧪 TESTING STRATEGY

### **1. Unit Testing (JUnit)**
- DAO layer tests
- Service layer tests
- Utility class tests
- Validation tests

### **2. Integration Testing**
- Database integration
- Servlet integration
- Service integration

### **3. Test-Driven Development (TDD)**
- Write tests before implementation
- Red-Green-Refactor cycle
- Code coverage > 80%

### **4. Test Automation**
- Selenium WebDriver for UI tests
- Automated test suites
- Continuous testing

### **5. Test Documentation**
- Test plan document
- Test case specifications
- Test results with screenshots

---

## 🔐 SECURITY FEATURES

1. **Password Encryption** (BCrypt)
2. **Session Management**
3. **SQL Injection Prevention** (Prepared Statements)
4. **XSS Prevention** (Input sanitization)
5. **CSRF Protection**
6. **Role-based Access Control**
7. **Secure Headers**
8. **HTTPS Configuration**

---

## 📦 REQUIRED LIBRARIES

### **Backend:**
```
- javax.servlet-api (4.0.1)
- mysql-connector-java (8.0.33)
- jstl (1.2)
- javax.mail (1.6.2)
- bcrypt (0.9.0)
- gson (2.10.1)
- iText (PDF generation)
- junit (5.9.2)
- mockito (5.3.1)
```

### **Frontend:**
```
- Bootstrap (5.3)
- jQuery (3.7)
- Chart.js (4.3)
- Font Awesome (6.4)
- SweetAlert2 (11.7)
- DataTables (1.13)
```

---

## 🚀 DEVELOPMENT PHASES

### **Phase 1: Setup & Design (Week 1)**
- ✅ UML Diagrams (Use Case, Class, Sequence)
- ✅ Database design & creation
- ✅ Project structure setup
- ✅ GitHub repository initialization

### **Phase 2: Backend Development (Week 2-3)**
- ✅ Database connection setup
- ✅ Model classes (POJOs)
- ✅ DAO layer implementation
- ✅ Service layer implementation
- ✅ Servlet controllers
- ✅ Authentication & authorization

### **Phase 3: Frontend Development (Week 3-4)**
- ✅ JSP pages design
- ✅ CSS styling with animations
- ✅ JavaScript validation
- ✅ Bootstrap integration
- ✅ Chart.js dashboards

### **Phase 4: Advanced Features (Week 4-5)**
- ✅ Email notifications
- ✅ PDF generation
- ✅ Advanced search
- ✅ Review system
- ✅ Offers management

### **Phase 5: Testing & Documentation (Week 5-6)**
- ✅ Unit testing
- ✅ Integration testing
- ✅ Test automation
- ✅ Documentation
- ✅ GitHub version control

---

## 📝 DELIVERABLES

### **1. Source Code**
- Complete Java project
- Well-commented code
- Follows coding standards

### **2. Database**
- SQL schema file
- Sample data file
- ER diagram

### **3. Documentation (4000 words)**
- UML diagrams with explanations
- Design pattern implementation
- Test plan and results
- GitHub repository link
- User manual
- Technical documentation

### **4. GitHub Repository**
- Public repository
- Multiple commits showing progression
- Version control documentation
- README.md file
- CI/CD workflow (bonus)

---

## 🎯 DISTINCTION LEVEL CHECKLIST

### **UML Diagrams (20 marks):**
- ✅ Highly detailed diagrams
- ✅ Clear OOP concepts
- ✅ Multiplicity & navigability
- ✅ Aggregation & composition
- ✅ Excellent UML notation
- ✅ Critical analysis with justification

### **Architecture & Design Patterns (40 marks):**
- ✅ 3-tier architecture
- ✅ Multiple design patterns with justification
- ✅ Advanced database features (stored procedures, triggers)
- ✅ Complex functionality (email, SMS, PDF)
- ✅ Sophisticated UI with animations
- ✅ Professional reports for decision-making
- ✅ Effective sessions/cookies

### **Testing (20 marks):**
- ✅ Test-driven development
- ✅ Comprehensive test cases
- ✅ Test automation
- ✅ All tests passing with screenshots
- ✅ Traceability matrix

### **GitHub & Documentation (20 marks):**
- ✅ Professional documentation
- ✅ Clear explanations with screenshots
- ✅ Version control demonstrated
- ✅ CI/CD workflow
- ✅ Multiple versions deployed

---

## 🎨 KEY FEATURES SUMMARY

### **For DISTINCTION:**
1. ✅ **Beautiful UI** - Hotel-themed with animations
2. ✅ **3 User Roles** - Admin, Staff, Guest with proper access control
3. ✅ **Real-time Dashboard** - Charts and analytics
4. ✅ **Email Notifications** - Booking confirmations
5. ✅ **PDF Invoices** - Professional billing
6. ✅ **Review System** - Guest feedback
7. ✅ **Advanced Search** - Multiple filters
8. ✅ **Promotional Offers** - Discount management
9. ✅ **Audit Logging** - Activity tracking
10. ✅ **Responsive Design** - Mobile-friendly
11. ✅ **Input Validation** - Client & server-side
12. ✅ **Security** - Password encryption, SQL injection prevention
13. ✅ **Design Patterns** - Multiple patterns implemented
14. ✅ **Test Automation** - TDD approach
15. ✅ **Version Control** - Git with multiple commits

---

## 📅 TIMELINE

| Week | Tasks |
|------|-------|
| 1 | Design UML diagrams, Setup project, Create database |
| 2 | Backend development (Models, DAOs, Services) |
| 3 | Servlet controllers, Authentication, Authorization |
| 4 | Frontend JSP pages, CSS styling, JavaScript |
| 5 | Advanced features, Reports, Testing |
| 6 | Documentation, Final testing, GitHub deployment |

---

## 🎓 FINAL NOTES

This project plan is designed to achieve **DISTINCTION LEVEL (70-100)** by:

1. ✅ **Exceeding requirements** - Not just meeting, but exceeding all criteria
2. ✅ **Professional quality** - Industry-standard code and design
3. ✅ **Advanced features** - Going beyond basic requirements
4. ✅ **Complete documentation** - Professional and detailed
5. ✅ **Proper testing** - TDD approach with automation
6. ✅ **Version control** - Demonstrating Git best practices

---

## 🚀 NEXT STEPS

**Ready to implement:**
1. Create project structure and folder hierarchy
2. Setup MySQL database with schema
3. Design UML diagrams (Use Case, Class, Sequence)
4. Begin backend development
5. Develop frontend with animations
6. Implement advanced features
7. Complete testing and documentation

---

**Author:** Rovo Dev  
**Date:** January 18, 2026  
**Version:** 1.0
