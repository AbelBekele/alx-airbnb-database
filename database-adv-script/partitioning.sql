-- partitioning.sql

-- 1. Create the partitioned table
CREATE TABLE bookings_partitioned (
    booking_id SERIAL,
    user_id INTEGER,
    property_id INTEGER,
    start_date DATE,
    end_date DATE,
    total_price DECIMAL(10,2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- 2. Create partitions by quarter
CREATE TABLE bookings_2024_q1 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE bookings_2024_q2 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE bookings_2024_q3 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE bookings_2024_q4 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- 3. Create indexes on partitioned table
CREATE INDEX idx_bookings_part_start_date ON bookings_partitioned(start_date);
CREATE INDEX idx_bookings_part_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_part_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_part_status ON bookings_partitioned(status);

-- 4. Migrate existing data (if any)
INSERT INTO bookings_partitioned 
SELECT * FROM bookings 
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01';

-- 5. Test Queries for Performance Comparison

-- Test Query 1: Range scan for specific quarter
EXPLAIN ANALYZE
SELECT *
FROM bookings_partitioned
WHERE start_date >= '2024-01-01' 
AND start_date < '2024-04-01';

-- Test Query 2: Multi-quarter range scan
EXPLAIN ANALYZE
SELECT 
    DATE_TRUNC('month', start_date) as booking_month,
    COUNT(*) as booking_count,
    SUM(total_price) as total_revenue
FROM bookings_partitioned
WHERE start_date >= '2024-01-01' 
AND start_date < '2024-07-01'
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY booking_month;

-- Test Query 3: Join with other tables
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.email,
    p.property_name,
    b.start_date,
    b.total_price
FROM bookings_partitioned b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-03-31'
AND b.status = 'confirmed';

-- 6. Maintenance procedures
CREATE OR REPLACE PROCEDURE create_next_partition(
    start_date DATE,
    end_date DATE,
    partition_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %I PARTITION OF bookings_partitioned
         FOR VALUES FROM (%L) TO (%L)',
        partition_name, start_date, end_date
    );
END;
$$;

-- 7. Create function to automatically create future partitions
CREATE OR REPLACE FUNCTION create_future_partitions()
RETURNS void AS $$
DECLARE
    next_quarter DATE;
    partition_name TEXT;
BEGIN
    -- Get the start date of the next quarter
    next_quarter := DATE_TRUNC('quarter', NOW() + INTERVAL '3 months');
    
    -- Create partition for next quarter
    partition_name := 'bookings_' || 
                     EXTRACT(YEAR FROM next_quarter) || '_q' || 
                     EXTRACT(QUARTER FROM next_quarter);
    
    CALL create_next_partition(
        next_quarter,
        next_quarter + INTERVAL '3 months',
        partition_name
    );
END;
$$ LANGUAGE plpgsql;

-- 8. Schedule automatic partition creation (example for cron job)
-- Requires pg_cron extension
-- SELECT cron.schedule('0 0 1 * *', $$SELECT create_future_partitions()$$);

-- 9. Monitoring queries
CREATE VIEW vw_partition_stats AS
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname || '.' || tablename)) as table_size,
    pg_size_pretty(pg_indexes_size(schemaname || '.' || tablename)) as index_size,
    (SELECT count(*) FROM pg_indexes WHERE schemaname = p.schemaname AND tablename = p.tablename) as index_count
FROM pg_tables p
WHERE tablename LIKE 'bookings_%'
ORDER BY tablename;

-- 10. Cleanup old partitions procedure
CREATE OR REPLACE PROCEDURE cleanup_old_partitions(
    older_than_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    partition_name TEXT;
BEGIN
    FOR partition_name IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE tablename LIKE 'bookings_%'
        AND tablename ~ '^bookings_\d{4}_q[1-4]$'
    LOOP
        IF to_date(split_part(partition_name, '_', 2), 'YYYY') < older_than_date THEN
            EXECUTE 'DROP TABLE IF EXISTS ' || partition_name;
        END IF;
    END;
END;
$$;