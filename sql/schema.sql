DROP DATABASE IF EXISTS online_booking_variant22;

CREATE DATABASE online_booking_variant22
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE online_booking_variant22;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    phone VARCHAR(20) NOT NULL UNIQUE,

    email VARCHAR(100) NOT NULL UNIQUE,

    birth_date DATE NOT NULL,

    CHECK (
        birth_date <= CURDATE() - INTERVAL 14 YEAR
    )
);

CREATE TABLE psychologists (
    psychologist_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    specialization VARCHAR(100) NOT NULL,

    phone VARCHAR(20) NOT NULL UNIQUE,

    experience_years INT NOT NULL,

    CHECK (
        experience_years >= 0
    )
);

CREATE TABLE tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,

    test_name VARCHAR(100) NOT NULL UNIQUE,

    methodology TEXT NOT NULL,

    duration_minutes INT NOT NULL,

    psychologist_id INT NOT NULL,

    CHECK (
        duration_minutes BETWEEN 15 AND 180
    ),

    FOREIGN KEY (psychologist_id)
        REFERENCES psychologists(psychologist_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE questionnaires (
    questionnaire_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    questionnaire_date DATE NOT NULL,

    result_text TEXT NOT NULL,

    anxiety_level INT NOT NULL,

    CHECK (
        anxiety_level BETWEEN 1 AND 10
    ),

    FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE profession_recommendations (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    profession_name VARCHAR(100) NOT NULL,

    recommendation_text TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    psychologist_id INT NOT NULL,

    test_id INT NOT NULL,

    appointment_type ENUM(
        'testing',
        'consultation'
    ) NOT NULL,

    appointment_datetime DATETIME NOT NULL,

    status ENUM(
        'planned',
        'completed',
        'cancelled'
    ) DEFAULT 'planned',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (psychologist_id)
        REFERENCES psychologists(psychologist_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (test_id)
        REFERENCES tests(test_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE KEY unique_slot (
        psychologist_id,
        appointment_datetime
    )
);

CREATE INDEX idx_appointments_datetime
ON appointments(appointment_datetime);

CREATE INDEX idx_appointments_client
ON appointments(client_id);

CREATE INDEX idx_questionnaires_client
ON questionnaires(client_id);

CREATE INDEX idx_recommendations_client
ON profession_recommendations(client_id);
