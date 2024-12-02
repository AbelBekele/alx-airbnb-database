# AirBnB Database Schema   
## Overview This repository contains the database schema for an AirBnB-like platform. The schema is designed to manage users, properties, bookings, payments, reviews, and messaging functionality in a normalized and efficient manner.   

## Table of Contents 
-  [Prerequisites](#prerequisites)
-  [Installation](#installation) 
- [Database Structure](#database-structure) 
- [Key Features](#key-features) 
- [Usage Examples](#usage-examples) 
- [Schema Maintenance](#schema-maintenance) 
- [Best Practices](#best-practices) 
- [Troubleshooting](#troubleshooting)   

## Prerequisites 
- PostgreSQL 12.0 or higher 
- UUID extension capability 
- Minimum 100MB storage space 
- Database administration privileges  

## Installation   

### 1. Create Database 
`sql CREATE DATABASE airbnb_db;`

### 2. Connect to Database
`\c airbnb_db`

### 3. Execute Schema

`psql -U your_username -d airbnb_db -f schema.sql`

## Database Structure

### Core Tables

1.  **Users**
    -   Stores user information
    -   Supports multiple roles (guest, host, admin)
    -   Email validation and unique constraints
2.  **Locations**
    -   Manages property locations
    -   Normalized address information
    -   Supports international addresses
3.  **Properties**
    -   Property listings information
    -   Linked to hosts and locations
    -   Includes pricing and description
4.  **Bookings**
    -   Reservation management
    -   Status tracking
    -   Date range validation
5.  **PaymentMethods**
    -   Supported payment types
    -   Payment method details
6.  **Payments**
    -   Transaction records
    -   Links bookings with payment methods
7.  **Reviews**
    -   Property reviews and ratings
    -   User feedback management
8.  **Messages**
    -   User communication system
    -   Timestamp tracking

### Key Relationships

```
Users ─┬─── Properties (as host)
	   ├─── Bookings (as guest)
	   ├─── Reviews 
	   └─── Messages (as sender/recipient)   
Properties ─┬─── Bookings
			├─── Reviews 
			└─── Locations   
Bookings ─── Payments
 ```

## Key Features

### 1. Data Integrity

-   Foreign key constraints
-   Check constraints for validation
-   Unique constraints where applicable
-   Automated timestamp management

### 2. Performance Optimization

-   Strategic indexing on:
    -   Foreign keys
    -   Search fields
    -   Sort fields
-   Optimized data types

### 3. Security

-   Password hashing requirement
-   Email validation
-   Phone number validation
-   Role-based access control

### 4. Scalability

-   UUID for primary keys
-   Normalized structure
-   Efficient indexing strategy

## Usage Examples

### 1. Create New User

```sql
INSERT  INTO Users (
   first_name, 
   last_name, 
   email, 
   password_hash, 
   role 
  )  VALUES  (
     'John', 
     'Doe', 
     'john.doe@email.com', 
     'hashed_password', 
     'guest' 
 );
```

### 2. Create Property Listing
```sql
INSERT  INTO Properties (
	host_id, 
	location_id, 
	name, 
	description, 
	price_per_night 
)  VALUES  (
	'host_uuid', 
	'location_uuid', 
	'Beach House', 
	'Beautiful beachfront property', 
	150.00 
);
```

## Schema Maintenance

### Regular Tasks

1.  Index maintenance
`REINDEX DATABASE airbnb_db;`

2.  Statistics update
`ANALYZE;`

3.  Backup
```pg_dump airbnb_db > backup.sql```

### Monitoring

-   Monitor index usage
-   Check for slow queries
-   Validate constraint effectiveness

## Best Practices

### 1. Data Input

-   Always use prepared statements
-   Validate data before insertion
-   Handle NULL values appropriately

### 2. Queries

-   Use indexes effectively
-   Avoid SELECT *
-   Implement pagination for large results

### 3. Transactions

-   Use transactions for multi-table operations
-   Implement proper error handling
-   Maintain ACID compliance

## Troubleshooting

### Common Issues

1.  **Constraint Violations**
    -   Check data validity
    -   Verify foreign key references
    -   Ensure unique constraints are met
2.  **Performance Issues**
    -   Review query plans
    -   Check index usage
    -   Analyze table statistics
3.  **Connection Issues**
    -   Verify database credentials
    -   Check connection limits
    -   Review server logs


