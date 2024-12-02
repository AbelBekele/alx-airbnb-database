-- INNER JOIN query to retrieve all bookings and their users

SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
ORDER BY 
    b.booking_id;


-- LEFT JOIN query to retrieve all properties and their reviews

SELECT 
    p.property_id,
    p.property_name,
    p.description,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
ORDER BY 
    p.property_id, r.review_date DESC;


-- FULL OUTER JOIN query to retrieve all users and bookings:

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.booking_id;


