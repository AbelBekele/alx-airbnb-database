-- monitoring_analysis.sql

-- Enable query profiling (if using MySQL)
SET profiling = 1;

-- 1. Monitor frequently used queries
-- Query 1: Search bookings by date range
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.email,
    p.property_name,
    b.check_in_date,
    b.total_price
FROM 
    bookings b
    JOIN users u ON b.user_id = u.user_id
    JOIN properties p ON b.property_id = p.property_id
WHERE 
    b.check_in_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND b.status = 'confirmed';

-- Query 2: Dashboard statistics
EXPLAIN ANALYZE
SELECT 
    COUNT(*) as total_bookings,
    AVG(total_price) as avg_booking_value,
    COUNT(DISTINCT user_id) as unique_users
FROM 
    bookings
WHERE 
    created_at >= CURRENT_DATE - INTERVAL '30 days';

-- Query 3: Property availability search
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.property_name,
    p.daily_rate,
    COUNT(b.booking_id) as total_bookings
FROM 
    properties p
    LEFT JOIN bookings b ON p.property_id = b.property_id
WHERE 
    p.status = 'active'
GROUP BY 
    p.property_id, p.property_name, p.daily_rate
HAVING 
    COUNT(b.booking_id) < 10;

-- 2. Create monitoring views for ongoing analysis
CREATE VIEW vw_query_stats AS
SELECT 
    substring(query, 1, 50) as query_sample,
    calls,
    total_time,
    mean_time,
    rows
FROM 
    pg_stat_statements
ORDER BY 
    total_time DESC
LIMIT 20;

CREATE VIEW vw_table_stats AS
SELECT
    schemaname,
    relname as table_name,
    seq_scan,
    seq_tup_read,
    idx_scan,
    n_live_tup,
    n_dead_tup
FROM 
    pg_stat_user_tables;

-- 3. Implement suggested improvements

-- Add composite index for date range searches
CREATE INDEX idx_bookings_date_status ON bookings(check_in_date, status);

-- Add index for dashboard queries
CREATE INDEX idx_bookings_created_at ON bookings(created_at);

-- Add index for property searches
CREATE INDEX idx_properties_status_bookings ON properties(status) INCLUDE (daily_rate);

-- 4. Recheck query performance after improvements
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.email,
    p.property_name,
    b.check_in_date,
    b.total_price
FROM 
    bookings b
    JOIN users u ON b.user_id = u.user_id
    JOIN properties p ON b.property_id = p.property_id
WHERE 
    b.check_in_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND b.status = 'confirmed';

-- 5. Monitor cache hit ratios
SELECT 
    sum(heap_blks_read) as heap_read,
    sum(heap_blks_hit)  as heap_hit,
    sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read))::float as ratio
FROM 
    pg_statio_user_tables;

-- 6. Check for unused indexes
SELECT 
    schemaname || '.' || tablename as table,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM 
    pg_stat_user_indexes
WHERE 
    idx_scan = 0
ORDER BY 
    schemaname, tablename;

-- 7. Monitor table bloat
SELECT 
    schemaname, 
    tablename, 
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as total_size,
    pg_size_pretty(pg_table_size(schemaname || '.' || tablename)) as table_size,
    pg_size_pretty(pg_indexes_size(schemaname || '.' || tablename)) as index_size
FROM 
    pg_tables
WHERE 
    schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    pg_total_relation_size(schemaname || '.' || tablename) DESC;