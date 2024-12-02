
# SQL Complex Queries with Joins and Subqueries

## Description

This repository contains examples of complex SQL queries demonstrating different types of JOIN operations and subqueries. The queries are designed to show how to retrieve and analyze data from multiple related tables in a database system.

## Queries Included

### 1. JOIN Operations

#### INNER JOIN

-   Retrieves all bookings with their corresponding user information
-   Demonstrates matching records between bookings and users tables

#### LEFT JOIN

-   Shows all properties and their associated reviews
-   Includes properties that have no reviews
-   Demonstrates how to preserve all records from the left table

#### FULL OUTER JOIN

-   Displays all users and bookings relationships
-   Includes users without bookings and bookings without users
-   Demonstrates complete data retrieval from both tables

### 2. Subqueries

#### Properties with High Ratings

-   Uses non-correlated subquery to find properties with average rating > 4.0
-   Provides alternative approach using derived tables
-   Demonstrates aggregation in subqueries

#### User Booking Analysis

-   Uses correlated subquery to identify users with more than 3 bookings
-   Includes alternative JOIN-based approach
-   Shows different methods to count related records

## Usage

To use these queries:

1.  Ensure you have a database with the following tables:
    -   users
    -   bookings
    -   properties
    -   reviews
2.  Copy and paste the desired query into your SQL client
3.  Execute the query

## Best Practices

-   Use appropriate indexes for optimized performance
-   Test different query approaches for best results
-   Use EXPLAIN to analyze query execution plans
-   Consider database size when choosing query approach

## Note

-   If you're using MySQL, which doesn't support FULL OUTER JOIN directly, an alternative query using UNION is provided
-   Performance may vary between different database management systems

## Requirements

-   Any SQL database management system (PostgreSQL recommended)
-   Basic understanding of SQL syntax
-   Database with appropriate tables and relationships