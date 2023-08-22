-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2023 at 04:07 AM
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
-- Database: `tracking_pengantaran_barang`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `ID_Barang` int(11) NOT NULL,
  `Nama_Barang` varchar(255) DEFAULT NULL,
  `Deskripsi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `informasi_pengantaran`
-- (See below for the actual view)
--
CREATE TABLE `informasi_pengantaran` (
`Nama_Barang` varchar(255)
,`Nama_Pengirim` varchar(255)
,`Nama_Penerima` varchar(255)
,`Tanggal_Kirim` date
,`Tanggal_Terima` date
);

-- --------------------------------------------------------

--
-- Table structure for table `penerima`
--

CREATE TABLE `penerima` (
  `ID_Penerima` int(11) NOT NULL,
  `Nama_Penerima` varchar(255) DEFAULT NULL,
  `Alamat_Penerima` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pengantaran`
--

CREATE TABLE `pengantaran` (
  `ID_Pengantaran` int(11) NOT NULL,
  `ID_Barang` int(11) DEFAULT NULL,
  `ID_Pengirim` int(11) DEFAULT NULL,
  `ID_Penerima` int(11) DEFAULT NULL,
  `Tanggal_Kirim` date DEFAULT NULL,
  `Tanggal_Terima` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `pengantaran`
--
DELIMITER $$
CREATE TRIGGER `Update_Jumlah_Barang` AFTER INSERT ON `pengantaran` FOR EACH ROW BEGIN
  UPDATE Barang
  SET Jumlah = Jumlah - 1
  WHERE ID_Barang = NEW.ID_Barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pengirim`
--

CREATE TABLE `pengirim` (
  `ID_Pengirim` int(11) NOT NULL,
  `Nama_Pengirim` varchar(255) DEFAULT NULL,
  `Alamat_Pengirim` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure for view `informasi_pengantaran`
--
DROP TABLE IF EXISTS `informasi_pengantaran`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasi_pengantaran`  AS SELECT `b`.`Nama_Barang` AS `Nama_Barang`, `p`.`Nama_Pengirim` AS `Nama_Pengirim`, `pn`.`Nama_Penerima` AS `Nama_Penerima`, `pa`.`Tanggal_Kirim` AS `Tanggal_Kirim`, `pa`.`Tanggal_Terima` AS `Tanggal_Terima` FROM (((`pengantaran` `pa` join `barang` `b` on(`pa`.`ID_Barang` = `b`.`ID_Barang`)) join `pengirim` `p` on(`pa`.`ID_Pengirim` = `p`.`ID_Pengirim`)) join `penerima` `pn` on(`pa`.`ID_Penerima` = `pn`.`ID_Penerima`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`ID_Barang`);

--
-- Indexes for table `penerima`
--
ALTER TABLE `penerima`
  ADD PRIMARY KEY (`ID_Penerima`);

--
-- Indexes for table `pengantaran`
--
ALTER TABLE `pengantaran`
  ADD PRIMARY KEY (`ID_Pengantaran`),
  ADD KEY `ID_Barang` (`ID_Barang`),
  ADD KEY `ID_Pengirim` (`ID_Pengirim`),
  ADD KEY `ID_Penerima` (`ID_Penerima`);

--
-- Indexes for table `pengirim`
--
ALTER TABLE `pengirim`
  ADD PRIMARY KEY (`ID_Pengirim`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pengantaran`
--
ALTER TABLE `pengantaran`
  ADD CONSTRAINT `pengantaran_ibfk_1` FOREIGN KEY (`ID_Barang`) REFERENCES `barang` (`ID_Barang`),
  ADD CONSTRAINT `pengantaran_ibfk_2` FOREIGN KEY (`ID_Pengirim`) REFERENCES `pengirim` (`ID_Pengirim`),
  ADD CONSTRAINT `pengantaran_ibfk_3` FOREIGN KEY (`ID_Penerima`) REFERENCES `penerima` (`ID_Penerima`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
