-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: pelaporan_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_user'),(22,'Can change user',6,'change_user'),(23,'Can delete user',6,'delete_user'),(24,'Can view user',6,'view_user'),(25,'Can add laporan',7,'add_laporan'),(26,'Can change laporan',7,'change_laporan'),(27,'Can delete laporan',7,'delete_laporan'),(28,'Can view laporan',7,'view_laporan'),(29,'Can add status history',8,'add_statushistory'),(30,'Can change status history',8,'change_statushistory'),(31,'Can delete status history',8,'delete_statushistory'),(32,'Can view status history',8,'view_statushistory'),(33,'Can add rating feedback',9,'add_ratingfeedback'),(34,'Can change rating feedback',9,'change_ratingfeedback'),(35,'Can delete rating feedback',9,'delete_ratingfeedback'),(36,'Can view rating feedback',9,'view_ratingfeedback'),(37,'Can add penanganan',10,'add_penanganan'),(38,'Can change penanganan',10,'change_penanganan'),(39,'Can delete penanganan',10,'delete_penanganan'),(40,'Can view penanganan',10,'view_penanganan'),(41,'Can add notifikasi',11,'add_notifikasi'),(42,'Can change notifikasi',11,'change_notifikasi'),(43,'Can delete notifikasi',11,'delete_notifikasi'),(44,'Can view notifikasi',11,'view_notifikasi'),(45,'Can add log aktivitas',12,'add_logaktivitas'),(46,'Can change log aktivitas',12,'change_logaktivitas'),(47,'Can delete log aktivitas',12,'delete_logaktivitas'),(48,'Can view log aktivitas',12,'view_logaktivitas'),(49,'Can add dokumentasi penanganan',13,'add_dokumentasipenanganan'),(50,'Can change dokumentasi penanganan',13,'change_dokumentasipenanganan'),(51,'Can delete dokumentasi penanganan',13,'delete_dokumentasipenanganan'),(52,'Can view dokumentasi penanganan',13,'view_dokumentasipenanganan');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(13,'app','dokumentasipenanganan'),(7,'app','laporan'),(12,'app','logaktivitas'),(11,'app','notifikasi'),(10,'app','penanganan'),(9,'app','ratingfeedback'),(8,'app','statushistory'),(6,'app','user'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-05-04 07:31:27.745966'),(2,'contenttypes','0002_remove_content_type_name','2026-05-04 07:31:27.777103'),(3,'auth','0001_initial','2026-05-04 07:31:27.903358'),(4,'auth','0002_alter_permission_name_max_length','2026-05-04 07:31:27.925134'),(5,'auth','0003_alter_user_email_max_length','2026-05-04 07:31:27.931020'),(6,'auth','0004_alter_user_username_opts','2026-05-04 07:31:27.931020'),(7,'auth','0005_alter_user_last_login_null','2026-05-04 07:31:27.941629'),(8,'auth','0006_require_contenttypes_0002','2026-05-04 07:31:27.941629'),(9,'auth','0007_alter_validators_add_error_messages','2026-05-04 07:31:27.950532'),(10,'auth','0008_alter_user_username_max_length','2026-05-04 07:31:27.953987'),(11,'auth','0009_alter_user_last_name_max_length','2026-05-04 07:31:27.981667'),(12,'auth','0010_alter_group_name_max_length','2026-05-04 07:31:27.996659'),(13,'auth','0011_update_proxy_permissions','2026-05-04 07:31:28.007550'),(14,'auth','0012_alter_user_first_name_max_length','2026-05-04 07:31:28.015740'),(15,'app','0001_initial','2026-05-04 07:31:28.377060'),(16,'admin','0001_initial','2026-05-04 07:31:28.424658'),(17,'admin','0002_logentry_remove_auto_add','2026-05-04 07:31:28.441333'),(18,'admin','0003_logentry_add_action_flag_choices','2026-05-04 07:31:28.455015'),(19,'sessions','0001_initial','2026-05-04 07:31:28.478449'),(20,'app','0002_alter_laporan_kategori','2026-05-28 08:31:41.027323'),(21,'app','0003_user_jabatan','2026-06-04 06:57:41.351746'),(22,'app','0004_remove_penanganan_petugas_penanganan_petugas','2026-06-06 07:11:29.791643');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('c40vwfqpea53lsig8z2x89ooj9t93c2t','.eJxVjDsOwjAQBe_iGlnxb2NT0nMGa-3d4ACypTipEHeHSCmgfTPzXiLitpa4dV7iTOIsQJx-t4T5wXUHdMd6azK3ui5zkrsiD9rltRE_L4f7d1Cwl2-dtcZgGdCjMRSSyqBZOWWzC1YjTx4BLA9Bo4WkDOtxnLwjsEoN3pB4fwDdejdB:1wLdlu:M65tQ9Onc6_TpF5AcPIinn7MtE7jjL2Ko7dZGvTtZEA','2026-05-23 09:14:54.079663'),('ccldc2s6rtrtlu1q4dxblu7me5zn4c2s','.eJxVjDsOgzAQBe_iOrKw8WdJmZ4zoPXuOiaJQMJQRbl7QKJI2pl5760G3NYybFWWYWR1VUZdfllCesp0CH7gdJ81zdO6jEkfiT5t1f3M8rqd7d9BwVr2ddNABywWCUxsPVuxLrvWBgc-MMQcPRCmJgOQMzG2HUMSH2nnQTKqzxfEwjdt:1wV33v:en99kFSgBLGZcbiTRo9R-zLqUx4-iB6ATnsalZ-GDWI','2026-06-18 08:04:23.168282'),('hwykb997aa9tk8249o06zej889fq2j2b','.eJxVjEsOwjAMBe-SNYrsNrFTluw5Q5TGLi2gROpnhbg7VOoCtm9m3svEtK1j3Bad4yTmbNicfrc-5YeWHcg9lVu1uZZ1nnq7K_agi71W0eflcP8OxrSM3xopUMCk1CijSIPoQRV6YQjkWsLAjI4IHEgHPAydh0ytIvshQWbz_gCx9zaI:1wLdaw:YXKdGzlqR0f-jz_-5ZtcpOyScisDtdNfv5qSdsiGw2w','2026-05-23 09:03:34.178472'),('juklacnloysbb1353g1l0l33i0gxbd0t','.eJxVjEEOwiAQRe_C2hCYlA64dO8ZyDCAVA0kpV013t026UK3_733N-FpXYpfe5r9FMVVgLj8boH4leoB4pPqo0ludZmnIA9FnrTLe4vpfTvdv4NCvey1QstsOSvlAoLRVmNGysGwQz0khIAJGOIIA6lgcsQ8wq4YQueSG8TnC95AN8A:1wMeBZ:CSpptkkcDbx4t-HpyYoI9hxFJlNkckKIastn2-F-xuo','2026-05-26 03:53:33.679415'),('ma5ex057s5qvpnxpbphueiawnjxij336','.eJxVjEEOwiAQRe_C2hCYlA64dO8ZyDCAVA0kpV013t026UK3_733N-FpXYpfe5r9FMVVgLj8boH4leoB4pPqo0ludZmnIA9FnrTLe4vpfTvdv4NCvey1QstsOSvlAoLRVmNGysGwQz0khIAJGOIIA6lgcsQ8wq4YQueSG8TnC95AN8A:1wOtcs:oVmopQuj-DVAt3OrCUwQ2apseaki93UmnJ66MTdN4OI','2026-06-01 08:47:02.316971'),('s56fckppgqi7fy652dnrdmafzy2fpiwl','.eJxVjMEOwiAQRP-FsyEsZQnr0bvfQGChUjWQlPbU-O-2SQ96m8x7M5vwYV2KX3ue_ZTEVaC4_HYx8CvXA6RnqI8mudVlnqI8FHnSLu8t5fftdP8OSuhlX4MDM1gEx5YyEowRSYFiBQyIoENOZNSwR8Ux8zjoBMYRaSAbEmjx-QKooDZy:1wLdbq:GJM9i3qgPDnpR9R6XV0KMZG6tizJmuc5LJuvjrwEa3Q','2026-05-23 09:04:30.216536'),('ug9dnqufb8k0p1teb0j98le6yr9huz59','.eJxVjEEOwiAQRe_C2hCGEgZcuvcMZIBBqgaS0q6Md9cmXej2v_f-SwTa1hq2wUuYszgLJ06_W6T04LaDfKd26zL1ti5zlLsiDzrktWd-Xg7376DSqN8avQY_RUOJnI7JFa8mMGDQAtisTQHl2WuHZBkdJiysrMoAGGkiZcT7A77kNuQ:1wMeHo:K5TnaVw-c0EBwSwg7LLwN3t771-ldfVEN0RX2ChM7EU','2026-05-26 04:00:00.110105'),('vmzph2mueb7arbgu3bfb3tjpgxw0v6w7','.eJxVjDsOgzAQBe_iOrKw8WdJmZ4zoPXuOiaJQMJQRbl7QKJI2pl5760G3NYybFWWYWR1VUZdfllCesp0CH7gdJ81zdO6jEkfiT5t1f3M8rqd7d9BwVr2ddNABywWCUxsPVuxLrvWBgc-MMQcPRCmJgOQMzG2HUMSH2nnQTKqzxfEwjdt:1wVkmX:cYfRzI6gRYyewQZqOojNYEpjGBsY9Y1DlgBIQ7PR0YY','2026-06-20 06:45:21.220729'),('z1qn3qxmu4y2t2rq61qw4vg4s8o3mc2r','.eJxVjDsOgzAQBe_iOrKw8WdJmZ4zoPXuOiaJQMJQRbl7QKJI2pl5760G3NYybFWWYWR1VUZdfllCesp0CH7gdJ81zdO6jEkfiT5t1f3M8rqd7d9BwVr2ddNABywWCUxsPVuxLrvWBgc-MMQcPRCmJgOQMzG2HUMSH2nnQTKqzxfEwjdt:1wPZ7i:pkNNnP0FnpoxafyrEIogoFGKMqGPhmLMOZDuMb949D0','2026-06-03 05:05:38.361832');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dokumentasi_penanganan`
--

DROP TABLE IF EXISTS `dokumentasi_penanganan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dokumentasi_penanganan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `foto` varchar(100) NOT NULL,
  `keterangan` varchar(200) DEFAULT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `penanganan_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dokumentasi_penanganan_penanganan_id_0d3d27d5_fk_penanganan_id` (`penanganan_id`),
  CONSTRAINT `dokumentasi_penanganan_penanganan_id_0d3d27d5_fk_penanganan_id` FOREIGN KEY (`penanganan_id`) REFERENCES `penanganan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dokumentasi_penanganan`
