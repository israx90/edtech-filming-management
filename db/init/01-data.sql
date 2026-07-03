-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql301.infinityfree.com
-- Generation Time: Jul 03, 2026 at 03:50 PM
-- Server version: 11.4.12-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_41857535_edtech`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES
(1, 2, 'Israx', 'Eliminó usuario: Administrador', 'user', 1, NULL, '2026-05-07 13:53:45'),
(2, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (89 materias)', 'subject', NULL, NULL, '2026-05-07 14:00:28'),
(3, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:00:28'),
(4, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (92 materias)', 'subject', NULL, NULL, '2026-05-07 14:01:23'),
(5, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (92 materias)', 'subject', NULL, NULL, '2026-05-07 14:01:23'),
(6, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (92 materias)', 'subject', NULL, NULL, '2026-05-07 14:11:16'),
(7, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:11:16'),
(8, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (92 materias)', 'subject', NULL, NULL, '2026-05-07 14:19:45'),
(9, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:19:45'),
(10, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (81 materias)', 'subject', NULL, NULL, '2026-05-07 14:21:27'),
(11, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:21:27'),
(12, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (85 materias)', 'subject', NULL, NULL, '2026-05-07 14:26:00'),
(13, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:26:00'),
(14, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (84 materias)', 'subject', NULL, NULL, '2026-05-07 14:32:00'),
(15, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:32:00'),
(16, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:35:30'),
(17, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:35:30'),
(18, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (79 materias)', 'subject', NULL, NULL, '2026-05-07 14:35:30'),
(19, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 14:35:30'),
(20, 2, 'Israx', 'Creó usuario: Diego (post_productor)', 'user', 3, NULL, '2026-05-07 14:37:21'),
(21, 2, 'Israx', 'Creó usuario: Tito (academica)', 'user', 4, NULL, '2026-05-07 14:38:17'),
(22, 4, 'Tito', 'Agregó docente pendiente: Jorge Rodriguez', 'pending_teacher', 1, 'ACI-611 Análisis y Contabilidad Internacional (M2) (CPU)', '2026-05-07 14:52:19'),
(23, 3, 'Diego', 'Marcó docente como resuelto', 'pending_teacher', 1, NULL, '2026-05-07 14:53:44'),
(24, 3, 'Diego', 'Marcó docente como resuelto', 'pending_teacher', 1, NULL, '2026-05-07 14:53:44'),
(25, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (45 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:31'),
(26, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:31'),
(27, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:41'),
(28, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:41'),
(29, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (86 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:48'),
(30, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:13:48'),
(31, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:14:01'),
(32, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:14:01'),
(33, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (80 materias)', 'subject', NULL, NULL, '2026-05-07 15:14:51'),
(34, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:14:51'),
(35, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:20:58'),
(36, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:20:58'),
(37, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (89 materias)', 'subject', NULL, NULL, '2026-05-07 15:21:25'),
(38, 2, 'Israx', 'Eliminó todas las materias del semestre #1 (0 materias)', 'subject', NULL, NULL, '2026-05-07 15:21:25'),
(39, 2, 'Israx', 'Creó usuario: NINOSKA TORREZ (academica)', 'user', 5, NULL, '2026-05-11 06:39:44'),
(40, 5, 'NINOSKA TORREZ', 'Agregó docente pendiente: Lic. Jorge Peñaranda', 'pending_teacher', 2, 'NIN-611 Negocios Internacionales (M1) (ICO)', '2026-05-11 06:45:20'),
(41, 2, 'Israx', 'Marcó docente como resuelto', 'pending_teacher', 2, NULL, '2026-05-11 06:45:43'),
(42, 5, 'NINOSKA TORREZ', 'Editó docente pendiente', 'pending_teacher', 2, 'Lic. Jorge Peñaranda', '2026-05-11 06:46:01'),
(43, 2, 'Israx', 'Eliminó docente pendiente: Jorge Rodriguez', 'pending_teacher', 1, NULL, '2026-05-11 07:43:06'),
(44, 2, 'Israx', 'Creó usuario: Jose Sarzuri (academica)', 'user', 7, NULL, '2026-05-11 13:20:01'),
(45, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 2, NULL, '2026-05-11 13:29:58'),
(46, 2, 'Israx', 'Eliminó usuario: Tito', 'user', 4, NULL, '2026-05-11 14:45:51'),
(47, 2, 'Israx', 'Eliminó usuario: Jose Sarzuri', 'user', 7, NULL, '2026-05-11 14:45:57'),
(48, 2, 'Israx', 'Creó usuario: Gloria Ardaya (academica)', 'user', 8, NULL, '2026-05-11 14:46:46'),
(49, 2, 'Israx', 'Creó usuario: Viviana Valda (academica)', 'user', 9, NULL, '2026-05-11 14:48:12'),
(50, 2, 'Israx', 'Creó usuario: Zalaco (admin)', 'user', 10, NULL, '2026-05-11 14:53:27'),
(51, 2, 'Israx', 'Eliminó usuario: Zalaco', 'user', 10, NULL, '2026-05-11 14:53:51'),
(52, 2, 'Israx', 'Creó usuario: Zalaco (post_productor)', 'user', 11, NULL, '2026-05-11 14:54:32'),
(53, 2, 'Israx', 'Eliminó usuario: Diego', 'user', 3, NULL, '2026-05-11 14:55:28'),
(54, 2, 'Israx', 'Creó usuario: Angela Ramirez (academica)', 'user', 12, NULL, '2026-05-11 15:40:51'),
(55, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 2, NULL, '2026-05-11 16:13:51'),
(56, 2, 'Israx', 'Creó usuario: Jose Sarzuri (academica)', 'user', 13, NULL, '2026-05-12 08:24:51'),
(57, 13, 'Jose Sarzuri', 'Agregó docente pendiente: Julio René De Bonadona Velásquez', 'pending_teacher', 3, 'NTP-611 Nuevas Tendencias de la Publicidad', '2026-05-12 08:50:13'),
(58, 13, 'Jose Sarzuri', 'Agregó docente pendiente: Carlos Reynaldo Peña Peducassé', 'pending_teacher', 4, 'CIN-611 Comercio Internacional (ICO-ADM)', '2026-05-12 15:10:09'),
(59, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-12 15:10:21'),
(60, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-12 15:10:55'),
(61, 2, 'Israx', 'Eliminó usuario: NINOSKA TORREZ', 'user', 5, NULL, '2026-05-12 19:22:39'),
(62, 2, 'Israx', 'Creó usuario: Ninoska Torrez (academica)', 'user', 14, NULL, '2026-05-12 19:23:04'),
(63, 14, 'Ninoska Torrez', 'Agregó docente pendiente: Franz Apaza', 'pending_teacher', 5, 'TPM-411 Teoría y Política Monetaria (CPU)', '2026-05-13 07:00:59'),
(64, 14, 'Ninoska Torrez', 'Editó docente pendiente', 'pending_teacher', 5, 'Franz Apaza', '2026-05-13 07:01:47'),
(65, 14, 'Ninoska Torrez', 'Agregó docente pendiente: Jorge Peñaranda', 'pending_teacher', 6, 'NIN-611 Negocios Internacionales (M1) (ICO)', '2026-05-13 07:02:39'),
(66, 14, 'Ninoska Torrez', 'Editó docente pendiente', 'pending_teacher', 6, 'Jorge Peñaranda', '2026-05-13 07:03:53'),
(67, 14, 'Ninoska Torrez', 'Editó docente pendiente', 'pending_teacher', 5, 'Franz Apaza', '2026-05-13 07:09:48'),
(68, 14, 'Ninoska Torrez', 'Editó docente pendiente', 'pending_teacher', 6, 'Jorge Peñaranda', '2026-05-13 07:10:10'),
(69, 8, 'Gloria Ardaya', 'Agregó docente pendiente: Rolando Martín Cartagena Rocha', 'pending_teacher', 7, 'MDI-611 Marketing Digital (M2) (PUB)', '2026-05-13 12:25:20'),
(70, 8, 'Gloria Ardaya', 'Agregó docente pendiente: Félix Roberto Robles Flores', 'pending_teacher', 8, 'GTH-612 Gestión de Talento Humano II (ADM)', '2026-05-13 13:55:53'),
(71, 2, 'Israx', 'Eliminó docente pendiente: Lic. Jorge Peñaranda', 'pending_teacher', 2, NULL, '2026-05-13 14:17:19'),
(72, 2, 'Israx', 'Creó usuario: Mika Villanueva (admin)', 'user', 15, NULL, '2026-05-13 14:20:03'),
(73, 2, 'Israx', 'Creó usuario: Nayra Antezana (post_productor)', 'user', 16, NULL, '2026-05-13 14:50:48'),
(74, 2, 'Israx', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 8, NULL, '2026-05-13 16:15:46'),
(75, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 8, NULL, '2026-05-13 16:15:55'),
(76, 2, 'Israx', 'Cambió estado docente a: guion_incompleto', 'pending_teacher', 8, NULL, '2026-05-13 16:59:24'),
(77, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 8, NULL, '2026-05-13 16:59:28'),
(78, 12, 'Angela Ramirez', 'Agregó docente pendiente: Ruben Milton Ramirez Alvarado', 'pending_teacher', 9, 'SIG-611 Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO)', '2026-05-14 05:41:01'),
(79, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-14 07:37:33'),
(80, 12, 'Angela Ramirez', 'Editó docente pendiente', 'pending_teacher', 9, 'Ruben Milton Ramirez Alvarado', '2026-05-14 07:37:41'),
(81, 12, 'Angela Ramirez', 'Agregó docente pendiente: Luis Fernando Atanacio Fuentes', 'pending_teacher', 10, 'PII-612 Proyecto Integrador Intermedio II (DER)', '2026-05-14 07:40:59'),
(82, 2, 'Israx', 'Editó reserva del 2026-05-22', 'reservation', 9, 'Cuadro de Honor LA PAZ', '2026-05-14 08:23:36'),
(83, 2, 'Israx', 'Editó reserva del 2026-05-23', 'reservation', 8, 'Cuadro de Honor LP', '2026-05-14 08:23:57'),
(84, 2, 'Israx', 'Agregó docente pendiente: Ronald Alexander Vargas Gutierrez', 'pending_teacher', 11, 'DCI-615 Derecho Civil V (sucesiones) (DER)', '2026-05-14 08:46:56'),
(85, 2, 'Israx', 'Editó docente pendiente', 'pending_teacher', 11, 'Ronald Alexander Vargas Gutierrez', '2026-05-14 08:51:34'),
(86, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 5, 'Franz Apaza', '2026-05-14 08:54:04'),
(87, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 5, NULL, '2026-05-14 08:54:16'),
(88, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 6, 'Jorge Peñaranda', '2026-05-14 08:54:52'),
(89, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 6, NULL, '2026-05-14 08:55:00'),
(90, 2, 'Israx', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 11, NULL, '2026-05-14 08:55:10'),
(91, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 9, 'Ruben Milton Ramirez Alvarado', '2026-05-14 08:56:14'),
(92, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 9, NULL, '2026-05-14 08:56:31'),
(93, 2, 'Israx', 'Creó usuario: Felipe Vizcarra (post_productor)', 'user', 17, NULL, '2026-05-14 09:05:34'),
(94, 2, 'Israx', 'Creó usuario: Diego Alvarado (post_productor)', 'user', 18, NULL, '2026-05-14 09:06:41'),
(95, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-14 09:12:13'),
(96, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 4, NULL, '2026-05-14 09:12:20'),
(97, 2, 'Israx', 'Editó docente pendiente', 'pending_teacher', 11, 'Ronald Alexander Vargas Gutierrez', '2026-05-14 09:22:36'),
(98, 2, 'Israx', 'Creó usuario: Moises Luna (post_productor)', 'user', 19, NULL, '2026-05-14 09:36:32'),
(99, 2, 'Israx', 'Creó usuario: Alan Mendoza (admin)', 'user', 20, NULL, '2026-05-14 09:36:58'),
(100, 2, 'Israx', 'Creó usuario: Rubi Monroy (post_productor)', 'user', 21, NULL, '2026-05-14 13:21:39'),
(101, 12, 'Angela Ramirez', 'Agregó docente pendiente: Cesar Acarapi Apaza', 'pending_teacher', 12, 'PFO-711 Psicología Forense', '2026-05-18 07:03:20'),
(102, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 7, 'Rolando Martín Cartagena Rocha', '2026-05-18 10:13:27'),
(103, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 7, NULL, '2026-05-18 10:13:33'),
(104, 2, 'Israx', 'Creó filmación: DCI-615 (Ronald Alexander Vargas Gutierrez)', 'assignment', 3, 'Fecha: 2026-05-23', '2026-05-18 10:51:30'),
(105, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-18 10:51:31'),
(106, 2, 'Israx', 'Editó reserva del 2026-05-23', 'reservation', 8, 'Cuadro de Honor LP', '2026-05-18 13:31:31'),
(107, 8, 'Gloria Ardaya', 'Agregó docente pendiente: Karen Celeste Gutierrez Coronado', 'pending_teacher', 13, 'MIN-711 Marketing Internacional (M1) (ICO)', '2026-05-18 13:31:45'),
(108, 2, 'Israx', 'Editó reserva del 2026-05-23', 'reservation', 8, 'Cuadro de Honor LP', '2026-05-18 13:31:48'),
(109, 2, 'Israx', 'Eliminó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez) del 2026-05-23', 'session', 3, NULL, '2026-05-18 13:32:01'),
(110, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 11, NULL, '2026-05-18 13:32:32'),
(111, 2, 'Israx', 'Creó filmación: DCI-615 (Ronald Alexander Vargas Gutierrez)', 'assignment', 4, 'Fecha: 2026-05-18', '2026-05-18 13:33:05'),
(112, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-18 13:33:05'),
(113, 2, 'Israx', 'Eliminó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez) del 2026-05-18', 'session', 4, NULL, '2026-05-18 13:33:10'),
(114, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 11, NULL, '2026-05-18 13:33:15'),
(115, 2, 'Israx', 'Creó filmación: DCI-615 (Ronald Alexander Vargas Gutierrez)', 'assignment', 5, 'Fecha: 2026-05-23', '2026-05-18 13:34:13'),
(116, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-18 13:34:13'),
(117, 2, 'Israx', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-18 14:04:00'),
(118, 12, 'Angela Ramirez', 'Agregó docente pendiente: Erika Rada', 'pending_teacher', 14, 'DTT-611 Derecho de Transporte y Telecomunicaciones (DER)', '2026-05-18 14:42:31'),
(119, 2, 'Israx', 'Creó filmación: NIN-611 (Jorge Peñaranda)', 'assignment', 6, 'Fecha: 2026-05-28', '2026-05-18 15:20:32'),
(120, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 6, NULL, '2026-05-18 15:20:32'),
(121, 2, 'Israx', 'Comentó sobre docente: Jorge Peñaranda', 'pending_teacher', 6, '29 a mas tardar medio dia, y no hay problema si toma el primer vuelo del dia 28', '2026-05-18 15:22:07'),
(122, 2, 'Israx', 'Comentó sobre docente: Jorge Peñaranda', 'pending_teacher', 6, 'Esta programado para el 28 y 29, la fecha 28 no se hace problema si es el primer vuelo de la mañana y el 29 seria hasta mas tardar medio dia su vuelo de retorno', '2026-05-18 15:24:21'),
(123, 2, 'Israx', 'Creó filmación: TPM-411 (Franz Apaza)', 'assignment', 7, 'Fecha: 2026-05-22', '2026-05-18 15:32:07'),
(124, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 5, NULL, '2026-05-18 15:32:07'),
(125, 2, 'Israx', 'Comentó sobre docente: Franz Apaza', 'pending_teacher', 5, 'Docente Agendado para el viernes 22 por la tarde y viernes 29 por la tarde', '2026-05-18 15:34:52'),
(126, 2, 'Israx', 'Creó filmación: CIN-611 (Carlos Reynaldo Peña Peducassé)', 'assignment', 8, 'Fecha: 2026-06-01', '2026-05-18 15:48:37'),
(127, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 4, NULL, '2026-05-18 15:48:37'),
(128, 2, 'Israx', 'Comentó sobre docente: Carlos Reynaldo Peña Peducassé', 'pending_teacher', 4, 'Se contacto y se realizo la reseva para el 1 y 2 de junio, dia y medio, proceder a la compra de pasajes', '2026-05-18 15:50:33'),
(129, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 8, 'Félix Roberto Robles Flores', '2026-05-19 08:21:25'),
(130, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 8, NULL, '2026-05-19 08:21:33'),
(131, 12, 'Angela Ramirez', 'Agregó docente pendiente: Froilán Villavicencio; Yana', 'pending_teacher', 15, 'DAT-611 Derecho Aduanero y Tributario (DER)', '2026-05-19 09:42:02'),
(132, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 10, 'Luis Fernando Atanacio Fuentes', '2026-05-19 12:23:51'),
(133, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 10, NULL, '2026-05-19 12:24:00'),
(134, 13, 'Jose Sarzuri', 'Agregó docente pendiente: Patricia del Rosario Arrieta Melgarejo', 'pending_teacher', 16, 'CCO-612 Comportamiento del Consumidor II (M2) (PUB)', '2026-05-19 13:34:54'),
(135, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 16, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-19 13:36:19'),
(136, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 16, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-20 09:02:07'),
(137, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 16, NULL, '2026-05-20 09:02:15'),
(138, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 5, NULL, '2026-05-20 09:03:47'),
(139, 16, 'Nayra Antezana', 'Cambió estado docente a: scheduled', 'pending_teacher', 5, NULL, '2026-05-20 09:04:04'),
(140, 2, 'Israx', 'Creó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez) el 2026-05-29', 'session', 9, NULL, '2026-05-20 09:59:49'),
(141, 2, 'Israx', 'Eliminó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez) del 2026-05-29', 'session', 9, NULL, '2026-05-20 10:00:11'),
(142, 2, 'Israx', 'Creó sesión: TPM-411 (Franz Apaza) el 2026-05-29', 'session', 10, NULL, '2026-05-20 10:00:27'),
(143, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 9, NULL, '2026-05-20 12:53:47'),
(144, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 3, 'Julio René De Bonadona Velásquez', '2026-05-20 13:00:39'),
(145, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 3, NULL, '2026-05-20 13:00:46'),
(146, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 10, NULL, '2026-05-20 13:03:19'),
(147, 2, 'Israx', 'Comentó sobre docente: Luis Fernando Atanacio Fuentes', 'pending_teacher', 10, 'Puede todos los dias a partir de las 5 o mañana todo el día', '2026-05-20 13:03:53'),
(148, 2, 'Israx', 'Comentó sobre docente: Luis Fernando Atanacio Fuentes', 'pending_teacher', 10, 'Puede todos los dias a partir de las 5 o el 21 toda la mañana', '2026-05-20 13:04:41'),
(149, 2, 'Israx', 'Editó docente pendiente', 'pending_teacher', 3, 'Julio René De Bonadona Velásquez', '2026-05-20 13:10:02'),
(150, 2, 'Israx', 'Eliminó reserva del 2026-05-22', 'reservation', 9, 'Cuadro de Honor LA PAZ', '2026-05-20 13:13:21'),
(151, 2, 'Israx', 'Eliminó reserva del 2026-05-23', 'reservation', 8, 'Cuadro de Honor LP', '2026-05-20 13:13:25'),
(152, 2, 'Israx', 'Comentó sobre docente: Ruben Milton Ramirez Alvarado', 'pending_teacher', 9, 'Dentro del 30 Mayo al 13 de Junio dispone de tiempo', '2026-05-20 13:22:31'),
(153, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 16, NULL, '2026-05-20 13:28:37'),
(154, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 3, NULL, '2026-05-20 13:29:16'),
(155, 2, 'Israx', 'Eliminó reserva del 2026-05-30', 'reservation', 4, 'Cobertura Cuadro de Honor EA', '2026-05-20 13:29:55'),
(156, 2, 'Israx', 'Creó filmación: CCO-612 (Patricia del Rosario Arrieta Melgarejo)', 'assignment', 9, 'Fecha: 2026-05-26', '2026-05-20 14:34:25'),
(157, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 16, NULL, '2026-05-20 14:34:25'),
(158, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 16, NULL, '2026-05-20 14:34:40'),
(159, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 9, 'CCO-612 (Patricia del Rosario Arrieta Melgarejo)', '2026-05-20 14:38:20'),
(160, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 14:44:04'),
(161, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-20 14:44:20'),
(162, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-20 14:45:02'),
(163, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 14:45:16'),
(164, 2, 'Israx', 'Creó usuario: Micaela Cornejo (post_productor)', 'user', 22, NULL, '2026-05-20 14:46:06'),
(165, 2, 'Israx', 'Editó usuario #15', 'user', 15, NULL, '2026-05-20 14:46:20'),
(166, 2, 'Israx', 'Eliminó usuario: Administrador', 'user', 6, NULL, '2026-05-20 14:46:48'),
(167, 2, 'Israx', 'Creó usuario: Ricardo Aguayo (post_productor)', 'user', 23, NULL, '2026-05-20 14:47:44'),
(168, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 14:49:30'),
(169, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 7, NULL, '2026-05-20 16:22:25'),
(170, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:24:08'),
(171, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:35:18'),
(172, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:35:44'),
(173, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:58:38'),
(174, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:58:53'),
(175, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 16:59:59'),
(176, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:01:41'),
(177, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:05:03'),
(178, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:05:26'),
(179, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 9, 'CCO-612 (Patricia del Rosario Arrieta Melgarejo)', '2026-05-20 17:08:25'),
(180, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 5, 'DCI-615 (Ronald Alexander Vargas Gutierrez)', '2026-05-20 17:10:05'),
(181, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:11:54'),
(182, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:11:56'),
(183, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:12:21'),
(184, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:12:57'),
(185, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:20'),
(186, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:21'),
(187, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:22'),
(188, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:34'),
(189, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:34'),
(190, 23, 'Ricardo Aguayo', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:13:36'),
(191, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:15:59'),
(192, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:19:45'),
(193, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:20:47'),
(194, 2, 'Israx', 'Editó filmación: CIN-611', 'assignment', 8, 'Carlos Reynaldo Peña Peducassé', '2026-05-20 17:21:16'),
(195, 2, 'Israx', 'Creó sesión: CIN-611 (Carlos Reynaldo Peña Peducassé) el 2026-05-21', 'session', 12, NULL, '2026-05-20 17:21:43'),
(196, 2, 'Israx', 'Editó filmación: CIN-611', 'assignment', 8, 'Carlos Reynaldo Peña Peducassé', '2026-05-20 17:22:05'),
(197, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:24:37'),
(198, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:25:20'),
(199, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:27:39'),
(200, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 6, 'NIN-611 (Jorge Peñaranda)', '2026-05-20 17:28:33'),
(201, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:29:38'),
(202, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 6, 'NIN-611 (Jorge Peñaranda)', '2026-05-20 17:29:48'),
(203, 17, 'Felipe Vizcarra', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:30:35'),
(204, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:39:16'),
(205, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:45:07'),
(206, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:45:59'),
(207, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:48:36'),
(208, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:51:15'),
(209, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:51:34'),
(210, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:52:12'),
(211, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 17:52:23'),
(212, 2, 'Israx', 'Creó sesión: NIN-611 (Jorge Peñaranda) el 2026-05-29', 'session', 13, NULL, '2026-05-20 17:52:40'),
(213, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 17:56:04'),
(214, 23, 'Ricardo Aguayo', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:03:51'),
(215, 23, 'Ricardo Aguayo', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:09:52'),
(216, 23, 'Ricardo Aguayo', 'Editó docente pendiente', 'pending_teacher', 15, 'Froilán Villavicencio Yana', '2026-05-20 18:12:08'),
(217, 2, 'Israx', 'Editó reserva del 2026-05-29', 'reservation', 5, 'Cobertura Cuadro de Honor EA', '2026-05-20 18:20:11'),
(218, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:25:13'),
(219, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 18:25:18'),
(220, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:25:23'),
(221, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:31:18'),
(222, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:36:13'),
(223, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:37:22'),
(224, 2, 'Israx', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-20 18:37:33'),
(225, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-20 18:41:17'),
(226, 23, 'Ricardo Aguayo', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:46:26'),
(227, 23, 'Ricardo Aguayo', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-20 18:47:40'),
(228, 23, 'Ricardo Aguayo', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-20 18:52:26'),
(229, 2, 'Israx', 'Creó usuario: Abraham Kondori (admin)', 'user', 24, NULL, '2026-05-20 18:59:02'),
(230, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 08:12:05'),
(231, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 08:12:17'),
(232, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-21 08:27:29'),
(233, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 8, NULL, '2026-05-21 08:48:53'),
(234, 2, 'Israx', 'Creó filmación: NTM-611 (Julio René De Bonadona Velásquez)', 'assignment', 10, 'Fecha: 2026-05-27', '2026-05-21 08:53:35'),
(235, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 3, NULL, '2026-05-21 08:53:35'),
(236, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 10, 'NTM-611 (Julio René De Bonadona Velásquez)', '2026-05-21 08:54:55'),
(237, 2, 'Israx', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-21 08:59:06'),
(238, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 7, 'TPM-411 (Franz Apaza)', '2026-05-21 09:10:11'),
(239, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 09:16:00'),
(240, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 7, 'TPM-411 (Franz Apaza)', '2026-05-21 09:16:12'),
(241, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 09:25:05'),
(242, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 09:28:37'),
(243, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 10:06:45'),
(244, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 7, 'TPM-411 (Franz Apaza)', '2026-05-21 10:06:59'),
(245, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 7, 'TPM-411 (Franz Apaza)', '2026-05-21 10:17:52'),
(246, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 12, 'Cesar Acarapi Apaza', '2026-05-21 12:12:23'),
(247, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 12, NULL, '2026-05-21 12:12:29'),
(248, 17, 'Felipe Vizcarra', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-21 15:11:05'),
(249, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 12, NULL, '2026-05-22 07:03:35'),
(250, 2, 'Israx', 'Comentó sobre docente: Cesar Acarapi Apaza', 'pending_teacher', 12, 'llamar a las 2 de la tarde', '2026-05-22 07:04:06'),
(251, 18, 'Diego Alvarado', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 07:44:30'),
(252, 18, 'Diego Alvarado', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 07:45:11'),
(253, 18, 'Diego Alvarado', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 07:47:53'),
(254, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 14, 'Erika Rada', '2026-05-22 07:51:34'),
(255, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 14, NULL, '2026-05-22 07:51:40'),
(256, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 4, 'Carlos Reynaldo Peña Peducassé', '2026-05-22 07:58:28'),
(257, 13, 'Jose Sarzuri', 'Editó docente pendiente', 'pending_teacher', 16, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 07:59:05'),
(258, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 08:03:05'),
(259, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 08:03:27'),
(260, 18, 'Diego Alvarado', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 08:04:00'),
(261, 18, 'Diego Alvarado', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 08:04:14'),
(262, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 09:05:03'),
(263, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 09:05:13'),
(264, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 09:05:24'),
(265, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 09:05:39'),
(266, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 09:06:06'),
(267, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 09:07:07'),
(268, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 11:04:32'),
(269, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 11:05:54'),
(270, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 15, 'Froilán Villavicencio Yana', '2026-05-22 11:07:40'),
(271, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 15, NULL, '2026-05-22 11:07:45'),
(272, 17, 'Felipe Vizcarra', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 11:13:50'),
(273, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 13, 'Karen Celeste Gutierrez Coronado', '2026-05-22 12:03:44'),
(274, 16, 'Nayra Antezana', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 13, NULL, '2026-05-22 12:03:47'),
(275, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 12:15:36'),
(276, 2, 'Israx', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 12:15:43'),
(277, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 12:18:01'),
(278, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 12:18:29'),
(279, 2, 'Israx', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 12:18:34'),
(280, 2, 'Israx', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 12:18:37'),
(281, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 12:37:15'),
(282, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 12:37:18'),
(283, 2, 'Israx', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 12:37:20'),
(284, 2, 'Israx', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 12:37:24'),
(285, 2, 'Israx', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 12:38:59'),
(286, 2, 'Israx', 'Creó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez) el 2026-05-24', 'session', 15, NULL, '2026-05-22 12:39:11'),
(287, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 12:45:07'),
(288, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 13, NULL, '2026-05-22 12:57:04'),
(289, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:03:27'),
(290, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:03:52'),
(291, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:04:01'),
(292, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:04:05'),
(293, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:04:22'),
(294, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:04:33'),
(295, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:04:37'),
(296, 2, 'Israx', 'Creó filmación: DTT-611 (Erika Rada)', 'assignment', 11, 'Fecha: 2026-06-08', '2026-05-22 13:06:26'),
(297, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 14, NULL, '2026-05-22 13:06:27'),
(298, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 11, 'DTT-611 (Erika Rada)', '2026-05-22 13:07:29'),
(299, 2, 'Israx', 'Editó filmación: DTT-611', 'assignment', 11, 'Erika Rada', '2026-05-22 13:08:30'),
(300, 2, 'Israx', 'Creó filmación: SIG-611 (Ruben Milton Ramirez Alvarado)', 'assignment', 12, 'Fecha: 2026-06-09', '2026-05-22 13:08:58'),
(301, 2, 'Israx', 'Creó sesión: SIG-611 (Ruben Milton Ramirez Alvarado) el 2026-06-10', 'session', 18, NULL, '2026-05-22 13:08:58'),
(302, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 9, NULL, '2026-05-22 13:08:58'),
(303, 2, 'Israx', 'Editó filmación: SIG-611', 'assignment', 12, 'Ruben Milton Ramirez Alvarado', '2026-05-22 13:09:25'),
(304, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 11, 'DTT-611 (Erika Rada)', '2026-05-22 13:10:20'),
(305, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 12, 'SIG-611 (Ruben Milton Ramirez Alvarado)', '2026-05-22 13:10:57'),
(306, 2, 'Israx', 'Editó filmación: DTT-611', 'assignment', 11, 'Erika Rada', '2026-05-22 13:11:06'),
(307, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 12, 'SIG-611 (Ruben Milton Ramirez Alvarado)', '2026-05-22 13:11:13'),
(308, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:14:35'),
(309, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:14:46'),
(310, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:14:46'),
(311, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:15:06'),
(312, 19, 'Moises Luna', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 13:17:05'),
(313, 19, 'Moises Luna', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 13:17:17'),
(314, 19, 'Moises Luna', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:17:32'),
(315, 2, 'Israx', 'Editó filmación: SIG-611', 'assignment', 12, 'Ruben Milton Ramirez Alvarado', '2026-05-22 13:19:48'),
(316, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 13:24:00'),
(317, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 13:24:04'),
(318, 15, 'Mika Villanueva', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 13:24:15'),
(319, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:24:20'),
(320, 2, 'Israx', 'Creó filmación: PFO-711 (Cesar Acarapi Apaza)', 'assignment', 13, 'Fecha: 2026-06-19', '2026-05-22 13:24:20'),
(321, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 12, NULL, '2026-05-22 13:24:20'),
(322, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 13, 'PFO-711 (Cesar Acarapi Apaza)', '2026-05-22 13:24:40'),
(323, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:25:18'),
(324, 2, 'Israx', 'Editó filmación: PFO-711', 'assignment', 13, 'Cesar Acarapi Apaza', '2026-05-22 13:25:21'),
(325, 22, 'Micaela Cornejo', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:26:36'),
(326, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:28:05'),
(327, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:28:10'),
(328, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:28:14'),
(329, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:30:58'),
(330, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:31:04'),
(331, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:31:37'),
(332, 2, 'Israx', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:34:20'),
(333, 2, 'Israx', 'Creó filmación: MIN-711 (Karen Celeste Gutierrez Coronado)', 'assignment', 14, 'Fecha: 2026-06-22', '2026-05-22 13:37:10'),
(334, 2, 'Israx', 'Creó sesión: MIN-711 (Karen Celeste Gutierrez Coronado) el 2026-06-23', 'session', 21, NULL, '2026-05-22 13:37:11'),
(335, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 13, NULL, '2026-05-22 13:37:11'),
(336, 2, 'Israx', 'Cambió estado de filmación a: in_progress', 'assignment', 14, 'MIN-711 (Karen Celeste Gutierrez Coronado)', '2026-05-22 13:37:32'),
(337, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:41:26'),
(338, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:41:30'),
(339, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:41:47'),
(340, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:42:13'),
(341, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:42:23'),
(342, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:42:35'),
(343, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:43:13'),
(344, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:43:47'),
(345, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:43:50'),
(346, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:46:19'),
(347, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:46:47'),
(348, 15, 'Mika Villanueva', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 13:46:53'),
(349, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:46:57'),
(350, 15, 'Mika Villanueva', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 13:47:11'),
(351, 2, 'Israx', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:51:06'),
(352, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:51:10'),
(353, 19, 'Moises Luna', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 13:51:11'),
(354, 15, 'Mika Villanueva', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 13:51:50'),
(355, 17, 'Felipe Vizcarra', 'Editó filmación: DCI-615', 'assignment', 5, 'Ronald Alexander Vargas Gutierrez', '2026-05-22 14:10:53'),
(356, 17, 'Felipe Vizcarra', 'Editó filmación: CCO-612', 'assignment', 9, 'Patricia del Rosario Arrieta Melgarejo', '2026-05-22 14:11:00'),
(357, 17, 'Felipe Vizcarra', 'Editó filmación: NTM-611', 'assignment', 10, 'Julio René De Bonadona Velásquez', '2026-05-22 14:11:06'),
(358, 17, 'Felipe Vizcarra', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 14:11:09'),
(359, 17, 'Felipe Vizcarra', 'Editó filmación: NIN-611', 'assignment', 6, 'Jorge Peñaranda', '2026-05-22 14:11:18'),
(360, 15, 'Mika Villanueva', 'Editó filmación: TPM-411', 'assignment', 7, 'Franz Apaza', '2026-05-22 14:33:30'),
(361, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 15, NULL, '2026-05-22 14:55:39'),
(362, 2, 'Israx', 'Creó filmación: MDI-611 (Rolando Martín Cartagena Rocha)', 'assignment', 15, 'Fecha: 2026-06-03', '2026-05-22 15:08:35'),
(363, 2, 'Israx', 'Creó sesión: MDI-611 (Rolando Martín Cartagena Rocha) el 2026-06-12', 'session', 23, NULL, '2026-05-22 15:08:35'),
(364, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 7, NULL, '2026-05-22 15:08:35'),
(365, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 15, 'MDI-611 — Rolando Martín Cartagena Rocha', '2026-05-22 15:08:46'),
(366, 2, 'Israx', 'Editó sesión: DCI-615 (Ronald Alexander Vargas Gutierrez)', 'session', 5, '2026-05-23 15:30 - 20:00', '2026-05-22 15:34:07'),
(367, 2, 'Israx', 'Creó filmación: PII-612 (Luis Fernando Atanacio Fuentes)', 'assignment', 16, 'Fecha: 2026-06-11', '2026-05-22 15:41:24'),
(368, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 10, NULL, '2026-05-22 15:41:24'),
(369, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 16, 'PII-612 — Luis Fernando Atanacio Fuentes', '2026-05-22 15:41:39'),
(370, 8, 'Gloria Ardaya', 'Agregó docente pendiente: Wendy Echalar', 'pending_teacher', 17, 'PEP-511 Preparación y Evaluación de Proyectos (CPU-ADM-ICO)', '2026-05-25 12:00:17'),
(371, 2, 'Israx', 'Eliminó sesión: MIN-711 (Karen Celeste Gutierrez Coronado) del 2026-06-22', 'session', 20, NULL, '2026-05-25 13:17:44'),
(372, 2, 'Israx', 'Eliminó sesión: MIN-711 (Karen Celeste Gutierrez Coronado) del 2026-06-23', 'session', 21, NULL, '2026-05-25 13:17:47'),
(373, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 13, NULL, '2026-05-25 13:18:42'),
(374, 2, 'Israx', 'Creó filmación: MIN-711 (Karen Celeste Gutierrez Coronado)', 'assignment', 17, 'Fecha: 2026-06-29', '2026-05-25 13:19:20'),
(375, 2, 'Israx', 'Creó sesión: MIN-711 (Karen Celeste Gutierrez Coronado) el 2026-06-30', 'session', 26, NULL, '2026-05-25 13:19:20'),
(376, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 13, NULL, '2026-05-25 13:19:20'),
(377, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 17, 'MIN-711 — Karen Celeste Gutierrez Coronado', '2026-05-25 13:19:59'),
(378, 2, 'Israx', 'Creó filmación: GTH-612 (Félix Roberto Robles Flores)', 'assignment', 18, 'Fecha: 2026-06-03', '2026-05-25 14:17:47'),
(379, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 8, NULL, '2026-05-25 14:17:47'),
(380, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 18, 'GTH-612 — Félix Roberto Robles Flores', '2026-05-25 14:18:14'),
(381, 15, 'Mika Villanueva', 'Editó sesión: NIN-611 (Jorge Peñaranda)', 'session', 6, '2026-05-28 10:00 - 20:00', '2026-05-25 14:24:28'),
(382, 15, 'Mika Villanueva', 'Editó sesión: NIN-611 (Jorge Peñaranda)', 'session', 6, '2026-05-28 10:00 - 20:00', '2026-05-25 14:25:25'),
(383, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 5, 'DCI-615 — Ronald Alexander Vargas Gutierrez', '2026-05-25 17:07:40'),
(384, 15, 'Mika Villanueva', 'Editó sesión: NIN-611 (Jorge Peñaranda)', 'session', 6, '2026-05-28 10:00 - 20:00', '2026-05-25 17:13:53'),
(385, 15, 'Mika Villanueva', 'Editó sesión: TPM-411 (Franz Apaza)', 'session', 10, '2026-05-29 14:30 - 18:00', '2026-05-25 17:16:56'),
(386, 2, 'Israx', 'Creó sesión: CCO-612 (Patricia del Rosario Arrieta Melgarejo) el 2026-06-02', 'session', 28, NULL, '2026-05-26 07:22:19'),
(387, 2, 'Israx', 'Eliminó sesión: CCO-612 (Patricia del Rosario Arrieta Melgarejo) del 2026-05-26', 'session', 11, NULL, '2026-05-26 07:22:27'),
(388, 2, 'Israx', 'Eliminó reserva del 2026-05-29', 'reservation', 5, 'Cobertura Cuadro de Honor EA', '2026-05-26 17:18:01'),
(389, 2, 'Israx', 'Eliminó reserva del 2026-05-30', 'reservation', 17, 'Cobertura Cuadro de Honor EA', '2026-05-26 17:18:05'),
(390, 15, 'Mika Villanueva', 'Editó sesión: NTM-611 (Julio René De Bonadona Velásquez)', 'session', 14, '2026-05-27 14:00 - 19:00', '2026-05-27 10:43:36'),
(391, 2, 'Israx', 'Canceló sesión por inasistencia: NTM-611 (Julio René De Bonadona Velásquez) del 2026-05-27', 'session', 14, NULL, '2026-05-27 11:24:29'),
(392, 2, 'Israx', 'Creó sesión: NTM-611 (Julio René De Bonadona Velásquez) el 2026-06-08', 'session', 29, NULL, '2026-05-27 12:13:42'),
(393, 2, 'Israx', 'Canceló sesión por inasistencia: NIN-611 (Jorge Peñaranda) del 2026-05-28', 'session', 6, NULL, '2026-05-27 16:08:02'),
(394, 2, 'Israx', 'Canceló sesión por inasistencia: NIN-611 (Jorge Peñaranda) del 2026-05-29', 'session', 13, NULL, '2026-05-27 16:08:04'),
(395, 2, 'Israx', 'Creó sesión: NIN-611 (Jorge Peñaranda) el 2026-06-15', 'session', 30, NULL, '2026-05-27 18:28:28'),
(396, 2, 'Israx', 'Creó sesión: NIN-611 (Jorge Peñaranda) el 2026-06-16', 'session', 31, NULL, '2026-05-27 18:28:44'),
(397, 16, 'Nayra Antezana', 'Comentó sobre docente: Wendy Echalar', 'pending_teacher', 17, 'Esta materia no tiene listos los guiones facilitos de semana.', '2026-05-28 08:10:26'),
(398, 2, 'Israx', 'Creó filmación: DAT-611 (Froilán Villavicencio Yana)', 'assignment', 19, 'Fecha: 2026-05-28', '2026-05-28 15:16:30'),
(399, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 15, NULL, '2026-05-28 15:16:30'),
(400, 2, 'Israx', 'Cambió estado docente a: contacted', 'pending_teacher', 15, NULL, '2026-05-28 15:22:16'),
(401, 2, 'Israx', 'Eliminó sesión: DAT-611 (Froilán Villavicencio Yana) del 2026-05-28', 'session', 32, NULL, '2026-05-28 15:29:03'),
(402, 2, 'Israx', 'Creó filmación: DAT-611 (Froilán Villavicencio Yana)', 'assignment', 20, 'Fecha: 2026-06-10', '2026-05-28 15:32:04'),
(403, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 15, NULL, '2026-05-28 15:32:04'),
(404, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 20, 'DAT-611 — Froilán Villavicencio Yana', '2026-05-28 15:32:24'),
(405, 2, 'Israx', 'Cambió estado docente a: completed', 'pending_teacher', 11, NULL, '2026-05-28 16:38:09'),
(406, 2, 'Israx', 'Comentó sobre docente: Ronald Alexander Vargas Gutierrez', 'pending_teacher', 11, 'Esta revisando sus guiones, me contacte pero ella me llamara despues de hacer los ajustes', '2026-05-28 16:52:24'),
(407, 2, 'Israx', 'Cambió estado docente a: guion_incompleto', 'pending_teacher', 17, NULL, '2026-05-28 16:54:17'),
(408, 2, 'Israx', 'Eliminó sesión: CIN-611 (Carlos Reynaldo Peña Peducassé) del 2026-06-01', 'session', 8, NULL, '2026-05-29 13:10:23');
INSERT INTO `activity_log` (`id`, `user_id`, `user_name`, `action`, `entity_type`, `entity_id`, `details`, `created_at`) VALUES
(409, 2, 'Israx', 'Canceló sesión por inasistencia: CIN-611 (Carlos Reynaldo Peña Peducassé) del 2026-06-02', 'session', 12, NULL, '2026-05-29 13:10:34'),
(410, 2, 'Israx', 'Creó sesión: CIN-611 (Carlos Reynaldo Peña Peducassé) el 2026-06-25', 'session', 34, NULL, '2026-05-29 13:42:02'),
(411, 2, 'Israx', 'Creó sesión: CIN-611 (Carlos Reynaldo Peña Peducassé) el 2026-06-26', 'session', 35, NULL, '2026-05-29 13:42:21'),
(412, 2, 'Israx', 'Marcó filmación como: Completada', 'assignment', 8, 'CIN-611 — Carlos Reynaldo Peña Peducassé', '2026-05-29 13:43:16'),
(413, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 4, NULL, '2026-05-29 13:43:48'),
(414, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 4, NULL, '2026-05-29 13:43:57'),
(415, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-29 13:44:48'),
(416, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-29 13:44:52'),
(417, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-29 13:45:02'),
(418, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-29 13:48:14'),
(419, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 11, NULL, '2026-05-29 13:48:30'),
(420, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 8, 'CIN-611 — Carlos Reynaldo Peña Peducassé', '2026-05-29 13:57:22'),
(421, 2, 'Israx', 'Eliminó sesión: CIN-611 (Carlos Reynaldo Peña Peducassé) del 2026-06-02', 'session', 12, NULL, '2026-05-29 14:03:45'),
(422, 19, 'Moises Luna', 'Agregó docente pendiente: Franz Apaza', 'pending_teacher', 18, 'TPM-411 Teoría y Política Monetaria (CPU)', '2026-05-29 14:06:55'),
(423, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 4, NULL, '2026-05-29 14:16:27'),
(424, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 7, 'TPM-411 — Franz Apaza', '2026-06-02 08:55:53'),
(425, 19, 'Moises Luna', 'Eliminó docente pendiente: Franz Apaza', 'pending_teacher', 18, NULL, '2026-06-02 12:59:33'),
(426, 19, 'Moises Luna', 'Creó sesión: CCO-612 (Patricia del Rosario Arrieta Melgarejo) el 2026-06-11', 'session', 36, NULL, '2026-06-02 15:12:50'),
(427, 2, 'Israx', 'Reservó fechas: 2026-06-18 a 2026-06-18', 'reservation', NULL, 'UNICEF', '2026-06-03 08:49:25'),
(428, 2, 'Israx', 'Editó reserva del 2026-06-18', 'reservation', 18, 'UNICEF', '2026-06-03 08:49:35'),
(429, 2, 'Israx', 'Eliminó sesión: MDI-611 (Rolando Martín Cartagena Rocha) del 2026-06-12', 'session', 23, NULL, '2026-06-03 08:56:22'),
(430, 2, 'Israx', 'Reservó fechas: 2026-06-12 a 2026-06-12', 'reservation', NULL, 'Unicef', '2026-06-03 08:56:44'),
(431, 21, 'Rubi Monroy', 'Marcó filmación como: Completada', 'assignment', 18, 'GTH-612 — Félix Roberto Robles Flores', '2026-06-03 12:28:34'),
(432, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 15, 'MDI-611 — Rolando Martín Cartagena Rocha', '2026-06-03 14:09:00'),
(433, 2, 'Israx', 'Creó sesión: DTT-611 (Erika Rada) el 2026-06-16', 'session', 37, NULL, '2026-06-03 14:21:35'),
(434, 2, 'Israx', 'Creó sesión: DTT-611 (Erika Rada) el 2026-06-17', 'session', 38, NULL, '2026-06-03 14:21:51'),
(435, 2, 'Israx', 'Eliminó sesión: DTT-611 (Erika Rada) del 2026-06-08', 'session', 16, NULL, '2026-06-03 14:22:00'),
(436, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 11, 'DTT-611 — Erika Rada', '2026-06-03 19:48:11'),
(437, 21, 'Rubi Monroy', 'Creó sesión: NTM-611 (Julio René De Bonadona Velásquez) el 2026-06-17', 'session', 39, NULL, '2026-06-08 09:28:05'),
(438, 2, 'Israx', 'Canceló sesión por inasistencia: SIG-611 (Ruben Milton Ramirez Alvarado) del 2026-06-09', 'session', 17, NULL, '2026-06-08 13:12:49'),
(439, 2, 'Israx', 'Canceló sesión por inasistencia: SIG-611 (Ruben Milton Ramirez Alvarado) del 2026-06-10', 'session', 18, NULL, '2026-06-08 13:12:51'),
(440, 2, 'Israx', 'Eliminó reserva del 2026-06-12', 'reservation', 19, 'Unicef', '2026-06-08 14:13:10'),
(441, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 20, 'DAT-611 — Froilán Villavicencio Yana', '2026-06-10 16:39:22'),
(442, 21, 'Rubi Monroy', 'Marcó filmación como: Completada', 'assignment', 9, 'CCO-612 — Patricia del Rosario Arrieta Melgarejo', '2026-06-11 10:40:51'),
(443, 17, 'Felipe Vizcarra', 'Marcó filmación como: Completada', 'assignment', 16, 'PII-612 — Luis Fernando Atanacio Fuentes', '2026-06-12 06:57:10'),
(444, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 6, 'NIN-611 — Jorge Peñaranda', '2026-06-12 07:00:58'),
(445, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 6, 'NIN-611 — Jorge Peñaranda', '2026-06-12 07:01:04'),
(446, 16, 'Nayra Antezana', 'Agregó docente pendiente: WENDY', 'pending_teacher', 19, 'PEP-511 Preparación y Evaluación de Proyectos (CPU-ADM-ICO)', '2026-06-15 11:57:28'),
(447, 16, 'Nayra Antezana', 'Eliminó docente pendiente: WENDY', 'pending_teacher', 19, NULL, '2026-06-15 11:57:39'),
(448, 16, 'Nayra Antezana', 'Editó docente pendiente', 'pending_teacher', 17, 'Wendy Echalar', '2026-06-15 11:59:25'),
(449, 16, 'Nayra Antezana', 'Cambió estado docente a: completed', 'pending_teacher', 17, NULL, '2026-06-15 11:59:34'),
(450, 2, 'Israx', 'Reservó fechas: 2026-07-07 a 2026-07-10', 'reservation', NULL, 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:37'),
(451, 2, 'Israx', 'Editó reserva del 2026-07-08', 'reservation', 21, 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:51'),
(452, 2, 'Israx', 'Editó reserva del 2026-07-09', 'reservation', 22, 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:57'),
(453, 2, 'Israx', 'Editó reserva del 2026-07-07', 'reservation', 20, 'FIIE FORO INTERNACIONAL', '2026-06-15 12:28:10'),
(454, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 6, 'NIN-611 — Jorge Peñaranda', '2026-06-15 14:09:55'),
(455, 15, 'Mika Villanueva', 'Editó reserva del 2026-06-18', 'reservation', 18, 'UNICEF', '2026-06-15 14:56:29'),
(456, 2, 'Israx', 'Canceló sesión por inasistencia: NTM-611 (Julio René De Bonadona Velásquez) del 2026-06-08', 'session', 29, NULL, '2026-06-16 06:34:21'),
(457, 2, 'Israx', 'Canceló sesión por inasistencia: NTM-611 (Julio René De Bonadona Velásquez) del 2026-06-17', 'session', 39, NULL, '2026-06-16 06:34:26'),
(458, 2, 'Israx', 'Creó sesión: NTM-611 (Julio René De Bonadona Velásquez) el 2026-06-23', 'session', 40, NULL, '2026-06-16 06:34:43'),
(459, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 10, 'NTM-611 — Julio René De Bonadona Velásquez', '2026-06-16 06:46:07'),
(460, 2, 'Israx', 'Cambió estado docente a: pending', 'pending_teacher', 17, NULL, '2026-06-16 09:42:44'),
(461, 2, 'Israx', 'Creó filmación: PEP-511 (Wendy Echalar)', 'assignment', 21, 'Fecha: 2026-06-24', '2026-06-16 12:29:52'),
(462, 2, 'Israx', 'Cambió estado docente a: scheduled', 'pending_teacher', 17, NULL, '2026-06-16 12:29:53'),
(463, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 21, 'PEP-511 — Wendy Echalar', '2026-06-16 12:30:07'),
(464, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 11, 'DTT-611 — Erika Rada', '2026-06-16 22:24:50'),
(465, 19, 'Moises Luna', 'Creó sesión: PFO-711 (Cesar Acarapi Apaza) el 2026-07-01', 'session', 42, NULL, '2026-06-19 10:59:30'),
(466, 19, 'Moises Luna', 'Marcó filmación como: Completada', 'assignment', 13, 'PFO-711 — Cesar Acarapi Apaza', '2026-06-19 11:00:45'),
(467, 15, 'Mika Villanueva', 'Marcó filmación como: En progreso', 'assignment', 13, 'PFO-711 — Cesar Acarapi Apaza', '2026-06-19 12:52:50'),
(468, 2, 'Israx', 'Creó sesión: SIG-611 (Ruben Milton Ramirez Alvarado) el 2026-07-02', 'session', 43, NULL, '2026-06-19 13:41:28'),
(469, 2, 'Israx', 'Creó sesión: SIG-611 (Ruben Milton Ramirez Alvarado) el 2026-07-03', 'session', 44, NULL, '2026-06-19 13:41:59'),
(470, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 12, 'SIG-611 — Ruben Milton Ramirez Alvarado', '2026-06-19 13:42:08'),
(471, 19, 'Moises Luna', 'Marcó filmación como: Completada', 'assignment', 10, 'NTM-611 — Julio René De Bonadona Velásquez', '2026-06-23 09:39:37'),
(472, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 21, 'PEP-511 — Wendy Echalar', '2026-06-23 11:42:43'),
(473, 2, 'Israx', 'Creó sesión: PEP-511 (Wendy Echalar) el 2026-06-26', 'session', 45, NULL, '2026-06-23 11:43:03'),
(474, 2, 'Israx', 'Marcó filmación como: En progreso', 'assignment', 21, 'PEP-511 — Wendy Echalar', '2026-06-23 11:43:15'),
(475, 2, 'Israx', 'Reservó fechas: 2026-06-30 a 2026-06-30', 'reservation', NULL, 'Unicef', '2026-06-23 13:47:30'),
(476, 19, 'Moises Luna', 'Marcó filmación como: Completada', 'assignment', 8, 'CIN-611 — Carlos Reynaldo Peña Peducassé', '2026-06-25 13:29:50'),
(477, 21, 'Rubi Monroy', 'Creó sesión: PEP-511 (Wendy Echalar) el 2026-07-01', 'session', 46, NULL, '2026-06-26 14:30:20'),
(478, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 13, 'PFO-711 — Cesar Acarapi Apaza', '2026-07-01 08:39:36'),
(479, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 17, 'MIN-711 — Karen Celeste Gutierrez Coronado', '2026-07-01 08:40:44'),
(480, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 21, 'PEP-511 — Wendy Echalar', '2026-07-01 13:27:54'),
(481, 15, 'Mika Villanueva', 'Marcó filmación como: Completada', 'assignment', 12, 'SIG-611 — Ruben Milton Ramirez Alvarado', '2026-07-02 14:44:34'),
(482, 2, 'Israx', 'Activó semestre #2', 'semester', 2, NULL, '2026-07-03 09:09:54'),
(483, 2, 'Israx', 'Activó semestre #1', 'semester', 1, NULL, '2026-07-03 09:14:12'),
(484, 2, 'Israx', 'Activó semestre #2', 'semester', 2, NULL, '2026-07-03 09:14:34'),
(485, 2, 'Israx', 'Activó semestre #1', 'semester', 1, NULL, '2026-07-03 09:14:52'),
(486, 2, 'Israx', 'Activó semestre #2', 'semester', 2, NULL, '2026-07-03 09:15:07'),
(487, 2, 'Israx', 'Activó semestre #1', 'semester', 1, NULL, '2026-07-03 09:19:51'),
(488, 2, 'Israx', 'Cambió estado docente a: guion_revisado', 'pending_teacher', 11, NULL, '2026-07-03 09:21:41'),
(489, 2, 'Israx', 'Eliminó docente pendiente: Ronald Alexander Vargas Gutierrez', 'pending_teacher', 11, NULL, '2026-07-03 09:21:58'),
(490, 2, 'Israx', 'Activó semestre #2', 'semester', 2, NULL, '2026-07-03 09:23:43');

-- --------------------------------------------------------

--
-- Table structure for table `closed_weeks`
--

CREATE TABLE `closed_weeks` (
  `id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `reason` varchar(255) DEFAULT 'Estudio cerrado',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `filming_assignments`
