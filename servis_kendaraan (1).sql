-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2023 at 04:17 AM
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
-- Database: `servis_kendaraan`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_servis`
--

CREATE TABLE `detail_servis` (
  `ID_Detail_Servis` int(11) NOT NULL,
  `ID_Servis` int(11) NOT NULL,
  `ID_Suku_Cadang` int(11) NOT NULL,
  `Jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `detail_servis`
--
DELIMITER $$
CREATE TRIGGER `Update_Stok_Suku_Cadang` AFTER INSERT ON `detail_servis` FOR EACH ROW BEGIN
  UPDATE `Suku_Cadang`
  SET `Suku_Cadang`.`Stok` = `Suku_Cadang`.`Stok` - NEW.Jumlah
  WHERE `Suku_Cadang`.`ID_Suku_Cadang` = NEW.ID_Suku_Cadang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kendaraan`
--

CREATE TABLE `kendaraan` (
  `ID_Kendaraan` int(11) NOT NULL,
  `Merek` varchar(50) NOT NULL,
  `Tipe` varchar(50) NOT NULL,
  `Tahun_Produksi` int(11) NOT NULL,
  `Warna` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `ID_Pelanggan` int(11) NOT NULL,
  `Nama` varchar(100) NOT NULL,
  `Alamat` varchar(200) NOT NULL,
  `Telepon` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `servis`
--

CREATE TABLE `servis` (
  `ID_Servis` int(11) NOT NULL,
  `ID_Kendaraan` int(11) NOT NULL,
  `ID_Pelanggan` int(11) NOT NULL,
  `Tanggal_Servis` date NOT NULL,
  `Deskripsi_Kerusakan` text DEFAULT NULL,
  `Biaya_Servis` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `suku_cadang`
--

CREATE TABLE `suku_cadang` (
  `ID_Suku_Cadang` int(11) NOT NULL,
  `Nama` varchar(100) NOT NULL,
  `Harga` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_servis`
-- (See below for the actual view)
--
CREATE TABLE `view_servis` (
`ID_Servis` int(11)
,`Merek` varchar(50)
,`Tipe` varchar(50)
,`Nama_Pelanggan` varchar(100)
,`Tanggal_Servis` date
,`Deskripsi_Kerusakan` text
,`Biaya_Servis` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_servis`
--
DROP TABLE IF EXISTS `view_servis`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_servis`  AS SELECT `servis`.`ID_Servis` AS `ID_Servis`, `kendaraan`.`Merek` AS `Merek`, `kendaraan`.`Tipe` AS `Tipe`, `pelanggan`.`Nama` AS `Nama_Pelanggan`, `servis`.`Tanggal_Servis` AS `Tanggal_Servis`, `servis`.`Deskripsi_Kerusakan` AS `Deskripsi_Kerusakan`, `servis`.`Biaya_Servis` AS `Biaya_Servis` FROM ((`servis` join `kendaraan` on(`servis`.`ID_Kendaraan` = `kendaraan`.`ID_Kendaraan`)) join `pelanggan` on(`servis`.`ID_Pelanggan` = `pelanggan`.`ID_Pelanggan`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_servis`
--
ALTER TABLE `detail_servis`
  ADD PRIMARY KEY (`ID_Detail_Servis`),
  ADD KEY `ID_Servis` (`ID_Servis`),
  ADD KEY `ID_Suku_Cadang` (`ID_Suku_Cadang`);

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
-- Indexes for table `servis`
--
ALTER TABLE `servis`
  ADD PRIMARY KEY (`ID_Servis`),
  ADD KEY `ID_Kendaraan` (`ID_Kendaraan`),
  ADD KEY `ID_Pelanggan` (`ID_Pelanggan`);

--
-- Indexes for table `suku_cadang`
--
ALTER TABLE `suku_cadang`
  ADD PRIMARY KEY (`ID_Suku_Cadang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_servis`
--
ALTER TABLE `detail_servis`
  MODIFY `ID_Detail_Servis` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kendaraan`
--
ALTER TABLE `kendaraan`
  MODIFY `ID_Kendaraan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `ID_Pelanggan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `servis`
--
ALTER TABLE `servis`
  MODIFY `ID_Servis` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suku_cadang`
--
ALTER TABLE `suku_cadang`
  MODIFY `ID_Suku_Cadang` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_servis`
--
ALTER TABLE `detail_servis`
  ADD CONSTRAINT `detail_servis_ibfk_1` FOREIGN KEY (`ID_Servis`) REFERENCES `servis` (`ID_Servis`),
  ADD CONSTRAINT `detail_servis_ibfk_2` FOREIGN KEY (`ID_Suku_Cadang`) REFERENCES `suku_cadang` (`ID_Suku_Cadang`);

--
-- Constraints for table `servis`
--
ALTER TABLE `servis`
  ADD CONSTRAINT `servis_ibfk_1` FOREIGN KEY (`ID_Kendaraan`) REFERENCES `kendaraan` (`ID_Kendaraan`),
  ADD CONSTRAINT `servis_ibfk_2` FOREIGN KEY (`ID_Pelanggan`) REFERENCES `pelanggan` (`ID_Pelanggan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
