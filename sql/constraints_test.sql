USE online_booking_variant22;

INSERT INTO appointments
(
    client_id,
    psychologist_id,
    test_id,
    appointment_type,
    appointment_datetime
)
VALUES
(
    1,
    1,
    1,
    'testing',
    '2026-06-10 10:00:00'
);

INSERT INTO appointments
(
    client_id,
    psychologist_id,
    test_id,
    appointment_type,
    appointment_datetime
)
VALUES
(
    2,
    1,
    1,
    'testing',
    '2026-06-10 10:00:00'
);

DELETE FROM psychologists
WHERE psychologist_id = 1;

INSERT INTO psychologists
(
    full_name,
    specialization,
    phone,
    experience_years
)
VALUES
(
    'Тестовый Психолог',
    'Тест',
    '+70000000000',
    -5
);
