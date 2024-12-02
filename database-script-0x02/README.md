
# AirBnB Database Seed Data

## Overview
This script populates the AirBnB database with sample data for testing and development purposes.

## Sample Data Includes
- 8 Users (1 admin, 3 hosts, 4 guests)
- 5 Locations
- 5 Properties
- 5 Bookings
- 3 Payment Methods
- 3 Payments
- 3 Reviews
- 4 Messages

## Usage

1. Ensure PostgreSQL is installed and running
2. Connect to your database:
```bash
psql -U your_username -d airbnb_db
```

3.  Run the seed script:
`\i seed.sql`

## Verification

The script includes a verification query that displays the count of records in each table.

## Notes

-   All UUIDs are predefined for testing consistency
-   Existing data will be truncated before seeding
-   Dates are set for December 2023 - January 2024

## Warning

Do not run this script on a production database as it will delete existing data.