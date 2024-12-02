-- Query to find properties with average rating > 4.0 (Non-correlated subquery)

SELECT 
    p.property_id,
    p.property_name,
    p.description,
    (SELECT AVG(rating) 
     FROM reviews r 
     WHERE r.property_id = p.property_id) as avg_rating
FROM 
    properties p
WHERE 
    (SELECT AVG(rating) 
     FROM reviews r 
     WHERE r.property_id = p.property_id) > 4.0
ORDER BY 
    avg_rating DESC;


-- Correlated subquery to find users with more than 3 bookings

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) as booking_count
FROM 
    users u
WHERE 
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) > 3
ORDER BY 
    booking_count DESC;