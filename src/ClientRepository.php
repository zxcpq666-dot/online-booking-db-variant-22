<?php

class ClientRepository
extends AbstractRepository
{
    protected string $table = 'clients';

    public function create(
        string $name,
        string $phone,
        string $email,
        string $birthDate
    ): bool {

        $stmt = $this->pdo->prepare(
            "INSERT INTO clients
            (
                full_name,
                phone,
                email,
                birth_date
            )
            VALUES (?, ?, ?, ?)"
        );

        return $stmt->execute([
            $name,
            $phone,
            $email,
            $birthDate
        ]);
    }

    public function findByPhone(
        string $phone
    ): array|null {

        $stmt = $this->pdo->prepare(
            "SELECT * FROM clients
             WHERE phone = ?"
        );

        $stmt->execute([$phone]);

        return $stmt->fetch();
    }
}
