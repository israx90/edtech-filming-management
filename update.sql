-- ============================================================
-- MIGRATION: Nuevas funcionalidades v2.0
-- Fecha: 2026-05-13
-- Funcionalidades:
--   1. Tabla teacher_comments (hilo de comentarios por docente)
--   2. script_status ampliado a VARCHAR(50) para nuevos estados
-- ============================================================

-- 1. Ampliar columna script_status (soporta 'guion_pendiente', 'guion_revisado')
ALTER TABLE `filming_assignments`
    MODIFY COLUMN `script_status` VARCHAR(50) DEFAULT 'not_uploaded';

-- 2. Crear tabla de comentarios/hilo por docente pendiente
CREATE TABLE IF NOT EXISTS `teacher_comments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `pending_teacher_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `parent_id` INT DEFAULT NULL COMMENT 'NULL = comentario raíz, INT = respuesta',
    `message` TEXT NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`pending_teacher_id`) REFERENCES `pending_teachers`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`parent_id`) REFERENCES `teacher_comments`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Añadir sede y pasaje de vuelo a filming_assignments
ALTER TABLE `filming_assignments`
    ADD COLUMN `sede` VARCHAR(100) DEFAULT 'La Paz',
    ADD COLUMN `flight_ticket_path` VARCHAR(255) NULL;

-- 4. Añadir pasaje de vuelo a pending_teachers
ALTER TABLE `pending_teachers`
    ADD COLUMN `flight_ticket_path` VARCHAR(255) NULL;
