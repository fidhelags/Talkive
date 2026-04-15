-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Des 2025 pada 18.02
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
-- Database: `counselling_app`
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
(28, 10, 29, 'CSL-50D2E9CD', 'COMPLETED', 'https://meet.google.com/twi-ymrq-cav', '2025-12-09 20:36:16'),
(29, 10, 31, 'CSL-21176DAD', 'COMPLETED', 'https://meet.google.com/twi-ymrq-cav', '2025-12-09 22:40:21'),
(30, 10, 32, 'CSL-ECFD4C00', 'COMPLETED', 'https://meet.google.com/twi-ymrq-cav', '2025-12-09 23:36:29');

-- --------------------------------------------------------

--
-- Struktur dari tabel `consultation_reports`
--

CREATE TABLE `consultation_reports` (
  `id` bigint(20) NOT NULL,
  `booking_id` bigint(20) NOT NULL,
  `diagnosis` varchar(255) DEFAULT NULL,
  `solution` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `consultation_reports`
--

INSERT INTO `consultation_reports` (`id`, `booking_id`, `diagnosis`, `solution`, `notes`, `created_at`) VALUES
(6, 28, 'wow', 'istirahat', '-', '2025-12-09 22:25:53'),
(13, 29, 'waduh', 'waduh', 'waduh', '2025-12-09 22:41:29'),
(15, 30, 'qoqqqqqqq', 'qoqqqqqqqq', 'qoqqqqqqq', '2025-12-09 23:52:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `psychiatrists`
--

CREATE TABLE `psychiatrists` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `str_number` varchar(255) NOT NULL,
  `specialization` varchar(255) NOT NULL,
  `years_experience` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `psychiatrists`
--

INSERT INTO `psychiatrists` (`id`, `name`, `email`, `password`, `str_number`, `specialization`, `years_experience`, `created_at`) VALUES
(7, 'admin', 'admin@gmail.com', '$2a$10$rc.Pz2r2JklX9ZenFVzGxuXyQmrzXs8HFNWQcq1cplWC/w7nu7I.S', '123456789', 'Mental Health', 5, '2025-11-29 09:18:12'),
(9, 'Muhammad Ragil Sahyuda ', 'mragilsahyuda@gmail.com', '$2a$10$mw/8wJ5RiGn7SJ22lpepQ.SgkTqIF9zELj3rkJTomvuDO.92FoP16', '0123456789', 'Mental Health', 4, '2025-11-30 20:38:43'),
(10, 'dela', 'dela123@gmail.com', '$2a$10$DfNSUK0s3JqcpBH6vdHloOgsXV56M5ekQUDJfOulL/xqHmKcIPiJO', '22233', 'mental ', 3, '2025-12-03 15:41:05');

-- --------------------------------------------------------

--
-- Struktur dari tabel `slots`
--

CREATE TABLE `slots` (
  `id` bigint(20) NOT NULL,
  `psychiatrist_id` bigint(20) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `price` int(11) NOT NULL,
  `status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `slots`
--

INSERT INTO `slots` (`id`, `psychiatrist_id`, `date`, `start_time`, `end_time`, `price`, `status`) VALUES
(28, 10, '2025-12-04', '23:43:00', '04:43:00', 90000, 'PASSED'),
(29, 9, '2025-12-09', '20:35:00', '22:36:00', 80000, 'BOOKED'),
(30, 9, '2025-12-10', '21:04:00', '22:04:00', 100000, 'AVAILABLE'),
(31, 9, '2025-12-09', '21:14:00', '22:21:00', 20000, 'PENDING'),
(32, 9, '2025-12-09', '23:34:00', '23:58:00', 70000, 'PENDING'),
(33, 9, '2025-12-13', '13:35:00', '14:35:00', 34000, 'AVAILABLE');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(10, 'yudis', 'yudis2610@gmail.com', '$2a$10$aV3lQixctj7L0HuCJbCu9eK3o5yGRqZll1L9j9Dm8iSqyC9rqzQWC', '2025-11-30 20:39:20'),
(11, 'admin', 'admin@gmail.com', '$2a$10$I9ydVtSp/rBHRQWtIUtBcOa2LNjaNBKbmxILL2eAR3tx.PXUTrl5S', '2025-12-03 15:44:54');

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
-- Indeks untuk tabel `psychiatrists`
--
ALTER TABLE `psychiatrists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `slots`
--
ALTER TABLE `slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `psychiatrist_id` (`psychiatrist_id`);

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
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT untuk tabel `consultation_reports`
--
ALTER TABLE `consultation_reports`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `psychiatrists`
--
ALTER TABLE `psychiatrists`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `slots`
--
ALTER TABLE `slots`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  ADD CONSTRAINT `slots_ibfk_1` FOREIGN KEY (`psychiatrist_id`) REFERENCES `psychiatrists` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
