<?php

abstract class AbstractRepository
{
    protected PDO $pdo;

    protected string $table;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    public function findAll(): array
    {
        $stmt = $this->pdo->query(
            "SELECT * FROM {$this->table}"
        );

        return $stmt->fetchAll();
    }

    public function findById(int $id): array|null
    {
        $stmt = $this->pdo->prepare(
            "SELECT * FROM {$this->table}
             WHERE id = ?"
        );

        $stmt->execute([$id]);

        return $stmt->fetch();
    }

    public function delete(int $id): bool
    {
        $stmt = $this->pdo->prepare(
            "DELETE FROM {$this->table}
             WHERE id = ?"
        );

        $stmt->execute([$id]);

        return $stmt->rowCount() > 0;
    }
}
