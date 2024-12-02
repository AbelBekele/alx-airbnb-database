-- database_index.sql

-- First, let's analyze the current query performance
EXPLAIN ANALYZE
SELECT u.user_id, u.email, COUNT(b.booking_id) 
FROM users u 
LEFT JOIN bookings b ON u.user_id = b.user_id 
GROUP BY u.user_id, u.email;

-- Create indexes for Users table
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_last_name ON users(last_name);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Create indexes for Bookings table
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX IF NOT EXISTS idx_bookings_check_out_date ON bookings(check_out_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Create indexes for Properties table
CREATE INDEX IF NOT EXISTS idx_properties_owner_id ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_status ON properties(status);
CREATE INDEX IF NOT EXISTS idx_properties_property_type ON properties(property_type);
CREATE INDEX IF NOT EXISTS idx_properties_city ON properties(city);

-- Create composite indexes for frequently combined columns
CREATE INDEX IF NOT EXISTS idx_bookings_user_dates ON bookings(user_id, check_in_date, check_out_date);
CREATE INDEX IF NOT EXISTS idx_properties_location ON properties(city, property_type, status);

-- Analyze the tables to update statistics
ANALYZE users;
ANALYZE bookings;
ANALYZE properties;

-- Test queries with EXPLAIN ANALYZE to measure performance improvement

-- Test 1: User booking search
EXPLAIN ANALYZE
SELECT u.user_id, u.email, b.booking_id, b.check_in_date
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE u.email = 'test@example.com'
AND b.check_in_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Test 2: Property search
EXPLAIN ANALYZE
SELECT p.property_id, p.property_type, COUNT(b.booking_id) as booking_count
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
WHERE p.city = 'New York'
AND p.status = 'active'
GROUP BY p.property_id, p.property_type;

-- Test 3: Booking analysis
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.email,
    COUNT(b.booking_id) as total_bookings,
    AVG(b.total_price) as avg_booking_price
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE b.status = 'completed'
GROUP BY u.user_id, u.email
HAVING COUNT(b.booking_id) > 5;

-- Comments explaining index choices:
/*
1. Single-Column Indexes:
   - email: Frequently used in user lookups
   - user_id: Used in joins with bookings
   - property_id: Used in joins and searches
   - check_in_date/check_out_date: Used in date range queries
   - status: Frequently filtered fields

2. Composite Indexes:
   - bookings_user_dates: Optimizes date range queries per user
   - properties_location: Optimizes property searches by location and type

3. Performance Considerations:
   - Indexes improve SELECT query performance
   - But they slow down INSERT/UPDATE operations
   - Regular ANALYZE ensures optimal query planning
*/

-- Additional maintenance queries

-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;

-- Check table statistics
SELECT 
    relname as table_name,
    n_live_tup as row_count,
    n_dead_tup as dead_rows
FROM pg_stat_user_tables
WHERE schemaname = 'public';

-- Index size information
SELECT
    t.tablename,
    indexname,
    c.reltuples AS num_rows,
    pg_size_pretty(pg_relation_size(quote_ident(t.tablename)::text)) AS table_size,
    pg_size_pretty(pg_relation_size(quote_ident(indexname)::text)) AS index_size,
    CASE WHEN indisunique THEN 'Y' ELSE 'N' END AS UNIQUE,
    idx_scan as number_of_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_tables t
LEFT OUTER JOIN pg_class c ON t.tablename=c.relname
LEFT OUTER JOIN
    ( SELECT c.relname AS ctablename, ipg.relname AS indexname, x.indnatts AS number_of_columns,
             idx_scan, idx_tup_read, idx_tup_fetch, indexrelname, indisunique
      FROM pg_index x
      JOIN pg_class c ON c.oid = x.indrelid
      JOIN pg_class ipg ON ipg.oid = x.indexrelid
      JOIN pg_stat_all_indexes psai ON x.indexrelid = psai.indexrelid )
    AS foo
    ON t.tablename = foo.ctablename
WHERE t.schemaname='public'
ORDER BY 1,2;