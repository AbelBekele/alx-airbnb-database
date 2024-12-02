
# AirBnB Database System

A complete database implementation for an AirBnB-like platform using PostgreSQL.

## Overview

This repository contains a fully normalized database schema with sample data for managing property rentals, user interactions, bookings, payments, and reviews.

## Structure

- `/ERD` - Entity Relationship Diagram and requirements documentation
- `/database-script-0x01` - Database schema creation scripts
- `/database-script-0x02` - Sample data seeding scripts
- `normalization.md` - Database normalization analysis

## Features

- User management (guests, hosts, admins)
- Property listings and bookings
- Payment processing
- Review system
- Messaging system
- Location management

## Installation

1. Ensure PostgreSQL 12.0+ is installed
2. Create database:
```sql
CREATE DATABASE airbnb_db;
```
3.  Run schema script:

```bash
psql -U your_username -d airbnb_db -f database-script-0x01/schema.sql
```

4.  Load sample data:

```bash
psql -U your_username -d airbnb_db -f database-script-0x02/seed.sql
```

## Technical Details

-   Uses UUID for primary keys
-   Implements proper foreign key constraints
-   Includes optimized indexes
-   Follows 3NF normalization
-   Includes data validation

## Requirements

-   PostgreSQL 12.0 or higher
-   UUID extension capability
-   Minimum 100MB storage space
-   Database administration privileges

## License
MIT