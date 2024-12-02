-- seed.sql

-- Clear existing data (if any)
TRUNCATE TABLE Messages, Reviews, Payments, PaymentMethods, Bookings, Properties, Locations, Users CASCADE;

-- Reset sequences (if any)
-- Note: UUID doesn't need sequence reset

-- Insert Users
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
-- Admins
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Admin', 'User', 'admin@airbnb.com', 'hash_password_123', '+1234567890', 'admin'),

-- Hosts
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'John', 'Smith', 'john.smith@email.com', 'hash_password_124', '+1234567891', 'host'),
('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Mary', 'Johnson', 'mary.johnson@email.com', 'hash_password_125', '+1234567892', 'host'),
('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'Robert', 'Williams', 'robert.williams@email.com', 'hash_password_126', '+1234567893', 'host'),

-- Guests
('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'Sarah', 'Brown', 'sarah.brown@email.com', 'hash_password_127', '+1234567894', 'guest'),
('f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'Michael', 'Davis', 'michael.davis@email.com', 'hash_password_128', '+1234567895', 'guest'),
('g0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'Emma', 'Wilson', 'emma.wilson@email.com', 'hash_password_129', '+1234567896', 'guest'),
('h0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'James', 'Taylor', 'james.taylor@email.com', 'hash_password_130', '+1234567897', 'guest');

-- Insert Locations
INSERT INTO Locations (location_id, address, city, state, country, postal_code) VALUES
('i0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', '123 Beach Road', 'Miami', 'Florida', 'USA', '33139'),
('j0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', '456 Mountain Ave', 'Denver', 'Colorado', 'USA', '80202'),
('k0eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', '789 Lake Street', 'Chicago', 'Illinois', 'USA', '60601'),
('l0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', '321 Forest Lane', 'Seattle', 'Washington', 'USA', '98101'),
('m0eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', '654 Desert Road', 'Phoenix', 'Arizona', 'USA', '85001');

-- Insert Properties
INSERT INTO Properties (property_id, host_id, location_id, name, description, price_per_night) VALUES
('n0eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'i0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'Beachfront Paradise', 'Beautiful beachfront condo with ocean views', 250.00),
('o0eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'j0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'Mountain Retreat', 'Cozy cabin in the mountains', 175.00),
('p0eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'k0eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'City Center Loft', 'Modern loft in downtown', 200.00),
('q0eebc99-9c0b-4ef8-bb6d-6bb9bd380a27', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'l0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Forest Cabin', 'Secluded cabin in the woods', 150.00),
('r0eebc99-9c0b-4ef8-bb6d-6bb9bd380a28', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'm0eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'Desert Oasis', 'Modern house with pool', 225.00);

-- Insert Bookings
INSERT INTO Bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
('s0eebc99-9c0b-4ef8-bb6d-6bb9bd380a29', 'n0eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', '2023-12-01', '2023-12-05', 1000.00, 'confirmed'),
('t0eebc99-9c0b-4ef8-bb6d-6bb9bd380a30', 'o0eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', '2023-12-10', '2023-12-15', 875.00, 'confirmed'),
('u0eebc99-9c0b-4ef8-bb6d-6bb9bd380a31', 'p0eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'g0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '2023-12-20', '2023-12-23', 600.00, 'pending'),
('v0eebc99-9c0b-4ef8-bb6d-6bb9bd380a32', 'q0eebc99-9c0b-4ef8-bb6d-6bb9bd380a27', 'h0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', '2023-12-24', '2023-12-26', 300.00, 'confirmed'),
('w0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'r0eebc99-9c0b-4ef8-bb6d-6bb9bd380a28', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', '2024-01-01', '2024-01-05', 900.00, 'pending');

-- Insert PaymentMethods
INSERT INTO PaymentMethods (method_id, method_name, method_type, description) VALUES
('x0eebc99-9c0b-4ef8-bb6d-6bb9bd380a34', 'Credit Card', 'credit_card', 'Standard credit card payment'),
('y0eebc99-9c0b-4ef8-bb6d-6bb9bd380a35', 'PayPal', 'paypal', 'PayPal payment system'),
('z0eebc99-9c0b-4ef8-bb6d-6bb9bd380a36', 'Stripe', 'stripe', 'Stripe payment processing');

-- Insert Payments
INSERT INTO Payments (payment_id, booking_id, method_id, amount) VALUES
('aa0ebc99-9c0b-4ef8-bb6d-6bb9bd380a37', 's0eebc99-9c0b-4ef8-bb6d-6bb9bd380a29', 'x0eebc99-9c0b-4ef8-bb6d-6bb9bd380a34', 1000.00),
('ab0ebc99-9c0b-4ef8-bb6d-6bb9bd380a38', 't0eebc99-9c0b-4ef8-bb6d-6bb9bd380a30', 'y0eebc99-9c0b-4ef8-bb6d-6bb9bd380a35', 875.00),
('ac0ebc99-9c0b-4ef8-bb6d-6bb9bd380a39', 'v0eebc99-9c0b-4ef8-bb6d-6bb9bd380a32', 'z0eebc99-9c0b-4ef8-bb6d-6bb9bd380a36', 300.00);

-- Insert Reviews
INSERT INTO Reviews (review_id, property_id, user_id, rating, comment) VALUES
('ad0ebc99-9c0b-4ef8-bb6d-6bb9bd380a40', 'n0eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 5, 'Amazing beachfront property! Will definitely return.'),
('ae0ebc99-9c0b-4ef8-bb6d-6bb9bd380a41', 'o0eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 4, 'Great mountain views and cozy interior.'),
('af0ebc99-9c0b-4ef8-bb6d-6bb9bd380a42', 'q0eebc99-9c0b-4ef8-bb6d-6bb9bd380a27', 'h0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 5, 'Perfect forest getaway!');

-- Insert Messages
INSERT INTO Messages (message_id, sender_id, recipient_id, message_body) VALUES
('ag0ebc99-9c0b-4ef8-bb6d-6bb9bd380a43', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Is early check-in possible?'),
('ah0ebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'Yes, you can check in at 2 PM.'),
('ai0ebc99-9c0b-4ef8-bb6d-6bb9bd380a45', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Is parking available?'),
('aj0ebc99-9c0b-4ef8-bb6d-6bb9bd380a46', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'Yes, free parking is available.');

-- Verify data insertion
SELECT 'Users' as table_name, COUNT(*) as count FROM Users
UNION ALL
SELECT 'Locations', COUNT(*) FROM Locations
UNION ALL
SELECT 'Properties', COUNT(*) FROM Properties
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Bookings
UNION ALL
SELECT 'PaymentMethods', COUNT(*) FROM PaymentMethods
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Reviews
UNION ALL
SELECT 'Messages', COUNT(*) FROM Messages;