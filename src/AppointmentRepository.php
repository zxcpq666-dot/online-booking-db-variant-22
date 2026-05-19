<?php

class AppointmentRepository
extends AbstractRepository
{
    protected string $table = 'appointments';

    public function createAppointment(
        int $clientId,
        int $psychologistId,
        int $testId,
        string $type,
        string $datetime
    ): bool {

        try {

            $this->pdo->beginTransaction();

            $stmt = $this->pdo->prepare(
                "INSERT INTO appointments
                (
                    client_id,
                    psychologist_id,
                    test_id,
                    appointment_type,
                    appointment_datetime
                )
                VALUES (?, ?, ?, ?, ?)"
            );

            $stmt->execute([
                $clientId,
                $psychologistId,
                $testId,
                $type,
                $datetime
            ]);

            $this->pdo->commit();

            return true;

        } catch (PDOException $e) {

            $this->pdo->rollBack();

            throw new RepositoryException(
                $e->getMessage()
            );
        }
    }
}
