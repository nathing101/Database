-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2023 at 03:20 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rental_kendaraan`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pengembalian_Kendaraan` (IN `p_ID_Peminjaman` INT, IN `p_Tanggal_Pengembalian` DATE)   BEGIN
  UPDATE Peminjaman SET Tanggal_Pengembalian = p_Tanggal_Pengembalian WHERE ID_Peminjaman = p_ID_Peminjaman;
  UPDATE Kendaraan SET Tersedia = TRUE WHERE ID_Kendaraan = (SELECT ID_Kendaraan FROM Peminjaman WHERE ID_Peminjaman = p_ID_Peminjaman);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `data_peminjaman`
-- (See below for the actual view)
--
CREATE TABLE `data_peminjaman` (
`ID_Peminjaman` int(11)
,`Tanggal_Peminjaman` date
,`Tanggal_Pengembalian` date
,`Total_Biaya` decimal(10,2)
,`Nama_Pelanggan_Depan` varchar(50)
,`Nama_Pelanggan_Belakang` varchar(50)
,`Merek` varchar(50)
,`Model` varchar(50)
,`Tahun` int(11)
,`Tarif_Sewa` decimal(10,2)
,`Tersedia` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `kendaraan`
--

CREATE TABLE `kendaraan` (
  `ID_Kendaraan` int(11) NOT NULL,
  `Merek` varchar(50) DEFAULT NULL,
  `Model` varchar(50) DEFAULT NULL,
  `Tahun` int(11) DEFAULT NULL,
  `Tarif_Sewa` decimal(10,2) DEFAULT NULL,
  `Tersedia` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `ID_Pelanggan` int(11) NOT NULL,
  `Nama_Depan` varchar(50) DEFAULT NULL,
  `Nama_Belakang` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Nomor_Telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `ID_Pembayaran` int(11) NOT NULL,
  `ID_Peminjaman` int(11) DEFAULT NULL,
  `Metode_Pembayaran` varchar(50) DEFAULT NULL,
  `Total_Pembayaran` decimal(10,2) DEFAULT NULL,
  `Tanggal_Pembayaran` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `ID_Peminjaman` int(11) NOT NULL,
  `ID_Pelanggan` int(11) DEFAULT NULL,
  `ID_Kendaraan` int(11) DEFAULT NULL,
  `Tanggal_Peminjaman` date DEFAULT NULL,
  `Tanggal_Pengembalian` date DEFAULT NULL,
  `Total_Biaya` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `Hitung_Total_Biaya` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
  DECLARE durasi INT;
  SET durasi = DATEDIFF(NEW.Tanggal_Pengembalian, NEW.Tanggal_Peminjaman);
  UPDATE Peminjaman SET Total_Biaya = durasi * (SELECT Tarif_Sewa FROM Kendaraan WHERE ID_Kendaraan = NEW.ID_Kendaraan) WHERE ID_Peminjaman = NEW.ID_Peminjaman;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `data_peminjaman`
--
DROP TABLE IF EXISTS `data_peminjaman`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data_peminjaman`  AS SELECT `p`.`ID_Peminjaman` AS `ID_Peminjaman`, `p`.`Tanggal_Peminjaman` AS `Tanggal_Peminjaman`, `p`.`Tanggal_Pengembalian` AS `Tanggal_Pengembalian`, `p`.`Total_Biaya` AS `Total_Biaya`, `pl`.`Nama_Depan` AS `Nama_Pelanggan_Depan`, `pl`.`Nama_Belakang` AS `Nama_Pelanggan_Belakang`, `k`.`Merek` AS `Merek`, `k`.`Model` AS `Model`, `k`.`Tahun` AS `Tahun`, `k`.`Tarif_Sewa` AS `Tarif_Sewa`, `k`.`Tersedia` AS `Tersedia` FROM ((`peminjaman` `p` join `pelanggan` `pl` on(`p`.`ID_Pelanggan` = `pl`.`ID_Pelanggan`)) join `kendaraan` `k` on(`p`.`ID_Kendaraan` = `k`.`ID_Kendaraan`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kendaraan`
--
ALTER TABLE `kendaraan`
  ADD PRIMARY KEY (`ID_Kendaraan`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`ID_Pelanggan`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`ID_Pembayaran`),
  ADD KEY `ID_Peminjaman` (`ID_Peminjaman`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`ID_Peminjaman`),
  ADD KEY `ID_Pelanggan` (`ID_Pelanggan`),
  ADD KEY `ID_Kendaraan` (`ID_Kendaraan`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`ID_Peminjaman`) REFERENCES `peminjaman` (`ID_Peminjaman`);

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`ID_Pelanggan`) REFERENCES `pelanggan` (`ID_Pelanggan`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`ID_Kendaraan`) REFERENCES `kendaraan` (`ID_Kendaraan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