--

LOCK TABLES `dokumentasi_penanganan` WRITE;
/*!40000 ALTER TABLE `dokumentasi_penanganan` DISABLE KEYS */;
INSERT INTO `dokumentasi_penanganan` VALUES (1,'dokumentasi/images.jpg','sudah selesai di selesaikan masalah parkir liar','2026-05-09 07:31:26.391782',1),(2,'dokumentasi/pngtree-road-background-new-nice-trip-hd-wallpaper-image-picture-image_15598418.jpg','jalan sudah di bangun','2026-05-09 09:07:16.056481',2),(3,'dokumentasi/pngtree-road-background-new-nice-trip-hd-wallpaper-image-picture-image_15598_aTUiYzE.jpg','','2026-05-09 09:10:34.154359',3),(4,'dokumentasi/images_4Zsl0CR.jpg','','2026-05-09 09:14:04.670907',5),(5,'dokumentasi/0_E-bb96aSNeNcRAfI.jpg','','2026-05-09 09:14:54.842417',4),(6,'dokumentasi/images_rvu90LH.jpg','','2026-05-09 09:20:46.596161',6);
/*!40000 ALTER TABLE `dokumentasi_penanganan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laporan`
--

DROP TABLE IF EXISTS `laporan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `laporan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `judul` varchar(200) NOT NULL,
  `deskripsi` longtext NOT NULL,
  `kategori` varchar(30) NOT NULL,
  `status` varchar(20) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `alamat_kejadian` longtext DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `kadaluarsa_at` datetime(6) DEFAULT NULL,
  `pelapor_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `laporan_pelapor_id_ed1e7026_fk_user_id` (`pelapor_id`),
  CONSTRAINT `laporan_pelapor_id_ed1e7026_fk_user_id` FOREIGN KEY (`pelapor_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laporan`
--

LOCK TABLES `laporan` WRITE;
/*!40000 ALTER TABLE `laporan` DISABLE KEYS */;
INSERT INTO `laporan` VALUES (1,'Parkir liar','terjadi parkir liar di depan kos','KETERTIBAN','SELESAI',3.5400547,98.6246096,'jalan cempaka raya 1e','laporan/0_E-bb96aSNeNcRAfI.jpg','2026-05-09 05:40:20.510365','2026-05-09 07:31:45.921277',NULL,2),(2,'Jalan berlubang','Jalan nya banyak berlubang','LAINNYA','SELESAI',3.5382146,98.6236933,'Cempaka raya baru 1','laporan/IMG_20251014_150629.jpg','2026-05-09 09:01:10.701335','2026-05-09 09:07:26.082709',NULL,4),(3,'Chandra pelitttttttt','Chandra tidak mau membersihkan kos ku','LAINNYA','DITOLAK',3.5867533,98.6847949,'Kos cempaka','laporan/1000214757.jpg','2026-05-09 09:07:45.277642','2026-05-09 09:08:48.073854',NULL,5),(4,'Paret kotor','Paret terlalu kotor dan butuh di tindak lanjuti','LAINNYA','SELESAI',3.5811923,98.6338867,'Jalan cempaka raya no 1e kel. sempakata medan selayang','laporan/1000355237.jpg','2026-05-09 09:08:48.206654','2026-05-09 09:10:42.962072',NULL,6),(5,'Om makan gratis aja','Kamu nanyak','LAINNYA','SELESAI',3.5882823,98.6725305,'Jln cempaka raya','','2026-05-09 09:09:06.154940','2026-05-09 09:14:59.727814',NULL,7),(6,'Om makan gratis aja','Kamu nanyak','LAINNYA','SELESAI',3.5833000,98.6333000,'Sempakata','','2026-05-09 09:11:25.718918','2026-05-09 09:14:08.985265',NULL,7),(7,'Tawuran','Tawuran','KEAMANAN','SELESAI',3.5428052,98.6766368,'Kelurahan beringin','laporan/IMG-20251203-WA0003.jpeg','2026-05-09 09:17:55.871007','2026-05-09 09:20:57.568590',NULL,4),(8,'narkoba','narkoba','PENYAKIT_MSY','DITUGASKAN',3.5611237,98.6180985,'Asam Kumbang, Medan Selayang, City of Medan, North Sumatra, Sumatra, 20133, Indonesia','laporan/WhatsApp_Image_2026-05-06_at_13.05.52.jpeg','2026-06-04 08:02:56.490689','2026-06-06 10:12:52.603604',NULL,4);
/*!40000 ALTER TABLE `laporan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_aktivitas`
--

DROP TABLE IF EXISTS `log_aktivitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_aktivitas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `aksi` varchar(100) NOT NULL,
  `detail` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `log_aktivitas_user_id_13dd961c_fk_user_id` (`user_id`),
  CONSTRAINT `log_aktivitas_user_id_13dd961c_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_aktivitas`
--

LOCK TABLES `log_aktivitas` WRITE;
/*!40000 ALTER TABLE `log_aktivitas` DISABLE KEYS */;
INSERT INTO `log_aktivitas` VALUES (1,'Tambah User','User Doli dengan role PETUGAS dibuat','2026-05-05 06:09:32.675925',1),(2,'Membuat Laporan','Laporan #1: Parkir liar','2026-05-09 05:40:20.541224',2),(3,'Verifikasi Laporan','Laporan #1 diverifikasi','2026-05-09 05:41:36.391143',1),(4,'Assign Petugas','Laporan #1 ditugaskan ke Doli','2026-05-09 05:42:08.722833',1),(5,'Update Status','Laporan #1: Menuju Lokasi - ','2026-05-09 07:30:54.605835',3),(6,'Upload Dokumentasi','Dokumentasi untuk Penanganan #1','2026-05-09 07:31:26.406571',3),(7,'Update Status','Laporan #1: Diproses - ','2026-05-09 07:31:37.356654',3),(8,'Update Status','Laporan #1: Selesai - ','2026-05-09 07:31:45.939246',3),(9,'Memberikan Feedback','Feedback rating 5 untuk Laporan #1','2026-05-09 07:33:40.023963',2),(10,'Membuat Laporan','Laporan #2: Jalan berlubang','2026-05-09 09:01:10.716083',4),(11,'Verifikasi Laporan','Laporan #2 diverifikasi','2026-05-09 09:02:20.317031',1),(12,'Assign Petugas','Laporan #2 ditugaskan ke Doli','2026-05-09 09:02:37.669227',1),(13,'Update Status','Laporan #2: Menuju Lokasi - ','2026-05-09 09:05:28.006517',3),(14,'Update Status','Laporan #2: Diproses - ','2026-05-09 09:05:44.508554',3),(15,'Upload Dokumentasi','Dokumentasi untuk Penanganan #2','2026-05-09 09:07:16.073706',3),(16,'Update Status','Laporan #2: Selesai - ','2026-05-09 09:07:26.101976',3),(17,'Membuat Laporan','Laporan #3: Chandra pelitttttttt','2026-05-09 09:07:45.292685',5),(18,'Tolak Laporan','Laporan #3 ditolak: Laporan ditolak oleh admin, gak valid','2026-05-09 09:08:48.204640',1),(19,'Membuat Laporan','Laporan #4: Paret kotor','2026-05-09 09:08:48.359244',6),(20,'Verifikasi Laporan','Laporan #4 diverifikasi','2026-05-09 09:09:03.838066',1),(21,'Membuat Laporan','Laporan #5: Om makan gratis aja','2026-05-09 09:09:06.167272',7),(22,'Assign Petugas','Laporan #4 ditugaskan ke Doli','2026-05-09 09:09:10.048565',1),(23,'Update Status','Laporan #4: Menuju Lokasi - ','2026-05-09 09:09:56.275195',3),(24,'Upload Dokumentasi','Dokumentasi untuk Penanganan #3','2026-05-09 09:10:34.155005',3),(25,'Update Status','Laporan #4: Diproses - ','2026-05-09 09:10:39.097685',3),(26,'Update Status','Laporan #4: Selesai - ','2026-05-09 09:10:42.976496',3),(27,'Membuat Laporan','Laporan #6: Om makan gratis aja','2026-05-09 09:11:25.718918',7),(28,'Memberikan Feedback','Feedback rating 5 untuk Laporan #4','2026-05-09 09:11:33.044822',6),(29,'Verifikasi Laporan','Laporan #5 diverifikasi','2026-05-09 09:12:29.030955',1),(30,'Assign Petugas','Laporan #5 ditugaskan ke Doli','2026-05-09 09:12:36.257989',1),(31,'Verifikasi Laporan','Laporan #6 diverifikasi','2026-05-09 09:12:41.684661',1),(32,'Assign Petugas','Laporan #6 ditugaskan ke Doli','2026-05-09 09:12:49.606504',1),(33,'Update Status','Laporan #6: Menuju Lokasi - ','2026-05-09 09:13:51.704240',3),(34,'Update Status','Laporan #6: Diproses - ','2026-05-09 09:13:56.315700',3),(35,'Upload Dokumentasi','Dokumentasi untuk Penanganan #5','2026-05-09 09:14:04.687165',3),(36,'Update Status','Laporan #6: Selesai - ','2026-05-09 09:14:08.997954',3),(37,'Update Status','Laporan #5: Menuju Lokasi - ','2026-05-09 09:14:37.327190',3),(38,'Update Status','Laporan #5: Diproses - ','2026-05-09 09:14:42.308005',3),(39,'Upload Dokumentasi','Dokumentasi untuk Penanganan #4','2026-05-09 09:14:54.847423',3),(40,'Update Status','Laporan #5: Selesai - ','2026-05-09 09:14:59.740311',3),(41,'Membuat Laporan','Laporan #7: Tawuran','2026-05-09 09:17:55.888800',4),(42,'Verifikasi Laporan','Laporan #7 diverifikasi','2026-05-09 09:18:52.822868',1),(43,'Assign Petugas','Laporan #7 ditugaskan ke Doli','2026-05-09 09:19:48.319980',1),(44,'Update Status','Laporan #7: Menuju Lokasi - ','2026-05-09 09:20:13.773629',3),(45,'Update Status','Laporan #7: Diproses - ','2026-05-09 09:20:18.826885',3),(46,'Upload Dokumentasi','Dokumentasi untuk Penanganan #6','2026-05-09 09:20:46.601293',3),(47,'Update Status','Laporan #7: Selesai - ','2026-05-09 09:20:57.569860',3),(48,'Memberikan Feedback','Feedback rating 5 untuk Laporan #7','2026-05-09 09:22:15.310737',4),(49,'Memberikan Feedback','Feedback rating 5 untuk Laporan #2','2026-05-09 09:22:45.267948',4),(50,'Edit User','User Doli diupdate','2026-06-04 07:13:51.919521',1),(51,'Edit User','User Doli diupdate','2026-06-04 07:14:20.347143',1),(52,'Edit User','User Doli diupdate','2026-06-04 07:18:12.162170',1),(53,'Edit User','User Doli diupdate','2026-06-04 07:59:04.449960',1),(54,'Membuat Laporan','Laporan #8: narkoba','2026-06-04 08:02:56.509508',4),(55,'Verifikasi Laporan','Laporan #8 diverifikasi','2026-06-04 08:04:54.758945',1),(56,'Assign Petugas','Laporan #8 ditugaskan ke Doli','2026-06-04 08:05:19.548413',1),(57,'Assign Petugas','Laporan #8 ditugaskan ke 1 petugas: Doli','2026-06-06 10:09:30.789310',1),(58,'Assign Petugas','Laporan #8 ditugaskan ke 1 petugas: Doli','2026-06-06 10:12:52.653997',1),(59,'Tambah User','User lurah sempakata dengan role PETUGAS dibuat','2026-06-07 09:47:28.478813',1),(60,'Tambah User','User bahtiar damanik dengan role PETUGAS dibuat','2026-06-07 09:52:04.394072',1);
/*!40000 ALTER TABLE `log_aktivitas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifikasi`
--

DROP TABLE IF EXISTS `notifikasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifikasi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `judul` varchar(200) NOT NULL,
  `pesan` longtext NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notifikasi_user_id_b51eaed0_fk_user_id` (`user_id`),
  CONSTRAINT `notifikasi_user_id_b51eaed0_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifikasi`
--

LOCK TABLES `notifikasi` WRITE;
/*!40000 ALTER TABLE `notifikasi` DISABLE KEYS */;
INSERT INTO `notifikasi` VALUES (1,'Laporan Baru','Masyarakat wind membuat laporan: Parkir liar',0,'/admin/laporan/1/','2026-05-09 05:40:20.539209',1),(2,'Laporan Diverifikasi','Laporan \"Parkir liar\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/1/','2026-05-09 05:41:36.371498',2),(3,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Parkir liar',0,'/petugas/tugas/','2026-05-09 05:42:08.722833',3),(4,'Laporan Ditugaskan','Laporan \"Parkir liar\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/1/','2026-05-09 05:42:08.722833',2),(5,'Status Laporan Diperbarui','Laporan \"Parkir liar\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/1/','2026-05-09 07:30:54.600478',2),(6,'Status Laporan Diperbarui','Laporan \"Parkir liar\" status: Diproses. ',0,'/masyarakat/laporan/1/','2026-05-09 07:31:37.356654',2),(7,'Status Laporan Diperbarui','Laporan \"Parkir liar\" status: Selesai. ',0,'/masyarakat/laporan/1/','2026-05-09 07:31:45.937231',2),(8,'Laporan Baru','Masyarakat Habib membuat laporan: Jalan berlubang',0,'/admin/laporan/2/','2026-05-09 09:01:10.716083',1),(9,'Laporan Diverifikasi','Laporan \"Jalan berlubang\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/2/','2026-05-09 09:02:20.317031',4),(10,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Jalan berlubang',0,'/petugas/tugas/','2026-05-09 09:02:37.544208',3),(11,'Laporan Ditugaskan','Laporan \"Jalan berlubang\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/2/','2026-05-09 09:02:37.665869',4),(12,'Status Laporan Diperbarui','Laporan \"Jalan berlubang\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/2/','2026-05-09 09:05:27.994347',4),(13,'Status Laporan Diperbarui','Laporan \"Jalan berlubang\" status: Diproses. ',0,'/masyarakat/laporan/2/','2026-05-09 09:05:44.508554',4),(14,'Status Laporan Diperbarui','Laporan \"Jalan berlubang\" status: Selesai. ',0,'/masyarakat/laporan/2/','2026-05-09 09:07:26.101976',4),(15,'Laporan Baru','Masyarakat Maria Sitohang membuat laporan: Chandra pelitttttttt',0,'/admin/laporan/3/','2026-05-09 09:07:45.292685',1),(16,'Laporan Ditolak','Laporan \"Chandra pelitttttttt\" ditolak. Laporan ditolak oleh admin, gak valid',0,'/masyarakat/laporan/3/','2026-05-09 09:08:48.202962',5),(17,'Laporan Baru','Masyarakat Nomi membuat laporan: Paret kotor',0,'/admin/laporan/4/','2026-05-09 09:08:48.351917',1),(18,'Laporan Diverifikasi','Laporan \"Paret kotor\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/4/','2026-05-09 09:09:03.820652',6),(19,'Laporan Baru','Masyarakat Cris membuat laporan: Om makan gratis aja',0,'/admin/laporan/5/','2026-05-09 09:09:06.165212',1),(20,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Paret kotor',0,'/petugas/tugas/','2026-05-09 09:09:09.984181',3),(21,'Laporan Ditugaskan','Laporan \"Paret kotor\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/4/','2026-05-09 09:09:10.030429',6),(22,'Status Laporan Diperbarui','Laporan \"Paret kotor\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/4/','2026-05-09 09:09:56.275195',6),(23,'Status Laporan Diperbarui','Laporan \"Paret kotor\" status: Diproses. ',0,'/masyarakat/laporan/4/','2026-05-09 09:10:39.094486',6),(24,'Status Laporan Diperbarui','Laporan \"Paret kotor\" status: Selesai. ',0,'/masyarakat/laporan/4/','2026-05-09 09:10:42.962072',6),(25,'Laporan Baru','Masyarakat Cris membuat laporan: Om makan gratis aja',0,'/admin/laporan/6/','2026-05-09 09:11:25.718918',1),(26,'Laporan Diverifikasi','Laporan \"Om makan gratis aja\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/5/','2026-05-09 09:12:29.030955',7),(27,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Om makan gratis aja',0,'/petugas/tugas/','2026-05-09 09:12:36.208842',3),(28,'Laporan Ditugaskan','Laporan \"Om makan gratis aja\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/5/','2026-05-09 09:12:36.257989',7),(29,'Laporan Diverifikasi','Laporan \"Om makan gratis aja\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/6/','2026-05-09 09:12:41.669945',7),(30,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Om makan gratis aja',0,'/petugas/tugas/','2026-05-09 09:12:49.549552',3),(31,'Laporan Ditugaskan','Laporan \"Om makan gratis aja\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/6/','2026-05-09 09:12:49.580412',7),(32,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/6/','2026-05-09 09:13:51.700021',7),(33,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Diproses. ',0,'/masyarakat/laporan/6/','2026-05-09 09:13:56.315700',7),(34,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Selesai. ',0,'/masyarakat/laporan/6/','2026-05-09 09:14:08.985265',7),(35,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/5/','2026-05-09 09:14:37.327190',7),(36,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Diproses. ',0,'/masyarakat/laporan/5/','2026-05-09 09:14:42.308005',7),(37,'Status Laporan Diperbarui','Laporan \"Om makan gratis aja\" status: Selesai. ',0,'/masyarakat/laporan/5/','2026-05-09 09:14:59.740311',7),(38,'Laporan Baru','Masyarakat Habib membuat laporan: Tawuran',0,'/admin/laporan/7/','2026-05-09 09:17:55.886783',1),(39,'Laporan Diverifikasi','Laporan \"Tawuran\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/7/','2026-05-09 09:18:52.792643',4),(40,'Tugas Baru','Anda ditugaskan untuk menangani laporan: Tawuran',0,'/petugas/tugas/','2026-05-09 09:19:48.316122',3),(41,'Laporan Ditugaskan','Laporan \"Tawuran\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/7/','2026-05-09 09:19:48.319980',4),(42,'Status Laporan Diperbarui','Laporan \"Tawuran\" status: Menuju Lokasi. ',0,'/masyarakat/laporan/7/','2026-05-09 09:20:13.773629',4),(43,'Status Laporan Diperbarui','Laporan \"Tawuran\" status: Diproses. ',0,'/masyarakat/laporan/7/','2026-05-09 09:20:18.826885',4),(44,'Status Laporan Diperbarui','Laporan \"Tawuran\" status: Selesai. ',0,'/masyarakat/laporan/7/','2026-05-09 09:20:57.569860',4),(45,'Laporan Baru','Masyarakat Habib membuat laporan: narkoba',0,'/admin/laporan/8/','2026-06-04 08:02:56.507494',1),(46,'Laporan Diverifikasi','Laporan \"narkoba\" telah diverifikasi. Laporan telah diverifikasi oleh admin',0,'/masyarakat/laporan/8/','2026-06-04 08:04:54.758945',4),(47,'Tugas Baru','Anda ditugaskan untuk menangani laporan: narkoba',0,'/petugas/tugas/','2026-06-04 08:05:19.538309',3),(48,'Laporan Ditugaskan','Laporan \"narkoba\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/8/','2026-06-04 08:05:19.548413',4),(49,'Tugas Baru','Anda ditugaskan untuk menangani laporan: narkoba',0,'/petugas/tugas/','2026-06-06 10:09:30.742045',3),(50,'Laporan Ditugaskan','Laporan \"narkoba\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/8/','2026-06-06 10:09:30.782927',4),(51,'Tugas Baru','Anda ditugaskan untuk menangani laporan: narkoba',0,'/petugas/tugas/','2026-06-06 10:12:52.603604',3),(52,'Laporan Ditugaskan','Laporan \"narkoba\" telah ditugaskan ke petugas.',0,'/masyarakat/laporan/8/','2026-06-06 10:12:52.647421',4);
/*!40000 ALTER TABLE `notifikasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `penanganan`
--

DROP TABLE IF EXISTS `penanganan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `penanganan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `catatan` longtext DEFAULT NULL,
  `assigned_at` datetime(6) NOT NULL,
  `laporan_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `penanganan_laporan_id_6f778a48_fk_laporan_id` (`laporan_id`),
  CONSTRAINT `penanganan_laporan_id_6f778a48_fk_laporan_id` FOREIGN KEY (`laporan_id`) REFERENCES `laporan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penanganan`
--

LOCK TABLES `penanganan` WRITE;
/*!40000 ALTER TABLE `penanganan` DISABLE KEYS */;
INSERT INTO `penanganan` VALUES (1,'bereskan masalah nya','2026-05-09 05:42:08.679329',1),(2,'','2026-05-09 09:02:37.534900',2),(3,'','2026-05-09 09:09:09.984181',4),(4,'','2026-05-09 09:12:36.193349',5),(5,'','2026-05-09 09:12:49.546759',6),(6,'','2026-05-09 09:19:48.253365',7),(7,'','2026-06-04 08:05:19.516159',8);
/*!40000 ALTER TABLE `penanganan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `penanganan_petugas`
--

DROP TABLE IF EXISTS `penanganan_petugas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `penanganan_petugas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `penanganan_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `penanganan_petugas_penanganan_id_user_id_2aca259e_uniq` (`penanganan_id`,`user_id`),
  KEY `penanganan_petugas_user_id_2f230d66_fk_user_id` (`user_id`),
  CONSTRAINT `penanganan_petugas_penanganan_id_c0c3617f_fk_penanganan_id` FOREIGN KEY (`penanganan_id`) REFERENCES `penanganan` (`id`),
  CONSTRAINT `penanganan_petugas_user_id_2f230d66_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penanganan_petugas`
--

LOCK TABLES `penanganan_petugas` WRITE;
/*!40000 ALTER TABLE `penanganan_petugas` DISABLE KEYS */;
INSERT INTO `penanganan_petugas` VALUES (1,7,3);
/*!40000 ALTER TABLE `penanganan_petugas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_feedback`
--

DROP TABLE IF EXISTS `rating_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rating` smallint(5) unsigned NOT NULL CHECK (`rating` >= 0),
  `komentar` longtext DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `laporan_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `laporan_id` (`laporan_id`),
  CONSTRAINT `rating_feedback_laporan_id_ee17e826_fk_laporan_id` FOREIGN KEY (`laporan_id`) REFERENCES `laporan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_feedback`
--

LOCK TABLES `rating_feedback` WRITE;
/*!40000 ALTER TABLE `rating_feedback` DISABLE KEYS */;
INSERT INTO `rating_feedback` VALUES (1,5,'','2026-05-09 07:33:40.023963',1),(2,5,'','2026-05-09 09:11:33.044822',4),(3,5,'bagus, saya senang ada website ini','2026-05-09 09:22:15.310737',7),(4,5,'pelayanan nya cepat, masalah nya selesai dengan cepat','2026-05-09 09:22:45.258141',2);
/*!40000 ALTER TABLE `rating_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_history`
--

DROP TABLE IF EXISTS `status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `keterangan` longtext DEFAULT NULL,
  `changed_at` datetime(6) NOT NULL,
  `changed_by_id` bigint(20) DEFAULT NULL,
  `laporan_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status_history_changed_by_id_2346efbb_fk_user_id` (`changed_by_id`),
  KEY `status_history_laporan_id_43667f7f_fk_laporan_id` (`laporan_id`),
  CONSTRAINT `status_history_changed_by_id_2346efbb_fk_user_id` FOREIGN KEY (`changed_by_id`) REFERENCES `user` (`id`),
  CONSTRAINT `status_history_laporan_id_43667f7f_fk_laporan_id` FOREIGN KEY (`laporan_id`) REFERENCES `laporan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_history`
--

LOCK TABLES `status_history` WRITE;
/*!40000 ALTER TABLE `status_history` DISABLE KEYS */;
INSERT INTO `status_history` VALUES (1,'MENUNGGU','Laporan dibuat','2026-05-09 05:40:20.523592',NULL,1),(2,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 05:41:36.303710',1,1),(3,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 05:42:08.722833',1,1),(4,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 07:30:54.581547',3,1),(5,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 07:31:37.356654',3,1),(6,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 07:31:45.928954',3,1),(7,'MENUNGGU','Laporan dibuat','2026-05-09 09:01:10.709363',NULL,2),(8,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 09:02:20.317031',1,2),(9,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 09:02:37.534900',1,2),(10,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 09:05:27.994347',3,2),(11,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 09:05:44.508554',3,2),(12,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 09:07:26.089104',3,2),(13,'MENUNGGU','Laporan dibuat','2026-05-09 09:07:45.277642',NULL,3),(14,'DITOLAK','Laporan ditolak oleh admin, gak valid','2026-05-09 09:08:48.115965',1,3),(15,'MENUNGGU','Laporan dibuat','2026-05-09 09:08:48.208663',NULL,4),(16,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 09:09:03.779013',1,4),(17,'MENUNGGU','Laporan dibuat','2026-05-09 09:09:06.157943',NULL,5),(18,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 09:09:09.984181',1,4),(19,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 09:09:56.275195',3,4),(20,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 09:10:39.080764',3,4),(21,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 09:10:42.962072',3,4),(22,'MENUNGGU','Laporan dibuat','2026-05-09 09:11:25.718918',NULL,6),(23,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 09:12:29.000409',1,5),(24,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 09:12:36.195360',1,5),(25,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 09:12:41.632408',1,6),(26,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 09:12:49.549552',1,6),(27,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 09:13:51.690429',3,6),(28,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 09:13:56.313239',3,6),(29,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 09:14:08.985265',3,6),(30,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 09:14:37.308288',3,5),(31,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 09:14:42.296538',3,5),(32,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 09:14:59.731211',3,5),(33,'MENUNGGU','Laporan dibuat','2026-05-09 09:17:55.871007',NULL,7),(34,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-05-09 09:18:52.759436',1,7),(35,'DITUGASKAN','Ditugaskan kepada Doli','2026-05-09 09:19:48.271521',1,7),(36,'MENUJU_LOKASI','Status diubah oleh petugas: MENUJU_LOKASI','2026-05-09 09:20:13.773629',3,7),(37,'DIPROSES','Status diubah oleh petugas: DIPROSES','2026-05-09 09:20:18.822852',3,7),(38,'SELESAI','Status diubah oleh petugas: SELESAI','2026-05-09 09:20:57.569860',3,7),(39,'MENUNGGU','Laporan dibuat','2026-06-04 08:02:56.494738',NULL,8),(40,'DIVERIFIKASI','Laporan telah diverifikasi oleh admin','2026-06-04 08:04:54.754001',1,8),(41,'DITUGASKAN','Ditugaskan kepada Doli','2026-06-04 08:05:19.530214',1,8),(42,'DIVERIFIKASI','Status diperbarui','2026-06-06 10:08:49.624722',NULL,8),(43,'DITUGASKAN','Ditugaskan kepada Doli','2026-06-06 10:09:30.776499',1,8),(44,'DIVERIFIKASI','Status diperbarui','2026-06-06 10:12:22.669608',NULL,8),(45,'DITUGASKAN','Ditugaskan kepada Doli','2026-06-06 10:12:52.613378',1,8);
/*!40000 ALTER TABLE `status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `role` varchar(20) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `alamat` longtext DEFAULT NULL,
  `foto_profil` varchar(100) DEFAULT NULL,
  `jabatan` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'pbkdf2_sha256$600000$I9B2lbWdbDQI5BixUlB7Xp$hQcGysmx9H/5ZKXV65vKAArCC29mLggZA7kum1gSoco=','2026-06-07 07:12:35.107698',1,'admin','','','admin@gmail.com',1,1,'2026-05-04 07:32:42.001187','ADMIN',NULL,NULL,'',NULL),(2,'pbkdf2_sha256$600000$R3JqkONB8xi1lN6CZVkLF4$30oMGfylZFYV/3Cc2yniyos1He0yjBIeu+TkA/zYtlE=','2026-05-18 08:56:53.230714',0,'wind','','','wind@gmail.com',0,1,'2026-05-04 11:51:59.915099','MASYARAKAT','085282962318','sempakata','profil/WhatsApp_Image_2026-05-04_at_12.21.59.jpeg',NULL),(3,'pbkdf2_sha256$600000$jFRn8YT7RK9WYGUX03fS3u$cvykoaMUfRFE88RhjRblcMP165tw0usA5O4+INt7Pos=','2026-05-15 07:01:05.224633',0,'Doli','','','Doli@gmail.com',0,1,'2026-05-05 06:09:32.143768','PETUGAS','085282962318','','profil/walpaper.jpg','STAFF_TRANTIB'),(4,'pbkdf2_sha256$600000$2D94s4xzG3qeKTokTf2eRx$P87w8GrpC1JeQYTQZy9IDIBja0XMzXJLdhwsfsZ3Fy4=','2026-06-07 10:03:30.818830',0,'Habib','','','habib@gmail.com',0,1,'2026-05-09 08:56:57.028876','MASYARAKAT','085282962318','Cempaka raya baru 1','profil/donat_tiramisu.jpg',NULL),(5,'pbkdf2_sha256$600000$eQO5fHcRXTPpHBboweMFnB$4AeuRhbL40FNswWmpEUyRede5XFasRA4RHZov4g/fM8=','2026-05-09 09:04:30.213818',0,'Maria Sitohang','','','sitomar@gmail.com',0,1,'2026-05-09 09:02:22.994529','MASYARAKAT','085208520852','Cempaka','',NULL),(6,'pbkdf2_sha256$600000$188clhVFS9Ro7XqBGo5jP8$ivNNzbacB/pSxeXpfZVgUeO1wD5l87iAj/UPkdwn+JY=','2026-05-09 09:14:54.077453',0,'Nomi','','','nomi@gmail.com',0,1,'2026-05-09 09:03:02.153389','MASYARAKAT','081223081214','Jln Cempaka Raya No 1e Sempakata Medan selayang','',NULL),(7,'pbkdf2_sha256$600000$vcS5svowpbFJJ6LubH9f3U$ntbskxEAcY0z9MRo76Q/yoOf+1jGLklul8lJ6hCvkuA=','2026-05-09 09:03:34.178472',0,'Cris','','','bancin@gmail.com',0,1,'2026-05-09 09:03:16.363442','MASYARAKAT','082244556677','Sempakata','',NULL),(8,'pbkdf2_sha256$600000$OtLbPIpEEw55ncILo1mJ1a$DOoRjg8l2JkIAljaZmeKs+vN7Dq0V19YrGedAkylmmc=','2026-05-12 04:00:00.107902',0,'ana','','','marianakajahbase98@gmail.com',0,1,'2026-05-12 03:58:24.283241','MASYARAKAT','085762959039','Medan','',NULL),(9,'pbkdf2_sha256$600000$OhYF1MvPvooE7kcOr0Z6za$+xR9xZDOsA73iBA842zO/lAaCGmDIWVbR4w8bdw+LcY=','2026-05-20 05:04:16.238807',0,'Adit','','','Adit@gmail.com',0,1,'2026-05-20 05:03:54.792334','MASYARAKAT','085282952318','medan','',NULL),(10,'pbkdf2_sha256$600000$frow20IehRId7zBl3yNKWk$u9cIcX6Ug5VwrtGIy7S/nXDTozbJRBaSSUoK5/qcUA0=','2026-06-07 10:47:19.724239',0,'lurah sempakata','','','sempakata@gmail.com',0,1,'2026-06-07 09:47:27.391210','PETUGAS','082347589363','sempakata','','LURAH'),(11,'pbkdf2_sha256$600000$uoLtRuKxqs16MIu5dkgEz6$Tt1cq2bedDenPZYxkMZ9cSiNBtzuUYaFiux3IhegI1U=',NULL,0,'bahtiar damanik','','','bahtiar@gmail.com',0,1,'2026-06-07 09:52:03.645997','PETUGAS','085278538717','dr mansyur','','KASI_TRANTIB');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_groups_user_id_group_id_40beef00_uniq` (`user_id`,`group_id`),
  KEY `user_groups_group_id_b76f8aba_fk_auth_group_id` (`group_id`),
  CONSTRAINT `user_groups_group_id_b76f8aba_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_groups_user_id_abaea130_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_user_permissions`
--

DROP TABLE IF EXISTS `user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_user_permissions_user_id_permission_id_7dc6e2e0_uniq` (`user_id`,`permission_id`),
  KEY `user_user_permission_permission_id_9deb68a3_fk_auth_perm` (`permission_id`),
  CONSTRAINT `user_user_permission_permission_id_9deb68a3_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_user_permissions_user_id_ed4a47ea_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_user_permissions`
--

LOCK TABLES `user_user_permissions` WRITE;
/*!40000 ALTER TABLE `user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-24 10:29:03
