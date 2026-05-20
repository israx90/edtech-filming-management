
-- MySQL Dump

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `semesters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL DEFAULT 'EXT',
  `name` varchar(255) NOT NULL,
  `subject_type` varchar(50) DEFAULT 'Teórica',
  `semester_id` int(11) NOT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_subject` (`code`,`name`,`semester_id`),
  KEY `semester_id` (`semester_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `filming_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `teacher_name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject_id` int(11) NOT NULL,
  `drive_link` text,
  `script_status` varchar(30) DEFAULT 'not_uploaded',
  `status` varchar(20) DEFAULT 'in_progress',
  `last_hito_reached` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `recording_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment_id` int(11) NOT NULL,
  `session_date` date NOT NULL,
  `start_time` varchar(10) NOT NULL,
  `end_time` varchar(10) NOT NULL,
  `hito_reached` varchar(50) DEFAULT NULL,
  `notes` text,
  `staff_1_id` int(11) DEFAULT NULL,
  `staff_2_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `assignment_id` (`assignment_id`),
  KEY `staff_1_id` (`staff_1_id`),
  KEY `staff_2_id` (`staff_2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `closed_weeks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `week_start` date NOT NULL,
  `reason` varchar(255) DEFAULT 'Estudio cerrado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `week_start` (`week_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` varchar(10) NOT NULL,
  `end_time` varchar(10) NOT NULL,
  `reason` varchar(255) DEFAULT 'Reserva',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `pending_teachers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `subject_code` varchar(50) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `sede` varchar(50) NOT NULL DEFAULT 'La Paz',
  `is_external` tinyint(1) DEFAULT '0',
  `notes` text,
  `resolved` tinyint(1) DEFAULT '0',
  `added_by_user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `added_by_user_id` (`added_by_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `settings` (
  `key` varchar(100) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'academica',
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `user_sessions` (
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `activity_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `global_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `career` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_name` (`code`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `subjects` ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE;
ALTER TABLE `filming_assignments` ADD CONSTRAINT `filming_assignments_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;
ALTER TABLE `recording_sessions` ADD CONSTRAINT `recording_sessions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `filming_assignments` (`id`) ON DELETE CASCADE;
ALTER TABLE `recording_sessions` ADD CONSTRAINT `recording_sessions_ibfk_2` FOREIGN KEY (`staff_1_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
ALTER TABLE `recording_sessions` ADD CONSTRAINT `recording_sessions_ibfk_3` FOREIGN KEY (`staff_2_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
ALTER TABLE `reservations` ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `pending_teachers` ADD CONSTRAINT `pending_teachers_ibfk_1` FOREIGN KEY (`added_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
ALTER TABLE `user_sessions` ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `activity_log` ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

INSERT IGNORE INTO `semesters` (`id`, `name`, `is_active`, `created_at`) VALUES (1, '2026-1', 1, '2026-05-06 15:05:57');
INSERT IGNORE INTO `subjects` (`id`, `code`, `name`, `semester_id`, `completed`, `created_at`) VALUES (1, 'TH-611', 'Administracion del Talento Humano', 1, 0, '2026-05-06 15:09:00');
INSERT IGNORE INTO `subjects` (`id`, `code`, `name`, `semester_id`, `completed`, `created_at`) VALUES (2, 'MKT-501', 'Marketing Digital', 1, 0, '2026-05-06 15:09:00');
INSERT IGNORE INTO `subjects` (`id`, `code`, `name`, `semester_id`, `completed`, `created_at`) VALUES (3, 'FIN-320', 'Finanzas Corporativas', 1, 0, '2026-05-06 15:09:00');
INSERT IGNORE INTO `subjects` (`id`, `code`, `name`, `semester_id`, `completed`, `created_at`) VALUES (4, 'DER-410', 'Derecho Comercial', 1, 0, '2026-05-06 15:09:00');
INSERT IGNORE INTO `subjects` (`id`, `code`, `name`, `semester_id`, `completed`, `created_at`) VALUES (5, 'PSI-220', 'Psicologia OrganizacionalATH-611 Administraci', 1, 0, '2026-05-06 15:09:00');
INSERT IGNORE INTO `filming_assignments` (`id`, `teacher_name`, `phone`, `subject_id`, `drive_link`, `script_status`, `status`, `last_hito_reached`, `created_at`) VALUES (1, 'Lic. Garcia', '+591 71234567', 5, NULL, 'pending', 'in_progress', 'hito_5', '2026-05-06 15:12:16');
INSERT IGNORE INTO `filming_assignments` (`id`, `teacher_name`, `phone`, `subject_id`, `drive_link`, `script_status`, `status`, `last_hito_reached`, `created_at`) VALUES (2, 'Lic. Garcia', '+591 71234567', 4, NULL, 'pending', 'in_progress', NULL, '2026-05-06 15:15:09');
INSERT IGNORE INTO `recording_sessions` (`id`, `assignment_id`, `session_date`, `start_time`, `end_time`, `hito_reached`, `notes`, `created_at`, `staff_1_id`, `staff_2_id`) VALUES (1, 1, '2026-05-06', '08:00', '10:00', 'hito_5', NULL, '2026-05-06 15:12:16', NULL, NULL);
INSERT IGNORE INTO `recording_sessions` (`id`, `assignment_id`, `session_date`, `start_time`, `end_time`, `hito_reached`, `notes`, `created_at`, `staff_1_id`, `staff_2_id`) VALUES (3, 2, '2026-05-08', '08:00', '10:00', NULL, NULL, '2026-05-07 17:17:24', NULL, NULL);
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (1, 9, '2026-05-11', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (2, 9, '2026-05-12', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (3, 9, '2026-05-13', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (4, 9, '2026-05-14', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (5, 9, '2026-05-15', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (6, 9, '2026-05-11', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (7, 9, '2026-05-12', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (8, 9, '2026-05-13', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (9, 9, '2026-05-14', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`) VALUES (10, 9, '2026-05-15', '08:00', '10:00', 'EXED', '2026-05-07 18:22:38');
INSERT IGNORE INTO `pending_teachers` (`id`, `name`, `subject`, `phone`, `sede`, `is_external`, `notes`, `resolved`, `created_at`, `subject_code`, `added_by_user_id`) VALUES (1, 'Marketing Digital', '+591 71234567', NULL, 'La Paz', 0, NULL, 0, '2026-05-07 15:01:25', NULL, NULL);
INSERT IGNORE INTO `pending_teachers` (`id`, `name`, `subject`, `phone`, `sede`, `is_external`, `notes`, `resolved`, `created_at`, `subject_code`, `added_by_user_id`) VALUES (2, 'Lic. Rodriguez', 'Marketing Digital', '+591 71234567', 'La Paz', 0, NULL, 1, '2026-05-07 15:02:06', NULL, NULL);
INSERT IGNORE INTO `pending_teachers` (`id`, `name`, `subject`, `phone`, `sede`, `is_external`, `notes`, `resolved`, `created_at`, `subject_code`, `added_by_user_id`) VALUES (3, 'Dr. Fernandez', 'Inteligencia Artificial', '+591 76543210', 'Santa Cruz', 1, NULL, 0, '2026-05-07 15:04:20', NULL, NULL);
INSERT IGNORE INTO `pending_teachers` (`id`, `name`, `subject`, `phone`, `sede`, `is_external`, `notes`, `resolved`, `created_at`, `subject_code`, `added_by_user_id`) VALUES (4, 'Ricardo', 'Turismo', '74573450', 'Tarija', 1, NULL, 0, '2026-05-07 18:07:33', 'EHT-511', 5);
INSERT IGNORE INTO `settings` (`key`, `value`) VALUES ('studio_start_time', '08:00');
INSERT IGNORE INTO `settings` (`key`, `value`) VALUES ('studio_end_time', '18:00');
INSERT IGNORE INTO `settings` (`key`, `value`) VALUES ('studio_days', '1,2,3,4,5');
INSERT IGNORE INTO `users` (`id`, `username`, `password`, `role`, `name`, `created_at`) VALUES (1, 'admin', 'admin', 'admin', 'Administrador', '2026-05-07 17:13:29');
INSERT IGNORE INTO `users` (`id`, `username`, `password`, `role`, `name`, `created_at`) VALUES (2, 'reserva', 'reserva', 'post_productor', 'Usuario de Reserva', '2026-05-07 17:13:29');
INSERT IGNORE INTO `users` (`id`, `username`, `password`, `role`, `name`, `created_at`) VALUES (5, 'eisrael', '12345678', 'academica', 'Edson Israel', '2026-05-07 17:59:23');
INSERT IGNORE INTO `users` (`id`, `username`, `password`, `role`, `name`, `created_at`) VALUES (33, 'diego', '12345678', 'post_productor', 'Diego', '2026-05-07 18:48:12');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('ehnmjg0icyfmovniqd2', 1, '2026-05-07 15:39:02');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('vqx2fxvg03lmovsjhvl', 5, '2026-05-07 17:59:36');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('lzgrqpli33omovsjhvo', 5, '2026-05-07 17:59:36');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('hs148gxa9phmovso8by', 9, '2026-05-07 18:03:17');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('9qakhadc5lsmovso8c1', 9, '2026-05-07 18:03:17');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('5zekpmfki2umovu0wt4', 1, '2026-05-07 18:41:08');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('fmzf1jvk6jjmovu7era', 32, '2026-05-07 18:46:11');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('1jiywrp4e47movu8ndl', 1, '2026-05-07 18:47:09');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('770yelxkfs4movu8ndm', 1, '2026-05-07 18:47:09');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('kgjer2ir9wmovu9fmo', 1, '2026-05-07 18:47:46');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('3vu5qzz59efmovu9fmq', 1, '2026-05-07 18:47:46');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('n4h0vvtqu4pmovuafo1', 33, '2026-05-07 18:48:32');
INSERT IGNORE INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES ('pt99q8b2tpmovuafo2', 33, '2026-05-07 18:48:32');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (1, 1, 'Administrador', 'Creó usuario: Edson Israel Llanque (academica)', 'user', 4, NULL, '2026-05-07 17:16:11');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (2, 1, 'Administrador', 'Eliminó usuario: Edson Israel Llanque', 'user', 4, NULL, '2026-05-07 17:40:43');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (3, 1, 'Administrador', 'Creó usuario: Edson Israel (academica)', 'user', 5, NULL, '2026-05-07 17:59:23');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (4, 1, 'Administrador', 'Creó usuario: Mikaela (post_productor)', 'user', 9, NULL, '2026-05-07 18:02:56');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (5, 5, 'Edson Israel', 'Agregó docente pendiente: Ricardo', 'pending_teacher', 4, 'EHT-511 Turismo', '2026-05-07 18:07:33');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (6, 1, 'Administrador', 'Eliminó usuario: Mikaela', 'user', 9, NULL, '2026-05-07 18:42:31');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (7, 1, 'Administrador', 'Creó usuario: Mikaela (academica)', 'user', 31, NULL, '2026-05-07 18:42:48');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (8, 1, 'Administrador', 'Eliminó usuario: Mikaela', 'user', 31, NULL, '2026-05-07 18:43:44');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (9, 1, 'Administrador', 'Creó usuario: Mikaela (academica)', 'user', 32, NULL, '2026-05-07 18:45:10');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (10, 1, 'Administrador', 'Editó usuario #32', 'user', 32, NULL, '2026-05-07 18:45:39');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (11, 1, 'Administrador', 'Eliminó usuario: Mikaela', 'user', 32, NULL, '2026-05-07 18:47:48');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (12, 1, 'Administrador', 'Creó usuario: Diego (academica)', 'user', 33, NULL, '2026-05-07 18:48:12');
INSERT IGNORE INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES (13, 1, 'Administrador', 'Editó usuario #33', 'user', 33, NULL, '2026-05-07 18:48:41');
COMMIT;