--

CREATE TABLE `filming_assignments` (
  `id` int(11) NOT NULL,
  `teacher_name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject_id` int(11) NOT NULL,
  `drive_link` text DEFAULT NULL,
  `script_status` varchar(50) DEFAULT 'not_uploaded',
  `status` enum('in_progress','completed','cancelled') DEFAULT 'in_progress',
  `last_hito_reached` enum('pagina_inicio','hito_2','hito_3','hito_4','hito_5','semanas') DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `sede` varchar(100) DEFAULT 'La Paz',
  `flight_ticket_path` varchar(255) DEFAULT NULL,
  `assigned_staff` text DEFAULT NULL,
  `bitacora` text DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `rating` tinyint(3) UNSIGNED DEFAULT NULL COMMENT '1-5 star teacher rating',
  `rating_comment` text DEFAULT NULL COMMENT 'Optional review text for the rating'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `filming_assignments`
--

INSERT INTO `filming_assignments` (`id`, `teacher_name`, `phone`, `subject_id`, `drive_link`, `script_status`, `status`, `last_hito_reached`, `created_at`, `sede`, `flight_ticket_path`, `assigned_staff`, `bitacora`, `completed_at`, `rating`, `rating_comment`) VALUES
(1, 'Jorge Rodriguez', '74573450', 728, '', 'pending', 'in_progress', NULL, '2026-05-07 14:53:44', 'La Paz', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Jorge Rodriguez', '74573450', 728, '', 'pending', 'in_progress', NULL, '2026-05-07 14:53:44', 'La Paz', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Ronald Alexander Vargas Gutierrez', '68098700', 1023, 'https://docs.google.com/document/d/17WzbrMnnP0BJCWr1o8OGLp-mdOX1NoSD/edit', 'guion_revisado', 'in_progress', NULL, '2026-05-18 10:51:30', 'Sucre', '/uploads/tickets/1778775755_a00e4ce0a14a81c6.pdf', NULL, NULL, NULL, NULL, NULL),
(4, 'Ronald Alexander Vargas Gutierrez', '68098700', 1023, 'https://docs.google.com/document/d/17WzbrMnnP0BJCWr1o8OGLp-mdOX1NoSD/edit', 'not_uploaded', 'in_progress', NULL, '2026-05-18 13:33:05', 'Sucre', '/uploads/tickets/1778775755_a00e4ce0a14a81c6.pdf', NULL, NULL, NULL, NULL, NULL),
(5, 'Ronald Alexander Vargas Gutierrez', '68098700', 1023, 'https://docs.google.com/document/d/17WzbrMnnP0BJCWr1o8OGLp-mdOX1NoSD/edit', 'not_uploaded', 'completed', NULL, '2026-05-18 13:34:13', 'Sucre', '/uploads/tickets/1778775755_a00e4ce0a14a81c6.pdf', NULL, 'PI - H1 - H2 - H3- H4 - H5 + Todas las semanas completo', NULL, NULL, NULL),
(6, 'Jorge Peñaranda', '72204935', 1077, 'https://docs.google.com/document/d/1RBPWFHIYEZRFCBT8eb47jn6j3Lwfs9l-/edit', 'not_uploaded', 'completed', NULL, '2026-05-18 15:20:32', 'Cochabamba', NULL, NULL, '[28/05/2026 10:00-20:00] Sesión CANCELADA — Docente no se presentó.\n[29/05/2026 10:00-12:00] Sesión CANCELADA — Docente no se presentó.\n[15/06/2026 09:30-20:00] - se grabo toda la materia\n', '2026-06-15 14:09:55', 4, NULL),
(7, 'Franz Apaza', '71527625', 1073, 'https://docs.google.com/document/d/1RBPWFHIYEZRFCBT8eb47jn6j3Lwfs9l-/edit', 'not_uploaded', 'completed', NULL, '2026-05-18 15:32:07', 'La Paz', NULL, '', 'Se grabó DIA 1:\n- PI/H1\n- H2/PRH2\n- H3/PRH3\n- SEMANAS H2\n- SEMANAS H3\n\nSE GRABO DIA 2:\n- H4/PRH4\n- H5/PRH5\n- SEMANAS H4', '2026-06-02 08:55:53', 4, NULL),
(8, 'Carlos Reynaldo Peña Peducassé', '68225829', 1065, 'https://docs.google.com/document/d/1pCyK4cEJgCr5vd4q5bTwguWXSDy2twYn/edit?pli=1', 'not_uploaded', 'completed', NULL, '2026-05-18 15:48:37', 'Santa Cruz', NULL, NULL, '[02/06/2026 10:00-12:00] Sesión CANCELADA — Docente no se presentó.', '2026-06-25 13:29:50', 2, NULL),
(9, 'Patricia del Rosario Arrieta Melgarejo', '73054498', 1061, 'https://docs.google.com/document/d/1aRBUbwfU8ECoSFbt4hYFja51MGb7lCRy/edit', 'not_uploaded', 'completed', NULL, '2026-05-20 14:34:25', 'La Paz', NULL, NULL, '(02/06/2026) Solo se grabo H2/PRH2 y semanas del Hito 2 porque la licenciada no trajo cambios de ropa para los demás hitos.\n\n(11/06/2026) Se termino de grabar todo', '2026-06-11 10:40:51', NULL, NULL),
(10, 'Julio René De Bonadona Velásquez', '77519700', 1059, 'https://docs.google.com/document/d/1Uu5PGMXEqA-7gawIzwHercOpw6F1z0_6/edit', 'not_uploaded', 'completed', NULL, '2026-05-21 08:53:35', 'La Paz', NULL, NULL, '[27/05/2026 14:00-19:00] Sesión CANCELADA — Docente no se presentó.\n[08/05/2026 09:00-12:30]  - se grabó todas las semanas y páginas de inicio y cierre del hito 1 y 2\n\n\n[08/06/2026 09:00-12:30] Sesión CANCELADA — Docente no se presentó.\n[17/06/2026 11:00-12:30] Sesión CANCELADA — Docente no se presentó.', '2026-06-23 09:39:37', 4, NULL),
(11, 'Erika Rada', '77729963', 1055, 'https://docs.google.com/document/d/1Az6wyaKsH1HCQd-utQl0pqfE6ZL6jyFZ/edit', 'not_uploaded', 'completed', NULL, '2026-05-22 13:06:26', 'La Paz', NULL, NULL, '(16/06/2026) se grabo toda la materia', '2026-06-16 22:24:50', 3, NULL),
(12, 'Ruben Milton Ramirez Alvarado', '76600176', 1071, 'https://docs.google.com/document/d/1b0jkPbS_GO74aLZBO9Q4EV-mwLAzmLBM/edit', 'not_uploaded', 'completed', NULL, '2026-05-22 13:08:58', 'Cochabamba', NULL, NULL, '[09/06/2026 10:00-20:00] Sesión CANCELADA — Docente no se presentó.\n[10/06/2026 10:00-12:00] Sesión CANCELADA — Docente no se presentó.', '2026-07-02 14:44:34', 4, NULL),
(13, 'Cesar Acarapi Apaza', '73219314', 1079, 'https://docs.google.com/document/d/12LRAbmejwm7biuIpG1fDMfQP0s2g3CeO/edit', 'not_uploaded', 'completed', NULL, '2026-05-22 13:24:20', 'La Paz', NULL, NULL, '(19/06/2026) se grabo todas las paginas de inicio y las semanas del Hito 2\n(01/07/2026) Se grabo semanas hito 3 y 4 terminado\n\nEl docente lee con poca elocuencia', '2026-07-01 08:39:36', 2, NULL),
(14, 'Karen Celeste Gutierrez Coronado', '68676698', 1075, 'https://docs.google.com/document/d/1sxklWQRERFl1O2MFlynw6_dxajE6tcRL/edit', 'not_uploaded', 'in_progress', NULL, '2026-05-22 13:37:10', 'Sucre', NULL, NULL, '', NULL, NULL, NULL),
(15, 'Rolando Martín Cartagena Rocha', '76266020', 1063, 'https://docs.google.com/document/d/1VC0GN1_Jz7m5IrTPN9mAyJG8CHXiCe3w/edit', 'not_uploaded', 'completed', NULL, '2026-05-22 15:08:35', 'La Paz', NULL, NULL, 'Completo, se termino de grabar toda la materia\n\nEl docente demuestra dominio en filmación ', '2026-06-03 14:09:00', 5, NULL),
(16, 'Luis Fernando Atanacio Fuentes', '74085185', 1033, 'https://docs.google.com/document/d/1L8qjiOzsJ1dPSilVPsbZpsvO7s-D8p_J/edit', 'not_uploaded', 'completed', NULL, '2026-05-22 15:41:24', 'La Paz', NULL, NULL, '(11/06/2026) SE GRABO TODO', '2026-06-12 06:57:10', 5, NULL),
(17, 'Karen Celeste Gutierrez Coronado', '68676698', 1075, 'https://docs.google.com/document/d/1sxklWQRERFl1O2MFlynw6_dxajE6tcRL/edit', 'not_uploaded', 'completed', NULL, '2026-05-25 13:19:20', 'Sucre', NULL, NULL, '(29/06/2026) Se grabo toda la materia completo', '2026-07-01 08:40:44', 4, NULL),
(18, 'Félix Roberto Robles Flores', '69888644', 1067, 'https://docs.google.com/document/d/1OVPGM5rltyCxoe2KDau_wYQVPkYPH5Hy/edit', 'not_uploaded', 'completed', NULL, '2026-05-25 14:17:47', 'La Paz', NULL, NULL, 'Se terminó de grabar toda la materia. ', '2026-06-03 12:28:34', 4, NULL),
(19, 'Froilán Villavicencio Yana', '70750559', 1057, 'https://docs.google.com/document/d/13c4jrfjDGo0UHDXH49fbA0xy_3d_snfs/edit', 'not_uploaded', 'in_progress', NULL, '2026-05-28 15:16:30', 'La Paz', NULL, NULL, '', NULL, NULL, NULL),
(20, 'Froilán Villavicencio Yana', '70750559', 1057, 'https://docs.google.com/document/d/13c4jrfjDGo0UHDXH49fbA0xy_3d_snfs/edit', 'not_uploaded', 'completed', NULL, '2026-05-28 15:32:04', 'La Paz', NULL, NULL, '(10/06/2026) SE GRABO TODO', '2026-06-10 16:39:22', 5, NULL),
(21, 'Wendy Echalar', '72031165', 1069, '', 'not_uploaded', 'completed', NULL, '2026-06-16 12:29:52', 'La Paz', NULL, NULL, '24/06 se grabó todas las páginas de inicio y pr\n26/06 se grabó los facilitos del hito 2-3-4, queda pendiente S11 y facilitos del hito 5 \n01/07 Se grabo facilito 11 y facilitos hito 5\n\nSe podría haber acabado antes pero la docente no trajo su material para los facilitos', '2026-07-01 13:27:54', 4, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `global_subjects`
--

CREATE TABLE `global_subjects` (
  `id` int(11) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `subject_type` varchar(50) DEFAULT 'Teórica',
  `career` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `global_subjects`
--

INSERT INTO `global_subjects` (`id`, `code`, `name`, `subject_type`, `career`, `created_at`) VALUES
(1, 'SED-711 (M-S)', 'Sistema Evaluación del Desempeño', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(2, 'DLC-711 (MC-S)', 'Dirección y Liderazgo Creativo', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(3, 'MDE-711 (M-S)', 'Inteligencia de Negocios', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(4, 'GET-711 (M-S)', 'Gerencia Estratégica', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(5, 'MPN-711 (M-S)', 'Modelo y Plan de Negocios', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(6, 'GMN-711 (MC-S)', 'Gestión de Mypes y Negocios Familiares', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(7, 'GRM-711 (M-S)', 'Gestión de Recursos Microfinancieros', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(8, 'ITE-711 (M-S)', 'Innovación y Tecnología', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(9, 'PGE-711 (C-S)', 'Política y Gerencia Empresarial', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(10, 'APR-711 (C-S)', 'Administración de Proyectos', 'Teórica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(11, 'MIN-711 (C-S)', 'Metodología de la Investigación', 'Práctica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(12, 'PII-713 (P-S)', 'Proyecto Integrador Intermedio III', 'Práctica', 'LICENCIATURA EN ADMINISTRACIÓN DE EMPRESAS', '2026-07-03 09:05:47'),
(13, 'AIM-712 (M-S)', 'M1. Auditoría Impositiva II', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(14, 'GTI-711 (M-S)', 'M1. Gestión Tributaria Internacional', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(15, 'GAT-711 (M-S)', 'M1. Gabinete de Auditoría Tributaria', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(16, 'AIN-711 (M-S)', 'M2. Auditoría Internacional', 'Teórica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(17, 'ERF-711 (MC-S)', 'M2. Evaluación de Riesgos Financieros', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(18, 'GAF-711 (M-S)', 'M2. Gabinete de Auditoría Financiera', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(19, 'TPF-411 (C-S)', 'Teoría y Política Fiscal', 'Teórica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(20, 'AFO-711 (P-S)', 'Auditoría Forense', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(21, 'GTE-711 (P-S)', 'Gerencia de Tesorería', 'Numérica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(22, 'MIN-711 ((C-S)', 'Metodología de la Investigación', 'Práctica', 'LICENCIATURA EN CONTADURÍA PÚBLICA', '2026-07-03 09:05:47'),
(23, 'FIN-711 (MC-S)', 'M1.Finanzas Internacionales', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(24, 'CIN-712(M-S)', 'M1.Comercio Internacional II', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(25, 'LCI-711(M-S)', 'M1. Legislación Comercial Internacional', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(26, 'BIN-711 (M-S)', 'M2. Business Intelligence', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(27, 'BTP-711 (M-S)', 'M2. Bases Tecnológicas y Plataformas Digitales', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(28, 'DPD-711 (M-S)', 'M2. Desarrollo de Productos Digitales', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(29, 'TME-711(P-S)', 'Tendencias de Mercado', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(30, 'NTM-611(MC-S)', 'Nuevas Tendencias del Marketing', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(31, 'APR-711(C-S)', 'Administración de Proyectos', 'Teórica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(32, 'MIN-711(C-S)', 'Metodología de la Investigación', 'Práctica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(33, 'PII-713(P-S)', 'Proyecto Integrador Intermedio III', 'Práctica', 'LICENCIATURA EN INGENIERÍA COMERCIAL', '2026-07-03 09:05:47'),
(34, 'DIP-711 (P-S)', 'Derecho Internacional Público', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(35, 'DMU-711 (P-S)', 'Derecho Municipal', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(36, 'CRI-711 (P-S)', 'Criminalística', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(37, 'DPC-711 (P-S)', 'Derecho Procesal Civil', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(38, 'DIN-711 (P-S)', 'Derecho Informático', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(39, 'DBS-711 (P-S)', 'Derecho Bancario y de Seguros', 'Teórica', 'LICENCIATURA EN DERECHO', '2026-07-03 09:05:47'),
(40, 'GCP-711(M-S)', 'Gestión Creativa Publicitaria', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(41, 'EDI-711(M-S)', 'Estrategias Digitales', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(42, 'BES-711(MC-S)', 'Branding Estratégico', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(43, 'TMA-711(M-S)', 'Trade Marketing', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(44, 'SMC-711(MC-S)', 'Social Media y Community Managament', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(45, 'EBU-711(M-S)', 'e-Business', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(46, 'GPR-711(C-S)', 'Gestión de Proyectos', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(47, 'RSE-711(P-S)', 'Responsabilidad Social Empresarial', 'Teórica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47'),
(48, 'PAP-711(P-S)', 'Presupuestos Aplicados', 'Numérica', 'LICENCIATURA EN PUBLICIDAD Y MARKETING', '2026-07-03 09:05:47');

-- --------------------------------------------------------

--
-- Table structure for table `meeting_requests`
--

CREATE TABLE `meeting_requests` (
  `id` int(11) NOT NULL,
  `requester_name` varchar(255) NOT NULL,
  `requester_contact` varchar(255) DEFAULT NULL,
  `requested_date` date NOT NULL,
  `start_time` varchar(10) NOT NULL,
  `end_time` varchar(10) NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `reviewed_by_user_id` int(11) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `from_user_id` int(11) DEFAULT NULL,
  `from_user_name` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'info',
  `message` text NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `from_user_id`, `from_user_name`, `type`, `message`, `entity_type`, `entity_id`, `is_read`, `created_at`) VALUES
(1, 14, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Jorge Peñaranda (NIN-611) para el 2026-05-28', 'assignment', 6, 0, '2026-05-18 15:20:32'),
(2, 14, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Jorge Peñaranda (Negocios Internacionales (M1) (ICO))', 'pending_teacher', 6, 0, '2026-05-18 15:20:32'),
(3, 14, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Jorge Peñaranda (Negocios Internacionales (M1) (ICO)): \"29 a mas tardar medio dia, y no hay problema si toma el primer vuelo del dia 28\"', 'pending_teacher', 6, 0, '2026-05-18 15:22:07'),
(4, 14, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Jorge Peñaranda (Negocios Internacionales (M1) (ICO)): \"Esta programado para el 28 y 29, la fecha 28 no se hace problema si es el primer vuelo de la mañana y el 29 seria hasta mas tardar medio dia su vuelo de retorno\"', 'pending_teacher', 6, 0, '2026-05-18 15:24:21'),
(5, 14, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Franz Apaza (TPM-411) para el 2026-05-22', 'assignment', 7, 0, '2026-05-18 15:32:07'),
(6, 14, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Franz Apaza (Teoría y Política Monetaria (CPU))', 'pending_teacher', 5, 0, '2026-05-18 15:32:07'),
(7, 14, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Franz Apaza (Teoría y Política Monetaria (CPU)): \"Docente Agendado para el viernes 22 por la tarde y viernes 29 por la tarde\"', 'pending_teacher', 5, 0, '2026-05-18 15:34:52'),
(8, 13, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Carlos Reynaldo Peña Peducassé (CIN-611) para el 2026-06-01', 'assignment', 8, 0, '2026-05-18 15:48:37'),
(9, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Carlos Reynaldo Peña Peducassé (Comercio Internacional (ICO-ADM))', 'pending_teacher', 4, 0, '2026-05-18 15:48:37'),
(10, 13, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Carlos Reynaldo Peña Peducassé (Comercio Internacional (ICO-ADM)): \"Se contacto y se realizo la reseva para el 1 y 2 de junio, dia y medio, proceder a la compra de pasajes\"', 'pending_teacher', 4, 0, '2026-05-18 15:50:33'),
(11, 14, 16, 'Nayra Antezana', 'scheduled', 'Nayra Antezana agendó fecha para tu docente Franz Apaza (Teoría y Política Monetaria (CPU))', 'pending_teacher', 5, 0, '2026-05-20 09:04:04'),
(12, 12, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Ruben Milton Ramirez Alvarado (Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO))', 'pending_teacher', 9, 0, '2026-05-20 12:53:47'),
(13, 12, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Luis Fernando Atanacio Fuentes (Proyecto Integrador Intermedio II (DER))', 'pending_teacher', 10, 0, '2026-05-20 13:03:19'),
(14, 12, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Luis Fernando Atanacio Fuentes (Proyecto Integrador Intermedio II (DER)): \"Puede todos los dias a partir de las 5 o mañana todo el día\"', 'pending_teacher', 10, 0, '2026-05-20 13:03:53'),
(15, 12, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Luis Fernando Atanacio Fuentes (Proyecto Integrador Intermedio II (DER)): \"Puede todos los dias a partir de las 5 o el 21 toda la mañana\"', 'pending_teacher', 10, 0, '2026-05-20 13:04:41'),
(16, 12, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Ruben Milton Ramirez Alvarado (Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO)): \"Dentro del 30 Mayo al 13 de Junio dispone de tiempo\"', 'pending_teacher', 9, 0, '2026-05-20 13:22:31'),
(17, 13, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Patricia del Rosario Arrieta Melgarejo (Comportamiento del Consumidor II (M2) (PUB))', 'pending_teacher', 16, 0, '2026-05-20 13:28:37'),
(18, 13, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Julio René De Bonadona Velásquez (Nuevas Tendencias del Marketing (M2) (PUB))', 'pending_teacher', 3, 0, '2026-05-20 13:29:16'),
(19, 13, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Patricia del Rosario Arrieta Melgarejo (CCO-612) para el 2026-05-26', 'assignment', 9, 0, '2026-05-20 14:34:25'),
(20, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Patricia del Rosario Arrieta Melgarejo (Comportamiento del Consumidor II (M2) (PUB))', 'pending_teacher', 16, 0, '2026-05-20 14:34:25'),
(21, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Patricia del Rosario Arrieta Melgarejo (Comportamiento del Consumidor II (M2) (PUB))', 'pending_teacher', 16, 0, '2026-05-20 14:34:40'),
(22, 8, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Rolando Martín Cartagena Rocha (Marketing Digital (M2) (PUB))', 'pending_teacher', 7, 0, '2026-05-20 16:22:25'),
(23, 8, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Félix Roberto Robles Flores (Gestión de Talento Humano II (ADM))', 'pending_teacher', 8, 0, '2026-05-21 08:48:53'),
(24, 13, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Julio René De Bonadona Velásquez (NTM-611) para el 2026-05-27', 'assignment', 10, 0, '2026-05-21 08:53:35'),
(25, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Julio René De Bonadona Velásquez (Nuevas Tendencias del Marketing (M2) (PUB))', 'pending_teacher', 3, 0, '2026-05-21 08:53:35'),
(26, 12, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Cesar Acarapi Apaza (Psicología Forense)', 'pending_teacher', 12, 0, '2026-05-22 07:03:35'),
(27, 12, 2, 'Israx', 'comment', '? Israx dejó un comentario sobre Cesar Acarapi Apaza (Psicología Forense): \"llamar a las 2 de la tarde\"', 'pending_teacher', 12, 0, '2026-05-22 07:04:06'),
(28, 8, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Karen Celeste Gutierrez Coronado (Marketing Internacional (M1) (ICO))', 'pending_teacher', 13, 0, '2026-05-22 12:57:04'),
(29, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Erika Rada (DTT-611) para el 2026-06-08', 'assignment', 11, 0, '2026-05-22 13:06:26'),
(30, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Erika Rada (Derecho de Transporte y Telecomunicaciones (DER))', 'pending_teacher', 14, 0, '2026-05-22 13:06:27'),
(31, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Ruben Milton Ramirez Alvarado (SIG-611) para el 2026-06-09', 'assignment', 12, 0, '2026-05-22 13:08:58'),
(32, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Ruben Milton Ramirez Alvarado (Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO))', 'pending_teacher', 9, 0, '2026-05-22 13:08:58'),
(33, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Cesar Acarapi Apaza (PFO-711) para el 2026-06-19', 'assignment', 13, 0, '2026-05-22 13:24:20'),
(34, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Cesar Acarapi Apaza (Psicología Forense)', 'pending_teacher', 12, 0, '2026-05-22 13:24:20'),
(35, 8, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Karen Celeste Gutierrez Coronado (MIN-711) para el 2026-06-22', 'assignment', 14, 0, '2026-05-22 13:37:10'),
(36, 8, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Karen Celeste Gutierrez Coronado (Marketing Internacional (M1) (ICO))', 'pending_teacher', 13, 0, '2026-05-22 13:37:11'),
(37, 12, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Froilán Villavicencio Yana (Derecho Aduanero y Tributario (DER))', 'pending_teacher', 15, 0, '2026-05-22 14:55:39'),
(38, 8, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Rolando Martín Cartagena Rocha (MDI-611) para el 2026-06-03', 'assignment', 15, 0, '2026-05-22 15:08:35'),
(39, 8, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Rolando Martín Cartagena Rocha (Marketing Digital (M2) (PUB))', 'pending_teacher', 7, 0, '2026-05-22 15:08:35'),
(40, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Luis Fernando Atanacio Fuentes (PII-612) para el 2026-06-11', 'assignment', 16, 0, '2026-05-22 15:41:24'),
(41, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Luis Fernando Atanacio Fuentes (Proyecto Integrador Intermedio II (DER))', 'pending_teacher', 10, 0, '2026-05-22 15:41:24'),
(42, 8, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Karen Celeste Gutierrez Coronado (MIN-711) para el 2026-06-29', 'assignment', 17, 0, '2026-05-25 13:19:20'),
(43, 8, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Karen Celeste Gutierrez Coronado (Marketing Internacional (M1) (ICO))', 'pending_teacher', 13, 0, '2026-05-25 13:19:20'),
(44, 8, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Félix Roberto Robles Flores (GTH-612) para el 2026-06-03', 'assignment', 18, 0, '2026-05-25 14:17:47'),
(45, 8, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Félix Roberto Robles Flores (Gestión de Talento Humano II (ADM))', 'pending_teacher', 8, 0, '2026-05-25 14:17:47'),
(46, 8, 16, 'Nayra Antezana', 'comment', '? Nayra Antezana dejó un comentario sobre Wendy Echalar (Preparación y Evaluación de Proyectos (CPU-ADM-ICO)): \"Esta materia no tiene listos los guiones facilitos de semana.\"', 'pending_teacher', 17, 0, '2026-05-28 08:10:26'),
(47, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Froilán Villavicencio Yana (DAT-611) para el 2026-05-28', 'assignment', 19, 0, '2026-05-28 15:16:30'),
(48, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Froilán Villavicencio Yana (Derecho Aduanero y Tributario (DER))', 'pending_teacher', 15, 0, '2026-05-28 15:16:30'),
(49, 12, 2, 'Israx', 'contacted', 'Israx contactó a tu docente Froilán Villavicencio Yana (Derecho Aduanero y Tributario (DER))', 'pending_teacher', 15, 0, '2026-05-28 15:22:16'),
(50, 12, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Froilán Villavicencio Yana (DAT-611) para el 2026-06-10', 'assignment', 20, 0, '2026-05-28 15:32:04'),
(51, 12, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Froilán Villavicencio Yana (Derecho Aduanero y Tributario (DER))', 'pending_teacher', 15, 0, '2026-05-28 15:32:04'),
(52, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Carlos Reynaldo Peña Peducassé (Comercio Internacional (ICO-ADM))', 'pending_teacher', 4, 0, '2026-05-29 13:43:48'),
(53, 13, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Carlos Reynaldo Peña Peducassé (Comercio Internacional (ICO-ADM))', 'pending_teacher', 4, 0, '2026-05-29 14:16:27'),
(54, 8, 2, 'Israx', 'scheduled', 'Israx agendó filmación de Wendy Echalar (PEP-511) para el 2026-06-24', 'assignment', 21, 0, '2026-06-16 12:29:52'),
(55, 8, 2, 'Israx', 'scheduled', 'Israx agendó fecha para tu docente Wendy Echalar (Preparación y Evaluación de Proyectos (CPU-ADM-ICO))', 'pending_teacher', 17, 0, '2026-06-16 12:29:53');

-- --------------------------------------------------------

--
-- Table structure for table `pending_teachers`
--

CREATE TABLE `pending_teachers` (
  `id` int(11) NOT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `subject_code` varchar(50) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `subject_type` varchar(50) DEFAULT 'Teórica',
  `phone` varchar(50) DEFAULT NULL,
  `sede` varchar(100) NOT NULL DEFAULT 'La Paz',
  `is_external` tinyint(1) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `resolved` tinyint(1) DEFAULT 0,
  `added_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` varchar(30) DEFAULT 'pending',
  `drive_link` text DEFAULT NULL,
  `flight_ticket_path` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `pending_teachers`
--

INSERT INTO `pending_teachers` (`id`, `semester_id`, `name`, `subject_code`, `subject`, `subject_type`, `phone`, `sede`, `is_external`, `notes`, `resolved`, `added_by_user_id`, `created_at`, `status`, `drive_link`, `flight_ticket_path`) VALUES
(3, 1, 'Julio René De Bonadona Velásquez', 'NTM-611', 'Nuevas Tendencias del Marketing (M2) (PUB)', 'Teórica', '77519700', 'La Paz', 0, '', 0, 13, '2026-05-12 08:50:13', 'completed', 'https://docs.google.com/document/d/1Uu5PGMXEqA-7gawIzwHercOpw6F1z0_6/edit', NULL),
(9, 1, 'Ruben Milton Ramirez Alvarado', 'SIG-611', 'Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO)', 'Teórica', '76600176', 'Cochabamba', 1, 'Guion final listo, coordinar fechas; viene de Cochabamba, comunicarme para comprar pasajes.', 0, 12, '2026-05-14 05:41:01', 'completed', 'https://docs.google.com/document/d/1b0jkPbS_GO74aLZBO9Q4EV-mwLAzmLBM/edit', NULL),
(4, 1, 'Carlos Reynaldo Peña Peducassé', 'CIN-611', 'Comercio Internacional (ICO-ADM)', 'Teórica', '68225829', 'Santa Cruz', 1, 'Sugiero programarlo la última semana de mayo o la primera semana de junio, por tema de pago.', 0, 13, '2026-05-12 15:10:09', 'completed', 'https://docs.google.com/document/d/1pCyK4cEJgCr5vd4q5bTwguWXSDy2twYn/edit?pli=1', '/uploads/tickets/1779461909_841f449f45ab084a.pdf'),
(5, 1, 'Franz Apaza', 'TPM-411', 'Teoría y Política Monetaria (CPU)', 'Teórica', '71527625', 'La Paz', 0, 'Concluyo todo tiene ya las escaletas de sus guiones', 0, 14, '2026-05-13 07:00:59', 'completed', 'https://docs.google.com/document/d/1RBPWFHIYEZRFCBT8eb47jn6j3Lwfs9l-/edit', NULL),
(6, 1, 'Jorge Peñaranda', 'NIN-611', 'Negocios Internacionales (M1) (ICO)', 'Teórica', '72204935', 'Cochabamba', 1, 'El docente es de Cochabamba, tomar en cuenta ello para cuando se tenga fecha comunicarme para hacer la reserva de pasajes y todo el trámite.\nTiene ya las escaletas de sus guiones', 0, 14, '2026-05-13 07:02:39', 'completed', 'https://docs.google.com/document/d/1RBPWFHIYEZRFCBT8eb47jn6j3Lwfs9l-/edit', NULL),
(7, 1, 'Rolando Martín Cartagena Rocha', 'MDI-611', 'Marketing Digital (M2) (PUB)', 'Teórica', '76266020', 'La Paz', 0, '', 0, 8, '2026-05-13 12:25:20', 'completed', 'https://docs.google.com/document/d/1VC0GN1_Jz7m5IrTPN9mAyJG8CHXiCe3w/edit', NULL),
(8, 1, 'Félix Roberto Robles Flores', 'GTH-612', 'Gestión de Talento Humano II (ADM)', 'Teórica', '69888644', 'La Paz', 0, '', 0, 8, '2026-05-13 13:55:53', 'completed', 'https://docs.google.com/document/d/1OVPGM5rltyCxoe2KDau_wYQVPkYPH5Hy/edit', NULL),
(10, 1, 'Luis Fernando Atanacio Fuentes', 'PII-612', 'Proyecto Integrador Intermedio II (DER)', 'Proyecto Integrador', '74085185', 'La Paz', 0, '', 0, 12, '2026-05-14 07:40:59', 'completed', 'https://docs.google.com/document/d/1L8qjiOzsJ1dPSilVPsbZpsvO7s-D8p_J/edit', NULL),
(12, 1, 'Cesar Acarapi Apaza', 'PFO-711', 'Psicología Forense', 'Teórica', '73219314', 'La Paz', 0, '', 0, 12, '2026-05-18 07:03:20', 'completed', 'https://docs.google.com/document/d/12LRAbmejwm7biuIpG1fDMfQP0s2g3CeO/edit', NULL),
(13, 1, 'Karen Celeste Gutierrez Coronado', 'MIN-711', 'Marketing Internacional (M1) (ICO)', 'Teórica', '68676698', 'Sucre', 1, '', 0, 8, '2026-05-18 13:31:45', 'completed', 'https://docs.google.com/document/d/1sxklWQRERFl1O2MFlynw6_dxajE6tcRL/edit', NULL),
(14, 1, 'Erika Rada', 'DTT-611', 'Derecho de Transporte y Telecomunicaciones (DER)', 'Teórica', '77729963', 'La Paz', 0, '', 0, 12, '2026-05-18 14:42:31', 'completed', 'https://docs.google.com/document/d/1Az6wyaKsH1HCQd-utQl0pqfE6ZL6jyFZ/edit', NULL),
(15, 1, 'Froilán Villavicencio Yana', 'DAT-611', 'Derecho Aduanero y Tributario (DER)', 'Teórica', '70750559', 'La Paz', 0, '', 0, 12, '2026-05-19 09:42:02', 'completed', 'https://docs.google.com/document/d/13c4jrfjDGo0UHDXH49fbA0xy_3d_snfs/edit', NULL),
(16, 1, 'Patricia del Rosario Arrieta Melgarejo', 'CCO-612', 'Comportamiento del Consumidor II (M2) (PUB)', 'Teórica', '73054498', 'La Paz', 0, 'El guión ya fue revisado por la docente experta.', 0, 13, '2026-05-19 13:34:54', 'completed', 'https://docs.google.com/document/d/1aRBUbwfU8ECoSFbt4hYFja51MGb7lCRy/edit', NULL),
(17, 1, 'Wendy Echalar', 'PEP-511', 'Preparación y Evaluación de Proyectos (CPU-ADM-ICO)', 'Numérica', '72031165', 'La Paz', 0, 'Se terminaron los guiones solo faltan los links de material de apoyo desde la semana 14 a las 19', 0, 8, '2026-05-25 12:00:17', 'completed', 'https://docs.google.com/document/d/14S7pF1Iu51p5jUnmCeQgeHK9szCIMfWO/edit', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `recording_sessions`
--

CREATE TABLE `recording_sessions` (
  `id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `session_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `hito_reached` enum('pagina_inicio','hito_2','hito_3','hito_4','hito_5','semanas') DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `staff_1_id` int(11) DEFAULT NULL,
  `staff_2_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `staff_3_id` int(11) DEFAULT NULL,
  `staff_4_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'scheduled'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `recording_sessions`
--

INSERT INTO `recording_sessions` (`id`, `assignment_id`, `session_date`, `start_time`, `end_time`, `hito_reached`, `notes`, `staff_1_id`, `staff_2_id`, `created_at`, `staff_3_id`, `staff_4_id`, `status`) VALUES
(1, 1, '2026-05-07', '08:00:00', '10:00:00', '', NULL, NULL, NULL, '2026-05-07 14:53:44', NULL, NULL, 'scheduled'),
(2, 2, '2026-05-07', '08:00:00', '10:00:00', '', NULL, NULL, NULL, '2026-05-07 14:53:44', NULL, NULL, 'scheduled'),
(5, 5, '2026-05-23', '15:30:00', '20:00:00', '', 'CANCELADO', 21, NULL, '2026-05-18 13:34:13', NULL, NULL, 'scheduled'),
(6, 6, '2026-05-28', '10:00:00', '20:00:00', '', '', 21, 18, '2026-05-18 15:20:32', 22, 19, 'cancelled'),
(7, 7, '2026-05-22', '14:30:00', '17:00:00', '', '', 19, 23, '2026-05-18 15:32:07', NULL, NULL, 'scheduled'),
(10, 7, '2026-05-29', '14:30:00', '18:00:00', '', '', 19, 17, '2026-05-20 10:00:27', NULL, NULL, 'scheduled'),
(13, 6, '2026-05-29', '10:00:00', '12:00:00', '', '', 0, 0, '2026-05-20 17:52:40', NULL, NULL, 'cancelled'),
(14, 10, '2026-05-27', '14:00:00', '19:00:00', '', '', 18, 22, '2026-05-21 08:53:35', NULL, NULL, 'cancelled'),
(24, 16, '2026-06-11', '17:00:00', '20:00:00', NULL, '', 17, 19, '2026-05-22 15:41:24', NULL, NULL, 'scheduled'),
(15, 5, '2026-05-24', '10:00:00', '17:00:00', NULL, '', 17, 15, '2026-05-22 12:39:11', NULL, NULL, 'scheduled'),
(17, 12, '2026-06-09', '10:00:00', '20:00:00', NULL, '', 18, 22, '2026-05-22 13:08:58', 18, 15, 'cancelled'),
(18, 12, '2026-06-10', '10:00:00', '12:00:00', NULL, NULL, NULL, NULL, '2026-05-22 13:08:58', NULL, NULL, 'cancelled'),
(19, 13, '2026-06-19', '10:00:00', '18:00:00', NULL, '', 18, 19, '2026-05-22 13:24:20', NULL, NULL, 'scheduled'),
(26, 17, '2026-06-30', '10:00:00', '12:00:00', NULL, NULL, NULL, NULL, '2026-05-25 13:19:20', NULL, NULL, 'scheduled'),
(25, 17, '2026-06-29', '10:00:00', '20:00:00', NULL, '', 21, 18, '2026-05-25 13:19:20', 18, 19, 'scheduled'),
(22, 15, '2026-06-03', '14:00:00', '19:00:00', NULL, '', 18, 15, '2026-05-22 15:08:35', NULL, NULL, 'scheduled'),
(37, 11, '2026-06-16', '14:30:00', '20:00:00', NULL, '', 23, 19, '2026-06-03 14:21:35', NULL, NULL, 'scheduled'),
(27, 18, '2026-06-03', '10:00:00', '13:00:00', NULL, '', 17, 21, '2026-05-25 14:17:47', NULL, NULL, 'scheduled'),
(28, 9, '2026-06-02', '14:00:00', '20:00:00', NULL, '', 22, 19, '2026-05-26 07:22:19', NULL, NULL, 'scheduled'),
(29, 10, '2026-06-08', '09:00:00', '12:30:00', NULL, '', 19, 21, '2026-05-27 12:13:42', NULL, NULL, 'cancelled'),
(30, 6, '2026-06-15', '09:30:00', '20:00:00', NULL, '', 18, 21, '2026-05-27 18:28:28', 18, 21, 'scheduled'),
(31, 6, '2026-06-16', '09:30:00', '12:00:00', NULL, '', NULL, NULL, '2026-05-27 18:28:44', NULL, NULL, 'scheduled'),
(34, 8, '2026-06-25', '10:00:00', '20:00:00', NULL, '', 18, 23, '2026-05-29 13:42:02', 23, 19, 'scheduled'),
(33, 20, '2026-06-10', '14:00:00', '20:00:00', NULL, '', 17, 15, '2026-05-28 15:32:04', NULL, NULL, 'scheduled'),
(35, 8, '2026-06-26', '10:00:00', '12:00:00', NULL, '', NULL, NULL, '2026-05-29 13:42:21', NULL, NULL, 'scheduled'),
(36, 9, '2026-06-11', '09:00:00', '16:00:00', NULL, '', 23, 21, '2026-06-02 15:12:50', 23, 15, 'scheduled'),
(38, 11, '2026-06-17', '14:30:00', '20:00:00', NULL, '', 19, 15, '2026-06-03 14:21:51', NULL, NULL, 'scheduled'),
(39, 10, '2026-06-17', '11:00:00', '12:30:00', NULL, 'Solo debe grabar Páginas de inicio y Preguntas reflexivas de los hitos 3 - 4 - 5', 22, 21, '2026-06-08 09:28:05', NULL, NULL, 'cancelled'),
(40, 10, '2026-06-23', '11:00:00', '13:00:00', NULL, '', 21, 19, '2026-06-16 06:34:43', NULL, NULL, 'scheduled'),
(41, 21, '2026-06-24', '14:00:00', '18:00:00', NULL, '', 18, 21, '2026-06-16 12:29:52', 18, 21, 'scheduled'),
(42, 13, '2026-07-01', '09:00:00', '12:00:00', NULL, '', 17, 15, '2026-06-19 10:59:30', NULL, NULL, 'scheduled'),
(43, 12, '2026-07-02', '09:30:00', '18:00:00', NULL, '', 19, 21, '2026-06-19 13:41:28', 17, 15, 'scheduled'),
(44, 12, '2026-07-03', '09:30:00', '13:30:00', NULL, '', NULL, NULL, '2026-06-19 13:41:59', NULL, NULL, 'scheduled'),
(45, 21, '2026-06-26', '14:00:00', '18:00:00', NULL, '', 18, 21, '2026-06-23 11:43:03', NULL, NULL, 'scheduled'),
(46, 21, '2026-07-01', '14:00:00', '17:00:00', NULL, 'Se grabo facilito 11 y facilitos hito 5', 21, 18, '2026-06-26 14:30:20', NULL, NULL, 'scheduled');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `reason` varchar(255) DEFAULT 'Reserva',
  `created_at` datetime DEFAULT current_timestamp(),
  `attendees` text DEFAULT NULL,
  `is_displacement` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `user_id`, `date`, `start_time`, `end_time`, `reason`, `created_at`, `attendees`, `is_displacement`) VALUES
(11, 2, '2026-05-14', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(20, 2, '2026-07-07', '13:30:00', '20:30:00', 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:37', '[]', 0),
(12, 2, '2026-05-15', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(13, 2, '2026-05-16', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(14, 2, '2026-05-14', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(15, 2, '2026-05-15', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(16, 2, '2026-05-16', '08:00:00', '10:00:00', 'Cuadro de Honor Cocha', '2026-05-11 13:32:19', NULL, 0),
(21, 2, '2026-07-08', '12:00:00', '20:30:00', 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:37', '[]', 0),
(18, 2, '2026-06-18', '08:00:00', '20:00:00', 'UNICEF', '2026-06-03 08:49:25', '[\"Ricardo Aguayo\"]', 0),
(22, 2, '2026-07-09', '12:00:00', '20:30:00', 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:37', '[]', 0),
(23, 2, '2026-07-10', '12:00:00', '12:30:00', 'FIIE FORO INTERNACIONAL', '2026-06-15 12:27:37', NULL, 0),
(24, 2, '2026-06-30', '12:00:00', '18:00:00', 'Unicef', '2026-06-23 13:47:30', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`id`, `name`, `is_active`, `created_at`) VALUES
(1, 'II-2026', 0, '2026-05-07 13:52:56'),
(2, 'VII', 1, '2026-07-03 09:05:47');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `key` varchar(100) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`key`, `value`) VALUES
('studio_start_time', '08:00'),
('studio_end_time', '18:00'),
('studio_days', '1,2,3,4,5');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT 'EXT',
  `name` varchar(255) NOT NULL,
  `subject_type` varchar(50) DEFAULT 'Teórica',
  `semester_id` int(11) NOT NULL,
  `completed` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `code`, `name`, `subject_type`, `semester_id`, `completed`, `created_at`) VALUES
(1079, 'PFO-711', 'Psicología Forense', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1075, 'MIN-711', 'Marketing Internacional (M1) (ICO)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1077, 'NIN-611', 'Negocios Internacionales (M1) (ICO)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1073, 'TPM-411', 'Teoría y Política Monetaria (CPU)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1071, 'SIG-611', 'Sistemas Integrados de Gestión de la Calidad, Seguridad y Medio Ambiente (ICO)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1069, 'PEP-511', 'Preparación y Evaluación de Proyectos (CPU-ADM-ICO)', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1067, 'GTH-612', 'Gestión de Talento Humano II (ADM)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1065, 'CIN-611', 'Comercio Internacional (ICO-ADM)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1063, 'MDI-611', 'Marketing Digital (M2) (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1061, 'CCO-612', 'Comportamiento del Consumidor II (M2) (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1059, 'NTM-611', 'Nuevas Tendencias del Marketing (M2) (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1057, 'DAT-611', 'Derecho Aduanero y Tributario (DER)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1055, 'DTT-611', 'Derecho de Transporte y Telecomunicaciones (DER)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1053, 'PAD-611', 'Procedimientos Aduaneros (PAD)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1051, 'MVA-511', 'Mercado de valores (CPU)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1049, 'IND-611', 'Innovación y Negocio digitales (M1) (ICO)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1047, 'FCO-611', 'Finanzas Corporativas (M2) (CPU)', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1045, 'AGF-611', 'Asesoría y Gestión Financiera (M2) (CPU)', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1043, 'ACI-611', 'Análisis y Contabilidad Internacional (M2) (CPU)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1041, 'PII-612', 'Proyecto Integrador Intermedio II (PYM)', 'Proyecto Integrador', 1, 1, '2026-05-07 15:22:07'),
(1035, 'PII-612', 'Proyecto Integrador Intermedio II (ICO)', 'Proyecto Integrador', 1, 1, '2026-05-07 15:22:07'),
(1039, 'PII-612', 'Proyecto Integrador Intermedio II (CPU)', 'Proyecto Integrador', 1, 1, '2026-05-07 15:22:07'),
(1037, 'PII-612', 'Proyecto Integrador Intermedio II (ADM)', 'Proyecto Integrador', 1, 1, '2026-05-07 15:22:07'),
(1033, 'PII-612', 'Proyecto Integrador Intermedio II (DER)', 'Proyecto Integrador', 1, 1, '2026-05-07 15:22:07'),
(1031, 'IDE-611', 'Innovación y Desarrollo (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1029, 'GME-611', 'Gestión de Medios (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1027, 'MER-611', 'Merchandising', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1025, 'PAU-612', 'Producción Audiovisual II (PUB)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1023, 'DCI-615', 'Derecho Civil V (sucesiones) (DER)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1021, 'ARB-611', 'Arbitraje (DER)', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1019, 'PTR - 611', 'Planificación Tributaria', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1017, 'ACT - 611', 'Análisis y Contabilidad Tributaria', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1015, 'NMC-611', 'Negociación y Manejo de Conflictos', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1014, 'AUD-612', 'Auditoria II', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1013, 'IND - 611', 'Innovación y Negocio digitales', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1012, 'EEP-611', 'Estrategia Empresarial', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1011, 'CCO-611', 'Creatividad de contenidos', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1010, 'DEL-611', 'Derecho electoral', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1009, 'DAD-611', 'Derecho Administrativo', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1008, 'AIM-611', 'Auditoria impositiva', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1007, 'TIE-611', 'Taller de Incubadora de Empresas', 'Numérica', 1, 1, '2026-05-07 15:22:07'),
(1006, 'CEM.611', 'Competencias Emprendedoras', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1005, 'AME-611', 'Asesoramiento y Mentorización', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1004, 'PAP-611', 'Psicología Aplicada a la Publicidad', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1003, 'VCD-611', 'Ventas y Conversiones Digitales', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1002, 'NTP-611', 'Nuevas Tendencias de la Publicidad', 'Teórica', 1, 1, '2026-05-07 15:22:07'),
(1081, 'SED-711 (M-S)', 'Sistema Evaluación del Desempeño', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1082, 'DLC-711 (MC-S)', 'Dirección y Liderazgo Creativo', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1083, 'MDE-711 (M-S)', 'Inteligencia de Negocios', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1084, 'GET-711 (M-S)', 'Gerencia Estratégica', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1085, 'MPN-711 (M-S)', 'Modelo y Plan de Negocios', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1086, 'GMN-711 (MC-S)', 'Gestión de Mypes y Negocios Familiares', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1087, 'GRM-711 (M-S)', 'Gestión de Recursos Microfinancieros', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1088, 'ITE-711 (M-S)', 'Innovación y Tecnología', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1089, 'PGE-711 (C-S)', 'Política y Gerencia Empresarial', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1090, 'APR-711 (C-S)', 'Administración de Proyectos', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1091, 'MIN-711 (C-S)', 'Metodología de la Investigación', 'Práctica', 2, 0, '2026-07-03 09:05:47'),
(1092, 'PII-713 (P-S)', 'Proyecto Integrador Intermedio III', 'Práctica', 2, 0, '2026-07-03 09:05:47'),
(1093, 'AIM-712 (M-S)', 'M1. Auditoría Impositiva II', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1094, 'GTI-711 (M-S)', 'M1. Gestión Tributaria Internacional', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1095, 'GAT-711 (M-S)', 'M1. Gabinete de Auditoría Tributaria', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1096, 'AIN-711 (M-S)', 'M2. Auditoría Internacional', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1097, 'ERF-711 (MC-S)', 'M2. Evaluación de Riesgos Financieros', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1098, 'GAF-711 (M-S)', 'M2. Gabinete de Auditoría Financiera', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1099, 'TPF-411 (C-S)', 'Teoría y Política Fiscal', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1100, 'AFO-711 (P-S)', 'Auditoría Forense', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1101, 'GTE-711 (P-S)', 'Gerencia de Tesorería', 'Numérica', 2, 0, '2026-07-03 09:05:47'),
(1102, 'MIN-711 ((C-S)', 'Metodología de la Investigación', 'Práctica', 2, 0, '2026-07-03 09:05:47'),
(1103, 'FIN-711 (MC-S)', 'M1.Finanzas Internacionales', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1104, 'CIN-712(M-S)', 'M1.Comercio Internacional II', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1105, 'LCI-711(M-S)', 'M1. Legislación Comercial Internacional', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1106, 'BIN-711 (M-S)', 'M2. Business Intelligence', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1107, 'BTP-711 (M-S)', 'M2. Bases Tecnológicas y Plataformas Digitales', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1108, 'DPD-711 (M-S)', 'M2. Desarrollo de Productos Digitales', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1109, 'TME-711(P-S)', 'Tendencias de Mercado', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1110, 'NTM-611(MC-S)', 'Nuevas Tendencias del Marketing', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1111, 'APR-711(C-S)', 'Administración de Proyectos', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1112, 'MIN-711(C-S)', 'Metodología de la Investigación', 'Práctica', 2, 0, '2026-07-03 09:05:47'),
(1113, 'PII-713(P-S)', 'Proyecto Integrador Intermedio III', 'Práctica', 2, 0, '2026-07-03 09:05:47'),
(1114, 'DIP-711 (P-S)', 'Derecho Internacional Público', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1115, 'DMU-711 (P-S)', 'Derecho Municipal', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1116, 'CRI-711 (P-S)', 'Criminalística', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1117, 'DPC-711 (P-S)', 'Derecho Procesal Civil', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1118, 'DIN-711 (P-S)', 'Derecho Informático', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1119, 'DBS-711 (P-S)', 'Derecho Bancario y de Seguros', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1120, 'GCP-711(M-S)', 'Gestión Creativa Publicitaria', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1121, 'EDI-711(M-S)', 'Estrategias Digitales', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1122, 'BES-711(MC-S)', 'Branding Estratégico', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1123, 'TMA-711(M-S)', 'Trade Marketing', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1124, 'SMC-711(MC-S)', 'Social Media y Community Managament', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1125, 'EBU-711(M-S)', 'e-Business', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1126, 'GPR-711(C-S)', 'Gestión de Proyectos', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1127, 'RSE-711(P-S)', 'Responsabilidad Social Empresarial', 'Teórica', 2, 0, '2026-07-03 09:05:47'),
(1128, 'PAP-711(P-S)', 'Presupuestos Aplicados', 'Numérica', 2, 0, '2026-07-03 09:05:47');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_comments`
--

CREATE TABLE `teacher_comments` (
  `id` int(11) NOT NULL,
  `pending_teacher_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `teacher_comments`
--

INSERT INTO `teacher_comments` (`id`, `pending_teacher_id`, `user_id`, `parent_id`, `message`, `created_at`) VALUES
(2, 6, 2, NULL, 'Esta programado para el 28 y 29, la fecha 28 no se hace problema si es el primer vuelo de la mañana y el 29 seria hasta mas tardar medio dia su vuelo de retorno', '2026-05-18 15:24:21'),
(3, 5, 2, NULL, 'Docente Agendado para el viernes 22 por la tarde y viernes 29 por la tarde', '2026-05-18 15:34:52'),
(4, 4, 2, NULL, 'Se contacto y se realizo la reseva para el 1 y 2 de junio, dia y medio, proceder a la compra de pasajes', '2026-05-18 15:50:33'),
(6, 10, 2, NULL, 'Puede todos los dias a partir de las 5 o el 21 toda la mañana', '2026-05-20 13:04:41'),
(7, 9, 2, NULL, 'Dentro del 30 Mayo al 13 de Junio dispone de tiempo', '2026-05-20 13:22:31'),
(8, 12, 2, NULL, 'llamar a las 2 de la tarde', '2026-05-22 07:04:06'),
(9, 17, 16, NULL, 'Esta materia no tiene listos los guiones facilitos de semana.', '2026-05-28 08:10:26'),
(10, 11, 2, NULL, 'Esta revisando sus guiones, me contacte pero ella me llamara despues de hacer los ajustes', '2026-05-28 16:52:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','post_productor','academica') NOT NULL DEFAULT 'academica',
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `name`, `created_at`) VALUES
(12, 'angy', '$2y$10$PvuHSzIwyoNRkSmfVH8vDuMlQ6c/vdycTTcXALc8sEFbAbhYQJIaS', 'academica', 'Angela Ramirez', '2026-05-11 15:40:51'),
(2, 'Israx', '$2y$10$7KjjCYgd8/A6WqDI2H/rTedDx8bhMsGwq8fVxpMOZy9vx/ApERYAW', 'admin', 'Israx', '2026-05-07 12:58:33'),
(9, 'vivi', '$2y$10$T6kaiRtlE4LLtKAUwOd.R.TuVw4YeE2P1LEOrGu1QcgCHQa1q898.', 'academica', 'Viviana Valda', '2026-05-11 14:48:12'),
(14, 'ntorrez', '$2y$10$Od1NdJcSU2/JG.wn0rB3OupVMr6ToDSSjL50sdWuGyW2CFTjhoVoq', 'academica', 'Ninoska Torrez', '2026-05-12 19:23:04'),
(23, 'richi', '$2y$10$2r5YL9ykpaDMEfi9EMliT.unA/iWrjCyhS1QH7qPmsHOdISCgtFNO', 'post_productor', 'Ricardo Aguayo', '2026-05-20 14:47:44'),
(8, 'gloria', '$2y$10$QA0LmlL.8rk0tYadpYyycODUQi.pAC0oWZYUTjArDra/lYHj8aaBa', 'academica', 'Gloria Ardaya', '2026-05-11 14:46:46'),
(11, 'zalaco', '$2y$10$Lz9ygxOTCltEHqTE3cSXquUXRhQWMzbj3xiJmPB5OgyRylQ1H1OfC', 'post_productor', 'Zalaco', '2026-05-11 14:54:32'),
(13, 'josesarzuri', '$2y$10$rKA9jkK8m1Kfubd9VetV3ukGlOHs1ilFYaYTzVAQ4I/yZT.92HlYq', 'academica', 'Jose Sarzuri', '2026-05-12 08:24:51'),
(15, 'mika', '$2y$10$uRkeBG3kvn7Fe4EQhuhBjeiVGOa/SZnQGxQ3WrQFPW8qLkL1Wf.Ji', 'post_productor', 'Mika Villanueva', '2026-05-13 14:20:03'),
(16, 'nayra', '$2y$10$FNHhKkVq3UjLEQg6ceFhVOyTqcDZlxX9uhYUv8U/Nl2Xtu78Jah4e', 'post_productor', 'Nayra Antezana', '2026-05-13 14:50:48'),
(17, 'felipao', '$2y$10$Usc.V/Xa3A/bE8aZcjYfVuvP8HGDaPDSz53ndUWbSJQsuJ/zgfT66', 'post_productor', 'Felipe Vizcarra', '2026-05-14 09:05:34'),
(18, 'diego', '$2y$10$ENQhEI4FDSVbj9prWaVGA.WluikxntuJjyMMEVqS9Hvh/fqbiXvDu', 'post_productor', 'Diego Alvarado', '2026-05-14 09:06:41'),
(19, 'moi', '$2y$10$A6eZiZA7NjsNFncS2mBKYu8Qxl3lfhmjncIBaZu2rzFfzcGFgofia', 'post_productor', 'Moises Luna', '2026-05-14 09:36:32'),
(20, 'alan', '$2y$10$VS1SdFntA9dJEyqbI/My3OTVavbf1e2aFTx4FGfYtonraHfcz3jYy', 'admin', 'Alan Mendoza', '2026-05-14 09:36:58'),
(21, 'rubi', '$2y$10$N3Va0jgX/lMQKuVztq4CAuKHzuxePEKQc2/2dRu7gYgbEaCRETJUi', 'post_productor', 'Rubi Monroy', '2026-05-14 13:21:39'),
(22, 'mica', '$2y$10$8wWvP1nN9NVTaPy9XOFCl.Hc8lp/OLPjfCfZBr9pTgxHiOFYaagS2', 'post_productor', 'Micaela Cornejo', '2026-05-20 14:46:06'),
(24, 'aybi', '$2y$10$iitygFFbITJlZdAwFe5WOetxQYZUDZPiPtPwJfBxp7S4DkuudOVWO', 'admin', 'Abraham Kondori', '2026-05-20 18:59:02');

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_sessions`
--

INSERT INTO `user_sessions` (`token`, `user_id`, `created_at`) VALUES
('6a594eb95456d5b3b26a021bdb964d08', 2, '2026-05-07 13:08:22'),
('977d0315fa022ae0e9d0f042773d5f1d', 2, '2026-05-07 13:10:33'),
('956373edb9c2846ca0d469965d83e8b07b273dbb49b0879e6e4bf8d3c54fbc8b', 14, '2026-05-20 12:22:19'),
('1dce12322060b2e8b494d913a7725294', 2, '2026-05-07 13:47:01'),
('eda02951b022b232376d69712f7f5e08', 2, '2026-05-07 13:47:01'),
('a4b3bd813188c9ee98b838a018916e4a', 3, '2026-05-07 14:37:40'),
('98def792887a97d6b73eca52e35f1dfa', 3, '2026-05-07 14:37:40'),
('3f5f36b2cd89abd8fd7d204a8ddaf6b9', 4, '2026-05-07 14:38:31'),
('a5031bb96df59a8e5b0befd513e892d1', 2, '2026-05-07 15:21:47'),
('464f6dfff35639b8d1ea6af163b82082', 2, '2026-05-07 15:21:47'),
('94a3019c5904ac7bbfce9084816739fa', 5, '2026-05-11 06:42:02'),
('09891e6f7f8a6e12dab80f212fe94815', 5, '2026-05-11 06:42:02'),
('7717393fcfa6806b406ad89c87a3237e', 2, '2026-05-11 08:05:44'),
('cd7c7c06862fe70d9cf9290cea3dedf7', 2, '2026-05-11 08:05:44'),
('f7bbddfe7ea4acdeb0d2863a5cbc8b7b', 7, '2026-05-11 13:20:14'),
('503ab82bdcb6ac2eb987ce151d94ca66', 7, '2026-05-11 13:20:14'),
('e7225bd96be0021746858393d8fa60cc8ee38eccea8869af89946be14ed057e0', 13, '2026-07-03 09:35:20'),
('1e45f514e9339dfc56d63e302e9e76b4', 13, '2026-05-12 08:44:51'),
('670da9789d86d7aad0f5194f4ba8198b', 2, '2026-05-12 19:21:53'),
('e9bfd15118c1f5dda808abbe8dae66a6', 2, '2026-05-12 19:21:53'),
('786de66e6daafab330ef6de400c81568', 14, '2026-05-13 06:59:33'),
('4825d1046c8099670c01b196da63bded', 14, '2026-05-13 06:59:33'),
('08baa5f37220c1687a8cc70e84247a6a', 14, '2026-05-13 07:04:49'),
('f8eb62fa35de037fb21545d7a7d5da5d', 14, '2026-05-13 07:04:49'),
('2a977a7667a79f4ff21a68b676835d64', 8, '2026-05-13 07:08:46'),
('e2cb9e928ebd86c8ae3d628ecdc38e93', 8, '2026-05-13 07:08:46'),
('6c19a1d652148ba0c444060023a0ce2bd6ea3b9279cf4c798342f020cb2b7d02', 15, '2026-06-29 15:08:29'),
('e2f01fa436ac690f48ee7bc8fee999a9', 15, '2026-05-13 14:22:09'),
('344e1854e6f75386c125cdf42f931edc', 12, '2026-05-14 05:37:36'),
('23db323d8958ceedcb2668587b1d7ccd', 12, '2026-05-14 05:37:36'),
('77dc88463adf4dd91f67797d09ab2ca13ac8180d24184219b718996185bdea6c', 2, '2026-05-14 08:11:14'),
('cf35c3ebf05f583e017e954f83f9d8ecc3a31783980fff92812fe7bbcd27f896', 16, '2026-05-14 08:11:44'),
('4fad592be04860d6e2d188106ebb8c886868711bf6a0309f53fac1159348dd0f', 16, '2026-05-14 08:11:44'),
('e3e4ae7dd84bdda30a9f5507225844056c678815b3082cf4e0bed7751bd21009', 17, '2026-05-14 09:07:14'),
('0b6403b508b0f3108f984baadf1074c8ebf907689d775796c73201e520c275fd', 18, '2026-05-14 09:17:40'),
('f3fc501d5a39be83651d9847284edfa66ffdf1ab8670d201afafdd2f1585b725', 19, '2026-05-14 09:38:31'),
('a7df76b712eceaca7dace6f856f76be35a6ff7495bc71b95a3f1c302f54f93c8', 21, '2026-05-14 13:47:29'),
('91f174891510644be0846f1f7d45cc187836d7b526798d4b5ea0fae574b6ed62', 17, '2026-05-15 08:53:22'),
('066977e540e340a53adc4ecca825d17aae620e0b5046070e1b433a1dbf4b9dde', 16, '2026-05-18 10:11:39'),
('6503af2b7fd1c0cc3b0f2a27dcf9e4e1b2d92a0ff0968ed2f9af6624db244ec0', 2, '2026-05-18 10:49:48'),
('3d0dee62aeb973d585c1f947c5ac892f5b9c9c4080d5f61aa29bc5e025af79ac', 14, '2026-05-19 06:10:48'),
('8d45eef2d87330d7c9a1a8ff2164a7a68f82ad97a55e6d46cc58555f656df6c0', 13, '2026-05-19 13:30:46'),
('91df81ceaf070f95d658dffbd7e9562ccc90998ea3f6c0e59fcad1e2dc3f6b9a', 14, '2026-05-19 14:06:15'),
('8248e9f3e17f6c6280687e14c33a4d2accc26bec34d536f604206b446319a64d', 14, '2026-05-20 10:02:24'),
('dc17207b488c083a860fd76e5618f704763545e371c1185ddb55078b52bb0151', 6, '2026-05-20 12:48:18'),
('2174b28f93d5e695e8a4d8ed278c03d37d6003a065a42a8841165429b24e484d', 23, '2026-05-20 14:48:35'),
('ba716b4cd0d153d21898c2064f041781288339fc67743883a320b0287ff2531a', 23, '2026-05-20 14:50:00'),
('4e69844b065d16d49245e1693b6ed97bbc91418976c0ed3b4f33e1d6440853ed', 17, '2026-05-20 17:29:31'),
('6908107b378ef93b393934c5e9e5e28af91ecb896873580c529159267a232ea8', 22, '2026-05-22 13:26:16'),
('2b51dd0459892a534d67e80134fc000f09cf4a852cc753ea069fb1ed8746a4f4', 23, '2026-05-22 14:35:59'),
('24145e2e199e4af73ebbb3cc272d09b1060fbc6002884ee711f9b3f2dd5797ad', 15, '2026-05-22 19:22:06'),
('24558f75be7add14f14158a66d8583b54e89fa86b041ac124d32f1e9730819c4', 11, '2026-05-26 07:39:14'),
('00548c0c6b3c3174b20f59dd995e2206c6ba8baa61cad3bbd145dcd273857996', 19, '2026-05-26 13:49:59'),
('371bd1a8bac65b177b577e095328b68d4471c450563936e7b92c6432679b5a46', 2, '2026-05-26 17:17:53'),
('35da096d46a1e761bb83a478286ffd6d9902e7d1ca24d1f2be84cae286681526', 2, '2026-05-26 18:21:40'),
('ff2aef7f2e4f083bf023f22a3e4f585c0a6eb2d1ea6db4cdee41fbb7004d6114', 22, '2026-05-26 19:57:35'),
('45b993c6cdb48f5926caa2f2b344c6d4565095bffd19aa4dee83222775c460d4', 2, '2026-05-27 10:55:00'),
('52d2cbacadd246e568a37c809c80201f78f01c413a5f7ae29c61af371f1769a9', 2, '2026-05-27 11:50:36'),
('6e920f8542ee048dbe7a6fe836867ab1c47302d79297b1f615719b4b013b6919', 12, '2026-05-28 14:52:29'),
('0493fbb71783c5196cd3009c0ec2c211cb8f69e113160dd0b74904c026a69004', 12, '2026-06-01 08:06:34'),
('b9023ac929d17819bf19b2b1851ae2e11a4955a1e5f2966ad767945d8650e97e', 9, '2026-06-02 07:59:15'),
('6c6ce9d40fbc97a4ed2eeb31dfc640dde687d4a3e12f986f658ae7d6dad25757', 22, '2026-06-02 11:51:43'),
('81b1e7b77f1803ce386ef6dd59bc332117e480244c97be70a8e16a7ac89492f6', 22, '2026-06-07 18:52:05'),
('77f42f9102f7ad90d4114209a94530220b4e349eb46b0e57b37cba462917912e', 21, '2026-06-08 06:15:14'),
('4b7adb8ba4e9e6df0e41ee9b31bfb93f7494c570fc87565491cd6daefc4666b7', 21, '2026-06-08 06:25:44'),
('c8ff8f53358d487cc798b795939d02e245068ea38dc08edb65c241e7b66424f2', 17, '2026-06-08 08:54:38'),
('82922e330badc4c468384245557e2589e9ec7bfbd036b35185ce1a6619936e1b', 2, '2026-06-09 10:49:57'),
('712326891255b098e54936582fcc936c0ff458deef5b2a6adb2ce407f94cbf0f', 21, '2026-06-11 06:31:30'),
('3fbbb81be39643d17a73b3d490276cb8b0323836e2a834aa39658d2fe950905a', 21, '2026-06-15 06:04:43'),
('55139df92e6e44f625bb2a64719166816698c4ae6710afce6cb79ee122a1f2f8', 21, '2026-06-15 06:49:56'),
('df5cd45b7177d0cb87f16918c22fdf96b3f618ea77d222c8f3351b16de44aa3c', 2, '2026-06-15 12:26:28'),
('2ca02e595a7bc4ca562d2d814e7432a12a791aacbcf18ae3d9e99793b32fe9f0', 12, '2026-06-15 16:07:19'),
('6ce54cb2c753817e0ecb490d8fa727f6d73e76c61d623d7293859de96e75809c', 18, '2026-06-29 04:57:42'),
('160c669cab7ebd1b00f379dfbd3f9f570cc62a0741872dfd4b6d349db5927e9d', 23, '2026-06-29 15:38:27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `closed_weeks`
--
ALTER TABLE `closed_weeks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `week_start` (`week_start`);

--
-- Indexes for table `filming_assignments`
--
ALTER TABLE `filming_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `global_subjects`
--
ALTER TABLE `global_subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`,`name`);

--
-- Indexes for table `meeting_requests`
--
ALTER TABLE `meeting_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `from_user_id` (`from_user_id`);

--
-- Indexes for table `pending_teachers`
--
ALTER TABLE `pending_teachers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by_user_id` (`added_by_user_id`),
  ADD KEY `semester_id` (`semester_id`);

--
-- Indexes for table `recording_sessions`
--
ALTER TABLE `recording_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `staff_1_id` (`staff_1_id`),
  ADD KEY `staff_2_id` (`staff_2_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_subject_idx` (`code`,`name`,`semester_id`),
  ADD KEY `semester_id` (`semester_id`);

--
-- Indexes for table `teacher_comments`
--
ALTER TABLE `teacher_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pending_teacher_id` (`pending_teacher_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=491;

--
-- AUTO_INCREMENT for table `closed_weeks`
--
ALTER TABLE `closed_weeks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `filming_assignments`
--
ALTER TABLE `filming_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `global_subjects`
--
ALTER TABLE `global_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `meeting_requests`
--
ALTER TABLE `meeting_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `pending_teachers`
--
ALTER TABLE `pending_teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `recording_sessions`
--
ALTER TABLE `recording_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1129;

--
-- AUTO_INCREMENT for table `teacher_comments`
--
ALTER TABLE `teacher_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
