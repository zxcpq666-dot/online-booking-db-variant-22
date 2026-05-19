<?php

require 'config.example.php';

require 'src/Database.php';
require 'src/AbstractRepository.php';
require 'src/RepositoryException.php';
require 'src/ClientRepository.php';
require 'src/AppointmentRepository.php';

try {

    $pdo = Database::getConnection();

    $clients =
        new ClientRepository($pdo);

    echo "<pre>";

    print_r($clients->findAll());

    $clients->create(
        'Новый Клиент',
        '+79990000000',
        'new@mail.ru',
        '2001-01-01'
    );

    print_r(
        $clients->findByPhone(
            '+79990000000'
        )
    );

    echo "</pre>";

} catch (Exception $e) {

    echo $e->getMessage();
}
