SELECT
    b.booking_id,
    c.full_name,
    ws.service_name,
    ws.wash_type,
    wp.post_name,
    b.booking_datetime,
    b.end_datetime,
    b.status
FROM bookings b
JOIN clients c
ON b.client_id = c.client_id
JOIN wash_services ws
ON b.service_id = ws.service_id
JOIN wash_posts wp
ON b.post_id = wp.post_id
ORDER BY b.booking_datetime;
