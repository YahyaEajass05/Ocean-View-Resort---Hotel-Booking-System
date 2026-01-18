-- ============================================
-- Ocean View Resort - Sample Data
-- Version: 1.0.0
-- Description: Sample data for testing and demonstration
-- ============================================

USE oceanview_resort;

-- ============================================
-- Insert Sample Users
-- Password for all users: password123 (BCrypt hashed)
-- ============================================

INSERT INTO users (username, password, email, full_name, phone, role, status) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin@oceanview.com', 'Admin User', '+1234567890', 'ADMIN', 'ACTIVE'),
('staff1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'staff1@oceanview.com', 'John Smith', '+1234567891', 'STAFF', 'ACTIVE'),
('staff2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'staff2@oceanview.com', 'Sarah Johnson', '+1234567892', 'STAFF', 'ACTIVE'),
('guest1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'guest1@example.com', 'Michael Brown', '+1234567893', 'GUEST', 'ACTIVE'),
('guest2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'guest2@example.com', 'Emily Davis', '+1234567894', 'GUEST', 'ACTIVE'),
('guest3', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'guest3@example.com', 'David Wilson', '+1234567895', 'GUEST', 'ACTIVE');

-- ============================================
-- Insert Guest Details
-- ============================================

INSERT INTO guests (user_id, address, city, country, postal_code, id_type, id_number, date_of_birth, gender) VALUES
(4, '123 Main St', 'New York', 'USA', '10001', 'Passport', 'P12345678', '1985-05-15', 'MALE'),
(5, '456 Oak Ave', 'Los Angeles', 'USA', '90001', 'Driver License', 'DL987654', '1990-08-22', 'FEMALE'),
(6, '789 Pine Rd', 'Chicago', 'USA', '60601', 'National ID', 'NID456789', '1988-03-10', 'MALE');

-- ============================================
-- Insert Rooms
-- ============================================

INSERT INTO rooms (room_number, room_type, floor, capacity, price_per_night, description, amenities, status) VALUES
-- Floor 1 - Singles
('101', 'SINGLE', 1, 1, 80.00, 'Cozy single room with ocean view', '["Free WiFi", "Air Conditioning", "TV", "Mini Bar"]', 'AVAILABLE'),
('102', 'SINGLE', 1, 1, 80.00, 'Comfortable single room', '["Free WiFi", "Air Conditioning", "TV"]', 'AVAILABLE'),
('103', 'SINGLE', 1, 1, 80.00, 'Single room with balcony', '["Free WiFi", "Air Conditioning", "TV", "Balcony"]', 'AVAILABLE'),

-- Floor 1 - Doubles
('104', 'DOUBLE', 1, 2, 120.00, 'Spacious double room with queen bed', '["Free WiFi", "Air Conditioning", "TV", "Mini Bar", "Safe"]', 'AVAILABLE'),
('105', 'DOUBLE', 1, 2, 120.00, 'Double room with garden view', '["Free WiFi", "Air Conditioning", "TV", "Balcony"]', 'AVAILABLE'),

-- Floor 2 - Deluxe
('201', 'DELUXE', 2, 2, 180.00, 'Deluxe room with premium amenities', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Bathtub", "Ocean View"]', 'AVAILABLE'),
('202', 'DELUXE', 2, 2, 180.00, 'Deluxe room with jacuzzi', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Jacuzzi", "Ocean View"]', 'AVAILABLE'),
('203', 'DELUXE', 2, 3, 200.00, 'Deluxe room with extra bed', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Ocean View"]', 'AVAILABLE'),

-- Floor 3 - Suites
('301', 'SUITE', 3, 4, 300.00, 'Luxury suite with living area', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Living Area", "Kitchen", "Ocean View", "Balcony"]', 'AVAILABLE'),
('302', 'SUITE', 3, 4, 320.00, 'Presidential suite with panoramic view', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Living Area", "Kitchen", "Ocean View", "Balcony", "Jacuzzi"]', 'AVAILABLE'),

-- Floor 3 - Family
('303', 'FAMILY', 3, 5, 250.00, 'Family room with two bedrooms', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Two Bedrooms", "Kitchen"]', 'AVAILABLE'),
('304', 'FAMILY', 3, 6, 280.00, 'Large family room with ocean view', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Two Bedrooms", "Kitchen", "Ocean View", "Balcony"]', 'AVAILABLE'),

-- Floor 4 - More rooms
('401', 'DOUBLE', 4, 2, 150.00, 'Premium double room', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Ocean View"]', 'AVAILABLE'),
('402', 'DOUBLE', 4, 2, 150.00, 'Premium double with balcony', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Ocean View", "Balcony"]', 'AVAILABLE'),
('403', 'DELUXE', 4, 3, 220.00, 'Premium deluxe room', '["Free WiFi", "Air Conditioning", "Smart TV", "Mini Bar", "Safe", "Bathtub", "Ocean View", "Balcony"]', 'AVAILABLE');

-- ============================================
-- Insert Promotional Offers
-- ============================================

INSERT INTO offers (title, description, discount_type, discount_value, start_date, end_date, applicable_rooms, min_nights, status) VALUES
('Early Bird Discount', 'Book 30 days in advance and save 15%', 'PERCENTAGE', 15.00, '2026-01-01', '2026-12-31', '["SINGLE", "DOUBLE", "DELUXE"]', 2, 'ACTIVE'),
('Weekend Special', 'Special weekend rates - 20% off', 'PERCENTAGE', 20.00, '2026-01-01', '2026-06-30', '["DOUBLE", "DELUXE"]', 2, 'ACTIVE'),
('Suite Luxury Deal', 'Luxury suite package with $100 off', 'FIXED', 100.00, '2026-01-15', '2026-03-31', '["SUITE"]', 3, 'ACTIVE'),
('Family Package', 'Family rooms with 25% discount', 'PERCENTAGE', 25.00, '2026-02-01', '2026-08-31', '["FAMILY"]', 4, 'ACTIVE'),
('Long Stay Discount', 'Stay 7+ nights and save 30%', 'PERCENTAGE', 30.00, '2026-01-01', '2026-12-31', '["SINGLE", "DOUBLE", "DELUXE", "SUITE", "FAMILY"]', 7, 'ACTIVE');

-- ============================================
-- Insert Sample Reservations
-- ============================================

INSERT INTO reservations (reservation_number, guest_id, room_id, check_in_date, check_out_date, number_of_guests, number_of_nights, total_amount, discount_amount, tax_amount, final_amount, status, created_by) VALUES
('RES-2026-0001', 1, 1, '2026-02-01', '2026-02-05', 1, 4, 320.00, 0.00, 32.00, 352.00, 'CONFIRMED', 2),
('RES-2026-0002', 2, 4, '2026-02-10', '2026-02-15', 2, 5, 600.00, 90.00, 51.00, 561.00, 'CONFIRMED', 2),
('RES-2026-0003', 3, 9, '2026-02-20', '2026-02-25', 4, 5, 1500.00, 0.00, 150.00, 1650.00, 'PENDING', 3),
('RES-2026-0004', 1, 6, '2026-03-01', '2026-03-07', 2, 6, 1080.00, 162.00, 91.80, 1009.80, 'CONFIRMED', 2);

-- ============================================
-- Insert Sample Payments
-- ============================================

INSERT INTO payments (reservation_id, payment_number, amount, payment_method, payment_status, transaction_id) VALUES
(1, 'PAY-2026-0001', 352.00, 'CARD', 'COMPLETED', 'TXN123456789'),
(2, 'PAY-2026-0002', 561.00, 'ONLINE', 'COMPLETED', 'TXN987654321'),
(4, 'PAY-2026-0004', 1009.80, 'CARD', 'COMPLETED', 'TXN456789123');

-- ============================================
-- Insert Sample Reviews
-- ============================================

INSERT INTO reviews (reservation_id, guest_id, rating, cleanliness_rating, service_rating, value_rating, comment, status) VALUES
(1, 1, 5, 5, 5, 5, 'Excellent stay! Beautiful ocean view and very clean room. Staff was extremely friendly and helpful.', 'APPROVED'),
(2, 2, 4, 5, 4, 4, 'Great hotel with amazing amenities. The room was spacious and comfortable. Would definitely recommend!', 'APPROVED');

-- ============================================
-- Insert Sample Audit Logs
-- ============================================

INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details, ip_address) VALUES
(1, 'LOGIN', 'USER', 1, '{"browser": "Chrome", "os": "Windows"}', '192.168.1.100'),
(2, 'CREATE', 'RESERVATION', 1, '{"reservation_number": "RES-2026-0001"}', '192.168.1.101'),
(2, 'CREATE', 'RESERVATION', 2, '{"reservation_number": "RES-2026-0002"}', '192.168.1.101'),
(1, 'UPDATE', 'ROOM', 1, '{"field": "status", "old_value": "AVAILABLE", "new_value": "RESERVED"}', '192.168.1.100');

-- ============================================
-- Sample Data Insertion Complete
-- ============================================

-- Display summary
SELECT 'Users' as Table_Name, COUNT(*) as Record_Count FROM users
UNION ALL
SELECT 'Guests', COUNT(*) FROM guests
UNION ALL
SELECT 'Rooms', COUNT(*) FROM rooms
UNION ALL
SELECT 'Reservations', COUNT(*) FROM reservations
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Offers', COUNT(*) FROM offers
UNION ALL
SELECT 'Audit Logs', COUNT(*) FROM audit_logs;
