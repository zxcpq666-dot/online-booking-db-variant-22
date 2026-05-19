SELECT
    a.appointment_id,
    c.full_name AS client_name,
    p.full_name AS psychologist_name,
    t.test_name,
    a.appointment_datetime,
    a.status
FROM appointments a
JOIN clients c
ON a.client_id = c.client_id
JOIN psychologists p
ON a.psychologist_id = p.psychologist_id
JOIN tests t
ON a.test_id = t.test_id
ORDER BY a.appointment_datetime;

SELECT
    c.client_id,
    c.full_name,
    COUNT(pr.profession_name)
    AS total_recommendations
FROM clients c
JOIN profession_recommendations pr
ON c.client_id = pr.client_id
LEFT JOIN appointments a
ON c.client_id = a.client_id
AND a.appointment_type = 'consultation'
WHERE a.appointment_id IS NULL
GROUP BY c.client_id, c.full_name
HAVING COUNT(pr.profession_name) > 3;

SELECT DISTINCT
    c.client_id,
    c.full_name
FROM clients c
JOIN profession_recommendations pr
ON c.client_id = pr.client_id
GROUP BY c.client_id, c.full_name
HAVING COUNT(pr.profession_name)
>
(
    SELECT AVG(recommendation_count)
    FROM
    (
        SELECT COUNT(*)
        AS recommendation_count
        FROM profession_recommendations
        GROUP BY client_id
    ) AS stats
);
