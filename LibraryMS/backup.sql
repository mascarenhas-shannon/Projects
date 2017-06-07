-- MySQL dump 10.13  Distrib 5.6.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: DBProject
-- ------------------------------------------------------
-- Server version	5.6.28-0ubuntu0.15.04.1

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `admin_id` int(11) unsigned NOT NULL,
  `admin_password` varchar(20) NOT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (111,'Yellow'),(212,'Green');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `author_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author_name` varchar(20) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Bonds, Jennifer'),(2,'Bolton, Jeanell'),(3,'Blanco, Richard'),(4,'Blake, Toni'),(5,'Black, Maggie K.'),(6,'Bickford-Smith, Cora'),(7,'Bennett, Jenn'),(8,'Nancy, Lee'),(9,'Oded, Berko'),(10,'Mark,Luo'),(12,'Peter');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book` (
  `book_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ISBN` int(11) unsigned NOT NULL,
  PRIMARY KEY (`book_id`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `book_details` (`ISBN`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (102,765432190),(2,1234567891),(3,1234567891),(4,1234567891),(5,1234567891),(6,1234567891),(7,1234567891),(8,1234567891),(9,1234567891),(10,1234567891),(11,1234567891),(12,1234567891),(13,1234567891),(14,1234567891),(15,1234567891),(16,1234567891),(17,1234567891),(18,1234567891),(19,1234567891),(20,1234567891),(101,1234567891),(21,1234567892),(22,1234567892),(23,1234567892),(24,1234567892),(25,1234567892),(26,1234567892),(27,1234567892),(28,1234567892),(29,1234567892),(30,1234567892),(31,1234567892),(32,1234567892),(33,1234567892),(34,1234567892),(35,1234567892),(36,1234567892),(37,1234567892),(38,1234567892),(39,1234567892),(40,1234567892),(41,1234567893),(42,1234567893),(43,1234567893),(44,1234567893),(45,1234567893),(46,1234567893),(47,1234567893),(48,1234567893),(49,1234567893),(50,1234567893),(51,1234567893),(52,1234567893),(53,1234567893),(54,1234567893),(55,1234567893),(56,1234567893),(57,1234567893),(58,1234567893),(59,1234567893),(60,1234567893),(61,1234567894),(62,1234567894),(63,1234567894),(64,1234567894),(65,1234567894),(66,1234567894),(67,1234567894),(68,1234567894),(69,1234567894),(70,1234567894),(71,1234567894),(72,1234567894),(73,1234567894),(74,1234567894),(75,1234567894),(76,1234567894),(77,1234567894),(78,1234567894),(79,1234567894),(80,1234567894),(81,1234567895),(82,1234567895),(83,1234567895),(84,1234567895),(85,1234567895),(86,1234567895),(87,1234567895),(88,1234567895),(89,1234567895),(90,1234567895),(91,1234567895),(92,1234567895),(93,1234567895),(94,1234567895),(95,1234567895),(96,1234567895),(97,1234567895),(98,1234567895),(99,1234567895),(100,1234567895);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_association`
--

DROP TABLE IF EXISTS `book_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book_association` (
  `book_id` int(11) unsigned NOT NULL,
  `library_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`book_id`,`library_id`),
  KEY `library_id` (`library_id`),
  CONSTRAINT `book_association_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
  CONSTRAINT `book_association_ibfk_2` FOREIGN KEY (`library_id`) REFERENCES `branches` (`library_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_association`
--

LOCK TABLES `book_association` WRITE;
/*!40000 ALTER TABLE `book_association` DISABLE KEYS */;
INSERT INTO `book_association` VALUES (2,1),(3,1),(4,1),(5,1),(21,1),(22,1),(23,1),(24,1),(25,1),(41,1),(42,1),(43,1),(44,1),(45,1),(61,1),(62,1),(63,1),(64,1),(65,1),(81,1),(82,1),(83,1),(84,1),(85,1),(101,1),(102,1),(6,2),(7,2),(8,2),(9,2),(10,2),(26,2),(27,2),(28,2),(29,2),(30,2),(46,2),(47,2),(48,2),(49,2),(50,2),(66,2),(67,2),(68,2),(69,2),(70,2),(86,2),(87,2),(88,2),(89,2),(90,2),(11,3),(12,3),(13,3),(14,3),(15,3),(31,3),(32,3),(33,3),(34,3),(35,3),(51,3),(52,3),(53,3),(54,3),(55,3),(71,3),(72,3),(73,3),(74,3),(75,3),(91,3),(92,3),(93,3),(94,3),(95,3),(16,4),(17,4),(18,4),(19,4),(20,4),(36,4),(37,4),(38,4),(39,4),(40,4),(56,4),(57,4),(58,4),(59,4),(60,4),(76,4),(77,4),(78,4),(79,4),(80,4),(96,5),(97,5),(98,5),(99,5),(100,5);
/*!40000 ALTER TABLE `book_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_details`
--

DROP TABLE IF EXISTS `book_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book_details` (
  `ISBN` int(11) unsigned NOT NULL,
  `title` varchar(50) NOT NULL,
  `author_id` int(11) unsigned NOT NULL,
  `publisher_id` int(11) unsigned NOT NULL,
  `published_date` date NOT NULL,
  PRIMARY KEY (`ISBN`),
  KEY `author_id` (`author_id`),
  KEY `publisher_id` (`publisher_id`),
  CONSTRAINT `book_details_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`),
  CONSTRAINT `book_details_ibfk_2` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_details`
--

LOCK TABLES `book_details` WRITE;
/*!40000 ALTER TABLE `book_details` DISABLE KEYS */;
INSERT INTO `book_details` VALUES (765432190,'Gone With The Wind',12,6,'2001-08-01'),(1234567891,'The Deep Water',1,1,'0000-00-00'),(1234567892,'The Sea Water',2,2,'0000-00-00'),(1234567893,'The Peach Water',3,3,'0000-00-00'),(1234567894,'The Ginger Water',1,1,'0000-00-00'),(1234567895,'The Black Water',2,2,'0000-00-00');
/*!40000 ALTER TABLE `book_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrow_a_book`
--

DROP TABLE IF EXISTS `borrow_a_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `borrow_a_book` (
  `borrow_id` bigint(20) unsigned NOT NULL,
  `book_id` int(11) unsigned NOT NULL,
  `reader_id` bigint(20) unsigned NOT NULL,
  `library_id` int(11) unsigned NOT NULL,
  `borrow_datetime` datetime NOT NULL,
  `due_date` date NOT NULL,
  `return_datetime` datetime DEFAULT NULL,
  `fine_paid_by_reader` float DEFAULT '0',
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`borrow_id`,`book_id`,`reader_id`,`library_id`),
  UNIQUE KEY `borrow_id` (`borrow_id`),
  KEY `book_id` (`book_id`),
  KEY `reader_id` (`reader_id`),
  KEY `library_id` (`library_id`),
  CONSTRAINT `borrow_a_book_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
  CONSTRAINT `borrow_a_book_ibfk_2` FOREIGN KEY (`reader_id`) REFERENCES `reader_details` (`reader_id`),
  CONSTRAINT `borrow_a_book_ibfk_3` FOREIGN KEY (`library_id`) REFERENCES `branches` (`library_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow_a_book`
--

LOCK TABLES `borrow_a_book` WRITE;
/*!40000 ALTER TABLE `borrow_a_book` DISABLE KEYS */;
INSERT INTO `borrow_a_book` VALUES (1,2,1,1,'2016-05-10 12:35:29','2016-05-30','2016-05-31 12:35:29',20,'INACTIVE'),(2,3,1,2,'2016-12-05 12:35:29','2016-12-25',NULL,0,'ACTIVE'),(24848997969559552,2,1,2,'2016-12-07 08:51:50','2016-12-27',NULL,0,'ACTIVE'),(24848997969559553,5,1,3,'2016-12-07 08:52:08','2016-12-27',NULL,0,'ACTIVE'),(24848997969559554,6,1,3,'2016-12-07 08:52:19','2016-12-27',NULL,0,'ACTIVE'),(24848997969559555,7,1,3,'2016-12-07 08:52:31','2016-12-27',NULL,0,'ACTIVE'),(24848997969559556,10,2,1,'2016-12-07 08:53:42','2016-12-27',NULL,0,'ACTIVE'),(24848997969559557,11,2,2,'2016-12-07 08:53:53','2016-12-27',NULL,0,'ACTIVE'),(24848997969559558,13,2,2,'2016-12-07 08:54:03','2016-12-27',NULL,0,'ACTIVE'),(24848997969559559,14,2,2,'2016-12-07 08:54:10','2016-12-27',NULL,0,'ACTIVE'),(24848997969559560,12,3,1,'2016-12-07 08:57:25','2016-12-27',NULL,0,'ACTIVE'),(24848997969559561,16,3,1,'2016-12-07 08:57:37','2016-12-27',NULL,0,'ACTIVE'),(24848997969559562,17,3,1,'2016-12-07 08:57:46','2016-12-27',NULL,0,'ACTIVE'),(24848997969559563,18,3,1,'2016-12-07 08:57:53','2016-12-27',NULL,0,'ACTIVE'),(24848997969559564,20,3,1,'2016-12-07 08:58:00','2016-12-27',NULL,0,'ACTIVE'),(24848997969559565,21,4,1,'2016-12-07 08:58:25','2016-12-27',NULL,0,'ACTIVE'),(24848997969559566,22,4,1,'2016-12-07 08:58:30','2016-12-27',NULL,0,'ACTIVE');
/*!40000 ALTER TABLE `borrow_a_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branches` (
  `library_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `library_name` varchar(30) NOT NULL,
  `library_location` varchar(50) NOT NULL,
  PRIMARY KEY (`library_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'NY Reading club','1855 Broadway'),(2,'Queens Reading Club','87 Manhattan Avenue'),(3,'Cafe Cabana Reading ','78 Thorne Street'),(4,'J L Institute of Soc','89 Jonathan Street'),(5,'NYIT Manhattan','26 w 61 st NY'),(6,'Riverside','Manhattan');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publishers`
--

DROP TABLE IF EXISTS `publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publishers` (
  `publisher_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `publisher_name` varchar(20) NOT NULL,
  `publisher_address` varchar(50) NOT NULL,
  PRIMARY KEY (`publisher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publishers`
--

LOCK TABLES `publishers` WRITE;
/*!40000 ALTER TABLE `publishers` DISABLE KEYS */;
INSERT INTO `publishers` VALUES (1,'Deep','3448, John F Kennedy Blvd'),(2,'Shanon','56, Columbia Avenue'),(3,'Niket','134, Liberty Avenue'),(4,'Chintan','56, Spruce Street'),(5,'Ravina','123, New Castle'),(6,'Delton ','CoronaPlaza,NY');
/*!40000 ALTER TABLE `publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reader_details`
--

DROP TABLE IF EXISTS `reader_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reader_details` (
  `reader_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reader_name` varchar(20) NOT NULL,
  `reader_address` varchar(50) NOT NULL,
  `phone_number` int(10) DEFAULT NULL,
  PRIMARY KEY (`reader_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reader_details`
--

LOCK TABLES `reader_details` WRITE;
/*!40000 ALTER TABLE `reader_details` DISABLE KEYS */;
INSERT INTO `reader_details` VALUES (1,'Deep Desai','3448 John F Kennedy Blvd',2147483647),(2,'Niket Sagar','56 Columbia Avenue',2147483647),(3,'Jenil Desai','89 New Castle',1323231113),(4,' Shannon M','68 New Florida',2147483647),(24848997969559567,'Amith D\'souza','Liberty Ave,NY',987654321),(24848997969559568,'Ajith D\'souza','111 Ave,Queens,NY',876543210),(24848997969559569,'Renita Crasto','112 Ave,Queens,NY',765432109),(24848997969559570,'Michelle Brown','113 Ave,Queens,NY',654321098),(24848997969559571,'George M','Al Nuzha,NJ',543209887),(24848997969559572,'Violet D','Flushing,NY',642359887);
/*!40000 ALTER TABLE `reader_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserve_a_book`
--

DROP TABLE IF EXISTS `reserve_a_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reserve_a_book` (
  `reserve_id` bigint(20) unsigned NOT NULL,
  `book_id` int(11) unsigned NOT NULL,
  `reader_id` bigint(20) unsigned NOT NULL,
  `reserve_datetime` datetime NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`reserve_id`,`book_id`,`reader_id`),
  UNIQUE KEY `reserve_id` (`reserve_id`),
  KEY `book_id` (`book_id`),
  KEY `reader_id` (`reader_id`),
  CONSTRAINT `reserve_a_book_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`),
  CONSTRAINT `reserve_a_book_ibfk_2` FOREIGN KEY (`reader_id`) REFERENCES `reader_details` (`reader_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserve_a_book`
--

LOCK TABLES `reserve_a_book` WRITE;
/*!40000 ALTER TABLE `reserve_a_book` DISABLE KEYS */;
INSERT INTO `reserve_a_book` VALUES (1,2,1,'2012-05-08 12:35:29','ACTIVE'),(2,2,2,'2012-05-09 12:35:29','ACTIVE'),(3,3,1,'2012-05-08 12:35:29','ACTIVE');
/*!40000 ALTER TABLE `reserve_a_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `total_number_of_copies`
--

DROP TABLE IF EXISTS `total_number_of_copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `total_number_of_copies` (
  `ISBN` int(11) unsigned NOT NULL,
  `library_id` int(11) unsigned NOT NULL,
  `no_of_copies` int(5) unsigned NOT NULL,
  PRIMARY KEY (`ISBN`,`library_id`),
  KEY `library_id` (`library_id`),
  CONSTRAINT `total_number_of_copies_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `book` (`ISBN`),
  CONSTRAINT `total_number_of_copies_ibfk_2` FOREIGN KEY (`library_id`) REFERENCES `branches` (`library_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `total_number_of_copies`
--

LOCK TABLES `total_number_of_copies` WRITE;
/*!40000 ALTER TABLE `total_number_of_copies` DISABLE KEYS */;
INSERT INTO `total_number_of_copies` VALUES (765432190,1,1),(1234567891,1,5),(1234567891,2,5),(1234567891,3,5),(1234567891,4,5),(1234567892,1,5),(1234567892,2,5),(1234567892,3,5),(1234567892,4,5),(1234567893,1,5),(1234567893,2,5),(1234567893,3,5),(1234567893,4,5),(1234567894,1,5),(1234567894,2,5),(1234567894,3,5),(1234567894,4,5),(1234567895,1,5),(1234567895,2,5),(1234567895,3,5),(1234567895,4,5);
/*!40000 ALTER TABLE `total_number_of_copies` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-07  9:38:13
