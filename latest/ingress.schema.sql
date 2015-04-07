-- MySQL dump 10.13  Distrib 5.6.19, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ingress
-- ------------------------------------------------------
-- Server version	5.6.19-1~dotdeb.1

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
  `lat` float(8,6) DEFAULT NULL,
  `lon` float(8,6) DEFAULT NULL,
  PRIMARY KEY (`msgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cookies`
--

DROP TABLE IF EXISTS `cookies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cookies` (
  `playerguid` char(34) NOT NULL DEFAULT '',
  `cookie` text,
  `csrftoken` char(32) DEFAULT NULL,
  `team` char(5) DEFAULT NULL,
  `lastaccesstime` int(11) NOT NULL,
  `active` smallint(1) DEFAULT '0',
  `useragent` varchar(1024) DEFAULT 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17',
  PRIMARY KEY (`playerguid`),
  KEY `team` (`team`)
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
-- Table structure for table `hiddenups`
--

DROP TABLE IF EXISTS `hiddenups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hiddenups` (
  `msgts` int(11) NOT NULL,
  `portalgid` varchar(35) NOT NULL,
  `playerguid` char(34) NOT NULL DEFAULT '0',
  `resonatorid` char(36) NOT NULL,
  `resonatorlevel` tinyint(4) NOT NULL,
  PRIMARY KEY (`resonatorid`),
  KEY `msgts` (`msgts`),
  KEY `portalgid` (`portalgid`),
  KEY `playerguid` (`playerguid`),
  KEY `resonatorlevel` (`resonatorlevel`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `l0neutral`
--

DROP TABLE IF EXISTS `l0neutral`;
/*!50001 DROP VIEW IF EXISTS `l0neutral`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l0neutral` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l1blue`
--

DROP TABLE IF EXISTS `l1blue`;
/*!50001 DROP VIEW IF EXISTS `l1blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l1blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l1green`
--

DROP TABLE IF EXISTS `l1green`;
/*!50001 DROP VIEW IF EXISTS `l1green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l1green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l2blue`
--

DROP TABLE IF EXISTS `l2blue`;
/*!50001 DROP VIEW IF EXISTS `l2blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l2blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l2green`
--

DROP TABLE IF EXISTS `l2green`;
/*!50001 DROP VIEW IF EXISTS `l2green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l2green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l3blue`
--

DROP TABLE IF EXISTS `l3blue`;
/*!50001 DROP VIEW IF EXISTS `l3blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l3blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l3green`
--

DROP TABLE IF EXISTS `l3green`;
/*!50001 DROP VIEW IF EXISTS `l3green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l3green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l4blue`
--

DROP TABLE IF EXISTS `l4blue`;
/*!50001 DROP VIEW IF EXISTS `l4blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l4blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l4green`
--

DROP TABLE IF EXISTS `l4green`;
/*!50001 DROP VIEW IF EXISTS `l4green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l4green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l5blue`
--

DROP TABLE IF EXISTS `l5blue`;
/*!50001 DROP VIEW IF EXISTS `l5blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l5blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l5green`
--

DROP TABLE IF EXISTS `l5green`;
/*!50001 DROP VIEW IF EXISTS `l5green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l5green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l6blue`
--

DROP TABLE IF EXISTS `l6blue`;
/*!50001 DROP VIEW IF EXISTS `l6blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l6blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l6green`
--

DROP TABLE IF EXISTS `l6green`;
/*!50001 DROP VIEW IF EXISTS `l6green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l6green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l7blue`
--

DROP TABLE IF EXISTS `l7blue`;
/*!50001 DROP VIEW IF EXISTS `l7blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l7blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l7green`
--

DROP TABLE IF EXISTS `l7green`;
/*!50001 DROP VIEW IF EXISTS `l7green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l7green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l8blue`
--

DROP TABLE IF EXISTS `l8blue`;
/*!50001 DROP VIEW IF EXISTS `l8blue`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l8blue` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l8blueplayers`
--

DROP TABLE IF EXISTS `l8blueplayers`;
/*!50001 DROP VIEW IF EXISTS `l8blueplayers`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l8blueplayers` AS SELECT 
 1 AS `playerguid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `l8green`
--

DROP TABLE IF EXISTS `l8green`;
/*!50001 DROP VIEW IF EXISTS `l8green`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `l8green` AS SELECT 
 1 AS `portalgid`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `pos1` char(10) DEFAULT NULL,
  `pos2` char(10) DEFAULT NULL,
  KEY `pos1` (`pos1`),
  KEY `pos2` (`pos2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portaladdr`
--

DROP TABLE IF EXISTS `portaladdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portaladdr` (
  `portalgid` varchar(35) NOT NULL DEFAULT '',
  `portaltitle` varchar(255) NOT NULL DEFAULT '',
  `portaladdr` varchar(255) NOT NULL DEFAULT '',
  `latE6` int(10) NOT NULL,
  `lonE6` int(10) NOT NULL,
  PRIMARY KEY (`portalgid`),
  KEY `latE6` (`latE6`),
  KEY `lonE6` (`lonE6`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portallifetime`
--

DROP TABLE IF EXISTS `portallifetime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portallifetime` (
  `portalgid` varchar(35) NOT NULL DEFAULT '',
  `team` char(5) DEFAULT NULL,
  `captime` int(11) NOT NULL,
  `losttime` int(11) DEFAULT '0',
  PRIMARY KEY (`captime`),
  KEY `portalgid` (`portalgid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portals`
--

DROP TABLE IF EXISTS `portals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portals` (
  `lat` float(8,6) DEFAULT NULL,
  `lon` float(8,6) DEFAULT NULL,
  `portalgid` varchar(35) NOT NULL DEFAULT '',
  `team` char(5) DEFAULT NULL,
  `captime` int(11) NOT NULL,
  `capplid` char(34) DEFAULT NULL,
  `lastupd` int(11) NOT NULL,
  PRIMARY KEY (`portalgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxies`
--

DROP TABLE IF EXISTS `proxies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proxies` (
  `ip` char(34) NOT NULL DEFAULT '127.0.0.1',
  `port` char(5) DEFAULT NULL,
  `lastaccesstime` int(11) NOT NULL,
  `active` smallint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qk`
--

DROP TABLE IF EXISTS `qk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qk` (
  `qk` varchar(16) NOT NULL DEFAULT '',
  `minLatE6` int(8) DEFAULT NULL,
  `minLngE6` int(8) DEFAULT NULL,
  `maxLatE6` int(8) DEFAULT NULL,
  `maxLngE6` int(8) DEFAULT NULL,
  PRIMARY KEY (`qk`),
  KEY `minLatE6` (`minLatE6`),
  KEY `maxLatE6` (`maxLatE6`),
  KEY `maxLngE6` (`maxLngE6`),
  KEY `minLngE6` (`minLngE6`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resonators`
--

DROP TABLE IF EXISTS `resonators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resonators` (
  `id` char(36) NOT NULL DEFAULT '',
  `portalgid` varchar(35) NOT NULL DEFAULT '',
  `slot` tinyint(4) NOT NULL DEFAULT '0',
  `level` tinyint(4) DEFAULT NULL,
  `energy` smallint(6) DEFAULT NULL,
  `dist` tinyint(4) DEFAULT NULL,
  `ownguid` char(34) DEFAULT NULL,
  PRIMARY KEY (`slot`,`portalgid`),
  KEY `level` (`level`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resxm`
--

DROP TABLE IF EXISTS `resxm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resxm` (
  `level` tinyint(4) DEFAULT NULL,
  `energy` smallint(6) DEFAULT NULL,
  KEY `energy` (`energy`),
  KEY `level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shields`
--

DROP TABLE IF EXISTS `shields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shields` (
  `portalgid` varchar(35) NOT NULL DEFAULT '',
  `slot` tinyint(4) NOT NULL DEFAULT '0',
  `mitigation` tinyint(4) DEFAULT NULL,
  `ownguid` char(34) DEFAULT NULL,
  PRIMARY KEY (`slot`,`portalgid`),
  KEY `portalgid` (`portalgid`),
  KEY `slot` (`slot`),
  KEY `mitigation` (`mitigation`),
  KEY `ownguid` (`ownguid`)
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
  `latE6` int(10) NOT NULL,
  `lngE6` int(10) NOT NULL,
  PRIMARY KEY (`msgid`),
  KEY `playerguid` (`playerguid`),
  KEY `eventtype` (`eventtype`),
  KEY `portalgid` (`portalgid`),
  KEY `resonatorlevel` (`resonatorlevel`),
  KEY `msgts` (`msgts`),
  KEY `team` (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `l0neutral`
--

/*!50001 DROP VIEW IF EXISTS `l0neutral`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l0neutral` AS select `portals`.`portalgid` AS `portalgid` from `portals` where (`portals`.`team` = 'NEUTR') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l1blue`
--

/*!50001 DROP VIEW IF EXISTS `l1blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l1blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 0 and 1.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l1green`
--

/*!50001 DROP VIEW IF EXISTS `l1green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l1green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 0 and 1.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l2blue`
--

/*!50001 DROP VIEW IF EXISTS `l2blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l2blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 1.99 and 2.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l2green`
--

/*!50001 DROP VIEW IF EXISTS `l2green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l2green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 1.99 and 2.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l3blue`
--

/*!50001 DROP VIEW IF EXISTS `l3blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l3blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 2.99 and 3.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l3green`
--

/*!50001 DROP VIEW IF EXISTS `l3green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l3green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 2.99 and 3.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l4blue`
--

/*!50001 DROP VIEW IF EXISTS `l4blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l4blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 3.99 and 4.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l4green`
--

/*!50001 DROP VIEW IF EXISTS `l4green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l4green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 3.99 and 4.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l5blue`
--

/*!50001 DROP VIEW IF EXISTS `l5blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l5blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 4.99 and 5.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l5green`
--

/*!50001 DROP VIEW IF EXISTS `l5green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l5green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 4.99 and 5.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l6blue`
--

/*!50001 DROP VIEW IF EXISTS `l6blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l6blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 5.99 and 6.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l6green`
--

/*!50001 DROP VIEW IF EXISTS `l6green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l6green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 5.99 and 6.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l7blue`
--

/*!50001 DROP VIEW IF EXISTS `l7blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l7blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 6.99 and 7.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l7green`
--

/*!50001 DROP VIEW IF EXISTS `l7green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l7green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 6.99 and 7.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l8blue`
--

/*!50001 DROP VIEW IF EXISTS `l8blue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l8blue` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'RESIS')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 7.99 and 8.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l8blueplayers`
--

/*!50001 DROP VIEW IF EXISTS `l8blueplayers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l8blueplayers` AS select distinct `syscomm`.`playerguid` AS `playerguid` from `syscomm` where ((`syscomm`.`resonatorlevel` = 8) and (`syscomm`.`team` = 'RESIS') and (`syscomm`.`eventtype` = 'resdeploy')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `l8green`
--

/*!50001 DROP VIEW IF EXISTS `l8green`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `l8green` AS select `r`.`portalgid` AS `portalgid` from (`resonators` `r` join `portals` `p`) where ((`p`.`portalgid` = convert(`r`.`portalgid` using utf8)) and (`p`.`team` = 'ALIEN')) group by `r`.`portalgid` having ((sum(`r`.`level`) / 8) between 7.99 and 8.99) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-28 12:43:24
