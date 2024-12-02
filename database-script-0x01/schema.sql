-- schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create ENUM types
CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method_type AS ENUM ('credit_card', 'paypal', 'stripe');

-- Create User table
CREATE TABLE Users (
    user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role user_role NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_phone CHECK (phone_number IS NULL OR phone_number ~* '^\+?[0-9]{10,15}$')
);

-- Create Location table
CREATE TABLE Locations (
    location_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create Property table
CREATE TABLE Properties (
    property_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    host_id UUID NOT NULL,
    location_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE CASCADE,
    CONSTRAINT positive_price CHECK (price_per_night > 0)
);

-- Create Booking table
CREATE TABLE Bookings (
    booking_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status booking_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT valid_dates CHECK (end_date > start_date),
    CONSTRAINT positive_total CHECK (total_price > 0)
);

-- Create PaymentMethod table
CREATE TABLE PaymentMethods (
    method_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    method_type payment_method_type NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create Payment table
CREATE TABLE Payments (
    payment_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    booking_id UUID NOT NULL UNIQUE,
    method_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (method_id) REFERENCES PaymentMethods(method_id) ON DELETE CASCADE,
    CONSTRAINT positive_amount CHECK (amount > 0)
);

-- Create Review table
CREATE TABLE Reviews (
    review_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT valid_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT unique_user_property_review UNIQUE (user_id, property_id)
);

-- Create Message table
CREATE TABLE Messages (
    message_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create Indexes for better performance

-- Users table indexes
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_role ON Users(role);

-- Properties table indexes
CREATE INDEX idx_properties_host ON Properties(host_id);
CREATE INDEX idx_properties_location ON Properties(location_id);
CREATE INDEX idx_properties_price ON Properties(price_per_night);

-- Bookings table indexes
CREATE INDEX idx_bookings_property ON Bookings(property_id);
CREATE INDEX idx_bookings_user ON Bookings(user_id);
CREATE INDEX idx_bookings_dates ON Bookings(start_date, end_date);
CREATE INDEX idx_bookings_status ON Bookings(status);

-- Payments table indexes
CREATE INDEX idx_payments_booking ON Payments(booking_id);
CREATE INDEX idx_payments_method ON Payments(method_id);
CREATE INDEX idx_payments_date ON Payments(payment_date);

-- Reviews table indexes
CREATE INDEX idx_reviews_property ON Reviews(property_id);
CREATE INDEX idx_reviews_user ON Reviews(user_id);
CREATE INDEX idx_reviews_rating ON Reviews(rating);

-- Messages table indexes
CREATE INDEX idx_messages_sender ON Messages(sender_id);
CREATE INDEX idx_messages_recipient ON Messages(recipient_id);
CREATE INDEX idx_messages_sent_at ON Messages(sent_at);

-- Create trigger function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for Properties table
CREATE TRIGGER update_properties_updated_at
    BEFORE UPDATE ON Properties
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();