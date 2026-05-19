SELECT
    wash_type,
    COUNT(service_id)
    AS total_services
FROM wash_services
GROUP BY wash_type
ORDER BY total_services DESC;
