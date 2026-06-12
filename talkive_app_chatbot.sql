-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2026 at 05:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
-- Table structure for table `bookings`
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
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `slot_id`, `midtrans_order_id`, `payment_status`, `meeting_link`, `created_at`) VALUES
(1, 1, 1, 'CSL-516EB62C', 'COMPLETED', 'https://meet.google.com/naq-yfyv-pwv', '2026-06-11 08:34:11'),
(2, 1, 4, 'CSL-25B6B89C', 'COMPLETED', 'https://meet.google.com/naq-yfyv-pwv', '2026-06-11 08:34:34'),
(3, 4, 8, 'CSL-8A020D17', 'PENDING', NULL, '2026-06-11 18:20:48');

-- --------------------------------------------------------

--
-- Table structure for table `chat_histories`
--

CREATE TABLE `chat_histories` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `tutor_id` bigint(20) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `mode` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_histories`
--

INSERT INTO `chat_histories` (`id`, `user_id`, `tutor_id`, `sender`, `message`, `mode`, `language`, `created_at`) VALUES
(1, NULL, NULL, 'USER', 'teach me about probability in math subject', 'general', 'English', '2026-06-12 06:54:18'),
(2, NULL, NULL, 'USER', 'teach me about probability in math subject', 'general', 'English', '2026-06-12 06:54:53'),
(3, NULL, NULL, 'BOT', 'Hi there! I’d be happy to help. \n\n**Probability** is the branch of math that measures how likely an event is to happen. \n\nHere are the basics:\n\n### 1. The Scale\nProbability is always expressed as a number between **0 and 1** (or 0% to 100%):\n*   **0 (0%):** Impossible (e.g., rolling a 7 on a standard 6-sided die).\n*   **0.5 (50%):** An even chance (e.g., flipping a coin and getting heads).\n*   **1 (100%):** Certain (e.g., pulling a red marble out of a bag filled only with red marbles).\n\n### 2. The Formula\n$$\\text{Probability} = \\frac{\\text{Number of favorable outcomes}}{\\text{Total number of possible outcomes}}$$\n\n### 3. Quick Example\nIf you roll a standard 6-sided die, what is the probability of rolling a **4**?\n*   **Favorable outcome:** Only 1 way to roll a 4.\n*   **Total possible outcomes:** 6 (numbers 1 through 6).\n*   **Probability:** $\\frac{1}{6}$ (or about 16.7%).\n\nWould you like to try a practice problem together?', 'general', 'English', '2026-06-12 06:54:59'),
(4, NULL, NULL, 'USER', '.', 'general', 'English', '2026-06-12 07:20:13'),
(5, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:20:27'),
(6, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:32:02'),
(7, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:34:46'),
(8, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:51:37'),
(9, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:51:56'),
(10, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 07:56:02'),
(11, NULL, NULL, 'BOT', 'Hi there! I\'m your Talkive language learning assistant. How can I help you with your language studies today? We can practice speaking, work on grammar, build your vocabulary, or even do a fun roleplay!', 'general', 'English', '2026-06-12 07:56:05'),
(12, NULL, NULL, 'USER', 'can you teach me about math?', 'general', 'English', '2026-06-12 07:56:24'),
(13, NULL, NULL, 'USER', 'can you teach me about math?', 'general', 'English', '2026-06-12 07:57:27'),
(14, NULL, NULL, 'USER', 'ror', 'general', 'English', '2026-06-12 07:57:45'),
(15, NULL, NULL, 'USER', 'can you teach me about math?', 'general', 'English', '2026-06-12 07:57:54'),
(16, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 08:07:19'),
(17, NULL, NULL, 'USER', 'hi', 'general', 'English', '2026-06-12 08:12:05'),
(18, NULL, NULL, 'BOT', 'Hi there! Welcome to Talkive. I\'m your language learning assistant. \n\nHow can I help you with your English today? We can practice speaking, learn new vocabulary, review grammar, or try a fun roleplay!', 'general', 'English', '2026-06-12 08:12:10'),
(19, NULL, NULL, 'USER', 'can you teach me about math', 'general', 'English', '2026-06-12 08:12:17'),
(20, NULL, NULL, 'BOT', 'I\'m sorry, but I can\'t help you with math. As Talkive\'s language learning assistant, I focus strictly on language education, such as English grammar, vocabulary, pronunciation, and speaking practice. \n\nWould you like to practice your English conversation skills or work on some new vocabulary today?', 'general', 'English', '2026-06-12 08:12:20'),
(21, NULL, NULL, 'USER', 'what is the derivative of x^2-x+4', 'general', 'English', '2026-06-12 08:13:05'),
(22, NULL, NULL, 'BOT', 'I cannot help you with math problems, as I am strictly a language learning assistant. I can, however, help you with English grammar, vocabulary, speaking practice, or other language-related topics. \n\nIf you\'d like, we could practice how to discuss math concepts in English, or we can focus on any other language topic you prefer! What would you like to practice today?', 'general', 'English', '2026-06-12 08:13:07'),
(23, NULL, NULL, 'USER', 'chinese', 'general', 'English', '2026-06-12 08:29:09'),
(24, NULL, NULL, 'BOT', 'Hello! Are you interested in learning Chinese, or are you a native Chinese speaker looking to practice your English? \n\nI can help you with vocabulary, grammar, pronunciation, speaking practice, or roleplay in either language. Let me know how you would like to start!', 'general', 'English', '2026-06-12 08:29:12'),
(25, NULL, NULL, 'USER', 'how to say I love chinese culture', 'general', 'English', '2026-06-12 08:29:42'),
(26, NULL, NULL, 'BOT', 'To say \"I love Chinese culture\" in Mandarin Chinese, you can say:\n\n**我热爱中国文化。**\n* **Pinyin:** Wǒ rè\'ài Zhōngguó wénhuà.\n* **Literal meaning:** \"I passionately love Chinese culture.\"\n\nIf you want a slightly softer version (closer to \"I really like...\"), you can say:\n**我非常喜欢中国文化。**\n* **Pinyin:** Wǒ fēicháng xǐhuān Zhōngguó wénhuà.\n\nWould you like to practice pronouncing these phrases, or are you looking for different ways to express this in English?', 'general', 'English', '2026-06-12 08:29:45'),
(27, NULL, NULL, 'USER', 'how to say \"I love Machine Learning\"', 'general', 'English', '2026-06-12 08:36:24'),
(28, NULL, NULL, 'BOT', 'In English, you can say exactly that: **\"I love machine learning.\"** \n\nHere are a few other natural ways to express the same idea:\n*   **\"I\'m really into machine learning.\"** (Casual)\n*   **\"I have a passion for machine learning.\"** (More formal/enthusiastic)\n*   **\"I\'m fascinated by machine learning.\"** (Showcases deep interest)\n\nWould you like to practice pronouncing these, or do you want to learn how to say this phrase in a different language?', 'general', 'English', '2026-06-12 08:36:29'),
(29, NULL, NULL, 'USER', 'i want to learn chinese', 'general', 'English', '2026-06-12 08:45:57'),
(30, NULL, NULL, 'BOT', 'That is wonderful! I would love to help you start your Chinese learning journey. \n\nSince Chinese is a tonal language, a great place to begin is with **Pinyin** (the phonetic system) and the **four tones**, or we can start with some basic everyday vocabulary and greetings. \n\nHow would you like to begin? We can do a quick introductory lesson on greetings like \"Nǐ hǎo\" (Hello), or practice pronunciation!', 'general', 'English', '2026-06-12 08:45:59'),
(31, NULL, NULL, 'USER', 'how to say \"I love chinese culture\"', 'general', 'English', '2026-06-12 08:46:19'),
(32, NULL, NULL, 'BOT', 'In Chinese, you can say:\n\n**我热爱中国文化** \n* **Pinyin:** Wǒ rè\'ài Zhōngguó wénhuà.\n* **Literal translation:** \"I passionately love Chinese culture.\"\n\nIf you want a slightly more common, everyday version, you can say:\n**我喜欢中国文化**\n* **Pinyin:** Wǒ xǐhuān Zhōngguó wénhuà.\n* **Literal translation:** \"I like Chinese culture.\"\n\nWould you like to practice pronouncing these, or learn how to say this in another language?', 'general', 'English', '2026-06-12 08:46:23'),
(33, 4, NULL, 'USER', 'i want to learn chinese, how do i say \"I like this bike\"', 'general', 'English', '2026-06-12 08:47:32'),
(34, 4, NULL, 'BOT', 'In Chinese, you can say:\n\n**我喜欢这辆自行车。**\n*Pinyin:* Wǒ xǐhuan zhè liàng zìxíngchē.\n\nHere is a quick breakdown of the words:\n* **我 (wǒ)** = I\n* **喜欢 (xǐhuan)** = like\n* **这 (zhè)** = this\n* **辆 (liàng)** = (measure word for vehicles like bikes)\n* **自行车 (zìxíngchē)** = bicycle/bike\n\nWould you like to practice pronouncing these words, or should we look at how to write the characters?', 'general', 'English', '2026-06-12 08:47:35'),
(35, NULL, NULL, 'USER', 'I want to learn german, how do i say \"Salute!\"', 'general', 'English', '2026-06-12 08:50:03'),
(36, NULL, NULL, 'BOT', 'In German, how you say \"Salute!\" depends on the context:\n\n1. **As a toast (Cheers!):** You say **\"Prost!\"** (pronounced *prohst*) or **\"Zum Wohl!\"** (pronounced *tsoom vohl*).\n2. **As a casual greeting (like \"Hi\" or \"Hello\"):** You can use **\"Hallo!\"** or **\"Salü!\"** (commonly used in Switzerland and southwestern Germany).\n\nWhich one of these were you looking for? We can practice using it in a sentence!', 'general', 'English', '2026-06-12 08:50:07'),
(37, NULL, NULL, 'USER', 'i want to learn chinese, how do i say \"Salute!\"', 'general', 'English', '2026-06-12 08:54:04'),
(38, NULL, NULL, 'BOT', 'In Chinese, how you say \"Salute!\" depends on the context:\n\n*   **As a gesture of respect or a military salute:** 敬礼 (*jìng lǐ*)\n*   **As a toast (like \"Cheers!\" / \"Salute!\" in Italian):** 干杯 (*gān bēi* - literally \"dry cup\")\n*   **To pay tribute or express deep respect to someone:** 致敬 (*zhì jìng*)\n\nWhich one would you like to practice pronouncing today?', 'general', 'English', '2026-06-12 08:54:08'),
(39, NULL, 3, 'USER', 'i want to learn german, how do i say \"Salute!\"?', 'general', 'English', '2026-06-12 10:07:49'),
(40, NULL, 3, 'BOT', 'In German, how you say \"Salute!\" depends on the context:\n\n1. **As a toast (Cheers!):** \n   * **\"Prost!\"** (informal) or **\"Zum Wohl!\"** (more formal, literally \"to your health\").\n\n2. **As a wish for good health (when someone sneezes):** \n   * **\"Gesundheit!\"**\n\n3. **As a general greeting:** \n   * **\"Hallo!\"** (Hello) or **\"Guten Tag!\"** (Good day).\n\nWhich context were you thinking of? We can practice pronouncing them together!', 'general', 'English', '2026-06-12 10:07:54');

-- --------------------------------------------------------

--
-- Table structure for table `consultation_reports`
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
-- Dumping data for table `consultation_reports`
--

INSERT INTO `consultation_reports` (`id`, `booking_id`, `session_summary`, `student_progress`, `strengths`, `weaknesses`, `improvement`, `recommendation`, `created_at`) VALUES
(1, 1, 'Session Summary', 'Student Progreess', 'Strengths', 'Weakness', 'Improvement Plan', 'Recommendation', '2026-06-11 08:36:44'),
(2, 2, 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', '2026-06-11 08:43:53');

-- --------------------------------------------------------

--
-- Table structure for table `slots`
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
-- Dumping data for table `slots`
--

INSERT INTO `slots` (`id`, `tutor_id`, `date`, `start_time`, `end_time`, `price`, `level`, `lesson_type`, `description`, `duration`, `status`) VALUES
(1, 1, '2026-06-11', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'BOOKED'),
(2, 1, '2026-06-12', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'AVAILABLE'),
(3, 1, '2026-06-13', '19:00:00', '20:30:00', 145000, 'Intermediate', 'Conversation', 'Bussiness Conversation', 90, 'AVAILABLE'),
(4, 2, '2026-06-12', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'BOOKED'),
(5, 2, '2026-06-13', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE'),
(6, 2, '2026-06-14', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE'),
(7, 2, '2026-06-15', '12:00:00', '12:45:00', 100000, 'Beginner', 'Kids Learning', 'Story Telling', 45, 'AVAILABLE'),
(8, 3, '2026-06-18', '21:18:00', '22:03:00', 100000, 'Beginner', 'Conversation', 'English Conversation', 45, 'PENDING');

-- --------------------------------------------------------

--
-- Table structure for table `tutors`
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
-- Dumping data for table `tutors`
--

INSERT INTO `tutors` (`id`, `name`, `email`, `password`, `certification`, `language`, `years_experience`, `fcm_token`, `created_at`) VALUES
(1, 'Ragil Tutor', 'ragil@gmail.com', '$2a$10$CnKnA6Lu66h5H5TLRE2EJujoVa7usae.UAKg8u6gwUPR134C3844O', 'IELTS 9.0', 'English', 8, NULL, '2026-06-11 08:26:04'),
(2, 'Rafly リヴァイ', 'rafly@gmail.com', '$2a$10$Nm2Ibeq6vhZig8WeJp4WqOXJlqm6gs1DpsRviSEWB4.y4ol0s1IYC', 'JLPT', 'Japanese', 11, NULL, '2026-06-11 08:30:52'),
(3, 'Fadhil Tutor', 'fadhil1@gmail.com', '$2a$10$mUGGl6MTEU5HePJ3AhKkCuIXVGS7yn047LyBOri6biCd9UHI7.D4S', 'STR-123', 'English', 3, NULL, '2026-06-11 17:48:18');

-- --------------------------------------------------------

--
-- Table structure for table `users`
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
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `preferred_language`, `fcm_token`, `created_at`) VALUES
(1, 'Yudistira Ramadhan', 'yudis@gmail.com', '$2a$10$vt421dvUbIhvaRDQZYkMKOq8C13jkjWiuNgXpvjHf27UyBE2b1mZq', '', 'elASEtALTRqYt19wn2_2VW:APA91bEYft1w9ayrzyg805ILVR4ayOw9hyGuAAP4afi_u2nglbilGB5gtsFwVUWeuOEOQ50oFyg9_BunoZ4gZt9roBEToNwZJaS3C_Ca3seApSMf2GlVY0A', '2026-06-11 08:32:45'),
(2, 'Fidhela G. S.', 'fidhela@gmail.com', '$2a$10$e7Pl7A0jWP2.zGRLUrvnwOMCUpAc2qDVhW6CobQpAtoXnkWjNr/ga', NULL, NULL, '2026-06-11 08:32:59'),
(3, 'Fadhil ', 'fadhil@gmail.com', '$2a$10$p/a7R9PZqZWJ5ZcmBMeO5.sS8spBO0pr4xqfDje9zUR4.bhbmaVxy', NULL, NULL, '2026-06-11 08:33:20'),
(4, 'Fadhil Student', 'fadhil2@gmail.com', '$2a$10$2Ar3q7jxo7BAagUMUXxt8uIqM.oH3cp/TCQ00Yv0RjBinQvqGUVYG', NULL, NULL, '2026-06-11 18:20:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `slot_id` (`slot_id`);

--
-- Indexes for table `chat_histories`
--
ALTER TABLE `chat_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_chat_user` (`user_id`),
  ADD KEY `fk_chat_tutor` (`tutor_id`);

--
-- Indexes for table `consultation_reports`
--
ALTER TABLE `consultation_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_id` (`booking_id`);

--
-- Indexes for table `slots`
--
ALTER TABLE `slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `tutors`
--
ALTER TABLE `tutors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `chat_histories`
--
ALTER TABLE `chat_histories`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `consultation_reports`
--
ALTER TABLE `consultation_reports`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `slots`
--
ALTER TABLE `slots`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tutors`
--
ALTER TABLE `tutors`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `slots` (`id`);

--
-- Constraints for table `chat_histories`
--
ALTER TABLE `chat_histories`
  ADD CONSTRAINT `fk_chat_tutor` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_chat_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultation_reports`
--
ALTER TABLE `consultation_reports`
  ADD CONSTRAINT `consultation_reports_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `slots`
--
ALTER TABLE `slots`
  ADD CONSTRAINT `slots_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
