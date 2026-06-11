SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `talkive_app`;
USE `talkive_app`;

-- --------------------------------------------------------
-- Tabel `users`
-- --------------------------------------------------------
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `preferred_language` varchar(100) DEFAULT NULL,
  `fcm_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabel `tutors`
-- --------------------------------------------------------
CREATE TABLE `tutors` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `certification` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `years_experience` int(11) NOT NULL,
  `fcm_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabel `slots`
-- --------------------------------------------------------
CREATE TABLE `slots` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tutor_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `price` int(11) NOT NULL,
  `level` varchar(255) DEFAULT NULL,
  `lesson_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'AVAILABLE',
  PRIMARY KEY (`id`),
  KEY `tutor_id` (`tutor_id`),
  CONSTRAINT `slots_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabel `bookings`
-- --------------------------------------------------------
CREATE TABLE `bookings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `slot_id` bigint(20) NOT NULL,
  `midtrans_order_id` varchar(255) DEFAULT NULL,
  `payment_status` enum('PENDING','PAID','LINK_SENT','COMPLETED') DEFAULT 'PENDING',
  `meeting_link` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `slot_id` (`slot_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Tabel `consultation_reports`
-- --------------------------------------------------------
CREATE TABLE `consultation_reports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `booking_id` bigint(20) NOT NULL,
  `session_summary` text DEFAULT NULL,
  `student_progress` text DEFAULT NULL,
  `strengths` text DEFAULT NULL,
  `weaknesses` text DEFAULT NULL,
  `improvement` text DEFAULT NULL,
  `recommendation` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  CONSTRAINT `consultation_reports_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;