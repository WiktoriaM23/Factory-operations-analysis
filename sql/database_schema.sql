-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Wrz 30, 2026 at 06:00 PM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.2.12

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `factory_operations`
--
CREATE DATABASE IF NOT EXISTS `factory_operations` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `factory_operations`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dim_date`
--

DROP TABLE IF EXISTS `dim_date`;
CREATE TABLE `dim_date` (
  `date_id` date NOT NULL,
  `year` smallint(6) DEFAULT NULL,
  `month_no` tinyint(4) DEFAULT NULL,
  `month_name` varchar(12) DEFAULT NULL,
  `week_no` tinyint(4) DEFAULT NULL,
  `day_name` varchar(12) DEFAULT NULL,
  `is_weekend` tinyint(1) DEFAULT NULL,
  `production_status` varchar(12) DEFAULT NULL,
  `closure_reason` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dim_line`
--

DROP TABLE IF EXISTS `dim_line`;
CREATE TABLE `dim_line` (
  `line_id` varchar(3) NOT NULL,
  `line_name` varchar(50) DEFAULT NULL,
  `base_performance_factor` decimal(8,5) DEFAULT NULL,
  `variability` varchar(10) DEFAULT NULL,
  `weekday_schedule_probability` decimal(8,5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dim_product`
--

DROP TABLE IF EXISTS `dim_product`;
CREATE TABLE `dim_product` (
  `product_id` varchar(3) NOT NULL,
  `product_name` varchar(80) DEFAULT NULL,
  `product_group` varchar(30) DEFAULT NULL,
  `base_units_per_shift` int(11) DEFAULT NULL,
  `energy_kwh_per_unit` decimal(10,4) DEFAULT NULL,
  `base_defect_rate` decimal(10,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dim_shift`
--

DROP TABLE IF EXISTS `dim_shift`;
CREATE TABLE `dim_shift` (
  `shift_id` varchar(3) NOT NULL,
  `shift_name` varchar(20) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `performance_modifier` decimal(8,5) DEFAULT NULL,
  `defect_modifier` decimal(10,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dim_time_interval`
--

DROP TABLE IF EXISTS `dim_time_interval`;
CREATE TABLE `dim_time_interval` (
  `time_id` varchar(3) NOT NULL,
  `interval_start` time DEFAULT NULL,
  `interval_end` time DEFAULT NULL,
  `slot_no` tinyint(4) DEFAULT NULL,
  `shift_id` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fact_defect`
--

DROP TABLE IF EXISTS `fact_defect`;
CREATE TABLE `fact_defect` (
  `defect_id` varchar(10) NOT NULL,
  `production_id` varchar(10) NOT NULL,
  `defect_type` varchar(30) DEFAULT NULL,
  `severity` varchar(10) DEFAULT NULL,
  `defective_units` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fact_downtime`
--

DROP TABLE IF EXISTS `fact_downtime`;
CREATE TABLE `fact_downtime` (
  `downtime_id` varchar(10) NOT NULL,
  `downtime_event_id` varchar(12) NOT NULL,
  `production_id` varchar(10) NOT NULL,
  `downtime_cause` varchar(40) DEFAULT NULL,
  `downtime_minutes` decimal(6,2) DEFAULT NULL,
  `is_planned` tinyint(1) DEFAULT NULL,
  `impact_level` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fact_production`
--

DROP TABLE IF EXISTS `fact_production`;
CREATE TABLE `fact_production` (
  `production_id` varchar(10) NOT NULL,
  `date_id` date NOT NULL,
  `time_id` varchar(3) NOT NULL,
  `line_id` varchar(3) NOT NULL,
  `product_id` varchar(3) NOT NULL,
  `shift_id` varchar(3) NOT NULL,
  `interval_start_datetime` datetime NOT NULL,
  `interval_end_datetime` datetime NOT NULL,
  `planned_units` int(11) DEFAULT NULL,
  `produced_units` int(11) DEFAULT NULL,
  `downtime_minutes` decimal(6,2) DEFAULT NULL,
  `microstop_minutes` decimal(6,2) DEFAULT NULL,
  `defective_units` int(11) DEFAULT NULL,
  `energy_consumption_kwh` decimal(12,2) DEFAULT NULL,
  `production_plan_achievement` decimal(10,6) DEFAULT NULL,
  `defect_rate` decimal(10,6) DEFAULT NULL,
  `energy_per_unit` decimal(10,4) DEFAULT NULL,
  `operating_status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `dim_date`
--
ALTER TABLE `dim_date`
  ADD PRIMARY KEY (`date_id`);

--
-- Indeksy dla tabeli `dim_line`
--
ALTER TABLE `dim_line`
  ADD PRIMARY KEY (`line_id`);

--
-- Indeksy dla tabeli `dim_product`
--
ALTER TABLE `dim_product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indeksy dla tabeli `dim_shift`
--
ALTER TABLE `dim_shift`
  ADD PRIMARY KEY (`shift_id`);

--
-- Indeksy dla tabeli `dim_time_interval`
--
ALTER TABLE `dim_time_interval`
  ADD PRIMARY KEY (`time_id`);

--
-- Indeksy dla tabeli `fact_defect`
--
ALTER TABLE `fact_defect`
  ADD PRIMARY KEY (`defect_id`),
  ADD KEY `production_id` (`production_id`);

--
-- Indeksy dla tabeli `fact_downtime`
--
ALTER TABLE `fact_downtime`
  ADD PRIMARY KEY (`downtime_id`),
  ADD KEY `idx_dt_event` (`downtime_event_id`),
  ADD KEY `production_id` (`production_id`);

--
-- Indeksy dla tabeli `fact_production`
--
ALTER TABLE `fact_production`
  ADD PRIMARY KEY (`production_id`),
  ADD UNIQUE KEY `uq_line_interval` (`line_id`,`interval_start_datetime`),
  ADD KEY `idx_date` (`date_id`),
  ADD KEY `idx_product` (`product_id`),
  ADD KEY `time_id` (`time_id`),
  ADD KEY `shift_id` (`shift_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fact_defect`
--
ALTER TABLE `fact_defect`
  ADD CONSTRAINT `fact_defect_ibfk_1` FOREIGN KEY (`production_id`) REFERENCES `fact_production` (`production_id`);

--
-- Constraints for table `fact_downtime`
--
ALTER TABLE `fact_downtime`
  ADD CONSTRAINT `fact_downtime_ibfk_1` FOREIGN KEY (`production_id`) REFERENCES `fact_production` (`production_id`);

--
-- Constraints for table `fact_production`
--
ALTER TABLE `fact_production`
  ADD CONSTRAINT `fact_production_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `dim_date` (`date_id`),
  ADD CONSTRAINT `fact_production_ibfk_2` FOREIGN KEY (`time_id`) REFERENCES `dim_time_interval` (`time_id`),
  ADD CONSTRAINT `fact_production_ibfk_3` FOREIGN KEY (`line_id`) REFERENCES `dim_line` (`line_id`),
  ADD CONSTRAINT `fact_production_ibfk_4` FOREIGN KEY (`product_id`) REFERENCES `dim_product` (`product_id`),
  ADD CONSTRAINT `fact_production_ibfk_5` FOREIGN KEY (`shift_id`) REFERENCES `dim_shift` (`shift_id`);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
