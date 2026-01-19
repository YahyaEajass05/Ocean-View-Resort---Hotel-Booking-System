# 🗄️ Database Setup Guide - Ocean View Resort

## Quick Start: Setting Up Your Database

---

## 📋 Prerequisites

1. **MySQL Server** installed and running (Version 5.7+ or 8.0+)
2. **MySQL Workbench** or MySQL Command Line Client
3. **Root access** to MySQL server

---

## 🚀 Option 1: Quick Setup (Recommended)

### Step 1: Open MySQL Command Line or Workbench

```bash
mysql -u root -p
```
Enter your MySQL root password when prompted.

### Step 2: Execute the Main Schema

```sql
SOURCE D:/Intellij Projects/Hotel/src/main/resources/database/schema-jdbc.sql;
```

Or copy and paste the entire contents of `schema-jdbc.sql` into MySQL Workbench and execute.

### Step 3: Verify Database Creation

```sql
USE oceanview_resort;
SHOW TABLES;
```

You should see 8 tables:
- users
- guests
- rooms
- offers
- reservations
- payments
- reviews
- audit_logs

### Step 4: Optional - Add Triggers

```sql
SOURCE D:/Intellij Projects/Hotel/src/main/resources/database/triggers.sql;
```

### Step 5: Optional - Add Stored Procedures

```sql
SOURCE D:/Intellij Projects/Hotel/src/main/resources/database/procedures.sql;
```

### Step 6: Optional - Load Sample Data

```sql
SOURCE D:/Intellij Projects/Hotel/src/main/resources/database/sample-data.sql;
```

---

## 🔧 Option 2: Manual Setup Using MySQL Workbench

### Step 1: Open MySQL Workbench
1. Launch MySQL Workbench
2. Connect to your local MySQL server
3. Enter your password

### Step 2: Create Database
1. Click on **"File" → "Open SQL Script"**
2. Navigate to: `src/main/resources/database/schema-jdbc.sql`
3. Click **"Execute"** (Lightning bolt icon) or press `Ctrl+Shift+Enter`

### Step 3: Verify Tables
In the left sidebar:
1. Right-click on **Schemas**
2. Click **"Refresh All"**
3. Expand **oceanview_resort** database
4. You should see all 8 tables

### Step 4: Add Triggers and Procedures (Optional)
Repeat steps 1-2 for:
- `triggers.sql`
- `procedures.sql`

---

## 🔍 Verification Queries

### Check All Tables Were Created
```sql
USE oceanview_resort;
SHOW TABLES;
```

### Check Table Structures
```sql
DESCRIBE users;
DESCRIBE rooms;
DESCRIBE reservations;
```

### Check Views
```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

Expected views:
- v_active_reservations
- v_available_rooms
- v_revenue_summary

### Check Triggers (if installed)
```sql
SHOW TRIGGERS FROM oceanview_resort;
```

Expected: `trg_reservation_confirmed`

### Check Stored Procedures (if installed)
```sql
SHOW PROCEDURE STATUS WHERE Db = 'oceanview_resort';
```

Expected: `sp_get_available_rooms`

---

## 📝 Create Initial Admin User

After the database is set up, you can create an initial admin user:

```sql
USE oceanview_resort;

-- Insert admin user (password: admin123 - BCrypt hashed)
INSERT INTO users (username, password, email, full_name, phone, role, status) 
VALUES (
    'admin',
    '$2a$10$YourBCryptHashedPasswordHere',  -- You'll need to hash this properly
    'admin@oceanviewresort.com',
    'System Administrator',
    '+1234567890',
    'ADMIN',
    'ACTIVE'
);

-- Verify user created
SELECT user_id, username, email, role FROM users WHERE username = 'admin';
```

**Note:** The password needs to be properly BCrypt hashed. You can:
1. Use the registration page after deployment
2. Or use an online BCrypt generator for 'admin123' and paste the hash

---

## ⚙️ Update Application Configuration

Edit: `src/main/resources/config/application.properties`

```properties
# Update these values to match your MySQL setup
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/oceanview_resort?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username=root
db.password=YOUR_MYSQL_ROOT_PASSWORD

# Connection Pool Settings (already configured)
db.pool.initialSize=5
db.pool.maxActive=20
db.pool.maxIdle=10
db.pool.minIdle=5
db.pool.maxWait=30000
```

---

## 🐛 Troubleshooting

### Issue: "Access denied for user"
**Solution:** Check your MySQL username and password in `application.properties`

```sql
-- Create a dedicated database user (recommended for production)
CREATE USER 'oceanview_user'@'localhost' IDENTIFIED BY 'strong_password_here';
GRANT ALL PRIVILEGES ON oceanview_resort.* TO 'oceanview_user'@'localhost';
FLUSH PRIVILEGES;
```

Then update `application.properties`:
```properties
db.username=oceanview_user
db.password=strong_password_here
```

### Issue: "Unknown database 'oceanview_resort'"
**Solution:** The database wasn't created. Run `schema-jdbc.sql` again.

### Issue: "Table doesn't exist"
**Solution:** Tables weren't created. Check for SQL errors when running schema.

```sql
-- Drop and recreate database
DROP DATABASE IF EXISTS oceanview_resort;
CREATE DATABASE oceanview_resort CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Then run schema-jdbc.sql again
```

### Issue: Connection timeout
**Solution:** Check if MySQL is running

```bash
# Windows
net start MySQL80

# Or check services
services.msc
```

### Issue: "Public Key Retrieval is not allowed"
**Solution:** Already handled in the JDBC URL with `allowPublicKeyRetrieval=true`

---

## 📊 Database Schema Overview

### Core Tables:
- **users** - Authentication and user information
- **guests** - Extended guest profile data
- **rooms** - Hotel room inventory
- **offers** - Promotional offers and discounts
- **reservations** - Booking records
- **payments** - Payment transactions
- **reviews** - Guest reviews and ratings
- **audit_logs** - System activity tracking

### Relationships:
```
users (1) ──→ (1) guests
guests (1) ──→ (N) reservations
rooms (1) ──→ (N) reservations
reservations (1) ──→ (N) payments
reservations (1) ──→ (1) reviews
users (1) ──→ (N) audit_logs
```

---

## ✅ Final Checklist

Before starting the application:

- [ ] MySQL server is running
- [ ] Database `oceanview_resort` is created
- [ ] All 8 tables are created successfully
- [ ] Views are created (3 views)
- [ ] Optional: Triggers installed
- [ ] Optional: Stored procedures installed
- [ ] Optional: Sample data loaded
- [ ] `application.properties` updated with correct credentials
- [ ] Database connection tested

---

## 🎯 Test Database Connection

Create a simple test to verify connectivity:

```sql
USE oceanview_resort;

-- Should return 0 (no users yet)
SELECT COUNT(*) as user_count FROM users;

-- Should return all room types
SELECT DISTINCT room_type FROM rooms;

-- Check database collation
SELECT @@character_set_database, @@collation_database;
```

Expected: `utf8mb4` and `utf8mb4_unicode_ci`

---

## 📞 Need Help?

If you encounter issues:
1. Check MySQL error logs
2. Verify MySQL service is running
3. Confirm credentials in `application.properties`
4. Test connection using MySQL Workbench
5. Check firewall settings (port 3306)

---

*Generated by: Rovo Dev*  
*Guide Version: 1.0.0*
