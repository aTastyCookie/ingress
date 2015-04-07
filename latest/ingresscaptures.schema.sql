-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ingresscaptures
-- ------------------------------------------------------
-- Server version	5.5.38-0+wheezy1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `capturetable`
--

DROP TABLE IF EXISTS `capturetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `capturetable` (
  `msgts` int(11),
  `team` char(5) NOT NULL,
  `playerguid` char(34) NOT NULL DEFAULT '0',
  `portalgid` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comm`
--

DROP TABLE IF EXISTS `comm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comm` (
  `msgid` varchar(35) NOT NULL DEFAULT '',
  `msgts` int(11) NOT NULL,
  `team` char(5) DEFAULT NULL,
  `plextType` char(16) DEFAULT NULL,
  `playerguid` char(34) NOT NULL DEFAULT '0',
  `text` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`msgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guids`
--

DROP TABLE IF EXISTS `guids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guids` (
  `nickname` char(50) DEFAULT '0',
  `guid` char(34) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`),
  KEY `nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `syscomm`
--

DROP TABLE IF EXISTS `syscomm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `syscomm` (
  `msgid` char(34) NOT NULL DEFAULT '',
  `msgts` int(11) NOT NULL,
  `team` char(5) NOT NULL,
  `plextType` char(16) DEFAULT NULL,
  `playerguid` char(34) NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `eventtype` varchar(16) DEFAULT NULL,
  `resonatorlevel` int(1) DEFAULT NULL,
  `portalgid` varchar(35) NOT NULL,
  PRIMARY KEY (`msgid`),
  KEY `playerguid` (`playerguid`),
  KEY `eventtype` (`eventtype`),
  KEY `portalgid` (`portalgid`),
  KEY `resonatorlevel` (`resonatorlevel`),
  KEY `msgts` (`msgts`),
  KEY `team` (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-28 12:46:11
