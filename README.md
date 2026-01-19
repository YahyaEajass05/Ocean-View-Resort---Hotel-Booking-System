# 🏨 Ocean View Resort - Hotel Booking System

## 📋 Project Overview

**Ocean View Resort** is an advanced hotel booking and management system developed as part of the CIS6003 Advanced Programming module. The system provides a comprehensive solution for managing hotel reservations, guests, rooms, and billing operations.

## 🎯 Key Features

### Core Functionality
- ✅ Multi-role user authentication (Admin, Staff, Guest)
- ✅ Room reservation management
- ✅ Guest check-in/check-out system
- ✅ Automated billing and invoice generation
- ✅ Real-time room availability tracking

### Advanced Features
- 🌟 Interactive dashboard with Chart.js analytics
- 🌟 Email notifications for bookings
- 🌟 PDF invoice generation
- 🌟 Guest review and rating system
- 🌟 Promotional offers management
- 🌟 Advanced search and filtering
- 🌟 Audit logging and activity tracking
- 🌟 Responsive design with animations

## 🛠️ Technology Stack

### Backend
- **Java** - Core programming language
- **JSP** (Jakarta EE) - Server-side rendering
- **Servlets** - Request handling
- **JDBC** - Database connectivity
- **MySQL** - Database management

### Frontend
- **HTML5** - Structure
- **CSS3** - Styling with animations
- **JavaScript** - Client-side logic
- **Bootstrap 5** - Responsive framework
- **Chart.js** - Data visualization
- **JSTL** - JSP tag library

### Design Patterns
- Singleton Pattern
- Factory Pattern
- DAO Pattern
- MVC Pattern
- Service Layer Pattern

## 📁 Project Structure

```
ocean-view-resort/
├── src/
│   ├── main/
│   │   ├── java/com/oceanview/
│   │   │   ├── config/         # Configuration classes
│   │   │   ├── model/          # Entity classes
│   │   │   ├── dao/            # Data Access Objects
│   │   │   ├── service/        # Business logic
│   │   │   ├── controller/     # Servlets
│   │   │   ├── filter/         # Filters
│   │   │   ├── util/           # Utility classes
│   │   │   └── factory/        # Factory classes
│   │   ├── webapp/
│   │   │   ├── assets/         # CSS, JS, Images
│   │   │   ├── views/          # JSP pages
│   │   │   └── WEB-INF/        # Configuration
│   │   └── resources/
│   │       ├── config/         # Properties files
│   │       └── database/       # SQL scripts
│   └── test/                   # Unit tests
├── pom.xml                     # Maven configuration
└── README.md                   # This file
```

## 🚀 Getting Started

### Prerequisites
- Java JDK 11 or higher
- Apache Tomcat 9.0 or higher
- MySQL 8.0 or higher
- Maven 3.6 or higher
- IDE (IntelliJ IDEA, Eclipse, or NetBeans)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ocean-view-resort.git
   cd ocean-view-resort
   ```

2. **Configure Database**
   - Create MySQL database:
     ```sql
     CREATE DATABASE oceanview_resort;
     ```
   - Update database credentials in `application.properties`:
     ```properties
     db.url=jdbc:mysql://localhost:3306/oceanview_resort
     db.username=your_username
     db.password=your_password
     ```

3. **Run Database Schema**
   ```bash
   mysql -u root -p oceanview_resort < src/main/resources/database/schema.sql
   ```

4. **Build the project**
   ```bash
   mvn clean install
   ```

5. **Deploy to Tomcat**
   - Copy `target/oceanview-resort.war` to Tomcat's `webapps` directory
   - Start Tomcat server

6. **Access the application**
   ```
   http://localhost:8080/oceanview-resort
   ```

## 👥 Default User Accounts

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |
| Staff | staff | staff123 |
| Guest | guest | guest123 |

## 📚 User Roles & Permissions

### Admin
- Full system access
- User management
- Room management
- View all reservations
- Generate reports
- Manage offers
- System configuration

### Staff
- Manage reservations
- Guest check-in/check-out
- View room availability
- Generate bills
- Search reservations

### Guest
- Register account
- Search rooms
- Make reservations
- View booking history
- Download invoices
- Rate and review

## 🗄️ Database Schema

The system uses 8 main tables:
- `users` - User authentication
- `guests` - Guest details
- `rooms` - Room inventory
- `reservations` - Booking records
- `payments` - Payment transactions
- `reviews` - Guest reviews
- `offers` - Promotional offers
- `audit_logs` - Activity tracking

## 🧪 Testing

Run unit tests:
```bash
mvn test
```

Generate test coverage report:
```bash
mvn jacoco:report
```

## 📊 Reports & Analytics

- Revenue dashboard with charts
- Booking analytics
- Guest demographics
- Room performance metrics
- Occupancy rate trends

## 🔐 Security Features

- Password encryption (BCrypt)
- SQL injection prevention
- XSS protection
- Session management
- Role-based access control
- Audit logging

## 📖 Documentation

Detailed documentation available in:
- [Project Plan](PROJECT_PLAN.md)
- [UML Diagrams](docs/uml/)
- [API Documentation](docs/api/)
- [User Manual](docs/user-manual.pdf)

## 🤝 Contributing

This is an academic project. For queries, contact the module leader.

## 📄 License

This project is developed for educational purposes as part of CIS6003 - Advanced Programming module.

## 👨‍💻 Author

**Student Name**  
Student ID: [Your ID]  
Module: CIS6003 Advanced Programming  
Academic Year: 2025  
Semester: 1

## 📧 Contact

For support or queries:
- Email: priyanga@icbtcampus.edu.lk
- Module: CIS6003 Advanced Programming

---

**Version:** 1.0.0  
**Last Updated:** January 18, 2026
