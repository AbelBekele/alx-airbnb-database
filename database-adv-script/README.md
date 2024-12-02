
# SQL Complex Queries with Joins

## Description

This repository contains examples of complex SQL queries demonstrating different types of JOIN operations. The queries are designed to show how to retrieve data from multiple related tables in a database system.

## Queries Included

### 1. INNER JOIN

-   Retrieves all bookings with their corresponding user information
-   Demonstrates matching records between bookings and users tables

### 2. LEFT JOIN

-   Shows all properties and their associated reviews
-   Includes properties that have no reviews
-   Demonstrates how to preserve all records from the left table

### 3. FULL OUTER JOIN

-   Displays all users and bookings relationships
-   Includes users without bookings and bookings without users
-   Demonstrates complete data retrieval from both tables

## Usage

To use these queries:

1.  Ensure you have a database with the following tables:
    -   users
    -   bookings
    -   properties
    -   reviews
2.  Copy and paste the desired query into your SQL client
3.  Execute the query

## Note

If you're using MySQL, which doesn't support FULL OUTER JOIN directly, an alternative query using UNION is provided.

## Requirements

-   Any SQL database management system (PostgreSQL recommended)
-   Basic understanding of SQL syntax
-   Database with appropriate tables and relationships