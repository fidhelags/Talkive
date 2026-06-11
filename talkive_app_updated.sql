-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 11 Jun 2026 pada 04.07
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `talkive_app`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `slot_id` bigint(20) NOT NULL,
  `midtrans_order_id` varchar(255) DEFAULT NULL,
  `payment_status` enum('PENDING','PAID','LINK_SENT','COMPLETED') DEFAULT 'PENDING',
  `meeting_link` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `slot_id`, `midtrans_order_id`, `payment_status`, `meeting_link`, `created_at`) VALUES
(1, 1, 1, 'CSL-516EB62C', 'COMPLETED', 'https://meet.google.com/naq-yfyv-pwv', '2026-06-11 08:34:11'),
(2, 1, 4, 'CSL-25B6B89C', 'COMPLETED', 'https://meet.google.com/naq-yfyv-pwv', '2026-06-11 08:34:34');

-- --------------------------------------------------------

--
-- Struktur dari tabel `consultation_reports`
--

CREATE TABLE `consultation_reports` (
  `id` bigint(20) NOT NULL,
  `booking_id` bigint(20) NOT NULL,
  `session_summary` text DEFAULT NULL,
  `student_progress` text DEFAULT NULL,
  `strengths` text DEFAULT NULL,
  `weaknesses` text DEFAULT NULL,
  `improvement` text DEFAULT NULL,
  `recommendation` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `consultation_reports`
--

INSERT INTO `consultation_reports` (`id`, `booking_id`, `session_summary`, `student_progress`, `strengths`, `weaknesses`, `improvement`, `recommendation`, `created_at`) VALUES
(1, 1, 'Session Summary', 'Student Progreess', 'Strengths', 'Weakness', 'Improvement Plan', 'Recommendation', '2026-06-11 08:36:44'),
(2, 2, 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', '2026-06-11 08:43:53');

-- --------------------------------------------------------

--
-- Struktur dari tabel `slots`
--

CREATE TABLE `slots` (
  `id` bigint(20) NOT NULL,
  `tutor_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `price` int(11) NOT NULL,
  `level` varchar(255) DEFAULT NULL,
  `lesson_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'AVAILABLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `slots`
--

INSERT INTO `slots` (`id`, `tutor_id`, `date`, `start_time`, `end_time`, `price`, `level`, `lesson_type`, `description`, `duration`, `status`) VALUES
(1, 1, '2026-06-11', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'BOOKED'),
(2, 1, '2026-06-12', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'AVAILABLE'),
(3, 1, '2026-06-13', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'AVAILABLE'),
(4, 2, '2026-06-12', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'BOOKED'),
(5, 2, '2026-06-13', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE'),
(6, 2, '2026-06-14', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE'),
(7, 2, '2026-06-15', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tutors`
--

CREATE TABLE `tutors` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `certification` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `years_experience` int(11) NOT NULL,
  `fcm_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tutors`
--

INSERT INTO `tutors` (`id`, `name`, `email`, `password`, `certification`, `language`, `years_experience`, `fcm_token`, `created_at`) VALUES
(1, 'Ragil Tutor', 'ragil@gmail.com', '$2a$10$CnKnA6Lu66h5H5TLRE2EJujoVa7usae.UAKg8u6gwUPR134C3844O', 'IELTS 9.0', 'English', 8, NULL, '2026-06-11 08:26:04'),
(2, 'Rafly リヴァイ', 'rafly@gmail.com', '$2a$10$Nm2Ibeq6vhZig8WeJp4WqOXJlqm6gs1DpsRviSEWB4.y4ol0s1IYC', 'JLPT', 'Japanese', 11, NULL, '2026-06-11 08:30:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `preferred_language` varchar(255) DEFAULT NULL,
  `fcm_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `preferred_language`, `fcm_token`, `created_at`) VALUES
(1, 'Yudistira Ramadhan', 'yudis@gmail.com', '$2a$10$vt421dvUbIhvaRDQZYkMKOq8C13jkjWiuNgXpvjHf27UyBE2b1mZq', '', 'elASEtALTRqYt19wn2_2VW:APA91bEYft1w9ayrzyg805ILVR4ayOw9hyGuAAP4afi_u2nglbilGB5gtsFwVUWeuOEOQ50oFyg9_BunoZ4gZt9roBEToNwZJaS3C_Ca3seApSMf2GlVY0A', '2026-06-11 08:32:45'),
(2, 'Fidhela G. S.', 'fidhela@gmail.com', '$2a$10$e7Pl7A0jWP2.zGRLUrvnwOMCUpAc2qDVhW6CobQpAtoXnkWjNr/ga', NULL, NULL, '2026-06-11 08:32:59'),
(3, 'Fadhil ', 'fadhil@gmail.com', '$2a$10$p/a7R9PZqZWJ5ZcmBMeO5.sS8spBO0pr4xqfDje9zUR4.bhbmaVxy', NULL, NULL, '2026-06-11 08:33:20');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `slot_id` (`slot_id`);

--
-- Indeks untuk tabel `consultation_reports`
--
ALTER TABLE `consultation_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_id` (`booking_id`);

--
-- Indeks untuk tabel `slots`
--
ALTER TABLE `slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indeks untuk tabel `tutors`
--
ALTER TABLE `tutors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `consultation_reports`
--
ALTER TABLE `consultation_reports`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `slots`
--
ALTER TABLE `slots`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `tutors`
--
ALTER TABLE `tutors`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`id`);

--
-- Ketidakleluasaan untuk tabel `consultation_reports`
--
ALTER TABLE `consultation_reports`
  ADD CONSTRAINT `consultation_reports_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `slots`
--
ALTER TABLE `slots`
  ADD CONSTRAINT `slots_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
