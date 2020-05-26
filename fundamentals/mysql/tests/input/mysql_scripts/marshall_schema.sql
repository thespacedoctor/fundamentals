-- MySQL dump 10.13  Distrib 5.7.26, for macos10.14 (x86_64)
--
-- Host: localhost    Database: marshall
-- ------------------------------------------------------
-- Server version	5.7.26

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
-- Temporary table structure for view `_subview_object_akas`
--

DROP TABLE IF EXISTS `_subview_object_akas`;
/*!50001 DROP VIEW IF EXISTS `_subview_object_akas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `_subview_object_akas` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `primaryKeyId`,
 1 AS `name`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `referenceImageUrl`,
 1 AS `targetImageUrl`,
 1 AS `subtractedImageUrl`,
 1 AS `tripletImageUrl`,
 1 AS `finderImageUrl`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `atel_coordinates`
--

DROP TABLE IF EXISTS `atel_coordinates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atel_coordinates` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `atelNumber` int(11) NOT NULL,
  `raDeg` double NOT NULL,
  `decDeg` double NOT NULL,
  `crossMatchDate` datetime DEFAULT NULL,
  `singleClassification` varchar(45) DEFAULT NULL,
  `supernovaTag` int(11) DEFAULT NULL,
  `ingested` int(11) DEFAULT '0',
  `atelName` varchar(45) NOT NULL,
  `atelUrl` varchar(200) NOT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(45) NOT NULL,
  `titleToComment` tinyint(4) NOT NULL DEFAULT '0',
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `updated` tinyint(1) DEFAULT '0',
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `atelnumber_ra_dec` (`atelNumber`,`raDeg`,`decDeg`),
  KEY `ra_deg` (`raDeg`,`decDeg`),
  KEY `atelNumber` (`atelNumber`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `atel_fullcontent`
--

DROP TABLE IF EXISTS `atel_fullcontent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atel_fullcontent` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `atelNumber` int(11) DEFAULT NULL,
  `authors` mediumtext,
  `backRefList` varchar(450) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `email` varchar(450) DEFAULT NULL,
  `refList` varchar(450) DEFAULT NULL,
  `tags` varchar(450) DEFAULT NULL,
  `title` varchar(450) DEFAULT NULL,
  `userText` mediumtext,
  `datePublished` datetime NOT NULL,
  `atelType` varchar(500) DEFAULT NULL,
  `dateParsed` datetime DEFAULT NULL COMMENT 'The date the ATel text was parsed for names and coordinates',
  `updated` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `atelnumber` (`atelNumber`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `atel_names`
--

DROP TABLE IF EXISTS `atel_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atel_names` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `atelNumber` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `crossMatchDate` datetime DEFAULT NULL,
  `singleClassification` varchar(45) DEFAULT NULL,
  `supernovaTag` int(11) DEFAULT NULL,
  `ingested` int(11) DEFAULT '0',
  `atelName` varchar(45) NOT NULL,
  `atelUrl` varchar(200) NOT NULL,
  `survey` varchar(45) NOT NULL,
  `titleToComment` tinyint(4) NOT NULL DEFAULT '0',
  `summaryRow` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `atelnumber_name` (`atelNumber`,`name`),
  KEY `atelNumber` (`atelNumber`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `corrupted_files`
--

DROP TABLE IF EXISTS `corrupted_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `corrupted_files` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `filePath` varchar(1000) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `corrupted` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `archivePath` varchar(200) DEFAULT NULL,
  `rewriteFitsHeader` tinyint(4) NOT NULL DEFAULT '0',
  `APNUM1` varchar(100) DEFAULT NULL,
  `ARCFILE` varchar(100) DEFAULT NULL,
  `BITPIX` int(11) DEFAULT NULL,
  `CD1_1` double DEFAULT NULL,
  `CDELT1` double DEFAULT NULL,
  `CRPIX1` double DEFAULT NULL,
  `CRVAL1` double DEFAULT NULL,
  `CTYPE1` varchar(100) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `DATE_OBS` datetime DEFAULT NULL COMMENT 'original keyword: DATE-OBS',
  `DC_FLAG` tinyint(4) DEFAULT NULL COMMENT 'original keyword: DC-FLAG',
  `EXTEND` varchar(100) DEFAULT NULL,
  `FILETYPE` int(11) DEFAULT NULL,
  `FILTER` varchar(100) DEFAULT NULL,
  `GRISM` varchar(100) DEFAULT NULL,
  `INSTRUME` varchar(100) DEFAULT NULL,
  `IRAF_TLM` datetime DEFAULT NULL COMMENT 'original keyword: IRAF-TLM',
  `LTM1_1` double DEFAULT NULL,
  `MJD_OBS` double DEFAULT NULL COMMENT 'original keyword: MJD-OBS',
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NCOMBINE` tinyint(4) DEFAULT NULL,
  `OBJECT` varchar(100) DEFAULT NULL,
  `ORIGFILE` varchar(100) DEFAULT NULL,
  `ORIGIN` varchar(100) DEFAULT NULL,
  `PROCSOFT` varchar(100) DEFAULT NULL,
  `SIMPLE` varchar(100) DEFAULT NULL,
  `SLIT` varchar(100) DEFAULT NULL,
  `TELESCOP` varchar(100) DEFAULT NULL,
  `WAT0_001` varchar(100) DEFAULT NULL,
  `WAT1_001` varchar(100) DEFAULT NULL,
  `WAT1_002` varchar(100) DEFAULT NULL,
  `WCSDIM` tinyint(4) DEFAULT NULL,
  `AIRMASS` double DEFAULT NULL,
  `BANDID1` varchar(100) DEFAULT NULL,
  `BANDID2` varchar(100) DEFAULT NULL,
  `BANDID3` varchar(100) DEFAULT NULL,
  `BANDID4` varchar(100) DEFAULT NULL,
  `CCDMEAN` double DEFAULT NULL,
  `CCDMEANT` int(11) DEFAULT NULL,
  `CCDPROC` varchar(100) DEFAULT NULL,
  `CCDSEC` varchar(100) DEFAULT NULL,
  `CD2_2` double DEFAULT NULL,
  `CD3_3` double DEFAULT NULL,
  `CTYPE2` varchar(100) DEFAULT NULL,
  `CTYPE3` varchar(100) DEFAULT NULL,
  `DCLOG1` varchar(100) DEFAULT NULL,
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `EQUINOX` double DEFAULT NULL,
  `ESO_ADA_ABSROT_END` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT END',
  `ESO_ADA_ABSROT_START` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT START',
  `ESO_ADA_GUID_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID DEC',
  `ESO_ADA_GUID_RA` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID RA',
  `ESO_ADA_GUID_STATUS` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID STATUS',
  `ESO_ADA_POSANG` double DEFAULT NULL COMMENT 'original keyword: ESO ADA POSANG',
  `ESO_DET_BITS` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET BITS',
  `ESO_DET_CHIP1_DATE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 DATE',
  `ESO_DET_CHIP1_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 ID',
  `ESO_DET_CHIP1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 INDEX',
  `ESO_DET_CHIP1_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NAME',
  `ESO_DET_CHIP1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NX',
  `ESO_DET_CHIP1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NY',
  `ESO_DET_CHIP1_PSZX` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZX',
  `ESO_DET_CHIP1_PSZY` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZY',
  `ESO_DET_CHIP1_X` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 X',
  `ESO_DET_CHIP1_XGAP` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 XGAP',
  `ESO_DET_CHIP1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 Y',
  `ESO_DET_CHIP1_YGAP` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 YGAP',
  `ESO_DET_CHIPS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIPS',
  `ESO_DET_DATE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET DATE',
  `ESO_DET_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO DET DEC',
  `ESO_DET_DID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET DID',
  `ESO_DET_EXP_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NO',
  `ESO_DET_EXP_RDTTIME` double DEFAULT NULL COMMENT 'original keyword: ESO DET EXP RDTTIME',
  `ESO_DET_EXP_TYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP TYPE',
  `ESO_DET_EXP_XFERTIM` double DEFAULT NULL COMMENT 'original keyword: ESO DET EXP XFERTIM',
  `ESO_DET_FRAM_ID` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM ID',
  `ESO_DET_FRAM_TYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM TYPE',
  `ESO_DET_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET ID',
  `ESO_DET_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET NAME',
  `ESO_DET_OUT1_CHIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CHIP',
  `ESO_DET_OUT1_CONAD` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CONAD',
  `ESO_DET_OUT1_GAIN` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 GAIN',
  `ESO_DET_OUT1_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 ID',
  `ESO_DET_OUT1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 INDEX',
  `ESO_DET_OUT1_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NAME',
  `ESO_DET_OUT1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NX',
  `ESO_DET_OUT1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NY',
  `ESO_DET_OUT1_OVSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCX',
  `ESO_DET_OUT1_OVSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCY',
  `ESO_DET_OUT1_PRSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCX',
  `ESO_DET_OUT1_PRSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCY',
  `ESO_DET_OUT1_RON` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 RON',
  `ESO_DET_OUT1_X` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 X',
  `ESO_DET_OUT1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 Y',
  `ESO_DET_OUTPUTS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTPUTS',
  `ESO_DET_OUTREF` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTREF',
  `ESO_DET_RA` double DEFAULT NULL COMMENT 'original keyword: ESO DET RA',
  `ESO_DET_READ_CLOCK` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET READ CLOCK',
  `ESO_DET_READ_MODE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET READ MODE',
  `ESO_DET_READ_NFRAM` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET READ NFRAM',
  `ESO_DET_READ_SPEED` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET READ SPEED',
  `ESO_DET_SHUT_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT ID',
  `ESO_DET_SHUT_TMCLOS` double DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMCLOS',
  `ESO_DET_SHUT_TMOPEN` double DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMOPEN',
  `ESO_DET_SHUT_TYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TYPE',
  `ESO_DET_SOFW_MODE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET SOFW MODE',
  `ESO_DET_WIN1_BINX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINX',
  `ESO_DET_WIN1_BINY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINY',
  `ESO_DET_WIN1_DIT1` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DIT1',
  `ESO_DET_WIN1_DKTM` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DKTM',
  `ESO_DET_WIN1_NDIT` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NDIT',
  `ESO_DET_WIN1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NX',
  `ESO_DET_WIN1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NY',
  `ESO_DET_WIN1_ST` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 ST',
  `ESO_DET_WIN1_STRX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRX',
  `ESO_DET_WIN1_STRY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRY',
  `ESO_DET_WIN1_UIT1` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 UIT1',
  `ESO_DET_WINDOWS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WINDOWS',
  `ESO_DPR_CATG` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DPR CATG',
  `ESO_DPR_TECH` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DPR TECH',
  `ESO_DPR_TYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO DPR TYPE',
  `ESO_INS_DATE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS DATE',
  `ESO_INS_DID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS DID',
  `ESO_INS_DPOR_POS` double DEFAULT NULL COMMENT 'original keyword: ESO INS DPOR POS',
  `ESO_INS_DPOR_ST` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS DPOR ST',
  `ESO_INS_FILT1_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 ID',
  `ESO_INS_FILT1_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NAME',
  `ESO_INS_FILT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NO',
  `ESO_INS_GRIS1_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 ID',
  `ESO_INS_GRIS1_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 NAME',
  `ESO_INS_GRIS1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 NO',
  `ESO_INS_GRIS1_TYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 TYPE',
  `ESO_INS_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS ID',
  `ESO_INS_MODE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS MODE',
  `ESO_INS_MOS1_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 LEN',
  `ESO_INS_MOS1_POSX` double DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 POSX',
  `ESO_INS_MOS1_POSY` double DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 POSY',
  `ESO_INS_SLIT1_ENC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 ENC',
  `ESO_INS_SLIT1_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 LEN',
  `ESO_INS_SLIT1_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 NAME',
  `ESO_INS_SLIT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 NO',
  `ESO_INS_SLIT1_WID` double DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 WID',
  `ESO_INS_SWSIM` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS SWSIM',
  `ESO_INS_WP_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS WP NAME',
  `ESO_INS_WP_ST` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS WP ST',
  `ESO_OBS_DID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS DID',
  `ESO_OBS_EXECTIME` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS EXECTIME',
  `ESO_OBS_GRP` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS GRP',
  `ESO_OBS_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS ID',
  `ESO_OBS_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS NAME',
  `ESO_OBS_OBSERVER` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS OBSERVER',
  `ESO_OBS_PI_COI_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI ID',
  `ESO_OBS_PI_COI_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI NAME',
  `ESO_OBS_PROG_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS PROG ID',
  `ESO_OBS_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO OBS START',
  `ESO_OBS_TARG_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OBS TARG NAME',
  `ESO_OBS_TPLNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS TPLNO',
  `ESO_OCS_CON_WCSFITS` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OCS CON WCSFITS',
  `ESO_OCS_DET1_IMGNAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO OCS DET1 IMGNAME',
  `ESO_TEL_AIRM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM END',
  `ESO_TEL_AIRM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM START',
  `ESO_TEL_ALT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL ALT',
  `ESO_TEL_AMBI_FWHM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM END',
  `ESO_TEL_AMBI_FWHM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM START',
  `ESO_TEL_AMBI_PRES_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES END',
  `ESO_TEL_AMBI_PRES_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES START',
  `ESO_TEL_AMBI_RHUM` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI RHUM',
  `ESO_TEL_AMBI_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI TEMP',
  `ESO_TEL_AMBI_WINDDIR` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDDIR',
  `ESO_TEL_AMBI_WINDSP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDSP',
  `ESO_TEL_AZ` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AZ',
  `ESO_TEL_CHOP_ST` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL CHOP ST',
  `ESO_TEL_DATE` datetime DEFAULT NULL COMMENT 'original keyword: ESO TEL DATE',
  `ESO_TEL_DID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL DID',
  `ESO_TEL_DOME_STATUS` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL DOME STATUS',
  `ESO_TEL_FOCU_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU ID',
  `ESO_TEL_FOCU_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU LEN',
  `ESO_TEL_FOCU_SCALE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU SCALE',
  `ESO_TEL_FOCU_VALUE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU VALUE',
  `ESO_TEL_GEOELEV` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOELEV',
  `ESO_TEL_GEOLAT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLAT',
  `ESO_TEL_GEOLON` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLON',
  `ESO_TEL_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL ID',
  `ESO_TEL_MOON_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON DEC',
  `ESO_TEL_MOON_RA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON RA',
  `ESO_TEL_OPER` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL OPER',
  `ESO_TEL_PARANG_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG END',
  `ESO_TEL_PARANG_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG START',
  `ESO_TEL_TARG_ALPHA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG ALPHA',
  `ESO_TEL_TARG_COORDTYPE` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG COORDTYPE',
  `ESO_TEL_TARG_DELTA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG DELTA',
  `ESO_TEL_TARG_EPOCH` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCH',
  `ESO_TEL_TARG_EPOCHSYSTEM` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCHSYSTEM',
  `ESO_TEL_TARG_EQUINOX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EQUINOX',
  `ESO_TEL_TARG_PARALLAX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PARALLAX',
  `ESO_TEL_TARG_PMA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMA',
  `ESO_TEL_TARG_PMD` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMD',
  `ESO_TEL_TARG_RADVEL` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG RADVEL',
  `ESO_TEL_TH_M1_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TH M1 TEMP',
  `ESO_TEL_TRAK_STATUS` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TEL TRAK STATUS',
  `ESO_TEL_TSS_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TSS TEMP8',
  `ESO_TPL_DID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TPL DID',
  `ESO_TPL_EXPNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL EXPNO',
  `ESO_TPL_ID` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TPL ID',
  `ESO_TPL_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TPL NAME',
  `ESO_TPL_NEXP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL NEXP',
  `ESO_TPL_PRESEQ` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TPL PRESEQ',
  `ESO_TPL_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO TPL START',
  `ESO_TPL_VERSION` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO TPL VERSION',
  `EXPTIME` double DEFAULT NULL,
  `GAIN` double DEFAULT NULL,
  `LST` double DEFAULT NULL,
  `LTM2_2` double DEFAULT NULL,
  `LTM3_3` double DEFAULT NULL,
  `MAGSTD` double DEFAULT NULL,
  `MJD_END` double DEFAULT NULL COMMENT 'original keyword: MJD-END',
  `OBID` int(11) DEFAULT NULL,
  `OBSERVER` varchar(100) DEFAULT NULL,
  `OBSTECH` varchar(100) DEFAULT NULL,
  `PI_COI` varchar(100) DEFAULT NULL COMMENT 'original keyword: PI-COI',
  `PRODCATG` varchar(100) DEFAULT NULL,
  `PROG_ID` varchar(100) DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `RADECSYS` varchar(100) DEFAULT NULL,
  `STDNAME` varchar(100) DEFAULT NULL,
  `TEXPTIME` double DEFAULT NULL,
  `TRIM` varchar(100) DEFAULT NULL,
  `UTC` double DEFAULT NULL,
  `WAT2_001` varchar(100) DEFAULT NULL,
  `WAT3_001` varchar(100) DEFAULT NULL,
  `archivedLocally` tinyint(4) DEFAULT '0',
  `currentFilename` varchar(200) DEFAULT NULL,
  `currentFilepath` varchar(500) DEFAULT NULL,
  `updatedFilepath` varchar(1000) DEFAULT NULL,
  `updatedFilename` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `filename` (`filename`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `downloads_eso_archive_nightly_data`
--

DROP TABLE IF EXISTS `downloads_eso_archive_nightly_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloads_eso_archive_nightly_data` (
  `night` datetime NOT NULL,
  `number_of_files` int(11) DEFAULT NULL,
  PRIMARY KEY (`night`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efosc_average_zero_points`
--

DROP TABLE IF EXISTS `efosc_average_zero_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `efosc_average_zero_points` (
  `filter` varchar(10) NOT NULL DEFAULT '',
  `zeropoint` double DEFAULT NULL,
  `zeropoint_error` double DEFAULT NULL,
  PRIMARY KEY (`filter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efosc_imaging`
--

DROP TABLE IF EXISTS `efosc_imaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `efosc_imaging` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `ABMAGLIM` decimal(5,2) DEFAULT NULL,
  `ABMAGSAT` decimal(5,2) DEFAULT NULL,
  `AIRMASS` double DEFAULT NULL,
  `ARCFILE` varchar(200) DEFAULT NULL,
  `ASTROMET` varchar(200) DEFAULT NULL,
  `BIASSEC` varchar(200) DEFAULT NULL,
  `BITPIX` int(11) DEFAULT NULL,
  `CCDMEAN` double DEFAULT NULL,
  `CCDMEANT` int(11) DEFAULT NULL,
  `CCDPROC` varchar(200) DEFAULT NULL,
  `CCDSEC` varchar(200) DEFAULT NULL,
  `CD1_1` double DEFAULT NULL,
  `CD1_2` double DEFAULT NULL,
  `CD2_1` double DEFAULT NULL,
  `CD2_2` double DEFAULT NULL,
  `CDELT1` double DEFAULT NULL,
  `CDELT2` double DEFAULT NULL,
  `CHECKSUM` varchar(200) DEFAULT NULL,
  `CRDER1` double DEFAULT NULL,
  `CRDER2` double DEFAULT NULL,
  `CRPIX1` double DEFAULT NULL,
  `CRPIX2` double DEFAULT NULL,
  `CRVAL1` double DEFAULT NULL,
  `CRVAL2` double DEFAULT NULL,
  `CSYER1` double DEFAULT NULL,
  `CSYER2` double DEFAULT NULL,
  `CTYPE1` varchar(200) DEFAULT NULL,
  `CTYPE2` varchar(200) DEFAULT NULL,
  `CUNIT1` varchar(200) DEFAULT NULL,
  `CUNIT2` varchar(200) DEFAULT NULL,
  `DATASUM` varchar(200) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `DATE_OBS` datetime DEFAULT NULL COMMENT 'original keyword: DATE-OBS',
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `ELLIPTIC` double DEFAULT NULL,
  `EQUINOX` double DEFAULT NULL,
  `ESO_ADA_ABSROT_END` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT END',
  `ESO_ADA_ABSROT_START` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT START',
  `ESO_ADA_GUID_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID DEC',
  `ESO_ADA_GUID_RA` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID RA',
  `ESO_ADA_GUID_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID STATUS',
  `ESO_ADA_POSANG` double DEFAULT NULL COMMENT 'original keyword: ESO ADA POSANG',
  `ESO_DET_BITS` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET BITS',
  `ESO_DET_CHIP1_DATE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 DATE',
  `ESO_DET_CHIP1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 ID',
  `ESO_DET_CHIP1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 INDEX',
  `ESO_DET_CHIP1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NAME',
  `ESO_DET_CHIP1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NX',
  `ESO_DET_CHIP1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NY',
  `ESO_DET_CHIP1_PSZX` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZX',
  `ESO_DET_CHIP1_PSZY` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZY',
  `ESO_DET_CHIP1_X` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 X',
  `ESO_DET_CHIP1_XGAP` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 XGAP',
  `ESO_DET_CHIP1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 Y',
  `ESO_DET_CHIP1_YGAP` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 YGAP',
  `ESO_DET_CHIPS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIPS',
  `ESO_DET_DATE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET DATE',
  `ESO_DET_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO DET DEC',
  `ESO_DET_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET DID',
  `ESO_DET_EXP_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NO',
  `ESO_DET_EXP_RDTTIME` double DEFAULT NULL COMMENT 'original keyword: ESO DET EXP RDTTIME',
  `ESO_DET_EXP_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP TYPE',
  `ESO_DET_EXP_XFERTIM` double DEFAULT NULL COMMENT 'original keyword: ESO DET EXP XFERTIM',
  `ESO_DET_FRAM_ID` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM ID',
  `ESO_DET_FRAM_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM TYPE',
  `ESO_DET_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET ID',
  `ESO_DET_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET NAME',
  `ESO_DET_OUT1_CHIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CHIP',
  `ESO_DET_OUT1_CONAD` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CONAD',
  `ESO_DET_OUT1_GAIN` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 GAIN',
  `ESO_DET_OUT1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 ID',
  `ESO_DET_OUT1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 INDEX',
  `ESO_DET_OUT1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NAME',
  `ESO_DET_OUT1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NX',
  `ESO_DET_OUT1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NY',
  `ESO_DET_OUT1_OVSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCX',
  `ESO_DET_OUT1_OVSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCY',
  `ESO_DET_OUT1_PRSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCX',
  `ESO_DET_OUT1_PRSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCY',
  `ESO_DET_OUT1_RON` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 RON',
  `ESO_DET_OUT1_X` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 X',
  `ESO_DET_OUT1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 Y',
  `ESO_DET_OUTPUTS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTPUTS',
  `ESO_DET_OUTREF` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTREF',
  `ESO_DET_RA` double DEFAULT NULL COMMENT 'original keyword: ESO DET RA',
  `ESO_DET_READ_CLOCK` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET READ CLOCK',
  `ESO_DET_READ_MODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET READ MODE',
  `ESO_DET_READ_NFRAM` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET READ NFRAM',
  `ESO_DET_READ_SPEED` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET READ SPEED',
  `ESO_DET_SHUT_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT ID',
  `ESO_DET_SHUT_TMCLOS` double DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMCLOS',
  `ESO_DET_SHUT_TMOPEN` double DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMOPEN',
  `ESO_DET_SHUT_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TYPE',
  `ESO_DET_SOFW_MODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET SOFW MODE',
  `ESO_DET_WIN1_BINX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINX',
  `ESO_DET_WIN1_BINY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINY',
  `ESO_DET_WIN1_DIT1` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DIT1',
  `ESO_DET_WIN1_DKTM` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DKTM',
  `ESO_DET_WIN1_NDIT` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NDIT',
  `ESO_DET_WIN1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NX',
  `ESO_DET_WIN1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NY',
  `ESO_DET_WIN1_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 ST',
  `ESO_DET_WIN1_STRX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRX',
  `ESO_DET_WIN1_STRY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRY',
  `ESO_DET_WIN1_UIT1` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 UIT1',
  `ESO_DET_WINDOWS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WINDOWS',
  `ESO_DPR_CATG` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR CATG',
  `ESO_DPR_TECH` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TECH',
  `ESO_DPR_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TYPE',
  `ESO_INS_DATE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS DATE',
  `ESO_INS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS DID',
  `ESO_INS_DPOR_POS` double DEFAULT NULL COMMENT 'original keyword: ESO INS DPOR POS',
  `ESO_INS_DPOR_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS DPOR ST',
  `ESO_INS_FILT1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 ID',
  `ESO_INS_FILT1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NAME',
  `ESO_INS_FILT1_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NO',
  `ESO_INS_GRIS1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 ID',
  `ESO_INS_GRIS1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 NAME',
  `ESO_INS_GRIS1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 NO',
  `ESO_INS_GRIS1_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 TYPE',
  `ESO_INS_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS ID',
  `ESO_INS_MODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS MODE',
  `ESO_INS_SLIT1_ENC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 ENC',
  `ESO_INS_SLIT1_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 LEN',
  `ESO_INS_SLIT1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 NAME',
  `ESO_INS_SLIT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 NO',
  `ESO_INS_SLIT1_WID` double DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 WID',
  `ESO_INS_SWSIM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS SWSIM',
  `ESO_INS_WP_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS WP NAME',
  `ESO_INS_WP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS WP ST',
  `ESO_OBS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS DID',
  `ESO_OBS_EXECTIME` double DEFAULT NULL COMMENT 'original keyword: ESO OBS EXECTIME',
  `ESO_OBS_GRP` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS GRP',
  `ESO_OBS_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS ID',
  `ESO_OBS_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS NAME',
  `ESO_OBS_OBSERVER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS OBSERVER',
  `ESO_OBS_PI_COI_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI ID',
  `ESO_OBS_PI_COI_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI NAME',
  `ESO_OBS_PROG_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PROG ID',
  `ESO_OBS_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO OBS START',
  `ESO_OBS_TARG_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS TARG NAME',
  `ESO_OBS_TPLNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS TPLNO',
  `ESO_OCS_CON_WCSFITS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS CON WCSFITS',
  `ESO_OCS_DET1_IMGNAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS DET1 IMGNAME',
  `ESO_TEL_AIRM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM END',
  `ESO_TEL_AIRM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM START',
  `ESO_TEL_ALT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL ALT',
  `ESO_TEL_AMBI_FWHM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM END',
  `ESO_TEL_AMBI_FWHM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM START',
  `ESO_TEL_AMBI_PRES_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES END',
  `ESO_TEL_AMBI_PRES_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES START',
  `ESO_TEL_AMBI_RHUM` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI RHUM',
  `ESO_TEL_AMBI_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI TEMP',
  `ESO_TEL_AMBI_WINDDIR` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDDIR',
  `ESO_TEL_AMBI_WINDSP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDSP',
  `ESO_TEL_AZ` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AZ',
  `ESO_TEL_CHOP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL CHOP ST',
  `ESO_TEL_DATE` datetime DEFAULT NULL COMMENT 'original keyword: ESO TEL DATE',
  `ESO_TEL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DID',
  `ESO_TEL_DOME_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DOME STATUS',
  `ESO_TEL_FOCU_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU ID',
  `ESO_TEL_FOCU_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU LEN',
  `ESO_TEL_FOCU_SCALE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU SCALE',
  `ESO_TEL_FOCU_VALUE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU VALUE',
  `ESO_TEL_GEOELEV` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOELEV',
  `ESO_TEL_GEOLAT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLAT',
  `ESO_TEL_GEOLON` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLON',
  `ESO_TEL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL ID',
  `ESO_TEL_MOON_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON DEC',
  `ESO_TEL_MOON_RA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON RA',
  `ESO_TEL_OPER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL OPER',
  `ESO_TEL_PARANG_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG END',
  `ESO_TEL_PARANG_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG START',
  `ESO_TEL_TARG_ALPHA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG ALPHA',
  `ESO_TEL_TARG_COORDTYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG COORDTYPE',
  `ESO_TEL_TARG_DELTA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG DELTA',
  `ESO_TEL_TARG_EPOCH` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCH',
  `ESO_TEL_TARG_EPOCHSYSTEM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCHSYSTEM',
  `ESO_TEL_TARG_EQUINOX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EQUINOX',
  `ESO_TEL_TARG_PARALLAX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PARALLAX',
  `ESO_TEL_TARG_PMA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMA',
  `ESO_TEL_TARG_PMD` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMD',
  `ESO_TEL_TARG_RADVEL` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG RADVEL',
  `ESO_TEL_TH_M1_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TH M1 TEMP',
  `ESO_TEL_TRAK_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TRAK STATUS',
  `ESO_TEL_TSS_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TSS TEMP8',
  `ESO_TPL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL DID',
  `ESO_TPL_EXPNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL EXPNO',
  `ESO_TPL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL ID',
  `ESO_TPL_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL NAME',
  `ESO_TPL_NEXP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL NEXP',
  `ESO_TPL_PRESEQ` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL PRESEQ',
  `ESO_TPL_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO TPL START',
  `ESO_TPL_VERSION` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL VERSION',
  `EXPTIME` double DEFAULT NULL,
  `EXTNAME` varchar(200) DEFAULT NULL,
  `FILETYPE` int(11) DEFAULT NULL,
  `FILTER` varchar(200) DEFAULT NULL,
  `FIXPIX` varchar(200) DEFAULT NULL,
  `FLATCOR` varchar(200) DEFAULT NULL,
  `FLUXCAL` varchar(200) DEFAULT NULL,
  `INHERIT` varchar(200) DEFAULT NULL,
  `INSTRUME` varchar(200) DEFAULT NULL,
  `IRAF_TLM` datetime DEFAULT NULL COMMENT 'original keyword: IRAF-TLM',
  `LACOSMIC` varchar(200) DEFAULT NULL,
  `LST` double DEFAULT NULL,
  `LTM1_1` double DEFAULT NULL,
  `LTM2_2` double DEFAULT NULL,
  `LTV1` double DEFAULT NULL,
  `MBKG` double DEFAULT NULL,
  `MJD_OBS` double DEFAULT NULL COMMENT 'original keyword: MJD-OBS',
  `M_EPOCH` varchar(200) DEFAULT NULL,
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` int(11) DEFAULT NULL,
  `NCOMBINE` tinyint(4) DEFAULT NULL,
  `OBJECT` varchar(200) DEFAULT NULL,
  `OBSERVER` varchar(200) DEFAULT NULL,
  `ORIGFILE` varchar(200) DEFAULT NULL,
  `ORIGIN` varchar(200) DEFAULT NULL,
  `PHOTSYS` varchar(200) DEFAULT NULL,
  `PHOTZP` double DEFAULT NULL,
  `PHOTZPER` double DEFAULT NULL,
  `PI_COI` varchar(200) DEFAULT NULL COMMENT 'original keyword: PI-COI',
  `PROV1` varchar(200) DEFAULT NULL,
  `PSF_FWHM` double DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `RADECSYS` varchar(200) DEFAULT NULL,
  `SINGLEXP` varchar(200) DEFAULT NULL,
  `TELESCOP` varchar(200) DEFAULT NULL,
  `TRACE1` varchar(200) DEFAULT NULL,
  `TRIM` varchar(200) DEFAULT NULL,
  `UTC` double DEFAULT NULL,
  `WAT0_001` varchar(200) DEFAULT NULL,
  `WAT1_001` varchar(200) DEFAULT NULL,
  `WAT2_001` varchar(200) DEFAULT NULL,
  `WCSDIM` tinyint(4) DEFAULT NULL,
  `XTENSION` varchar(200) DEFAULT NULL,
  `ZEROCOR` varchar(200) DEFAULT NULL,
  `ZPIRI` varchar(200) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` varchar(1000) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `BSCALE` double DEFAULT NULL,
  `BZERO` double DEFAULT NULL,
  `ESO_DET_TELE_INT` double DEFAULT NULL COMMENT 'original keyword: ESO DET TELE INT',
  `ESO_DET_TELE_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET TELE NO',
  `ESO_DET_TLM1_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 END',
  `ESO_DET_TLM1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 ID',
  `ESO_DET_TLM1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 NAME',
  `ESO_DET_TLM1_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 START',
  `ESO_DET_TLM2_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 END',
  `ESO_DET_TLM2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 ID',
  `ESO_DET_TLM2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 NAME',
  `ESO_DET_TLM2_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 START',
  `ESO_DET_TLM3_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 END',
  `ESO_DET_TLM3_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 ID',
  `ESO_DET_TLM3_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 NAME',
  `ESO_DET_TLM3_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 START',
  `ESO_DET_TLM4_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 END',
  `ESO_DET_TLM4_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 ID',
  `ESO_DET_TLM4_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 NAME',
  `ESO_DET_TLM4_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 START',
  `ESO_DET_TLM5_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 END',
  `ESO_DET_TLM5_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 ID',
  `ESO_DET_TLM5_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 NAME',
  `ESO_DET_TLM5_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 START',
  `ESO_DET_TLM6_END` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 END',
  `ESO_DET_TLM6_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 ID',
  `ESO_DET_TLM6_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 NAME',
  `ESO_DET_TLM6_START` double DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 START',
  `EXTEND` varchar(200) DEFAULT NULL,
  `GCOUNT` tinyint(4) DEFAULT NULL,
  `PCOUNT` tinyint(4) DEFAULT NULL,
  `SIMPLE` varchar(200) DEFAULT NULL,
  `BUNIT` varchar(200) DEFAULT NULL,
  `DATAMAX` double DEFAULT NULL,
  `DATAMIN` double DEFAULT NULL,
  `DETRON` double DEFAULT NULL,
  `EFFRON` double DEFAULT NULL,
  `GAIN` double DEFAULT NULL,
  `MJD_END` double DEFAULT NULL COMMENT 'original keyword: MJD-END',
  `OBID1` int(11) DEFAULT NULL,
  `OBSTECH` varchar(200) DEFAULT NULL,
  `PIXSCALE` double DEFAULT NULL,
  `PROCSOFT` varchar(200) DEFAULT NULL,
  `PRODCATG` varchar(200) DEFAULT NULL,
  `PROG_ID` varchar(200) DEFAULT NULL,
  `QUALITY` varchar(200) DEFAULT NULL,
  `REFERENC` varchar(200) DEFAULT NULL,
  `TEXPTIME` double DEFAULT NULL,
  `ZPGGR` varchar(200) DEFAULT NULL,
  `ESO_DET_OUT2_CHIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 CHIP',
  `ESO_DET_OUT2_CONAD` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 CONAD',
  `ESO_DET_OUT2_GAIN` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 GAIN',
  `ESO_DET_OUT2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 ID',
  `ESO_DET_OUT2_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 INDEX',
  `ESO_DET_OUT2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 NAME',
  `ESO_DET_OUT2_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 NX',
  `ESO_DET_OUT2_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 NY',
  `ESO_DET_OUT2_OVSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 OVSCX',
  `ESO_DET_OUT2_OVSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 OVSCY',
  `ESO_DET_OUT2_PRSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 PRSCX',
  `ESO_DET_OUT2_PRSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 PRSCY',
  `ESO_DET_OUT2_RON` double DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 RON',
  `ESO_DET_OUT2_X` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 X',
  `ESO_DET_OUT2_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 Y',
  `OBJMASK` varchar(200) DEFAULT NULL,
  `DARKTIME` double DEFAULT NULL,
  `PROV10` varchar(200) DEFAULT NULL,
  `PROV11` varchar(200) DEFAULT NULL,
  `PROV2` varchar(200) DEFAULT NULL,
  `PROV3` varchar(200) DEFAULT NULL,
  `PROV4` varchar(200) DEFAULT NULL,
  `PROV5` varchar(200) DEFAULT NULL,
  `PROV6` varchar(200) DEFAULT NULL,
  `PROV7` varchar(200) DEFAULT NULL,
  `PROV8` varchar(200) DEFAULT NULL,
  `PROV9` varchar(200) DEFAULT NULL,
  `TRACE10` varchar(200) DEFAULT NULL,
  `TRACE11` varchar(200) DEFAULT NULL,
  `TRACE2` varchar(200) DEFAULT NULL,
  `TRACE3` varchar(200) DEFAULT NULL,
  `TRACE4` varchar(200) DEFAULT NULL,
  `TRACE5` varchar(200) DEFAULT NULL,
  `TRACE6` varchar(200) DEFAULT NULL,
  `TRACE7` varchar(200) DEFAULT NULL,
  `TRACE8` varchar(200) DEFAULT NULL,
  `TRACE9` varchar(200) DEFAULT NULL,
  `FRICOR` varchar(200) DEFAULT NULL,
  `PROV12` varchar(200) DEFAULT NULL,
  `PROV13` varchar(200) DEFAULT NULL,
  `PROV14` varchar(200) DEFAULT NULL,
  `PROV15` varchar(200) DEFAULT NULL,
  `PROV16` varchar(200) DEFAULT NULL,
  `TRACE12` varchar(200) DEFAULT NULL,
  `TRACE13` varchar(200) DEFAULT NULL,
  `TRACE14` varchar(200) DEFAULT NULL,
  `TRACE15` varchar(200) DEFAULT NULL,
  `TRACE16` varchar(200) DEFAULT NULL,
  `COMMENT` varchar(200) DEFAULT NULL,
  `FILTER1` varchar(200) DEFAULT NULL,
  `GRISM` varchar(200) DEFAULT NULL,
  `IMAGETYP` varchar(200) DEFAULT NULL,
  `IMCMB001` varchar(200) DEFAULT NULL,
  `IMCMB002` varchar(200) DEFAULT NULL,
  `IMCMB003` varchar(200) DEFAULT NULL,
  `IMCMB004` varchar(200) DEFAULT NULL,
  `IMCMB005` varchar(200) DEFAULT NULL,
  `OBID` int(11) DEFAULT NULL,
  `ST` varchar(200) DEFAULT NULL,
  `UT` varchar(200) DEFAULT NULL,
  `OVERSCAN` varchar(200) DEFAULT NULL,
  `ZPRRI` varchar(200) DEFAULT NULL,
  `ZPVBV` varchar(200) DEFAULT NULL,
  `ZPVVR` varchar(200) DEFAULT NULL,
  `ZPRVR` varchar(200) DEFAULT NULL,
  `ZPUUB` varchar(200) DEFAULT NULL,
  `ZPBBV` varchar(200) DEFAULT NULL,
  `PROV17` varchar(200) DEFAULT NULL,
  `PROV18` varchar(200) DEFAULT NULL,
  `PROV19` varchar(200) DEFAULT NULL,
  `PROV20` varchar(200) DEFAULT NULL,
  `PROV21` varchar(200) DEFAULT NULL,
  `TRACE17` varchar(200) DEFAULT NULL,
  `TRACE18` varchar(200) DEFAULT NULL,
  `TRACE19` varchar(200) DEFAULT NULL,
  `TRACE20` varchar(200) DEFAULT NULL,
  `TRACE21` varchar(200) DEFAULT NULL,
  `ZPZIZ` varchar(200) DEFAULT NULL,
  `PROV22` varchar(200) DEFAULT NULL,
  `PROV23` varchar(200) DEFAULT NULL,
  `TRACE22` varchar(200) DEFAULT NULL,
  `TRACE23` varchar(200) DEFAULT NULL,
  `PROV24` varchar(200) DEFAULT NULL,
  `PROV25` varchar(200) DEFAULT NULL,
  `PROV26` varchar(200) DEFAULT NULL,
  `PROV27` varchar(200) DEFAULT NULL,
  `PROV28` varchar(200) DEFAULT NULL,
  `PROV29` varchar(200) DEFAULT NULL,
  `TRACE24` varchar(200) DEFAULT NULL,
  `TRACE25` varchar(200) DEFAULT NULL,
  `TRACE26` varchar(200) DEFAULT NULL,
  `TRACE27` varchar(200) DEFAULT NULL,
  `TRACE28` varchar(200) DEFAULT NULL,
  `TRACE29` varchar(200) DEFAULT NULL,
  `CONTNORM` varchar(200) DEFAULT NULL,
  `DISPELEM` varchar(200) DEFAULT NULL,
  `EXT_OBJ` varchar(200) DEFAULT NULL,
  `FLUXERR` double DEFAULT NULL,
  `LTV2` double DEFAULT NULL,
  `SPECSYS` varchar(200) DEFAULT NULL,
  `TELAPSE` double DEFAULT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `TMID` double DEFAULT NULL,
  `TOT_FLUX` varchar(200) DEFAULT NULL,
  `filetype_key_instrument` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_image_or_spectrum` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_reduction_stage` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_calibration` tinyint(4) NOT NULL DEFAULT '0',
  `transientBucketId` bigint(20) NOT NULL DEFAULT '0',
  `nameChangeRequired` tinyint(4) NOT NULL DEFAULT '0',
  `esoPhaseIII` tinyint(4) NOT NULL DEFAULT '0',
  `updatedFilename` varchar(200) DEFAULT NULL,
  `filenameUpdated` tinyint(4) NOT NULL DEFAULT '0',
  `objectInFilename` varchar(100) DEFAULT NULL,
  `updateObjectName` tinyint(4) NOT NULL DEFAULT '0',
  `OBJ_OLD` varchar(100) DEFAULT NULL COMMENT 'original keyword: OBJ-OLD',
  `currentFilename` varchar(200) DEFAULT NULL,
  `currentFilepath` varchar(500) DEFAULT NULL,
  `updatedFilepath` varchar(1000) DEFAULT NULL,
  `archivePath` varchar(200) DEFAULT NULL,
  `rewriteFitsHeader` tinyint(4) NOT NULL DEFAULT '0',
  `archivedLocally` tinyint(4) DEFAULT '0',
  `isInTransientBucket` tinyint(4) DEFAULT NULL,
  `DATA_REL` varchar(45) DEFAULT NULL,
  `astromet_rmsx` double DEFAULT NULL,
  `astromet_rmsy` double DEFAULT NULL,
  `astromet_sources` tinyint(4) DEFAULT NULL,
  `astromet_error_arcsec` double DEFAULT NULL,
  `RRELEASE` varchar(100) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `OTIME` double DEFAULT NULL,
  `TTIME` double DEFAULT NULL,
  `PROV30` varchar(100) DEFAULT NULL,
  `PROV31` varchar(100) DEFAULT NULL,
  `PROV32` varchar(100) DEFAULT NULL,
  `PROV33` varchar(100) DEFAULT NULL,
  `PROV34` varchar(100) DEFAULT NULL,
  `PROV35` varchar(100) DEFAULT NULL,
  `PROV36` varchar(100) DEFAULT NULL,
  `PROV37` varchar(100) DEFAULT NULL,
  `PROV38` varchar(100) DEFAULT NULL,
  `PROV39` varchar(100) DEFAULT NULL,
  `PROV40` varchar(100) DEFAULT NULL,
  `PROV41` varchar(100) DEFAULT NULL,
  `PROV42` varchar(100) DEFAULT NULL,
  `PROV43` varchar(100) DEFAULT NULL,
  `PROV44` varchar(100) DEFAULT NULL,
  `PROV45` varchar(100) DEFAULT NULL,
  `PROV46` varchar(100) DEFAULT NULL,
  `PROV47` varchar(100) DEFAULT NULL,
  `PROV48` varchar(100) DEFAULT NULL,
  `PROV49` varchar(100) DEFAULT NULL,
  `PROV50` varchar(100) DEFAULT NULL,
  `PROV51` varchar(100) DEFAULT NULL,
  `PROV52` varchar(100) DEFAULT NULL,
  `PROV53` varchar(100) DEFAULT NULL,
  `PROV54` varchar(100) DEFAULT NULL,
  `PROV55` varchar(100) DEFAULT NULL,
  `PROV56` varchar(100) DEFAULT NULL,
  `PROV57` varchar(100) DEFAULT NULL,
  `PROV58` varchar(100) DEFAULT NULL,
  `PROV59` varchar(100) DEFAULT NULL,
  `PROV60` varchar(100) DEFAULT NULL,
  `PROV61` varchar(100) DEFAULT NULL,
  `PROV62` varchar(100) DEFAULT NULL,
  `PROV63` varchar(100) DEFAULT NULL,
  `PROV64` varchar(100) DEFAULT NULL,
  `PROV65` varchar(100) DEFAULT NULL,
  `PROV66` varchar(100) DEFAULT NULL,
  `PROV67` varchar(100) DEFAULT NULL,
  `PROV68` varchar(100) DEFAULT NULL,
  `PROV69` varchar(100) DEFAULT NULL,
  `PROV70` varchar(100) DEFAULT NULL,
  `PROV71` varchar(100) DEFAULT NULL,
  `PROV72` varchar(100) DEFAULT NULL,
  `PROV73` varchar(100) DEFAULT NULL,
  `PROV74` varchar(100) DEFAULT NULL,
  `PROV75` varchar(100) DEFAULT NULL,
  `PROV76` varchar(100) DEFAULT NULL,
  `PROV77` varchar(100) DEFAULT NULL,
  `PROV78` varchar(100) DEFAULT NULL,
  `PROV79` varchar(100) DEFAULT NULL,
  `PROV80` varchar(100) DEFAULT NULL,
  `PROV81` varchar(100) DEFAULT NULL,
  `PROV82` varchar(100) DEFAULT NULL,
  `PROV83` varchar(100) DEFAULT NULL,
  `PROV84` varchar(100) DEFAULT NULL,
  `PROV85` varchar(100) DEFAULT NULL,
  `PROV86` varchar(100) DEFAULT NULL,
  `PROV87` varchar(100) DEFAULT NULL,
  `PROV88` varchar(100) DEFAULT NULL,
  `PROV89` varchar(100) DEFAULT NULL,
  `PROV90` varchar(100) DEFAULT NULL,
  `PROV91` varchar(100) DEFAULT NULL,
  `PROV92` varchar(100) DEFAULT NULL,
  `PROV93` varchar(100) DEFAULT NULL,
  `PROV94` varchar(100) DEFAULT NULL,
  `PROV95` varchar(100) DEFAULT NULL,
  `PROV96` varchar(100) DEFAULT NULL,
  `PROV97` varchar(100) DEFAULT NULL,
  `PROV98` varchar(100) DEFAULT NULL,
  `TRACE30` varchar(100) DEFAULT NULL,
  `TRACE31` varchar(100) DEFAULT NULL,
  `TRACE32` varchar(100) DEFAULT NULL,
  `TRACE33` varchar(100) DEFAULT NULL,
  `TRACE34` varchar(100) DEFAULT NULL,
  `TRACE35` varchar(100) DEFAULT NULL,
  `TRACE36` varchar(100) DEFAULT NULL,
  `TRACE37` varchar(100) DEFAULT NULL,
  `TRACE38` varchar(100) DEFAULT NULL,
  `TRACE39` varchar(100) DEFAULT NULL,
  `TRACE40` varchar(100) DEFAULT NULL,
  `TRACE41` varchar(100) DEFAULT NULL,
  `TRACE42` varchar(100) DEFAULT NULL,
  `TRACE43` varchar(100) DEFAULT NULL,
  `TRACE44` varchar(100) DEFAULT NULL,
  `TRACE45` varchar(100) DEFAULT NULL,
  `TRACE46` varchar(100) DEFAULT NULL,
  `TRACE47` varchar(100) DEFAULT NULL,
  `TRACE48` varchar(100) DEFAULT NULL,
  `TRACE49` varchar(100) DEFAULT NULL,
  `TRACE50` varchar(100) DEFAULT NULL,
  `TRACE51` varchar(100) DEFAULT NULL,
  `TRACE52` varchar(100) DEFAULT NULL,
  `TRACE53` varchar(100) DEFAULT NULL,
  `TRACE54` varchar(100) DEFAULT NULL,
  `TRACE55` varchar(100) DEFAULT NULL,
  `TRACE56` varchar(100) DEFAULT NULL,
  `TRACE57` varchar(100) DEFAULT NULL,
  `TRACE58` varchar(100) DEFAULT NULL,
  `TRACE59` varchar(100) DEFAULT NULL,
  `TRACE60` varchar(100) DEFAULT NULL,
  `TRACE61` varchar(100) DEFAULT NULL,
  `TRACE62` varchar(100) DEFAULT NULL,
  `TRACE63` varchar(100) DEFAULT NULL,
  `TRACE64` varchar(100) DEFAULT NULL,
  `TRACE65` varchar(100) DEFAULT NULL,
  `TRACE66` varchar(100) DEFAULT NULL,
  `TRACE67` varchar(100) DEFAULT NULL,
  `TRACE68` varchar(100) DEFAULT NULL,
  `TRACE69` varchar(100) DEFAULT NULL,
  `TRACE70` varchar(100) DEFAULT NULL,
  `TRACE71` varchar(100) DEFAULT NULL,
  `TRACE72` varchar(100) DEFAULT NULL,
  `TRACE73` varchar(100) DEFAULT NULL,
  `TRACE74` varchar(100) DEFAULT NULL,
  `TRACE75` varchar(100) DEFAULT NULL,
  `TRACE76` varchar(100) DEFAULT NULL,
  `TRACE77` varchar(100) DEFAULT NULL,
  `TRACE78` varchar(100) DEFAULT NULL,
  `TRACE79` varchar(100) DEFAULT NULL,
  `TRACE80` varchar(100) DEFAULT NULL,
  `TRACE81` varchar(100) DEFAULT NULL,
  `TRACE82` varchar(100) DEFAULT NULL,
  `TRACE83` varchar(100) DEFAULT NULL,
  `TRACE84` varchar(100) DEFAULT NULL,
  `TRACE85` varchar(100) DEFAULT NULL,
  `TRACE86` varchar(100) DEFAULT NULL,
  `TRACE87` varchar(100) DEFAULT NULL,
  `TRACE88` varchar(100) DEFAULT NULL,
  `TRACE89` varchar(100) DEFAULT NULL,
  `TRACE90` varchar(100) DEFAULT NULL,
  `TRACE91` varchar(100) DEFAULT NULL,
  `TRACE92` varchar(100) DEFAULT NULL,
  `TRACE93` varchar(100) DEFAULT NULL,
  `TRACE94` varchar(100) DEFAULT NULL,
  `TRACE95` varchar(100) DEFAULT NULL,
  `TRACE96` varchar(100) DEFAULT NULL,
  `TRACE97` varchar(100) DEFAULT NULL,
  `TRACE98` varchar(100) DEFAULT NULL,
  `ASSOC_SPECTRUM_NAME` varchar(100) DEFAULT NULL,
  `ASSOC_SPECTRUM_ID` int(11) DEFAULT NULL,
  `dryx_comment` varchar(100) DEFAULT NULL,
  `lock_row` tinyint(4) DEFAULT '0',
  `do_not_release` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `filename_quality` (`filename`,`QUALITY`) KEY_BLOCK_SIZE=2048,
  UNIQUE KEY `filename` (`filename`) KEY_BLOCK_SIZE=1024,
  KEY `currentFilename` (`currentFilename`) KEY_BLOCK_SIZE=1024,
  KEY `data_rel` (`DATA_REL`) KEY_BLOCK_SIZE=1024,
  KEY `calibratation_reduction_stage` (`filetype_key_reduction_stage`,`filetype_key_image_or_spectrum`) KEY_BLOCK_SIZE=1024
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efosc_spectra`
--

DROP TABLE IF EXISTS `efosc_spectra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `efosc_spectra` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `ARCFILE` text,
  `BITPIX` int(11) DEFAULT NULL,
  `BSCALE` int(11) DEFAULT NULL,
  `BZERO` int(11) DEFAULT NULL,
  `CDELT1` int(11) DEFAULT NULL,
  `CDELT2` int(11) DEFAULT NULL,
  `CHECKSUM` text,
  `CRPIX1` float DEFAULT NULL,
  `CRPIX2` float DEFAULT NULL,
  `CRVAL1` int(11) DEFAULT NULL,
  `CRVAL2` int(11) DEFAULT NULL,
  `CTYPE1` text,
  `CTYPE2` text,
  `DATASUM` text,
  `DATE` datetime DEFAULT NULL,
  `DATE_OBS` datetime DEFAULT NULL COMMENT 'original keyword: DATE-OBS',
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `EQUINOX` int(11) DEFAULT NULL,
  `ESO_ADA_ABSROT_END` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT END',
  `ESO_ADA_ABSROT_START` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT START',
  `ESO_ADA_GUID_STATUS` text COMMENT 'original keyword: ESO ADA GUID STATUS',
  `ESO_ADA_POSANG` double DEFAULT NULL COMMENT 'original keyword: ESO ADA POSANG',
  `ESO_DET_BITS` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET BITS',
  `ESO_DET_CHIP1_DATE` text COMMENT 'original keyword: ESO DET CHIP1 DATE',
  `ESO_DET_CHIP1_ID` text COMMENT 'original keyword: ESO DET CHIP1 ID',
  `ESO_DET_CHIP1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 INDEX',
  `ESO_DET_CHIP1_NAME` text COMMENT 'original keyword: ESO DET CHIP1 NAME',
  `ESO_DET_CHIP1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NX',
  `ESO_DET_CHIP1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 NY',
  `ESO_DET_CHIP1_PSZX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZX',
  `ESO_DET_CHIP1_PSZY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 PSZY',
  `ESO_DET_CHIP1_X` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 X',
  `ESO_DET_CHIP1_XGAP` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 XGAP',
  `ESO_DET_CHIP1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 Y',
  `ESO_DET_CHIP1_YGAP` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP1 YGAP',
  `ESO_DET_CHIPS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIPS',
  `ESO_DET_DATE` text COMMENT 'original keyword: ESO DET DATE',
  `ESO_DET_DEC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET DEC',
  `ESO_DET_DID` text COMMENT 'original keyword: ESO DET DID',
  `ESO_DET_EXP_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NO',
  `ESO_DET_EXP_RDTTIME` float DEFAULT NULL COMMENT 'original keyword: ESO DET EXP RDTTIME',
  `ESO_DET_EXP_TYPE` text COMMENT 'original keyword: ESO DET EXP TYPE',
  `ESO_DET_EXP_XFERTIM` float DEFAULT NULL COMMENT 'original keyword: ESO DET EXP XFERTIM',
  `ESO_DET_FRAM_ID` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM ID',
  `ESO_DET_FRAM_TYPE` text COMMENT 'original keyword: ESO DET FRAM TYPE',
  `ESO_DET_ID` text COMMENT 'original keyword: ESO DET ID',
  `ESO_DET_NAME` text COMMENT 'original keyword: ESO DET NAME',
  `ESO_DET_OUT1_CHIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CHIP',
  `ESO_DET_OUT1_CONAD` float DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 CONAD',
  `ESO_DET_OUT1_GAIN` float DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 GAIN',
  `ESO_DET_OUT1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 ID',
  `ESO_DET_OUT1_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 INDEX',
  `ESO_DET_OUT1_NAME` text COMMENT 'original keyword: ESO DET OUT1 NAME',
  `ESO_DET_OUT1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NX',
  `ESO_DET_OUT1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 NY',
  `ESO_DET_OUT1_OVSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCX',
  `ESO_DET_OUT1_OVSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 OVSCY',
  `ESO_DET_OUT1_PRSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCX',
  `ESO_DET_OUT1_PRSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 PRSCY',
  `ESO_DET_OUT1_RON` float DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 RON',
  `ESO_DET_OUT1_X` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 X',
  `ESO_DET_OUT1_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT1 Y',
  `ESO_DET_OUTPUTS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTPUTS',
  `ESO_DET_OUTREF` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUTREF',
  `ESO_DET_RA` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET RA',
  `ESO_DET_READ_CLOCK` text COMMENT 'original keyword: ESO DET READ CLOCK',
  `ESO_DET_READ_MODE` text COMMENT 'original keyword: ESO DET READ MODE',
  `ESO_DET_READ_NFRAM` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET READ NFRAM',
  `ESO_DET_READ_SPEED` text COMMENT 'original keyword: ESO DET READ SPEED',
  `ESO_DET_SHUT_ID` text COMMENT 'original keyword: ESO DET SHUT ID',
  `ESO_DET_SHUT_TMCLOS` float DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMCLOS',
  `ESO_DET_SHUT_TMOPEN` float DEFAULT NULL COMMENT 'original keyword: ESO DET SHUT TMOPEN',
  `ESO_DET_SHUT_TYPE` text COMMENT 'original keyword: ESO DET SHUT TYPE',
  `ESO_DET_SOFW_MODE` text COMMENT 'original keyword: ESO DET SOFW MODE',
  `ESO_DET_WIN1_BINX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINX',
  `ESO_DET_WIN1_BINY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 BINY',
  `ESO_DET_WIN1_DIT1` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DIT1',
  `ESO_DET_WIN1_DKTM` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DKTM',
  `ESO_DET_WIN1_NDIT` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NDIT',
  `ESO_DET_WIN1_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NX',
  `ESO_DET_WIN1_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 NY',
  `ESO_DET_WIN1_ST` text COMMENT 'original keyword: ESO DET WIN1 ST',
  `ESO_DET_WIN1_STRX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRX',
  `ESO_DET_WIN1_STRY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 STRY',
  `ESO_DET_WIN1_UIT1` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 UIT1',
  `ESO_DET_WINDOWS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WINDOWS',
  `ESO_DPR_CATG` text COMMENT 'original keyword: ESO DPR CATG',
  `ESO_DPR_TECH` text COMMENT 'original keyword: ESO DPR TECH',
  `ESO_DPR_TYPE` text COMMENT 'original keyword: ESO DPR TYPE',
  `ESO_INS_DATE` text COMMENT 'original keyword: ESO INS DATE',
  `ESO_INS_DID` text COMMENT 'original keyword: ESO INS DID',
  `ESO_INS_DPOR_POS` float DEFAULT NULL COMMENT 'original keyword: ESO INS DPOR POS',
  `ESO_INS_DPOR_ST` text COMMENT 'original keyword: ESO INS DPOR ST',
  `ESO_INS_FILT1_ID` text COMMENT 'original keyword: ESO INS FILT1 ID',
  `ESO_INS_FILT1_NAME` text COMMENT 'original keyword: ESO INS FILT1 NAME',
  `ESO_INS_FILT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NO',
  `ESO_INS_GRIS1_ID` text COMMENT 'original keyword: ESO INS GRIS1 ID',
  `ESO_INS_GRIS1_NAME` text COMMENT 'original keyword: ESO INS GRIS1 NAME',
  `ESO_INS_GRIS1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS GRIS1 NO',
  `ESO_INS_GRIS1_TYPE` text COMMENT 'original keyword: ESO INS GRIS1 TYPE',
  `ESO_INS_ID` text COMMENT 'original keyword: ESO INS ID',
  `ESO_INS_MODE` text COMMENT 'original keyword: ESO INS MODE',
  `ESO_INS_SLIT1_ENC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 ENC',
  `ESO_INS_SLIT1_LEN` float DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 LEN',
  `ESO_INS_SLIT1_NAME` text COMMENT 'original keyword: ESO INS SLIT1 NAME',
  `ESO_INS_SLIT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 NO',
  `ESO_INS_SLIT1_WID` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS SLIT1 WID',
  `ESO_INS_SWSIM` text COMMENT 'original keyword: ESO INS SWSIM',
  `ESO_INS_WP_NAME` text COMMENT 'original keyword: ESO INS WP NAME',
  `ESO_INS_WP_ST` text COMMENT 'original keyword: ESO INS WP ST',
  `ESO_OBS_DID` text COMMENT 'original keyword: ESO OBS DID',
  `ESO_OBS_EXECTIME` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS EXECTIME',
  `ESO_OBS_GRP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS GRP',
  `ESO_OBS_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS ID',
  `ESO_OBS_NAME` text COMMENT 'original keyword: ESO OBS NAME',
  `ESO_OBS_OBSERVER` text COMMENT 'original keyword: ESO OBS OBSERVER',
  `ESO_OBS_PI_COI_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI ID',
  `ESO_OBS_PI_COI_NAME` text COMMENT 'original keyword: ESO OBS PI-COI NAME',
  `ESO_OBS_PROG_ID` text COMMENT 'original keyword: ESO OBS PROG ID',
  `ESO_OBS_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO OBS START',
  `ESO_OBS_TPLNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS TPLNO',
  `ESO_OCS_DET1_IMGNAME` text COMMENT 'original keyword: ESO OCS DET1 IMGNAME',
  `ESO_TEL_AIRM_END` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM END',
  `ESO_TEL_AIRM_START` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM START',
  `ESO_TEL_ALT` float DEFAULT NULL COMMENT 'original keyword: ESO TEL ALT',
  `ESO_TEL_AMBI_FWHM_END` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM END',
  `ESO_TEL_AMBI_FWHM_START` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM START',
  `ESO_TEL_AMBI_PRES_END` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES END',
  `ESO_TEL_AMBI_PRES_START` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES START',
  `ESO_TEL_AMBI_RHUM` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI RHUM',
  `ESO_TEL_AMBI_TEMP` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI TEMP',
  `ESO_TEL_AMBI_WINDDIR` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDDIR',
  `ESO_TEL_AMBI_WINDSP` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDSP',
  `ESO_TEL_AZ` float DEFAULT NULL COMMENT 'original keyword: ESO TEL AZ',
  `ESO_TEL_CHOP_ST` text COMMENT 'original keyword: ESO TEL CHOP ST',
  `ESO_TEL_DATE` datetime DEFAULT NULL COMMENT 'original keyword: ESO TEL DATE',
  `ESO_TEL_DID` text COMMENT 'original keyword: ESO TEL DID',
  `ESO_TEL_DOME_STATUS` text COMMENT 'original keyword: ESO TEL DOME STATUS',
  `ESO_TEL_FOCU_ID` text COMMENT 'original keyword: ESO TEL FOCU ID',
  `ESO_TEL_FOCU_LEN` float DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU LEN',
  `ESO_TEL_FOCU_SCALE` float DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU SCALE',
  `ESO_TEL_FOCU_VALUE` float DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU VALUE',
  `ESO_TEL_GEOELEV` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOELEV',
  `ESO_TEL_GEOLAT` float DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLAT',
  `ESO_TEL_GEOLON` float DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLON',
  `ESO_TEL_ID` text COMMENT 'original keyword: ESO TEL ID',
  `ESO_TEL_MOON_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON DEC',
  `ESO_TEL_MOON_RA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON RA',
  `ESO_TEL_OPER` text COMMENT 'original keyword: ESO TEL OPER',
  `ESO_TEL_PARANG_END` float DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG END',
  `ESO_TEL_PARANG_START` float DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG START',
  `ESO_TEL_TARG_ALPHA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG ALPHA',
  `ESO_TEL_TARG_COORDTYPE` text COMMENT 'original keyword: ESO TEL TARG COORDTYPE',
  `ESO_TEL_TARG_DELTA` float DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG DELTA',
  `ESO_TEL_TARG_EPOCH` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCH',
  `ESO_TEL_TARG_EPOCHSYSTEM` text COMMENT 'original keyword: ESO TEL TARG EPOCHSYSTEM',
  `ESO_TEL_TARG_EQUINOX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EQUINOX',
  `ESO_TEL_TARG_PARALLAX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PARALLAX',
  `ESO_TEL_TARG_PMA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMA',
  `ESO_TEL_TARG_PMD` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMD',
  `ESO_TEL_TARG_RADVEL` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG RADVEL',
  `ESO_TEL_TH_M1_TEMP` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TEL TH M1 TEMP',
  `ESO_TEL_TRAK_STATUS` text COMMENT 'original keyword: ESO TEL TRAK STATUS',
  `ESO_TEL_TSS_TEMP8` float DEFAULT NULL COMMENT 'original keyword: ESO TEL TSS TEMP8',
  `ESO_TPL_DID` text COMMENT 'original keyword: ESO TPL DID',
  `ESO_TPL_EXPNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL EXPNO',
  `ESO_TPL_ID` text COMMENT 'original keyword: ESO TPL ID',
  `ESO_TPL_NAME` text COMMENT 'original keyword: ESO TPL NAME',
  `ESO_TPL_NEXP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL NEXP',
  `ESO_TPL_PRESEQ` text COMMENT 'original keyword: ESO TPL PRESEQ',
  `ESO_TPL_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO TPL START',
  `ESO_TPL_VERSION` text COMMENT 'original keyword: ESO TPL VERSION',
  `EXPTIME` double DEFAULT NULL,
  `EXTEND` text,
  `GCOUNT` tinyint(4) DEFAULT NULL,
  `INHERIT` text,
  `INSTRUME` text,
  `LST` double DEFAULT NULL,
  `MJD_OBS` double DEFAULT NULL COMMENT 'original keyword: MJD-OBS',
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` int(11) DEFAULT NULL,
  `OBJECT` text,
  `OBSERVER` text,
  `ORIGFILE` text,
  `ORIGIN` text,
  `PCOUNT` tinyint(4) DEFAULT NULL,
  `PI_COI` text COMMENT 'original keyword: PI-COI',
  `RA` double DEFAULT NULL,
  `RADECSYS` text,
  `SIMPLE` text,
  `TELESCOP` text,
  `UTC` int(11) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` mediumtext,
  `filename` varchar(200) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `AIRMASS` double DEFAULT NULL,
  `APERTURE` double DEFAULT NULL,
  `APNUM1` text,
  `ARC` text,
  `BANDID1` text,
  `BANDID2` text,
  `BANDID3` text,
  `BANDID4` text,
  `BIASSEC` text,
  `BUNIT` text,
  `CCDMEAN` double DEFAULT NULL,
  `CCDMEANT` int(11) DEFAULT NULL,
  `CCDPROC` text,
  `CCDSEC` text,
  `CD1_1` double DEFAULT NULL,
  `CD2_2` double DEFAULT NULL,
  `CD3_3` double DEFAULT NULL,
  `CONTNORM` text,
  `CTYPE3` text,
  `DC_FLAG` tinyint(4) DEFAULT NULL COMMENT 'original keyword: DC-FLAG',
  `DCLOG1` text,
  `DETRON` float DEFAULT NULL,
  `DISPELEM` text,
  `EFFRON` double DEFAULT NULL,
  `ESO_ADA_GUID_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID DEC',
  `ESO_ADA_GUID_RA` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID RA',
  `ESO_DET_TELE_INT` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET TELE INT',
  `ESO_DET_TELE_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET TELE NO',
  `ESO_DET_TLM1_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 END',
  `ESO_DET_TLM1_ID` text COMMENT 'original keyword: ESO DET TLM1 ID',
  `ESO_DET_TLM1_NAME` text COMMENT 'original keyword: ESO DET TLM1 NAME',
  `ESO_DET_TLM1_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM1 START',
  `ESO_DET_TLM2_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 END',
  `ESO_DET_TLM2_ID` text COMMENT 'original keyword: ESO DET TLM2 ID',
  `ESO_DET_TLM2_NAME` text COMMENT 'original keyword: ESO DET TLM2 NAME',
  `ESO_DET_TLM2_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM2 START',
  `ESO_DET_TLM3_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 END',
  `ESO_DET_TLM3_ID` text COMMENT 'original keyword: ESO DET TLM3 ID',
  `ESO_DET_TLM3_NAME` text COMMENT 'original keyword: ESO DET TLM3 NAME',
  `ESO_DET_TLM3_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM3 START',
  `ESO_DET_TLM4_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 END',
  `ESO_DET_TLM4_ID` text COMMENT 'original keyword: ESO DET TLM4 ID',
  `ESO_DET_TLM4_NAME` text COMMENT 'original keyword: ESO DET TLM4 NAME',
  `ESO_DET_TLM4_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM4 START',
  `ESO_DET_TLM5_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 END',
  `ESO_DET_TLM5_ID` text COMMENT 'original keyword: ESO DET TLM5 ID',
  `ESO_DET_TLM5_NAME` text COMMENT 'original keyword: ESO DET TLM5 NAME',
  `ESO_DET_TLM5_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM5 START',
  `ESO_DET_TLM6_END` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 END',
  `ESO_DET_TLM6_ID` text COMMENT 'original keyword: ESO DET TLM6 ID',
  `ESO_DET_TLM6_NAME` text COMMENT 'original keyword: ESO DET TLM6 NAME',
  `ESO_DET_TLM6_START` float DEFAULT NULL COMMENT 'original keyword: ESO DET TLM6 START',
  `ESO_INS_MOS1_LEN` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 LEN',
  `ESO_INS_MOS1_POSX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 POSX',
  `ESO_INS_MOS1_POSY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS MOS1 POSY',
  `ESO_OBS_TARG_NAME` text COMMENT 'original keyword: ESO OBS TARG NAME',
  `ESO_OCS_CON_WCSFITS` text COMMENT 'original keyword: ESO OCS CON WCSFITS',
  `EXT_OBJ` text,
  `FILETYPE` int(11) DEFAULT NULL,
  `FILTER` text,
  `FLATCOR` text,
  `FLUXCAL` text,
  `FLUXERR` float DEFAULT NULL,
  `GAIN` float DEFAULT NULL,
  `IRAF_TLM` datetime DEFAULT NULL COMMENT 'original keyword: IRAF-TLM',
  `LACOSMIC` text,
  `LAMNLIN` int(11) DEFAULT NULL,
  `LAMRMS` double DEFAULT NULL,
  `LTM1_1` int(11) DEFAULT NULL,
  `LTM2_2` int(11) DEFAULT NULL,
  `LTM3_3` int(11) DEFAULT NULL,
  `MAGSTD` float DEFAULT NULL,
  `MJD_END` double DEFAULT NULL COMMENT 'original keyword: MJD-END',
  `M_EPOCH` text,
  `NAXIS3` tinyint(4) DEFAULT NULL,
  `NCOMBINE` tinyint(4) DEFAULT NULL,
  `OBID1` int(11) DEFAULT NULL,
  `OBSTECH` text,
  `PROCSOFT` text,
  `PRODCATG` text,
  `PROG_ID` text,
  `PROV1` text,
  `QUALITY` varchar(10) DEFAULT NULL,
  `REFERENC` text,
  `SINGLEXP` text,
  `SPECSYS` text,
  `SPEC_BIN` decimal(5,4) DEFAULT NULL,
  `SPEC_BW` double DEFAULT NULL,
  `SPEC_ERR` double DEFAULT NULL,
  `SPEC_RES` double DEFAULT NULL,
  `SPEC_SYE` double DEFAULT NULL,
  `SPEC_VAL` double DEFAULT NULL,
  `STDNAME` text,
  `TELAPSE` decimal(10,4) DEFAULT NULL,
  `TEXPTIME` double DEFAULT NULL,
  `TITLE` text,
  `TMID` double DEFAULT NULL,
  `TOT_FLUX` text,
  `TRACE1` text,
  `TRIM` text,
  `VOCLASS` text,
  `VOPUB` text,
  `WAT0_001` text,
  `WAT1_001` text,
  `WAT1_002` text,
  `WAT2_001` text,
  `WAT3_001` text,
  `WAVELMAX` double DEFAULT NULL,
  `WAVELMIN` double DEFAULT NULL,
  `WCSDIM` tinyint(4) DEFAULT NULL,
  `XMAX` double DEFAULT NULL,
  `XMIN` double DEFAULT NULL,
  `ZEROCOR` text,
  `DATAMAX` double DEFAULT NULL,
  `DATAMIN` double DEFAULT NULL,
  `SHIFT` float DEFAULT NULL,
  `ASSOC1` text,
  `ASSON1` text,
  `CA_FLAG` tinyint(4) DEFAULT NULL COMMENT 'original keyword: CA-FLAG',
  `EX_FLAG` tinyint(4) DEFAULT NULL COMMENT 'original keyword: EX-FLAG',
  `SENSFUN` text,
  `SNR` double DEFAULT NULL,
  `CD1_2` double DEFAULT NULL,
  `CD2_1` double DEFAULT NULL,
  `LTV1` double DEFAULT NULL,
  `ESO_DET_WIN1_DIT2` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 DIT2',
  `ESO_DET_WIN1_UIT2` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN1 UIT2',
  `LTV2` double DEFAULT NULL,
  `REFSPEC1` text,
  `ATMOFILE` text,
  `DISPAXIS` tinyint(4) DEFAULT NULL,
  `OBID` int(11) DEFAULT NULL,
  `DARKTIME` float DEFAULT NULL,
  `PROV2` text,
  `PROV3` text,
  `PROV4` text,
  `PROV5` text,
  `TRACE2` text,
  `TRACE3` text,
  `TRACE4` text,
  `TRACE5` text,
  `COMMENT` text,
  `FILTER1` text,
  `GRISM` text,
  `IMAGETYP` text,
  `ST` text,
  `UT` text,
  `OVERSCAN` text,
  `filetype_key_instrument` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_image_or_spectrum` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_reduction_stage` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_calibration` tinyint(4) NOT NULL DEFAULT '0',
  `transientBucketId` bigint(20) NOT NULL DEFAULT '0',
  `nameChangeRequired` tinyint(4) NOT NULL DEFAULT '0',
  `esoPhaseIII` bigint(20) NOT NULL DEFAULT '0',
  `updatedFilename` text,
  `filenameUpdated` tinyint(4) NOT NULL DEFAULT '0',
  `objectInFilename` text,
  `updateObjectName` tinyint(4) NOT NULL DEFAULT '0',
  `ASSOC2` text,
  `ASSOC3` text,
  `ASSOC4` text,
  `ASSOC5` text,
  `OBJ_OLD` text COMMENT 'original keyword: OBJ-OLD',
  `TELE_DEC` double DEFAULT NULL COMMENT 'original keyword: TELE-DEC',
  `TELE_RA` double DEFAULT NULL COMMENT 'original keyword: TELE-RA',
  `binary_table_associated_spectrum_id` bigint(20) NOT NULL DEFAULT '0',
  `currentFilename` text,
  `currentFilepath` mediumtext,
  `updatedFilepath` mediumtext,
  `archivePath` text,
  `rewriteFitsHeader` tinyint(4) NOT NULL DEFAULT '0',
  `APNUM2` text,
  `archivedLocally` tinyint(4) DEFAULT '0',
  `ESO_DET_OUT2_CHIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 CHIP',
  `ESO_DET_OUT2_CONAD` float DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 CONAD',
  `ESO_DET_OUT2_GAIN` float DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 GAIN',
  `ESO_DET_OUT2_ID` text COMMENT 'original keyword: ESO DET OUT2 ID',
  `ESO_DET_OUT2_INDEX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 INDEX',
  `ESO_DET_OUT2_NAME` text COMMENT 'original keyword: ESO DET OUT2 NAME',
  `ESO_DET_OUT2_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 NX',
  `ESO_DET_OUT2_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 NY',
  `ESO_DET_OUT2_OVSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 OVSCX',
  `ESO_DET_OUT2_OVSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 OVSCY',
  `ESO_DET_OUT2_PRSCX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 PRSCX',
  `ESO_DET_OUT2_PRSCY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 PRSCY',
  `ESO_DET_OUT2_RON` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 RON',
  `ESO_DET_OUT2_X` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 X',
  `ESO_DET_OUT2_Y` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET OUT2 Y',
  `isInTransientBucket` tinyint(4) DEFAULT NULL,
  `DATA_REL` text,
  `PROV6` text,
  `PROV16` text,
  `PROV14` text,
  `PROV15` text,
  `PROV13` text,
  `PROV12` text,
  `PROV11` text,
  `PROV10` text,
  `PROV9` text,
  `PROV8` text,
  `PROV7` text,
  `nelem` int(11) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `BI_FLAG` text COMMENT 'original keyword: BI-FLAG',
  `FF_FLAG` text COMMENT 'original keyword: FF-FLAG',
  `OTIME` int(11) DEFAULT NULL,
  `TTIME` int(11) DEFAULT NULL,
  `TRACE6` text,
  `do_not_release` tinyint(1) NOT NULL DEFAULT '0',
  `flux_scaling_factor` float DEFAULT NULL,
  `OFILTER` varchar(100) DEFAULT NULL,
  `P3ORIG` varchar(100) DEFAULT NULL,
  `RRELEASE` varchar(100) DEFAULT NULL,
  `dryx_comment` varchar(100) DEFAULT NULL,
  `lock_row` tinyint(4) DEFAULT '0',
  `TRACE10` varchar(100) DEFAULT NULL,
  `TRACE11` varchar(100) DEFAULT NULL,
  `TRACE7` varchar(100) DEFAULT NULL,
  `TRACE8` varchar(100) DEFAULT NULL,
  `TRACE9` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `filename_quality` (`filename`,`QUALITY`) KEY_BLOCK_SIZE=4096,
  UNIQUE KEY `filename` (`filename`) KEY_BLOCK_SIZE=4096,
  KEY `currentFilename` (`currentFilename`(200)) KEY_BLOCK_SIZE=4096,
  KEY `data_rel` (`DATA_REL`(50)) KEY_BLOCK_SIZE=1024,
  KEY `calibratation_reduction_stage` (`filetype_key_reduction_stage`,`filetype_key_image_or_spectrum`) KEY_BLOCK_SIZE=1024
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efosc_spectra_associations`
--

DROP TABLE IF EXISTS `efosc_spectra_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `efosc_spectra_associations` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `image_id` int(11) NOT NULL,
  `association_id` int(11) NOT NULL,
  `assoc_keyword` int(11) NOT NULL,
  `added_to_fits_header` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `imageId_assosId` (`image_id`,`association_id`),
  KEY `image_id` (`image_id`),
  KEY `association_id` (`association_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `efosc_spectra_binary_table_extension`
--

DROP TABLE IF EXISTS `efosc_spectra_binary_table_extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `efosc_spectra_binary_table_extension` (
  `efosc_spectra_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `APERTURE` double DEFAULT NULL,
  `BITPIX` tinyint(4) DEFAULT NULL,
  `CHECKSUM` varchar(100) DEFAULT NULL,
  `DATASUM` varchar(100) DEFAULT NULL,
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `EXTNAME` varchar(100) DEFAULT NULL,
  `GCOUNT` tinyint(4) DEFAULT NULL,
  `INHERIT` int(11) DEFAULT NULL,
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` tinyint(4) DEFAULT NULL,
  `NELEM` int(11) DEFAULT NULL,
  `OBJECT` varchar(100) DEFAULT NULL,
  `PCOUNT` tinyint(4) DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `SPEC_BW` double DEFAULT NULL,
  `SPEC_VAL` double DEFAULT NULL,
  `TDMAX1` double DEFAULT NULL,
  `TDMIN1` double DEFAULT NULL,
  `TELAPSE` double DEFAULT NULL,
  `TFIELDS` tinyint(4) DEFAULT NULL,
  `TFORM1` varchar(100) DEFAULT NULL,
  `TFORM2` varchar(100) DEFAULT NULL,
  `TFORM3` varchar(100) DEFAULT NULL,
  `TFORM4` varchar(100) DEFAULT NULL,
  `TFORM5` varchar(100) DEFAULT NULL,
  `TFORM6` varchar(100) DEFAULT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `TMID` double DEFAULT NULL,
  `TTYPE1` varchar(100) DEFAULT NULL,
  `TTYPE2` varchar(100) DEFAULT NULL,
  `TTYPE3` varchar(100) DEFAULT NULL,
  `TTYPE4` varchar(100) DEFAULT NULL,
  `TTYPE5` varchar(100) DEFAULT NULL,
  `TTYPE6` varchar(100) DEFAULT NULL,
  `TUCD1` varchar(100) DEFAULT NULL,
  `TUCD2` varchar(100) DEFAULT NULL,
  `TUCD3` varchar(100) DEFAULT NULL,
  `TUCD4` varchar(100) DEFAULT NULL,
  `TUCD5` varchar(100) DEFAULT NULL,
  `TUCD6` varchar(100) DEFAULT NULL,
  `TUNIT1` varchar(100) DEFAULT NULL,
  `TUNIT2` varchar(100) DEFAULT NULL,
  `TUNIT3` varchar(100) DEFAULT NULL,
  `TUNIT4` varchar(100) DEFAULT NULL,
  `TUNIT5` varchar(100) DEFAULT NULL,
  `TUNIT6` varchar(100) DEFAULT NULL,
  `TUTYP1` varchar(100) DEFAULT NULL,
  `TUTYP2` varchar(100) DEFAULT NULL,
  `TUTYP3` varchar(100) DEFAULT NULL,
  `TUTYP4` varchar(100) DEFAULT NULL,
  `TUTYP5` varchar(100) DEFAULT NULL,
  `TUTYP6` varchar(100) DEFAULT NULL,
  `VOCLASS` varchar(100) DEFAULT NULL,
  `VOPUB` varchar(100) DEFAULT NULL,
  `XTENSION` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` varchar(100) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `SIMPLE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`efosc_spectra_id`),
  UNIQUE KEY `filename` (`filename`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filetype_key_calibration`
--

DROP TABLE IF EXISTS `filetype_key_calibration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filetype_key_calibration` (
  `key` tinyint(4) NOT NULL,
  `value` varchar(45) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `value_UNIQUE` (`value`),
  UNIQUE KEY `key_UNIQUE` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filetype_key_reduction_stage`
--

DROP TABLE IF EXISTS `filetype_key_reduction_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filetype_key_reduction_stage` (
  `key` tinyint(4) NOT NULL,
  `value` varchar(45) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `value_UNIQUE` (`value`),
  UNIQUE KEY `key_UNIQUE` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fits_header_keywords`
--

DROP TABLE IF EXISTS `fits_header_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fits_header_keywords` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `mysql_keyword` varchar(200) DEFAULT NULL,
  `fits_keyword` varchar(200) NOT NULL,
  `efosc_spectrum_2d` tinyint(4) NOT NULL DEFAULT '0',
  `efosc_spectrum_1d` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_spectrum_2d` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_spectrum_binary_table` tinyint(4) NOT NULL DEFAULT '0',
  `efosc_spectrum_binary_table` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_spectrum_binary_table_extension` tinyint(4) NOT NULL DEFAULT '0',
  `efosc_spectrum_binary_table_extension` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_spectrum_1d` tinyint(4) NOT NULL DEFAULT '0',
  `efosc_image` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_image` tinyint(4) NOT NULL DEFAULT '0',
  `sofi_image_weight` tinyint(4) NOT NULL DEFAULT '0',
  `fits_comment` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `primaryId_UNIQUE` (`primaryId`),
  UNIQUE KEY `fits_keyword_UNIQUE` (`fits_keyword`),
  KEY `mysql_keywords` (`mysql_keyword`),
  KEY `fits_keywords` (`fits_keyword`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_asassn_sne`
--

DROP TABLE IF EXISTS `fs_asassn_sne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_asassn_sne` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `Classification_Age` varchar(100) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Disc_Age` varchar(100) DEFAULT NULL,
  `Galaxy_name` varchar(100) DEFAULT NULL,
  `ID` varchar(100) DEFAULT NULL,
  `No` varchar(100) DEFAULT NULL,
  `Offset` double DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `Redshift` double DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `V_abs` double DEFAULT NULL,
  `V_disc` double DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `decl` double DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `surveyUrl` varchar(100) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `id` (`ID`,`Date`),
  UNIQUE KEY `id_date` (`ID`,`Date`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`RA`,`decl`),
  KEY `ingested` (`ingested`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_asassn_transients`
--

DROP TABLE IF EXISTS `fs_asassn_transients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_asassn_transients` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `Vmag` double DEFAULT NULL,
  `comment` varchar(700) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `decDeg` double DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `specClass` varchar(100) DEFAULT NULL,
  `commentAdded` tinyint(4) NOT NULL DEFAULT '0',
  `surveyUrl` varchar(100) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name` (`name`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `html16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_atlas`
--

DROP TABLE IF EXISTS `fs_atlas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_atlas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(20) NOT NULL,
  `ra_deg` double NOT NULL,
  `dec_deg` double NOT NULL,
  `mag` float DEFAULT NULL,
  `magErr` float DEFAULT NULL COMMENT 'Mag error only available in the recurrence data',
  `filter` varchar(10) DEFAULT NULL COMMENT 'Observaton filter',
  `observationMJD` double DEFAULT NULL COMMENT 'Observation date in MJD',
  `discDate` datetime DEFAULT NULL,
  `discMag` float DEFAULT NULL,
  `suggestedType` varchar(50) DEFAULT NULL,
  `catalogType` varchar(50) DEFAULT NULL,
  `hostZ` float DEFAULT NULL,
  `targetImageURL` varchar(512) DEFAULT NULL,
  `refImageURL` varchar(512) DEFAULT NULL,
  `diffImageURL` varchar(512) DEFAULT NULL,
  `objectURL` varchar(512) DEFAULT NULL,
  `summaryRow` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Summary row flag. 1 = summary row, 0 = recurrence. There should always be one summary row and at least one recurrence.',
  `ingested` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Transient Bucket ingest flag.  Has this data been ingested yet?',
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `survey` varchar(45) NOT NULL DEFAULT 'ATLAS',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `cz` double DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `htm20ID` bigint(20) DEFAULT NULL,
  `cy` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uq_candidateID_observationMJD_mag_filter_summaryRow` (`candidateID`,`observationMJD`,`mag`,`filter`,`summaryRow`),
  UNIQUE KEY `idx_uq_candidateID_discDate` (`candidateID`,`discDate`),
  KEY `idx_candidateID` (`candidateID`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`),
  KEY `idx_htm20ID` (`htm20ID`),
  KEY `idx_transientBucketId` (`transientBucketId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_atlas_forced_phot`
--

DROP TABLE IF EXISTS `fs_atlas_forced_phot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_atlas_forced_phot` (
  `primaryId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `atlas_object_id` bigint(20) unsigned NOT NULL,
  `atlas_designation` varchar(255) NOT NULL,
  `mjd_obs` double NOT NULL,
  `filter` varchar(10) NOT NULL,
  `mag` float NOT NULL,
  `dm` float DEFAULT NULL,
  `snr` float DEFAULT NULL,
  `zp` float DEFAULT NULL,
  `limiting_mag` tinyint(1) NOT NULL,
  `raDeg` double NOT NULL,
  `decDeg` double NOT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `survey` varchar(45) DEFAULT 'ATLAS FP',
  `htm16ID` bigint(20) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `peakval` float DEFAULT NULL,
  `skyval` float DEFAULT NULL,
  `peakfit` float DEFAULT NULL,
  `dpeak` float DEFAULT NULL,
  `skyfit` float DEFAULT NULL,
  `flux` float DEFAULT NULL,
  `dflux` float DEFAULT NULL,
  `chin` float DEFAULT NULL,
  `major` float DEFAULT NULL,
  `minor` float DEFAULT NULL,
  `snrdet` float DEFAULT NULL,
  `snrlimit` float DEFAULT NULL,
  `wpflx` float DEFAULT NULL,
  `dwpflx` float DEFAULT NULL,
  `texp` float DEFAULT NULL,
  `expname` varchar(45) DEFAULT NULL,
  `apfit` float DEFAULT NULL,
  `fnu` float DEFAULT NULL,
  `marshall_mag` float DEFAULT NULL,
  `marshall_limiting_mag` float DEFAULT NULL,
  `marshall_mag_error` float DEFAULT NULL,
  `fnu_error` float DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `object_id_mjd` (`atlas_object_id`,`mjd_obs`),
  KEY `atlas_object_id` (`atlas_object_id`),
  KEY `mjd_obs` (`mjd_obs`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`),
  KEY `idx_transientBucketId` (`transientBucketId`),
  KEY `idx_atlas_designation` (`atlas_designation`),
  KEY `idx_dateCreated` (`dateCreated`),
  KEY `idx_transientBucketId_designation` (`atlas_designation`,`transientBucketId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_crts_css`
--

DROP TABLE IF EXISTS `fs_crts_css`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_crts_css` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `circularUrl` varchar(450) DEFAULT NULL,
  `comment` mediumtext,
  `commentIngested` tinyint(4) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `filter` varchar(450) DEFAULT NULL,
  `finderChartUrl` varchar(644) DEFAULT NULL,
  `finderChartWebpage` varchar(450) DEFAULT NULL,
  `imagesUrl` varchar(450) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `lightcurveUrl` varchar(450) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `observationDate` varchar(450) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(450) DEFAULT NULL,
  `surveyObjectUrl` varchar(450) DEFAULT NULL,
  `targetImageUrl` varchar(624) DEFAULT NULL,
  `transientTypePrediction` varchar(450) DEFAULT NULL,
  `uniqueId` bigint(20) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `magErr` double DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `observationmjd_name` (`observationMJD`,`name`),
  KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm10ID`),
  KEY `idx_htm13ID` (`htm13ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_crts_mls`
--

DROP TABLE IF EXISTS `fs_crts_mls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_crts_mls` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `circularUrl` varchar(450) DEFAULT NULL,
  `comment` mediumtext,
  `commentIngested` tinyint(4) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `filter` varchar(450) DEFAULT NULL,
  `finderChartUrl` varchar(618) DEFAULT NULL,
  `finderChartWebpage` varchar(450) DEFAULT NULL,
  `imagesUrl` varchar(450) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `lightcurveUrl` varchar(450) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `observationDate` varchar(450) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(450) DEFAULT NULL,
  `surveyObjectUrl` varchar(450) DEFAULT NULL,
  `targetImageUrl` varchar(614) DEFAULT NULL,
  `transientTypePrediction` varchar(450) DEFAULT NULL,
  `uniqueId` bigint(20) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `magErr` double DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `observationmjd_name` (`observationMJD`,`name`),
  KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm10ID`),
  KEY `idx_htm13ID` (`htm13ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_crts_sss`
--

DROP TABLE IF EXISTS `fs_crts_sss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_crts_sss` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `circularUrl` varchar(450) DEFAULT NULL,
  `comment` mediumtext,
  `commentIngested` tinyint(4) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `filter` varchar(450) DEFAULT NULL,
  `finderChartUrl` varchar(618) DEFAULT NULL,
  `finderChartWebpage` varchar(450) DEFAULT NULL,
  `imagesUrl` varchar(450) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `lightcurveUrl` varchar(450) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `observationDate` varchar(450) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(450) DEFAULT NULL,
  `surveyObjectUrl` varchar(450) DEFAULT NULL,
  `targetImageUrl` varchar(614) DEFAULT NULL,
  `transientTypePrediction` varchar(450) DEFAULT NULL,
  `uniqueId` bigint(20) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `magErr` double DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `observationmjd_name` (`observationMJD`,`name`),
  KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm10ID`),
  KEY `idx_htm13ID` (`htm13ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_des`
--

DROP TABLE IF EXISTS `fs_des`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_des` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `decDeg` double DEFAULT NULL,
  `filter` varchar(100) DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT NULL,
  `magnitude` double DEFAULT NULL,
  `magnitudeError` double DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `observationDate` datetime DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `signal_to_noise` double DEFAULT NULL,
  `stampUrl` varchar(690) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(100) DEFAULT NULL,
  `surveyUrl` varchar(100) DEFAULT NULL,
  `transientTypePrediction` varchar(100) DEFAULT NULL,
  `finderImageUrl` varchar(100) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `diffUrl` varchar(684) DEFAULT NULL,
  `refUrl` varchar(684) DEFAULT NULL,
  `tarUrl` varchar(682) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name_observationmjd` (`name`,`observationMJD`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_gaia`
--

DROP TABLE IF EXISTS `fs_gaia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_gaia` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `candidateID` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dec_deg` double DEFAULT NULL,
  `discDate` varchar(100) DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `filter` varchar(100) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `objectURL` varchar(100) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `ra_deg` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `survey` varchar(10) DEFAULT 'Gaia',
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `cz` double DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `htm20ID` bigint(20) DEFAULT NULL,
  `cy` double DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `candidateid_observationmjd` (`candidateID`,`observationMJD`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`),
  KEY `idx_htm20ID` (`htm20ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_master`
--

DROP TABLE IF EXISTS `fs_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_master` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `comment` varchar(700) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `imageUrl` varchar(200) DEFAULT NULL,
  `magnitude` double DEFAULT NULL,
  `masterInt` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `telescope` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `survey` varchar(45) DEFAULT 'master',
  `discoveryMjd` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `filter` varchar(45) DEFAULT 'unfiltered',
  `candidateUrl` varchar(100) DEFAULT 'http://observ.pereplet.ru/sn_e.html',
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `day` varchar(100) DEFAULT NULL,
  `month` varchar(100) DEFAULT NULL,
  `tripletImageUrl` varchar(100) DEFAULT NULL,
  `year` varchar(100) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_ogle`
--

DROP TABLE IF EXISTS `fs_ogle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_ogle` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `filter` varchar(450) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `lastNonDetectionDate` varchar(450) DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `lightcurveUrl` varchar(614) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `observationDate` varchar(450) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `referenceFitsUrl` varchar(616) DEFAULT NULL,
  `referenceImageUrl` varchar(616) DEFAULT NULL,
  `subtractedFitsUrl` varchar(634) DEFAULT NULL,
  `subtractedImageUrl` varchar(634) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `survey` varchar(50) DEFAULT NULL,
  `surveyObjectUrl` varchar(450) DEFAULT NULL,
  `targetFitsUrl` varchar(638) DEFAULT NULL,
  `targetImageUrl` varchar(638) DEFAULT NULL,
  `transientTypePrediction` varchar(450) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `seeing` double DEFAULT NULL,
  `background` double DEFAULT NULL,
  `magErr` double DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `observationmjd_name_survey` (`observationMJD`,`name`,`survey`),
  UNIQUE KEY `observationmjd_name` (`observationMJD`,`name`),
  KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_panstarrs`
--

DROP TABLE IF EXISTS `fs_panstarrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_panstarrs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(20) NOT NULL,
  `ra_deg` double NOT NULL,
  `dec_deg` double NOT NULL,
  `mag` float DEFAULT NULL,
  `magErr` float DEFAULT NULL COMMENT 'Mag error only available in the recurrence data',
  `filter` varchar(10) DEFAULT NULL COMMENT 'Observaton filter',
  `observationMJD` double DEFAULT NULL COMMENT 'Observation date in MJD',
  `discDate` date DEFAULT NULL,
  `discMag` float DEFAULT NULL,
  `suggestedType` varchar(50) DEFAULT NULL,
  `catalogType` varchar(50) DEFAULT NULL,
  `hostZ` float DEFAULT NULL,
  `targetImageURL` varchar(512) DEFAULT NULL,
  `refImageURL` varchar(512) DEFAULT NULL,
  `diffImageURL` varchar(512) DEFAULT NULL,
  `objectURL` varchar(512) DEFAULT NULL,
  `ingested` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Transient Bucket ingest flag.  Has this data been ingested yet?',
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `survey` varchar(45) NOT NULL DEFAULT 'PS1',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `transientBucketId` bigint(20) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `idx_uq_candidateID_discDate` (`candidateID`,`discDate`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `uni_id_mag_mjd` (`candidateID`,`mag`,`observationMJD`),
  KEY `idx_candidateID` (`candidateID`) KEY_BLOCK_SIZE=1024,
  KEY `idx_htm16ID` (`htm16ID`) KEY_BLOCK_SIZE=1024,
  KEY `htm16` (`htm16ID`) KEY_BLOCK_SIZE=1024,
  KEY `ingested` (`ingested`) KEY_BLOCK_SIZE=1024,
  KEY `idx_htm10ID` (`htm13ID`) KEY_BLOCK_SIZE=1024,
  KEY `idx_htm13ID` (`htm13ID`) KEY_BLOCK_SIZE=1024,
  KEY `i_htm10ID` (`htm10ID`) KEY_BLOCK_SIZE=1024,
  KEY `i_htm13ID` (`htm13ID`) KEY_BLOCK_SIZE=1024,
  KEY `i_htm16ID` (`htm16ID`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_skymapper`
--

DROP TABLE IF EXISTS `fs_skymapper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_skymapper` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `RA` double DEFAULT NULL,
  `bestType` varchar(100) DEFAULT NULL,
  `candidateID` varchar(100) NOT NULL,
  `candidateURL` varchar(1000) DEFAULT NULL,
  `comment` varchar(2000) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateLastRead` datetime DEFAULT NULL,
  `diffThumbURL` varchar(1000) DEFAULT NULL,
  `discFilt` varchar(10) DEFAULT NULL,
  `discMJD` double DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `filt` varchar(10) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `magerr` double DEFAULT NULL,
  `mjd` double DEFAULT NULL,
  `newThumbURL` varchar(1000) DEFAULT NULL,
  `noneFilt` varchar(10) DEFAULT NULL,
  `noneMJD` double DEFAULT NULL,
  `noneMag` double DEFAULT NULL,
  `numDet` int(11) DEFAULT NULL,
  `refThumbURL` varchar(1000) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `survey` varchar(45) DEFAULT 'skymapper',
  `ingested` tinyint(4) DEFAULT '0',
  `summaryRow` tinyint(4) DEFAULT NULL,
  `finderURL` varchar(624) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `cz` double DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `htm20ID` bigint(20) DEFAULT NULL,
  `cy` double DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `candidateid_mjd` (`candidateID`,`mjd`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`),
  KEY `idx_htm20ID` (`htm20ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_tns_transients`
--

DROP TABLE IF EXISTS `fs_tns_transients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_tns_transients` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `decDeg` double NOT NULL,
  `decSex` varchar(100) DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `discMagFilter` varchar(20) DEFAULT NULL,
  `discoverer` varchar(100) DEFAULT NULL,
  `hostName` varchar(100) DEFAULT NULL,
  `hostRedshift` double DEFAULT NULL,
  `objectName` varchar(120) NOT NULL,
  `objectUrl` varchar(100) DEFAULT NULL,
  `raDeg` double NOT NULL,
  `raSex` varchar(100) DEFAULT NULL,
  `survey` varchar(40) DEFAULT NULL,
  `tnsId` int(11) DEFAULT NULL,
  `specType` varchar(20) DEFAULT NULL,
  `transRedshift` double DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `classificationDate` datetime DEFAULT NULL,
  `classificationDateParsed` tinyint(4) DEFAULT '0',
  `lastNonDetectionDateParsed` tinyint(4) DEFAULT '0',
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `objectname` (`objectName`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_user_added`
--

DROP TABLE IF EXISTS `fs_user_added`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_user_added` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(70) NOT NULL,
  `ra_deg` double NOT NULL,
  `dec_deg` double NOT NULL,
  `mag` float DEFAULT NULL,
  `magErr` float DEFAULT NULL COMMENT 'Mag error only available in the recurrence data',
  `filter` varchar(10) DEFAULT NULL COMMENT 'Observaton filter',
  `observationMJD` double DEFAULT NULL COMMENT 'Observation date in MJD',
  `discDate` date DEFAULT NULL,
  `discMag` float DEFAULT NULL,
  `suggestedType` varchar(50) DEFAULT NULL,
  `catalogType` varchar(50) DEFAULT NULL,
  `hostZ` float DEFAULT NULL,
  `targetImageURL` varchar(512) DEFAULT NULL,
  `objectURL` varchar(512) DEFAULT NULL,
  `summaryRow` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Summary row flag. 1 = summary row, 0 = recurrence. There should always be one summary row and at least one recurrence.',
  `ingested` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Transient Bucket ingest flag.  Has this data been ingested yet?',
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `survey` varchar(20) DEFAULT NULL,
  `author` varchar(100) NOT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `suggestedClassification` varchar(45) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uq_candidateID_observationMJD_mag_filter_summaryRow` (`candidateID`,`observationMJD`,`mag`,`filter`,`summaryRow`),
  UNIQUE KEY `idx_uq_candidateID_discDate` (`candidateID`,`discDate`),
  KEY `idx_candidateID` (`candidateID`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fs_ztf`
--

DROP TABLE IF EXISTS `fs_ztf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fs_ztf` (
  `candidateId` bigint(20) DEFAULT NULL,
  `objectId` varchar(50) NOT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `mjd` double NOT NULL,
  `fid` tinyint(4) DEFAULT NULL,
  `magpsf` double DEFAULT NULL,
  `sigmapsf` double DEFAULT NULL,
  `isdiffpos` char(1) DEFAULT NULL,
  `rb` float DEFAULT NULL,
  `magzpsci` double DEFAULT NULL,
  `magzpsciunc` double DEFAULT NULL,
  `filt` char(1) DEFAULT NULL,
  `surveyUrl` varchar(200) DEFAULT NULL,
  `tripletImageUrl` varchar(200) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `htm16ID` bigint(20) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `scorr` double DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT '0',
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `magnr` double DEFAULT NULL,
  `sigmagnr` double DEFAULT NULL,
  `distnr` double DEFAULT NULL,
  `distpsnr1` double DEFAULT NULL,
  `sgscore1` double DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `uni_objectId_mjd` (`objectId`,`mjd`),
  UNIQUE KEY `candidateId_UNIQUE` (`candidateId`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm10ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `idx_filt` (`filt`),
  KEY `idx_fid` (`fid`),
  KEY `idx_filt_fid` (`fid`,`filt`),
  KEY `idx_transientBucketID` (`transientBucketId`),
  KEY `idx_dateCreated` (`dateCreated`),
  KEY `idx_objectID` (`objectId`),
  KEY `idx_surveyUrl` (`surveyUrl`),
  KEY `idx_tripletImageUrl` (`tripletImageUrl`),
  KEY `idx_mjd` (`mjd`),
  KEY `idx_isdiffpos` (`isdiffpos`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs_executable_timings`
--

DROP TABLE IF EXISTS `logs_executable_timings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs_executable_timings` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(200) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `running_time` varchar(100) NOT NULL,
  PRIMARY KEY (`primaryId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_survey_marshall_discoveries`
--

DROP TABLE IF EXISTS `map_survey_marshall_discoveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_survey_marshall_discoveries` (
  `columnName` varchar(150) NOT NULL,
  `tns_sources` varchar(150) DEFAULT NULL,
  `tns_photometry` varchar(150) DEFAULT NULL,
  `view_tns_photometry_discoveries` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`columnName`),
  UNIQUE KEY `columnName_UNIQUE` (`columnName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_survey_marshall_photometry`
--

DROP TABLE IF EXISTS `map_survey_marshall_photometry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_survey_marshall_photometry` (
  `columnName` varchar(150) NOT NULL,
  `tns_photometry` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`columnName`),
  UNIQUE KEY `columnName_UNIQUE` (`columnName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_survey_marshall_spectra`
--

DROP TABLE IF EXISTS `map_survey_marshall_spectra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_survey_marshall_spectra` (
  `columnName` varchar(150) NOT NULL,
  `tns_spectra` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`columnName`),
  UNIQUE KEY `columnName_UNIQUE` (`columnName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_survey_transientBucket`
--

DROP TABLE IF EXISTS `map_survey_transientBucket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_survey_transientBucket` (
  `columnName` varchar(150) NOT NULL,
  PRIMARY KEY (`columnName`),
  UNIQUE KEY `columnName_UNIQUE` (`columnName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_fs_column_map`
--

DROP TABLE IF EXISTS `marshall_fs_column_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_fs_column_map` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `fs_table_name` varchar(45) NOT NULL,
  `fs_survey_name` varchar(45) DEFAULT NULL,
  `transientBucket_column` varchar(45) DEFAULT NULL,
  `fs_table_column` varchar(45) NOT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `unquie_fs_table_name_fs_table_column` (`fs_table_name`,`fs_table_column`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_sources`
--

DROP TABLE IF EXISTS `marshall_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_sources` (
  `marshallId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `raDeg` double DEFAULT NULL COMMENT 'RA is decimal degreed',
  `decDeg` double DEFAULT NULL COMMENT 'DEC in decimal degrees',
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sherlockClassification` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`marshallId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_marshallId` (`marshallId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_raDeg_decDeg` (`raDeg`,`decDeg`) KEY_BLOCK_SIZE=1024,
  KEY `i_marshallId` (`marshallId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_sources_discoveries`
--

DROP TABLE IF EXISTS `marshall_sources_discoveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_sources_discoveries` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `marshallId` bigint(20) NOT NULL,
  `name` varchar(40) NOT NULL COMMENT 'the name of the transient given by the reporting survey.',
  `survey` varchar(20) NOT NULL COMMENT 'the survey reporting observation of this transient',
  `discoveryPhase` varchar(20) DEFAULT NULL COMMENT 'the discovery phase given by the reporting survey (if any)',
  `surveyObjectUrl` varchar(200) DEFAULT NULL COMMENT 'the url for dedicated webpage of transients supplied by the reporting survey (if any)',
  `transientTypePrediction` varchar(40) DEFAULT NULL COMMENT 'an attempt at predicting the transient type by the reporting survey.',
  `transientTypePredicationSource` varchar(40) DEFAULT NULL COMMENT 'the name of the source/catalogue that was used to predict the transient type',
  `hostRedshift` float DEFAULT NULL COMMENT 'redshift measure for the host',
  `hostRedshiftType` varchar(10) DEFAULT NULL COMMENT 'type of redshift measure for the host galaxy\n',
  `referenceImageUrl` varchar(500) DEFAULT NULL COMMENT 'true or false',
  `targetImageUrl` varchar(500) DEFAULT NULL COMMENT 'true or false',
  `subtractedImageUrl` varchar(500) DEFAULT NULL,
  `tripletImageUrl` varchar(500) DEFAULT NULL,
  `finderImageUrl` varchar(450) DEFAULT NULL,
  `lightcurveURL` varchar(450) DEFAULT NULL,
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `masterId` int(11) NOT NULL DEFAULT '0' COMMENT 'If this flag is set (=1) then the transient is assigned this name as it''s master ID. If not set (=0) then there is another entry in this table where the master ID has been set.',
  `raDeg` double NOT NULL,
  `decDeg` double NOT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_primaryId` (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `marshallId_survey` (`marshallId`,`survey`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `i_marshallId` (`marshallId`),
  KEY `i_survey` (`survey`),
  KEY `i_surveyId` (`name`),
  KEY `i_masterId` (`masterId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_sources_photometry`
--

DROP TABLE IF EXISTS `marshall_sources_photometry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_sources_photometry` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `marshallId` bigint(20) NOT NULL,
  `name` varchar(40) NOT NULL COMMENT 'the name of the transient given by the reporting survey.',
  `observationDate` datetime NOT NULL COMMENT 'the survey observation date',
  `observationMJD` double NOT NULL COMMENT 'the survey observation MJD',
  `magnitude` float NOT NULL COMMENT 'the survey magnitude',
  `magnitudeError` float DEFAULT NULL COMMENT 'the survey magnitude error',
  `filter` varchar(20) DEFAULT NULL COMMENT 'survey filter',
  `telescope` varchar(100) DEFAULT NULL,
  `instrument` varchar(100) DEFAULT NULL,
  `dateDeleted` datetime DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_primaryId` (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_surveyId_mjd` (`name`,`observationMJD`),
  KEY `i_marshallId` (`marshallId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_sources_related_files`
--

DROP TABLE IF EXISTS `marshall_sources_related_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_sources_related_files` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `marshallId` bigint(20) NOT NULL,
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_primaryId` (`primaryId`) KEY_BLOCK_SIZE=1024,
  KEY `i_marshallId` (`marshallId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_sources_spectra`
--

DROP TABLE IF EXISTS `marshall_sources_spectra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_sources_spectra` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `marshallId` bigint(20) NOT NULL,
  `name` varchar(40) NOT NULL COMMENT 'the name of the transient given by the reporting survey.',
  `observationDate` datetime DEFAULT NULL COMMENT 'the survey observation date',
  `observationMJD` double NOT NULL COMMENT 'the survey observation MJD',
  `transientRedshift` float DEFAULT NULL COMMENT 'redshift as measured from a spectrum of the transient',
  `transientRedshiftNotes` varchar(40) DEFAULT NULL COMMENT 'transient redshift notes',
  `spectralType` varchar(100) NOT NULL COMMENT 'the spectral classification given by the reporting survey (if any)',
  `telescope` varchar(100) DEFAULT NULL,
  `instrument` varchar(100) DEFAULT NULL,
  `reducer` varchar(100) DEFAULT NULL,
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `classificationWRTMax` varchar(45) DEFAULT NULL,
  `classificationPhase` int(11) DEFAULT NULL,
  `survey` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_primaryId` (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `u_marshallId_mjd` (`marshallId`,`observationMJD`),
  UNIQUE KEY `u_name_mjd` (`name`,`observationMJD`),
  UNIQUE KEY `u_id_survey_specType` (`spectralType`,`marshallId`,`survey`),
  KEY `i_marshallId` (`marshallId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marshall_transient_akas`
--

DROP TABLE IF EXISTS `marshall_transient_akas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_transient_akas` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `transientBucketId` bigint(20) NOT NULL,
  `name` varchar(45) NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `uni_transientbucketid_name` (`transientBucketId`,`name`),
  KEY `idx_transientbucketid` (`transientBucketId`),
  KEY `idx_name` (`name`),
  KEY `idx_url` (`url`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_workflow_lists_counts`
--

DROP TABLE IF EXISTS `meta_workflow_lists_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_workflow_lists_counts` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `listname` varchar(100) DEFAULT NULL,
  `count` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `primaryId_UNIQUE` (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `listname_unique` (`listname`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ntt_photometric_night_log`
--

DROP TABLE IF EXISTS `ntt_photometric_night_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ntt_photometric_night_log` (
  `night_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `flag` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`night_date`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ntt_photometric_night_log_keys`
--

DROP TABLE IF EXISTS `ntt_photometric_night_log_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ntt_photometric_night_log_keys` (
  `flag` tinyint(4) NOT NULL DEFAULT '0',
  `value` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`flag`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ntt_standards`
--

DROP TABLE IF EXISTS `ntt_standards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ntt_standards` (
  `primaryId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `primaryId_UNIQUE` (`primaryId`),
  UNIQUE KEY `object_UNIQUE` (`object`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pesstoObjects`
--

DROP TABLE IF EXISTS `pesstoObjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pesstoObjects` (
  `pesstoObjectsId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'This is the primary ID for all pessto objects. All helper tables with reference this ID to associate data with the pessto object.',
  `transientBucketId` int(11) NOT NULL COMMENT 'the primary ID of the pessto object in the master_sn_list table.',
  `classifiedFlag` tinyint(4) NOT NULL DEFAULT '0',
  `marshallWorkflowLocation` varchar(45) NOT NULL COMMENT 'pessto workflow status flag 01 (cannot be null)',
  `alertWorkflowLocation` varchar(45) NOT NULL COMMENT 'pessto workflow status flag 02 (can be null)',
  `publicStatus` int(11) NOT NULL COMMENT 'the release status of the object',
  `dateAdded` datetime NOT NULL COMMENT 'date the pessto object was added to this database',
  `dateLastModified` datetime NOT NULL COMMENT 'date the entry for the pessto object **in this table** was last modified.',
  `finderChartLocalUrl` varchar(300) DEFAULT NULL,
  `lsq_stamp` tinyint(4) DEFAULT NULL,
  `css_stamp` tinyint(4) DEFAULT NULL,
  `lsq_lightcurve` tinyint(4) DEFAULT NULL,
  `ogle_target_stamp` tinyint(4) DEFAULT NULL,
  `ogle_lightcurve` tinyint(4) DEFAULT NULL,
  `ogle_subtracted_stamp` tinyint(4) DEFAULT NULL,
  `ogle_reference_stamp` tinyint(4) DEFAULT NULL,
  `mls_stamp` tinyint(4) DEFAULT NULL,
  `sss_stamp` tinyint(4) DEFAULT NULL,
  `css_lightcurve` tinyint(4) DEFAULT NULL,
  `sss_lightcurve` tinyint(4) DEFAULT NULL,
  `mls_lightcurve` tinyint(4) DEFAULT NULL,
  `ps1_subtracted_stamp` tinyint(4) DEFAULT NULL,
  `ps1_target_stamp` tinyint(4) DEFAULT NULL,
  `ps1_reference_stamp` tinyint(4) DEFAULT NULL,
  `skymapper_reference_stamp` tinyint(4) DEFAULT NULL,
  `skymapper_subtracted_stamp` tinyint(4) DEFAULT NULL,
  `skymapper_target_stamp` tinyint(4) DEFAULT NULL,
  `ogle_color_context_stamp` tinyint(4) DEFAULT NULL,
  `pi_name` varchar(200) DEFAULT NULL,
  `pi_email` varchar(200) DEFAULT NULL,
  `master_pessto_lightcurve` tinyint(4) DEFAULT NULL,
  `classification_finalised` tinyint(4) NOT NULL DEFAULT '0',
  `master_stamp` tinyint(4) DEFAULT NULL,
  `bsl_stamp` tinyint(4) DEFAULT NULL,
  `observationPriority` tinyint(4) DEFAULT '2',
  `lastTimeReviewed` datetime DEFAULT NULL,
  `mpcMatch` varchar(200) DEFAULT NULL,
  `snoozed` tinyint(4) DEFAULT '0',
  `lastReviewedMag` float DEFAULT NULL,
  `lastReviewedMagDate` datetime DEFAULT NULL,
  `des_target_stamp` tinyint(4) DEFAULT NULL,
  `des_reference_stamp` tinyint(4) DEFAULT NULL,
  `des_subtracted_stamp` tinyint(4) DEFAULT NULL,
  `gaia_stamp` tinyint(4) DEFAULT NULL,
  `ps1_map` tinyint(4) DEFAULT NULL,
  `photometry_catalogue_release` varchar(45) DEFAULT NULL,
  `transient_catalogue_release` varchar(45) DEFAULT NULL,
  `followup_target_release` varchar(45) DEFAULT NULL,
  `pessto_citations` varchar(200) DEFAULT NULL,
  `atlas_target_stamp` tinyint(4) DEFAULT NULL,
  `atlas_subtracted_stamp` tinyint(4) DEFAULT NULL,
  `atlas_reference_stamp` tinyint(4) DEFAULT NULL,
  `atlas_fp_lightcurve` datetime DEFAULT NULL,
  `ztf_stamp` tinyint(4) DEFAULT NULL,
  `user_added_stamp` tinyint(4) DEFAULT NULL,
  `resurrectionCount` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`pesstoObjectsId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `pesstoObjectId_UNIQUE` (`pesstoObjectsId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `masterSnId_UNIQUE` (`transientBucketId`) KEY_BLOCK_SIZE=1024,
  KEY `transientBucketId` (`transientBucketId`),
  KEY `classified` (`classifiedFlag`),
  KEY `mwl` (`marshallWorkflowLocation`),
  KEY `awl` (`alertWorkflowLocation`),
  FULLTEXT KEY `fulltext` (`pi_name`),
  FULLTEXT KEY `fulltext_pi_name` (`pi_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pesstoObjectsChangeLog`
--

DROP TABLE IF EXISTS `pesstoObjectsChangeLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pesstoObjectsChangeLog` (
  `pesstoObjectsChangeLog` int(11) NOT NULL AUTO_INCREMENT,
  `pesstoObjectsId` int(11) NOT NULL,
  `whatWasChanged` mediumtext NOT NULL,
  `whenChangeOccured` datetime NOT NULL,
  `changeAuthor` varchar(45) NOT NULL,
  PRIMARY KEY (`pesstoObjectsChangeLog`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pesstoObjectsComments`
--

DROP TABLE IF EXISTS `pesstoObjectsComments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pesstoObjectsComments` (
  `pesstoObjectsCommentsId` int(11) NOT NULL AUTO_INCREMENT,
  `pesstoObjectsId` int(11) NOT NULL,
  `commentAuthor` varchar(50) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateLastModified` datetime NOT NULL,
  `removed` tinyint(4) NOT NULL DEFAULT '0',
  `localAttachmentUrl` varchar(300) DEFAULT NULL,
  `comment` longtext NOT NULL,
  PRIMARY KEY (`pesstoObjectsCommentsId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `objectId_date_author_comment` (`pesstoObjectsId`,`dateCreated`,`commentAuthor`,`comment`(90)) KEY_BLOCK_SIZE=1024,
  KEY `pesstoObjectsId` (`pesstoObjectsId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pessto_marshall_object_summaries`
--

DROP TABLE IF EXISTS `pessto_marshall_object_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pessto_marshall_object_summaries` (
  `transientBucketId` bigint(20) NOT NULL COMMENT 'This is set to the primaryKeyId of the **first** entry of this object into the database (i.e. earliest dateCreated)',
  `name` varchar(40) CHARACTER SET utf8 NOT NULL COMMENT 'the name of the transient given by the reporting survey.',
  `survey` varchar(45) CHARACTER SET utf8 DEFAULT NULL COMMENT 'the survey reporting observation of this transient',
  `raDeg` double DEFAULT NULL COMMENT 'RA is decimal degreed',
  `decDeg` double DEFAULT NULL COMMENT 'DEC in decimal degrees',
  `spectralType` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT 'the spectral classification given by the reporting survey (if any)',
  `transientRedshift` float DEFAULT NULL COMMENT 'redshift as measured from a spectrum of the transient'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pessto_papers`
--

DROP TABLE IF EXISTS `pessto_papers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pessto_papers` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `abstract_url` varchar(640) DEFAULT NULL,
  `article_url` varchar(638) DEFAULT NULL,
  `athors` varchar(800) DEFAULT NULL,
  `bibcode` varchar(200) DEFAULT NULL,
  `citations_count` int(11) DEFAULT NULL,
  `citations_url` varchar(642) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `ejournal_url` varchar(640) DEFAULT NULL,
  `journal` varchar(616) DEFAULT NULL,
  `preprint_url` varchar(640) DEFAULT NULL,
  `pubdate` datetime DEFAULT NULL,
  `refcit_count` tinyint(4) DEFAULT NULL,
  `refcit_url` varchar(636) DEFAULT NULL,
  `title` varchar(800) DEFAULT NULL,
  `authors` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `bibcode_pubdate` (`bibcode`,`pubdate`) KEY_BLOCK_SIZE=4096
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phase_iii_photometry_catalogue_ssdr3`
--

DROP TABLE IF EXISTS `phase_iii_photometry_catalogue_ssdr3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_iii_photometry_catalogue_ssdr3` (
  `PHOT_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `SOURCE_ID` varchar(45) DEFAULT NULL,
  `MJD` decimal(7,2) NOT NULL,
  `U_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `U_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `B_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `B_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `V_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `V_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `R_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `R_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `I_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `I_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `U_AB_MAG` decimal(7,2) DEFAULT NULL,
  `U_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `G_AB_MAG` decimal(7,2) DEFAULT NULL,
  `G_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `R_AB_MAG` decimal(7,2) DEFAULT NULL,
  `R_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `I_AB_MAG` decimal(7,2) DEFAULT NULL,
  `I_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `Z_AB_MAG` decimal(7,2) DEFAULT NULL,
  `Z_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `J_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `J_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `H_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `H_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `KS_VEGA_MAG` decimal(7,2) DEFAULT NULL,
  `KS_VEGA_MAGERR` decimal(7,2) DEFAULT NULL,
  `LSQGR_AB_MAG` decimal(7,2) DEFAULT NULL,
  `LSQGR_AB_MAGERR` decimal(7,2) DEFAULT NULL,
  `UVW2_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `UVW2_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  `UVM2_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `UVM2_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  `UVW1_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `UVW1_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  `U_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `U_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  `B_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `B_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  `V_SWIFT_MAG` decimal(7,2) DEFAULT NULL,
  `V_SWIFT_MAGERR` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`PHOT_ID`),
  UNIQUE KEY `UNIQUE_SOURCE_MJD` (`SOURCE_ID`,`MJD`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phase_iii_transient_catalogue_ssdr2`
--

DROP TABLE IF EXISTS `phase_iii_transient_catalogue_ssdr2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_iii_transient_catalogue_ssdr2` (
  `primaryKeyId` int(11) NOT NULL AUTO_INCREMENT,
  `TRANSIENT_ID` varchar(250) NOT NULL,
  `TRANSIENT_RAJ2000` double NOT NULL,
  `INTERNAL_ID` tinyint(4) DEFAULT NULL,
  `TRANSIENT_DECJ2000` double NOT NULL,
  `TRANSIENT_CLASSIFICATION` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PECULIAR_FLAG` tinyint(4) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_SOURCE` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_ATEL` int(11) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_MJD` int(11) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_REDSHIFT` double DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE_DAYS_LOWER_LIMIT` tinyint(4) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE_DAYS_UPPER_LIMIT` tinyint(4) DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MJD` int(11) DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MAG` double DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MAG_FILTER` varchar(45) DEFAULT NULL,
  `FOLLOWUP_TARGET` tinyint(4) DEFAULT NULL,
  `HOST_SEARCH_STAGE` tinyint(4) DEFAULT NULL,
  `HOST_ID` varchar(45) DEFAULT NULL,
  `HOST_RAJ2000` varchar(45) DEFAULT NULL,
  `HOST_DECJ2000` varchar(45) DEFAULT NULL,
  `HOST_OFFSET_N_ARCSEC` double DEFAULT NULL,
  `HOST_OFFSET_E_ARCSEC` double DEFAULT NULL,
  `HOST_OFFSET_N` double DEFAULT NULL,
  `HOST_OFFSET_E` double DEFAULT NULL,
  `HOST_REDSHIFT_SPEC_SOURCE` varchar(45) DEFAULT NULL,
  `HOST_REDSHIFT_SPEC` double DEFAULT NULL,
  `HOST_REDSHIFT_PHOT_SOURCE` varchar(45) DEFAULT NULL,
  `HOST_REDSHIFT_PHOT` double DEFAULT NULL,
  `HOST_REDSHIFT_PHOT_ERR` double DEFAULT NULL,
  `PREVIOUS_TRANSIENT_ID` varchar(45) DEFAULT NULL,
  `Disc_Date` datetime DEFAULT NULL,
  `Classifcaition_Date` datetime DEFAULT NULL,
  `Phase` varchar(45) DEFAULT NULL,
  `Notes` varchar(200) DEFAULT NULL,
  `Marshall_Link` varchar(200) DEFAULT NULL,
  `TransientBucketId` bigint(20) NOT NULL,
  `Atel_Link` varchar(200) DEFAULT NULL,
  `Name_in_Atel` varchar(200) DEFAULT NULL,
  `RA` varchar(200) DEFAULT NULL,
  `DEC` varchar(200) DEFAULT NULL,
  `initial_release_number` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`primaryKeyId`),
  UNIQUE KEY `primaryKeyId_UNIQUE` (`primaryKeyId`),
  UNIQUE KEY `transientID` (`TRANSIENT_ID`),
  UNIQUE KEY `ra_dec` (`TRANSIENT_RAJ2000`,`TRANSIENT_DECJ2000`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phase_iii_transient_catalogue_ssdr3`
--

DROP TABLE IF EXISTS `phase_iii_transient_catalogue_ssdr3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_iii_transient_catalogue_ssdr3` (
  `ISSUES` varchar(300) DEFAULT NULL,
  `primaryKeyId` int(11) NOT NULL AUTO_INCREMENT,
  `TRANSIENT_ID` varchar(250) NOT NULL,
  `TRANSIENT_RAJ2000` double NOT NULL,
  `INTERNAL_ID` tinyint(4) DEFAULT NULL,
  `TRANSIENT_DECJ2000` double NOT NULL,
  `TRANSIENT_CLASSIFICATION` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PECULIAR_FLAG` tinyint(4) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_SOURCE` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_ATEL` int(11) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_MJD` int(11) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_REDSHIFT` double DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE` varchar(45) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE_DAYS_LOWER_LIMIT` tinyint(4) DEFAULT NULL,
  `TRANSIENT_CLASSIFICATION_PHASE_DAYS_UPPER_LIMIT` tinyint(4) DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MJD` int(11) DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MAG` double DEFAULT NULL,
  `TRANSIENT_DISCOVERY_MAG_FILTER` varchar(45) DEFAULT NULL,
  `FOLLOWUP_TARGET` tinyint(4) DEFAULT NULL,
  `HOST_SEARCH_STAGE` tinyint(4) DEFAULT NULL,
  `HOST_ID` varchar(45) DEFAULT NULL,
  `HOST_RAJ2000` varchar(45) DEFAULT NULL,
  `HOST_DECJ2000` varchar(45) DEFAULT NULL,
  `HOST_OFFSET_N_ARCSEC` double DEFAULT NULL,
  `HOST_OFFSET_E_ARCSEC` double DEFAULT NULL,
  `HOST_OFFSET_N` double DEFAULT NULL,
  `HOST_OFFSET_E` double DEFAULT NULL,
  `HOST_REDSHIFT_SPEC_SOURCE` varchar(45) DEFAULT NULL,
  `HOST_REDSHIFT_SPEC` double DEFAULT NULL,
  `HOST_REDSHIFT_PHOT_SOURCE` varchar(45) DEFAULT NULL,
  `HOST_REDSHIFT_PHOT` double DEFAULT NULL,
  `HOST_REDSHIFT_PHOT_ERR` double DEFAULT NULL,
  `PREVIOUS_TRANSIENT_ID` varchar(45) DEFAULT NULL,
  `marshall_discovery_date` datetime DEFAULT NULL,
  `marshall_classification_date` datetime DEFAULT NULL,
  `marshall_classification_phase` varchar(45) DEFAULT NULL,
  `marshall_classification` varchar(45) DEFAULT NULL,
  `marshall_transient_redshift` double DEFAULT NULL,
  `atel_discovery_date` datetime DEFAULT NULL,
  `atel_classification_date` datetime DEFAULT NULL,
  `atel_classification_phase` varchar(45) DEFAULT NULL,
  `atel_classification` varchar(45) DEFAULT NULL,
  `atel_transient_redshift` double DEFAULT NULL,
  `atel_notes` varchar(200) DEFAULT NULL,
  `TransientBucketId` bigint(20) NOT NULL,
  `atel_source_name` varchar(200) DEFAULT NULL,
  `atel_ra` varchar(200) DEFAULT NULL,
  `atel_dec` varchar(200) DEFAULT NULL,
  `initial_release_number` varchar(45) DEFAULT NULL,
  `erratum_atel` varchar(45) DEFAULT NULL,
  `marshall_classification_phase_days` int(11) DEFAULT NULL,
  `atel_discovery_survey` varchar(80) DEFAULT NULL,
  `atel_discovery_mag` double DEFAULT NULL,
  `atel_note_index` varchar(10) DEFAULT NULL,
  `tmp` varchar(45) DEFAULT NULL,
  `TRANSIENT_IAU_ID` varchar(250) DEFAULT NULL,
  `TRANSIENT_ALTERNATIVE_IDS` varchar(250) DEFAULT NULL,
  `TRANSIENT_DISCOVERY_ID` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`primaryKeyId`),
  UNIQUE KEY `primaryKeyId_UNIQUE` (`primaryKeyId`),
  UNIQUE KEY `transientid` (`TRANSIENT_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scheduler_api_calls`
--

DROP TABLE IF EXISTS `scheduler_api_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scheduler_api_calls` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `transientBucketId` bigint(20) NOT NULL,
  `objectName` varchar(50) NOT NULL,
  `magnitude` double DEFAULT NULL,
  `limitingMagnitude` tinyint(4) DEFAULT NULL,
  `apiCallType` varchar(45) DEFAULT NULL,
  `triggerTime` datetime NOT NULL,
  `stampUrl` varchar(200) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `primaryId_UNIQUE` (`primaryId`),
  UNIQUE KEY `uni_transientbucketid_triggerDate` (`transientBucketId`,`triggerTime`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sherlock_classifications`
--

DROP TABLE IF EXISTS `sherlock_classifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sherlock_classifications` (
  `transient_object_id` bigint(20) NOT NULL,
  `classification` varchar(45) DEFAULT NULL,
  `annotation` mediumtext,
  `summary` varchar(50) DEFAULT NULL,
  `mismatchComment` varchar(500) DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated` varchar(45) DEFAULT '0',
  `user` varchar(80) DEFAULT NULL,
  `commentDate` datetime DEFAULT NULL,
  `separationArcsec` double DEFAULT NULL,
  PRIMARY KEY (`transient_object_id`),
  KEY `idx_classification` (`classification`),
  KEY `idx_summary` (`summary`),
  KEY `idx_dateLastModified` (`dateLastModified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `sherlock_classifications_BEFORE_INSERT` BEFORE INSERT ON `sherlock_classifications` FOR EACH ROW
BEGIN
    IF new.classification = "ORPHAN" THEN
        SET new.annotation = "The transient location is not matched against any known catalogued source", new.summary = "No catalogued match";
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `sherlock_classifications_AFTER_INSERT` AFTER INSERT ON `sherlock_classifications` FOR EACH ROW
BEGIN
    update `transientBucket` set `sherlockClassification` = new.classification
					where `transientBucketId`  = new.transient_object_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sherlock_crossmatches`
--

DROP TABLE IF EXISTS `sherlock_crossmatches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sherlock_crossmatches` (
  `transient_object_id` bigint(20) unsigned DEFAULT NULL,
  `catalogue_object_id` varchar(200) DEFAULT NULL,
  `catalogue_table_id` smallint(5) unsigned DEFAULT NULL,
  `separationArcsec` double DEFAULT NULL,
  `northSeparationArcsec` double DEFAULT NULL,
  `eastSeparationArcsec` double DEFAULT NULL,
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `z` double DEFAULT NULL,
  `scale` double DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `distance_modulus` double DEFAULT NULL,
  `photoZ` double DEFAULT NULL,
  `photoZErr` double DEFAULT NULL,
  `association_type` varchar(45) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `physical_separation_kpc` double DEFAULT NULL,
  `catalogue_object_type` varchar(45) DEFAULT NULL,
  `catalogue_object_subtype` varchar(45) DEFAULT NULL,
  `association_rank` int(11) DEFAULT NULL,
  `catalogue_table_name` varchar(100) DEFAULT NULL,
  `catalogue_view_name` varchar(100) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  `rankScore` double DEFAULT NULL,
  `search_name` varchar(100) DEFAULT NULL,
  `major_axis_arcsec` double DEFAULT NULL,
  `direct_distance` double DEFAULT NULL,
  `direct_distance_scale` double DEFAULT NULL,
  `direct_distance_modulus` double DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `original_search_radius_arcsec` double DEFAULT NULL,
  `catalogue_view_id` int(11) DEFAULT NULL,
  `U` double DEFAULT NULL,
  `UErr` double DEFAULT NULL,
  `B` double DEFAULT NULL,
  `BErr` double DEFAULT NULL,
  `V` double DEFAULT NULL,
  `VErr` double DEFAULT NULL,
  `R` double DEFAULT NULL,
  `RErr` double DEFAULT NULL,
  `I` double DEFAULT NULL,
  `IErr` double DEFAULT NULL,
  `J` double DEFAULT NULL,
  `JErr` double DEFAULT NULL,
  `H` double DEFAULT NULL,
  `HErr` double DEFAULT NULL,
  `K` double DEFAULT NULL,
  `KErr` double DEFAULT NULL,
  `_u` double DEFAULT NULL,
  `_uErr` double DEFAULT NULL,
  `_g` double DEFAULT NULL,
  `_gErr` double DEFAULT NULL,
  `_r` double DEFAULT NULL,
  `_rErr` double DEFAULT NULL,
  `_i` double DEFAULT NULL,
  `_iErr` double DEFAULT NULL,
  `_z` double DEFAULT NULL,
  `_zErr` double DEFAULT NULL,
  `_y` double DEFAULT NULL,
  `_yErr` double DEFAULT NULL,
  `G` double DEFAULT NULL,
  `GErr` double DEFAULT NULL,
  `unkMag` double DEFAULT NULL,
  `unkMagErr` double DEFAULT NULL,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` tinyint(4) DEFAULT '0',
  `classificationReliability` tinyint(4) DEFAULT NULL,
  `transientAbsMag` double DEFAULT NULL,
  `merged_rank` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `key_transient_object_id` (`transient_object_id`),
  KEY `key_catalogue_object_id` (`catalogue_object_id`),
  KEY `idx_separationArcsec` (`separationArcsec`),
  KEY `idx_rank` (`rank`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sofi_imaging`
--

DROP TABLE IF EXISTS `sofi_imaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sofi_imaging` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `AIRMASS` double DEFAULT NULL,
  `ARCFILE` varchar(200) DEFAULT NULL,
  `BIASSEC` varchar(200) DEFAULT NULL,
  `BITPIX` int(11) DEFAULT NULL,
  `BUNIT` varchar(200) DEFAULT NULL,
  `CCDMEANT` int(11) DEFAULT NULL,
  `CCDPROC` varchar(200) DEFAULT NULL,
  `CCDSEC` varchar(200) DEFAULT NULL,
  `CD1_1` double DEFAULT NULL,
  `CD2_2` double DEFAULT NULL,
  `CDELT1` double DEFAULT NULL,
  `CDELT2` double DEFAULT NULL,
  `CHECKSUM` varchar(200) DEFAULT NULL,
  `CROSSTAL` varchar(200) DEFAULT NULL,
  `CRPIX1` double DEFAULT NULL,
  `CRPIX2` double DEFAULT NULL,
  `CRVAL1` double DEFAULT NULL,
  `CRVAL2` double DEFAULT NULL,
  `CTYPE1` varchar(200) DEFAULT NULL,
  `CTYPE2` varchar(200) DEFAULT NULL,
  `DATAMAX` double DEFAULT NULL,
  `DATAMIN` double DEFAULT NULL,
  `DATASUM` varchar(200) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `DATE_OBS` datetime DEFAULT NULL COMMENT 'original keyword: DATE-OBS',
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `DETRON` double DEFAULT NULL,
  `DIT` double DEFAULT NULL,
  `EQUINOX` double DEFAULT NULL,
  `ESO_ADA_ABSROT_END` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT END',
  `ESO_ADA_ABSROT_START` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT START',
  `ESO_ADA_GUID_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID STATUS',
  `ESO_ADA_POSANG` double DEFAULT NULL COMMENT 'original keyword: ESO ADA POSANG',
  `ESO_DET_CHIP_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP ID',
  `ESO_DET_CHIP_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NAME',
  `ESO_DET_CHIP_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NX',
  `ESO_DET_CHIP_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NY',
  `ESO_DET_CHIP_PXSPACE` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP PXSPACE',
  `ESO_DET_CHIP_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP TYPE',
  `ESO_DET_CHOP_CYCSKIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP CYCSKIP',
  `ESO_DET_CHOP_FREQ` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP FREQ',
  `ESO_DET_CHOP_NCYCLES` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP NCYCLES',
  `ESO_DET_CHOP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP ST',
  `ESO_DET_CON_OPMODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CON OPMODE',
  `ESO_DET_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET DID',
  `ESO_DET_DIT` double DEFAULT NULL COMMENT 'original keyword: ESO DET DIT',
  `ESO_DET_DITDELAY` double DEFAULT NULL COMMENT 'original keyword: ESO DET DITDELAY',
  `ESO_DET_EXP_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NAME',
  `ESO_DET_EXP_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NO',
  `ESO_DET_EXP_UTC` datetime DEFAULT NULL COMMENT 'original keyword: ESO DET EXP UTC',
  `ESO_DET_FILE_CUBE_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET FILE CUBE ST',
  `ESO_DET_FRAM_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM NO',
  `ESO_DET_FRAM_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM TYPE',
  `ESO_DET_FRAM_UTC` datetime DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM UTC',
  `ESO_DET_IRACE_ADC1_DELAY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 DELAY',
  `ESO_DET_IRACE_ADC1_ENABLE` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 ENABLE',
  `ESO_DET_IRACE_ADC1_FILTER1` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 FILTER1',
  `ESO_DET_IRACE_ADC1_FILTER2` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 FILTER2',
  `ESO_DET_IRACE_ADC1_HEADER` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 HEADER',
  `ESO_DET_IRACE_ADC1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 NAME',
  `ESO_DET_IRACE_SEQCONT` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE SEQCONT',
  `ESO_DET_MODE_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET MODE NAME',
  `ESO_DET_NCORRS` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NCORRS',
  `ESO_DET_NCORRS_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET NCORRS NAME',
  `ESO_DET_NDIT` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NDIT',
  `ESO_DET_NDITSKIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NDITSKIP',
  `ESO_DET_RSPEED` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET RSPEED',
  `ESO_DET_RSPEEDADD` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET RSPEEDADD',
  `ESO_DET_WIN_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN NX',
  `ESO_DET_WIN_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN NY',
  `ESO_DET_WIN_STARTX` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN STARTX',
  `ESO_DET_WIN_STARTY` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN STARTY',
  `ESO_DET_WIN_TYPE` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN TYPE',
  `ESO_DPR_CATG` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR CATG',
  `ESO_DPR_TECH` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TECH',
  `ESO_DPR_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TYPE',
  `ESO_INS_COLLIM_ENC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS COLLIM ENC',
  `ESO_INS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS DID',
  `ESO_INS_FILT1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 ID',
  `ESO_INS_FILT1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NAME',
  `ESO_INS_FILT1_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NO',
  `ESO_INS_FILT1_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 TYPE',
  `ESO_INS_FILT2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 ID',
  `ESO_INS_FILT2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 NAME',
  `ESO_INS_FILT2_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 NO',
  `ESO_INS_FILT2_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 TYPE',
  `ESO_INS_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS ID',
  `ESO_INS_MODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS MODE',
  `ESO_INS_OPTI1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 ID',
  `ESO_INS_OPTI1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 NAME',
  `ESO_INS_OPTI1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 NO',
  `ESO_INS_OPTI1_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 TYPE',
  `ESO_INS_OPTI2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 ID',
  `ESO_INS_OPTI2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 NAME',
  `ESO_INS_OPTI2_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 NO',
  `ESO_INS_OPTI2_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 TYPE',
  `ESO_INS_OPTI3_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 ID',
  `ESO_INS_OPTI3_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 NAME',
  `ESO_INS_OPTI3_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 NO',
  `ESO_INS_OPTI3_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 TYPE',
  `ESO_INS_PIXSCALE` double DEFAULT NULL COMMENT 'original keyword: ESO INS PIXSCALE',
  `ESO_INS_SWSIM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS SWSIM',
  `ESO_INS_TEMP_DETSW` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-DETSW',
  `ESO_INS_TEMP_DETSW_SET` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-DETSW SET',
  `ESO_INS_TEMP_MON_NAME1` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME1',
  `ESO_INS_TEMP_MON_NAME10` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME10',
  `ESO_INS_TEMP_MON_NAME2` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME2',
  `ESO_INS_TEMP_MON_NAME3` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME3',
  `ESO_INS_TEMP_MON_NAME4` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME4',
  `ESO_INS_TEMP_MON_NAME5` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME5',
  `ESO_INS_TEMP_MON_NAME6` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME6',
  `ESO_INS_TEMP_MON_NAME7` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME7',
  `ESO_INS_TEMP_MON_NAME8` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME8',
  `ESO_INS_TEMP_MON_NAME9` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME9',
  `ESO_INS_TEMP_MON_TEMP1` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP1',
  `ESO_INS_TEMP_MON_TEMP10` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP10',
  `ESO_INS_TEMP_MON_TEMP2` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP2',
  `ESO_INS_TEMP_MON_TEMP3` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP3',
  `ESO_INS_TEMP_MON_TEMP4` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP4',
  `ESO_INS_TEMP_MON_TEMP5` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP5',
  `ESO_INS_TEMP_MON_TEMP6` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP6',
  `ESO_INS_TEMP_MON_TEMP7` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP7',
  `ESO_INS_TEMP_MON_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP8',
  `ESO_INS_TEMP_MON_TEMP9` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP9',
  `ESO_INS_TEMP_VACP` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-VACP',
  `ESO_INS_TIME` datetime DEFAULT NULL COMMENT 'original keyword: ESO INS TIME',
  `ESO_OBS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS DID',
  `ESO_OBS_EXECTIME` double DEFAULT NULL COMMENT 'original keyword: ESO OBS EXECTIME',
  `ESO_OBS_GRP` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS GRP',
  `ESO_OBS_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS ID',
  `ESO_OBS_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS NAME',
  `ESO_OBS_OBSERVER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS OBSERVER',
  `ESO_OBS_PI_COI_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI ID',
  `ESO_OBS_PI_COI_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI NAME',
  `ESO_OBS_PROG_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PROG ID',
  `ESO_OBS_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO OBS START',
  `ESO_OBS_TARG_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS TARG NAME',
  `ESO_OBS_TPLNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS TPLNO',
  `ESO_OCS_COMP_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS COMP ID',
  `ESO_OCS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS DID',
  `ESO_OCS_SELECT_ARM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS SELECT-ARM',
  `ESO_SEQ_CUMOFFSETA` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ CUMOFFSETA',
  `ESO_SEQ_CUMOFFSETD` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ CUMOFFSETD',
  `ESO_SEQ_CUMOFFSETX` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ CUMOFFSETX',
  `ESO_SEQ_CUMOFFSETY` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ CUMOFFSETY',
  `ESO_SEQ_POISSON` int(11) DEFAULT NULL COMMENT 'original keyword: ESO SEQ POISSON',
  `ESO_SEQ_RELOFFSETX` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ RELOFFSETX',
  `ESO_SEQ_RELOFFSETY` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ RELOFFSETY',
  `ESO_TEL_AIRM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM END',
  `ESO_TEL_AIRM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM START',
  `ESO_TEL_ALT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL ALT',
  `ESO_TEL_AMBI_FWHM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM END',
  `ESO_TEL_AMBI_FWHM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM START',
  `ESO_TEL_AMBI_PRES_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES END',
  `ESO_TEL_AMBI_PRES_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES START',
  `ESO_TEL_AMBI_RHUM` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI RHUM',
  `ESO_TEL_AMBI_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI TEMP',
  `ESO_TEL_AMBI_WINDDIR` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDDIR',
  `ESO_TEL_AMBI_WINDSP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDSP',
  `ESO_TEL_AZ` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AZ',
  `ESO_TEL_CHOP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL CHOP ST',
  `ESO_TEL_DATE` datetime DEFAULT NULL COMMENT 'original keyword: ESO TEL DATE',
  `ESO_TEL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DID',
  `ESO_TEL_DOME_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DOME STATUS',
  `ESO_TEL_FOCU_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU ID',
  `ESO_TEL_FOCU_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU LEN',
  `ESO_TEL_FOCU_SCALE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU SCALE',
  `ESO_TEL_FOCU_VALUE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU VALUE',
  `ESO_TEL_GEOELEV` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOELEV',
  `ESO_TEL_GEOLAT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLAT',
  `ESO_TEL_GEOLON` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLON',
  `ESO_TEL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL ID',
  `ESO_TEL_MOON_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON DEC',
  `ESO_TEL_MOON_RA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON RA',
  `ESO_TEL_OPER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL OPER',
  `ESO_TEL_PARANG_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG END',
  `ESO_TEL_PARANG_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG START',
  `ESO_TEL_TARG_ALPHA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG ALPHA',
  `ESO_TEL_TARG_COORDTYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG COORDTYPE',
  `ESO_TEL_TARG_DELTA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG DELTA',
  `ESO_TEL_TARG_EPOCH` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCH',
  `ESO_TEL_TARG_EPOCHSYSTEM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCHSYSTEM',
  `ESO_TEL_TARG_EQUINOX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EQUINOX',
  `ESO_TEL_TARG_PARALLAX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PARALLAX',
  `ESO_TEL_TARG_PMA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMA',
  `ESO_TEL_TARG_PMD` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMD',
  `ESO_TEL_TARG_RADVEL` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG RADVEL',
  `ESO_TEL_TH_M1_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TH M1 TEMP',
  `ESO_TEL_TRAK_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TRAK STATUS',
  `ESO_TEL_TSS_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TSS TEMP8',
  `ESO_TPL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL DID',
  `ESO_TPL_EXPNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO TPL EXPNO',
  `ESO_TPL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL ID',
  `ESO_TPL_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL NAME',
  `ESO_TPL_NEXP` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TPL NEXP',
  `ESO_TPL_PRESEQ` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL PRESEQ',
  `ESO_TPL_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO TPL START',
  `ESO_TPL_VERSION` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL VERSION',
  `EXPTIME` double DEFAULT NULL,
  `EXTEND` varchar(200) DEFAULT NULL,
  `FILETYPE` int(11) DEFAULT NULL,
  `FILTER` varchar(200) DEFAULT NULL,
  `FLATCOR` varchar(200) DEFAULT NULL,
  `GAIN` double DEFAULT NULL,
  `ILLUMCOR` varchar(200) DEFAULT NULL,
  `INSTRUME` varchar(200) DEFAULT NULL,
  `IRAF_TLM` datetime DEFAULT NULL COMMENT 'original keyword: IRAF-TLM',
  `LST` double DEFAULT NULL,
  `LTM1_1` double DEFAULT NULL,
  `LTM2_2` double DEFAULT NULL,
  `MBKG` double DEFAULT NULL,
  `MJD_END` double DEFAULT NULL COMMENT 'original keyword: MJD-END',
  `MJD_OBS` double DEFAULT NULL COMMENT 'original keyword: MJD-OBS',
  `M_EPOCH` varchar(200) DEFAULT NULL,
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` int(11) DEFAULT NULL,
  `NDIT` tinyint(4) DEFAULT NULL,
  `OBID1` int(11) DEFAULT NULL,
  `OBJECT` varchar(200) DEFAULT NULL,
  `OBSERVER` varchar(200) DEFAULT NULL,
  `OBSTECH` varchar(200) DEFAULT NULL,
  `ORIGFILE` varchar(200) DEFAULT NULL,
  `ORIGIN` varchar(200) DEFAULT NULL,
  `PI_COI` varchar(200) DEFAULT NULL COMMENT 'original keyword: PI-COI',
  `PIXSCALE` double DEFAULT NULL,
  `PROCSOFT` varchar(200) DEFAULT NULL,
  `PRODCATG` varchar(200) DEFAULT NULL,
  `PROG_ID` varchar(200) DEFAULT NULL,
  `PROV1` varchar(200) DEFAULT NULL,
  `QUALITY` varchar(200) DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `RADECSYS` varchar(200) DEFAULT NULL,
  `REFERENC` varchar(200) DEFAULT NULL,
  `SIMPLE` varchar(200) DEFAULT NULL,
  `SINGLEXP` varchar(200) DEFAULT NULL,
  `SKYSUB` varchar(200) DEFAULT NULL,
  `TELESCOP` varchar(200) DEFAULT NULL,
  `TEXPTIME` double DEFAULT NULL,
  `TRACE1` varchar(200) DEFAULT NULL,
  `TRIM` varchar(200) DEFAULT NULL,
  `UTC` double DEFAULT NULL,
  `WAT0_001` varchar(200) DEFAULT NULL,
  `WAT1_001` varchar(200) DEFAULT NULL,
  `WAT2_001` varchar(200) DEFAULT NULL,
  `WCSDIM` tinyint(4) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` varchar(1000) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `CCDMEAN` double DEFAULT NULL,
  `ESO_OCS_WCS_RTD_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS WCS-RTD ST',
  `PC1_1` double DEFAULT NULL,
  `PC1_2` double DEFAULT NULL,
  `PC2_1` double DEFAULT NULL,
  `PC2_2` double DEFAULT NULL,
  `NCOMBINE` tinyint(4) DEFAULT NULL,
  `OBJMASK` varchar(200) DEFAULT NULL,
  `PROV2` varchar(200) DEFAULT NULL,
  `PROV3` varchar(200) DEFAULT NULL,
  `PROV4` varchar(200) DEFAULT NULL,
  `TRACE2` varchar(200) DEFAULT NULL,
  `TRACE3` varchar(200) DEFAULT NULL,
  `TRACE4` varchar(200) DEFAULT NULL,
  `IMCMB001` varchar(200) DEFAULT NULL,
  `IMCMB002` varchar(200) DEFAULT NULL,
  `OBID` int(11) DEFAULT NULL,
  `ESO_ADA_GUID_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID DEC',
  `ESO_ADA_GUID_RA` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID RA',
  `COMMENT` varchar(200) DEFAULT NULL,
  `ABMAGLIM` double DEFAULT NULL,
  `ABMAGSAT` double DEFAULT NULL,
  `ASSOC1` varchar(200) DEFAULT NULL,
  `ASSON1` varchar(200) DEFAULT NULL,
  `ASTROMET` varchar(200) DEFAULT NULL,
  `CD1_2` double DEFAULT NULL,
  `CD2_1` double DEFAULT NULL,
  `CRDER1` double DEFAULT NULL,
  `CRDER2` double DEFAULT NULL,
  `CSYER1` double DEFAULT NULL,
  `CSYER2` double DEFAULT NULL,
  `CUNIT1` varchar(200) DEFAULT NULL,
  `CUNIT2` varchar(200) DEFAULT NULL,
  `ELLIPTIC` double DEFAULT NULL,
  `FLUXCAL` varchar(200) DEFAULT NULL,
  `NJITTER` tinyint(4) DEFAULT NULL,
  `NOFFSETS` tinyint(4) DEFAULT NULL,
  `NTCRPIX1` double DEFAULT NULL,
  `NTCRPIX2` double DEFAULT NULL,
  `NUSTEP` tinyint(4) DEFAULT NULL,
  `PHOTSYS` varchar(200) DEFAULT NULL,
  `PHOTZP` double DEFAULT NULL,
  `PHOTZPER` double DEFAULT NULL,
  `PROV10` varchar(200) DEFAULT NULL,
  `PROV11` varchar(200) DEFAULT NULL,
  `PSF_FWHM` double DEFAULT NULL,
  `PROV12` varchar(200) DEFAULT NULL,
  `ZPJJH` varchar(200) DEFAULT NULL,
  `PROV13` varchar(200) DEFAULT NULL,
  `PROV5` varchar(200) DEFAULT NULL,
  `PROV14` varchar(200) DEFAULT NULL,
  `PROV6` varchar(200) DEFAULT NULL,
  `PROV15` varchar(200) DEFAULT NULL,
  `PROV7` varchar(200) DEFAULT NULL,
  `PROV16` varchar(200) DEFAULT NULL,
  `PROV8` varchar(200) DEFAULT NULL,
  `PROV9` varchar(200) DEFAULT NULL,
  `TRACE10` varchar(200) DEFAULT NULL,
  `TRACE11` varchar(200) DEFAULT NULL,
  `TRACE12` varchar(200) DEFAULT NULL,
  `TRACE13` varchar(200) DEFAULT NULL,
  `TRACE5` varchar(200) DEFAULT NULL,
  `TRACE14` varchar(200) DEFAULT NULL,
  `TRACE6` varchar(200) DEFAULT NULL,
  `TRACE15` varchar(200) DEFAULT NULL,
  `TRACE7` varchar(200) DEFAULT NULL,
  `TRACE16` varchar(200) DEFAULT NULL,
  `TRACE8` varchar(200) DEFAULT NULL,
  `TRACE9` varchar(200) DEFAULT NULL,
  `ZPKHK` varchar(200) DEFAULT NULL,
  `DARKTIME` double DEFAULT NULL,
  `ZPHJH` varchar(200) DEFAULT NULL,
  `MKILLUM` varchar(200) DEFAULT NULL,
  `HDRVER` datetime DEFAULT NULL,
  `filetype_key_instrument` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_image_or_spectrum` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_reduction_stage` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_calibration` tinyint(4) NOT NULL DEFAULT '0',
  `transientBucketId` bigint(20) NOT NULL DEFAULT '0',
  `nameChangeRequired` tinyint(4) NOT NULL DEFAULT '0',
  `esoPhaseIII` tinyint(4) NOT NULL DEFAULT '0',
  `updatedFilename` varchar(200) DEFAULT NULL,
  `filenameUpdated` tinyint(4) NOT NULL DEFAULT '0',
  `objectInFilename` varchar(100) DEFAULT NULL,
  `updateObjectName` tinyint(4) NOT NULL DEFAULT '0',
  `currentFilename` varchar(200) DEFAULT NULL,
  `currentFilepath` varchar(500) DEFAULT NULL,
  `updatedFilepath` varchar(1000) DEFAULT NULL,
  `archivePath` varchar(200) DEFAULT NULL,
  `rewriteFitsHeader` tinyint(4) NOT NULL DEFAULT '0',
  `archivedLocally` tinyint(4) DEFAULT '0',
  `isInTransientBucket` tinyint(4) DEFAULT NULL,
  `DATA_REL` varchar(45) DEFAULT NULL,
  `NTID` tinyint(4) DEFAULT NULL,
  `ESO_INS_LAMP3_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP3 NAME',
  `ESO_INS_LAMP3_SET` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP3 SET',
  `EFFRON` double DEFAULT '0',
  `astromet_rmsx` double DEFAULT NULL,
  `astromet_rmsy` double DEFAULT NULL,
  `astromet_sources` tinyint(4) DEFAULT NULL,
  `astromet_error_arcsec` double DEFAULT NULL,
  `RRELEASE` varchar(100) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `EXTNAME` varchar(100) DEFAULT NULL,
  `INHERIT` varchar(100) DEFAULT NULL,
  `XTENSION` varchar(100) DEFAULT NULL,
  `TELAPSE` double DEFAULT NULL,
  `TMID` double DEFAULT NULL,
  `PROV17` varchar(100) DEFAULT NULL,
  `PROV18` varchar(100) DEFAULT NULL,
  `PROV19` varchar(100) DEFAULT NULL,
  `PROV20` varchar(100) DEFAULT NULL,
  `PROV21` varchar(100) DEFAULT NULL,
  `PROV22` varchar(100) DEFAULT NULL,
  `PROV23` varchar(100) DEFAULT NULL,
  `PROV24` varchar(100) DEFAULT NULL,
  `TRACE17` varchar(100) DEFAULT NULL,
  `TRACE18` varchar(100) DEFAULT NULL,
  `TRACE19` varchar(100) DEFAULT NULL,
  `TRACE20` varchar(100) DEFAULT NULL,
  `TRACE21` varchar(100) DEFAULT NULL,
  `TRACE22` varchar(100) DEFAULT NULL,
  `TRACE23` varchar(100) DEFAULT NULL,
  `TRACE24` varchar(100) DEFAULT NULL,
  `do_not_release` tinyint(1) NOT NULL DEFAULT '0',
  `ESO_SEQ_JITTER_WIDTH` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ JITTER WIDTH',
  `ESO_SEQ_SKYTHROW` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ SKYTHROW',
  `dryx_comment` varchar(100) DEFAULT NULL,
  `lock_row` tinyint(4) DEFAULT '0',
  `PROV25` varchar(100) DEFAULT NULL,
  `PROV26` varchar(100) DEFAULT NULL,
  `PROV27` varchar(100) DEFAULT NULL,
  `PROV28` varchar(100) DEFAULT NULL,
  `PROV29` varchar(100) DEFAULT NULL,
  `PROV30` varchar(100) DEFAULT NULL,
  `PROV31` varchar(100) DEFAULT NULL,
  `PROV32` varchar(100) DEFAULT NULL,
  `TRACE25` varchar(100) DEFAULT NULL,
  `TRACE26` varchar(100) DEFAULT NULL,
  `TRACE27` varchar(100) DEFAULT NULL,
  `TRACE28` varchar(100) DEFAULT NULL,
  `TRACE29` varchar(100) DEFAULT NULL,
  `TRACE30` varchar(100) DEFAULT NULL,
  `TRACE31` varchar(100) DEFAULT NULL,
  `TRACE32` varchar(100) DEFAULT NULL,
  `PROV33` varchar(100) DEFAULT NULL,
  `PROV34` varchar(100) DEFAULT NULL,
  `PROV35` varchar(100) DEFAULT NULL,
  `PROV36` varchar(100) DEFAULT NULL,
  `TRACE33` varchar(100) DEFAULT NULL,
  `TRACE34` varchar(100) DEFAULT NULL,
  `TRACE35` varchar(100) DEFAULT NULL,
  `TRACE36` varchar(100) DEFAULT NULL,
  `PROV37` varchar(100) DEFAULT NULL,
  `PROV38` varchar(100) DEFAULT NULL,
  `PROV39` varchar(100) DEFAULT NULL,
  `PROV40` varchar(100) DEFAULT NULL,
  `PROV41` varchar(100) DEFAULT NULL,
  `PROV42` varchar(100) DEFAULT NULL,
  `PROV43` varchar(100) DEFAULT NULL,
  `PROV44` varchar(100) DEFAULT NULL,
  `PROV45` varchar(100) DEFAULT NULL,
  `PROV46` varchar(100) DEFAULT NULL,
  `PROV47` varchar(100) DEFAULT NULL,
  `PROV48` varchar(100) DEFAULT NULL,
  `PROV49` varchar(100) DEFAULT NULL,
  `PROV50` varchar(100) DEFAULT NULL,
  `PROV51` varchar(100) DEFAULT NULL,
  `PROV52` varchar(100) DEFAULT NULL,
  `PROV53` varchar(100) DEFAULT NULL,
  `PROV54` varchar(100) DEFAULT NULL,
  `PROV55` varchar(100) DEFAULT NULL,
  `PROV56` varchar(100) DEFAULT NULL,
  `PROV57` varchar(100) DEFAULT NULL,
  `PROV58` varchar(100) DEFAULT NULL,
  `PROV59` varchar(100) DEFAULT NULL,
  `PROV60` varchar(100) DEFAULT NULL,
  `TRACE37` varchar(100) DEFAULT NULL,
  `TRACE38` varchar(100) DEFAULT NULL,
  `TRACE39` varchar(100) DEFAULT NULL,
  `TRACE40` varchar(100) DEFAULT NULL,
  `TRACE41` varchar(100) DEFAULT NULL,
  `TRACE42` varchar(100) DEFAULT NULL,
  `TRACE43` varchar(100) DEFAULT NULL,
  `TRACE44` varchar(100) DEFAULT NULL,
  `TRACE45` varchar(100) DEFAULT NULL,
  `TRACE46` varchar(100) DEFAULT NULL,
  `TRACE47` varchar(100) DEFAULT NULL,
  `TRACE48` varchar(100) DEFAULT NULL,
  `TRACE49` varchar(100) DEFAULT NULL,
  `TRACE50` varchar(100) DEFAULT NULL,
  `TRACE51` varchar(100) DEFAULT NULL,
  `TRACE52` varchar(100) DEFAULT NULL,
  `TRACE53` varchar(100) DEFAULT NULL,
  `TRACE54` varchar(100) DEFAULT NULL,
  `TRACE55` varchar(100) DEFAULT NULL,
  `TRACE56` varchar(100) DEFAULT NULL,
  `TRACE57` varchar(100) DEFAULT NULL,
  `TRACE58` varchar(100) DEFAULT NULL,
  `TRACE59` varchar(100) DEFAULT NULL,
  `TRACE60` varchar(100) DEFAULT NULL,
  `coordinatesCentred` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `filename_quality` (`filename`,`QUALITY`) KEY_BLOCK_SIZE=2048,
  UNIQUE KEY `filename` (`filename`) KEY_BLOCK_SIZE=1024,
  KEY `currentFilename` (`currentFilename`) KEY_BLOCK_SIZE=1024,
  KEY `data_rel` (`DATA_REL`) KEY_BLOCK_SIZE=1024,
  KEY `calibratation_reduction_stage` (`filetype_key_reduction_stage`,`filetype_key_image_or_spectrum`) KEY_BLOCK_SIZE=1024
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sofi_imaging_associations`
--

DROP TABLE IF EXISTS `sofi_imaging_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sofi_imaging_associations` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `image_id` int(11) NOT NULL,
  `association_id` int(11) NOT NULL,
  `assoc_keyword` int(11) NOT NULL,
  `added_to_fits_header` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `imageId_assosId` (`image_id`,`association_id`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sofi_spectra`
--

DROP TABLE IF EXISTS `sofi_spectra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sofi_spectra` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `AIRMASS` double DEFAULT NULL,
  `ARC` varchar(200) DEFAULT NULL,
  `ARCFILE` varchar(200) DEFAULT NULL,
  `BIASSEC` varchar(200) DEFAULT NULL,
  `BITPIX` int(11) DEFAULT NULL,
  `BUNIT` varchar(200) DEFAULT NULL,
  `CCDMEANT` int(11) DEFAULT NULL,
  `CCDPROC` varchar(200) DEFAULT NULL,
  `CCDSEC` varchar(200) DEFAULT NULL,
  `CD1_1` double DEFAULT NULL,
  `CD2_2` double DEFAULT NULL,
  `CDELT1` double DEFAULT NULL,
  `CDELT2` double DEFAULT NULL,
  `CHECKSUM` varchar(200) DEFAULT NULL,
  `CONTNORM` varchar(200) DEFAULT NULL,
  `CROSSTAL` varchar(200) DEFAULT NULL,
  `CRPIX1` double DEFAULT NULL,
  `CRPIX2` double DEFAULT NULL,
  `CRVAL1` double DEFAULT NULL,
  `CRVAL2` double DEFAULT NULL,
  `CTYPE1` varchar(200) DEFAULT NULL,
  `CTYPE2` varchar(200) DEFAULT NULL,
  `DATAMAX` double DEFAULT NULL,
  `DATAMIN` double DEFAULT NULL,
  `DATASUM` varchar(200) DEFAULT NULL,
  `DATE` datetime DEFAULT NULL,
  `DATE_OBS` datetime DEFAULT NULL COMMENT 'original keyword: DATE-OBS',
  `DC_FLAG` tinyint(4) DEFAULT NULL COMMENT 'original keyword: DC-FLAG',
  `DCLOG1` varchar(200) DEFAULT NULL,
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `DETRON` double DEFAULT NULL,
  `DISPAXIS` tinyint(4) DEFAULT NULL,
  `DISPELEM` varchar(200) DEFAULT NULL,
  `DIT` double DEFAULT NULL,
  `EQUINOX` double DEFAULT NULL,
  `ESO_ADA_ABSROT_END` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT END',
  `ESO_ADA_ABSROT_START` double DEFAULT NULL COMMENT 'original keyword: ESO ADA ABSROT START',
  `ESO_ADA_GUID_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID DEC',
  `ESO_ADA_GUID_RA` double DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID RA',
  `ESO_ADA_GUID_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO ADA GUID STATUS',
  `ESO_ADA_POSANG` double DEFAULT NULL COMMENT 'original keyword: ESO ADA POSANG',
  `ESO_DET_CHIP_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP ID',
  `ESO_DET_CHIP_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NAME',
  `ESO_DET_CHIP_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NX',
  `ESO_DET_CHIP_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP NY',
  `ESO_DET_CHIP_PXSPACE` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP PXSPACE',
  `ESO_DET_CHIP_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHIP TYPE',
  `ESO_DET_CHOP_CYCSKIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP CYCSKIP',
  `ESO_DET_CHOP_FREQ` double DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP FREQ',
  `ESO_DET_CHOP_NCYCLES` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP NCYCLES',
  `ESO_DET_CHOP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CHOP ST',
  `ESO_DET_CON_OPMODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET CON OPMODE',
  `ESO_DET_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET DID',
  `ESO_DET_DIT` double DEFAULT NULL COMMENT 'original keyword: ESO DET DIT',
  `ESO_DET_DITDELAY` double DEFAULT NULL COMMENT 'original keyword: ESO DET DITDELAY',
  `ESO_DET_EXP_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NAME',
  `ESO_DET_EXP_NO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET EXP NO',
  `ESO_DET_EXP_UTC` datetime DEFAULT NULL COMMENT 'original keyword: ESO DET EXP UTC',
  `ESO_DET_FILE_CUBE_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET FILE CUBE ST',
  `ESO_DET_FRAM_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM NO',
  `ESO_DET_FRAM_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM TYPE',
  `ESO_DET_FRAM_UTC` datetime DEFAULT NULL COMMENT 'original keyword: ESO DET FRAM UTC',
  `ESO_DET_IRACE_ADC1_DELAY` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 DELAY',
  `ESO_DET_IRACE_ADC1_ENABLE` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 ENABLE',
  `ESO_DET_IRACE_ADC1_FILTER1` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 FILTER1',
  `ESO_DET_IRACE_ADC1_FILTER2` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 FILTER2',
  `ESO_DET_IRACE_ADC1_HEADER` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 HEADER',
  `ESO_DET_IRACE_ADC1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE ADC1 NAME',
  `ESO_DET_IRACE_SEQCONT` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET IRACE SEQCONT',
  `ESO_DET_MODE_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET MODE NAME',
  `ESO_DET_NC_NSAMPPIX` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NC NSAMPPIX',
  `ESO_DET_NCORRS` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET NCORRS',
  `ESO_DET_NCORRS_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DET NCORRS NAME',
  `ESO_DET_NDIT` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NDIT',
  `ESO_DET_NDITSKIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NDITSKIP',
  `ESO_DET_NDSAMPLES` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET NDSAMPLES',
  `ESO_DET_NDSKIP` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET NDSKIP',
  `ESO_DET_RSPEED` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET RSPEED',
  `ESO_DET_RSPEEDADD` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET RSPEEDADD',
  `ESO_DET_WIN_NX` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN NX',
  `ESO_DET_WIN_NY` int(11) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN NY',
  `ESO_DET_WIN_STARTX` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN STARTX',
  `ESO_DET_WIN_STARTY` double DEFAULT NULL COMMENT 'original keyword: ESO DET WIN STARTY',
  `ESO_DET_WIN_TYPE` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO DET WIN TYPE',
  `ESO_DPR_CATG` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR CATG',
  `ESO_DPR_TECH` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TECH',
  `ESO_DPR_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO DPR TYPE',
  `ESO_INS_COLLIM_ENC` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS COLLIM ENC',
  `ESO_INS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS DID',
  `ESO_INS_FILT1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 ID',
  `ESO_INS_FILT1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NAME',
  `ESO_INS_FILT1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 NO',
  `ESO_INS_FILT1_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT1 TYPE',
  `ESO_INS_FILT2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 ID',
  `ESO_INS_FILT2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 NAME',
  `ESO_INS_FILT2_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 NO',
  `ESO_INS_FILT2_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS FILT2 TYPE',
  `ESO_INS_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS ID',
  `ESO_INS_MODE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS MODE',
  `ESO_INS_OPTI1_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 ID',
  `ESO_INS_OPTI1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 NAME',
  `ESO_INS_OPTI1_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 NO',
  `ESO_INS_OPTI1_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI1 TYPE',
  `ESO_INS_OPTI2_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 ID',
  `ESO_INS_OPTI2_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 NAME',
  `ESO_INS_OPTI2_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 NO',
  `ESO_INS_OPTI2_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI2 TYPE',
  `ESO_INS_OPTI3_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 ID',
  `ESO_INS_OPTI3_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 NAME',
  `ESO_INS_OPTI3_NO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 NO',
  `ESO_INS_OPTI3_TYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS OPTI3 TYPE',
  `ESO_INS_PIXSCALE` double DEFAULT NULL COMMENT 'original keyword: ESO INS PIXSCALE',
  `ESO_INS_SWSIM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS SWSIM',
  `ESO_INS_TEMP_DETSW` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-DETSW',
  `ESO_INS_TEMP_DETSW_SET` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-DETSW SET',
  `ESO_INS_TEMP_MON_NAME1` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME1',
  `ESO_INS_TEMP_MON_NAME10` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME10',
  `ESO_INS_TEMP_MON_NAME2` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME2',
  `ESO_INS_TEMP_MON_NAME3` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME3',
  `ESO_INS_TEMP_MON_NAME4` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME4',
  `ESO_INS_TEMP_MON_NAME5` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME5',
  `ESO_INS_TEMP_MON_NAME6` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME6',
  `ESO_INS_TEMP_MON_NAME7` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME7',
  `ESO_INS_TEMP_MON_NAME8` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME8',
  `ESO_INS_TEMP_MON_NAME9` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON NAME9',
  `ESO_INS_TEMP_MON_TEMP1` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP1',
  `ESO_INS_TEMP_MON_TEMP10` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP10',
  `ESO_INS_TEMP_MON_TEMP2` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP2',
  `ESO_INS_TEMP_MON_TEMP3` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP3',
  `ESO_INS_TEMP_MON_TEMP4` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP4',
  `ESO_INS_TEMP_MON_TEMP5` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP5',
  `ESO_INS_TEMP_MON_TEMP6` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP6',
  `ESO_INS_TEMP_MON_TEMP7` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP7',
  `ESO_INS_TEMP_MON_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP8',
  `ESO_INS_TEMP_MON_TEMP9` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-MON TEMP9',
  `ESO_INS_TEMP_VACP` double DEFAULT NULL COMMENT 'original keyword: ESO INS TEMP-VACP',
  `ESO_INS_TIME` datetime DEFAULT NULL COMMENT 'original keyword: ESO INS TIME',
  `ESO_OBS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS DID',
  `ESO_OBS_EXECTIME` double DEFAULT NULL COMMENT 'original keyword: ESO OBS EXECTIME',
  `ESO_OBS_GRP` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS GRP',
  `ESO_OBS_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS ID',
  `ESO_OBS_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS NAME',
  `ESO_OBS_OBSERVER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS OBSERVER',
  `ESO_OBS_PI_COI_ID` int(11) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI ID',
  `ESO_OBS_PI_COI_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PI-COI NAME',
  `ESO_OBS_PROG_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS PROG ID',
  `ESO_OBS_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO OBS START',
  `ESO_OBS_TARG_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OBS TARG NAME',
  `ESO_OBS_TPLNO` tinyint(4) DEFAULT NULL COMMENT 'original keyword: ESO OBS TPLNO',
  `ESO_OCS_COMP_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS COMP ID',
  `ESO_OCS_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS DID',
  `ESO_OCS_SELECT_ARM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS SELECT-ARM',
  `ESO_SEQ_CUMOFFSETX` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ CUMOFFSETX',
  `ESO_SEQ_JITTER_WIDTH` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ JITTER WIDTH',
  `ESO_SEQ_NODTHROW` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ NODTHROW',
  `ESO_SEQ_RELOFFSETX` double DEFAULT NULL COMMENT 'original keyword: ESO SEQ RELOFFSETX',
  `ESO_TEL_AIRM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM END',
  `ESO_TEL_AIRM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AIRM START',
  `ESO_TEL_ALT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL ALT',
  `ESO_TEL_AMBI_FWHM_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM END',
  `ESO_TEL_AMBI_FWHM_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI FWHM START',
  `ESO_TEL_AMBI_PRES_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES END',
  `ESO_TEL_AMBI_PRES_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI PRES START',
  `ESO_TEL_AMBI_RHUM` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI RHUM',
  `ESO_TEL_AMBI_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI TEMP',
  `ESO_TEL_AMBI_WINDDIR` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDDIR',
  `ESO_TEL_AMBI_WINDSP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AMBI WINDSP',
  `ESO_TEL_AZ` double DEFAULT NULL COMMENT 'original keyword: ESO TEL AZ',
  `ESO_TEL_CHOP_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL CHOP ST',
  `ESO_TEL_DATE` datetime DEFAULT NULL COMMENT 'original keyword: ESO TEL DATE',
  `ESO_TEL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DID',
  `ESO_TEL_DOME_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL DOME STATUS',
  `ESO_TEL_FOCU_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU ID',
  `ESO_TEL_FOCU_LEN` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU LEN',
  `ESO_TEL_FOCU_SCALE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU SCALE',
  `ESO_TEL_FOCU_VALUE` double DEFAULT NULL COMMENT 'original keyword: ESO TEL FOCU VALUE',
  `ESO_TEL_GEOELEV` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOELEV',
  `ESO_TEL_GEOLAT` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLAT',
  `ESO_TEL_GEOLON` double DEFAULT NULL COMMENT 'original keyword: ESO TEL GEOLON',
  `ESO_TEL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL ID',
  `ESO_TEL_MOON_DEC` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON DEC',
  `ESO_TEL_MOON_RA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL MOON RA',
  `ESO_TEL_OPER` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL OPER',
  `ESO_TEL_PARANG_END` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG END',
  `ESO_TEL_PARANG_START` double DEFAULT NULL COMMENT 'original keyword: ESO TEL PARANG START',
  `ESO_TEL_TARG_ALPHA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG ALPHA',
  `ESO_TEL_TARG_COORDTYPE` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG COORDTYPE',
  `ESO_TEL_TARG_DELTA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG DELTA',
  `ESO_TEL_TARG_EPOCH` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCH',
  `ESO_TEL_TARG_EPOCHSYSTEM` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EPOCHSYSTEM',
  `ESO_TEL_TARG_EQUINOX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG EQUINOX',
  `ESO_TEL_TARG_PARALLAX` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PARALLAX',
  `ESO_TEL_TARG_PMA` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMA',
  `ESO_TEL_TARG_PMD` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG PMD',
  `ESO_TEL_TARG_RADVEL` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TARG RADVEL',
  `ESO_TEL_TH_M1_TEMP` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TH M1 TEMP',
  `ESO_TEL_TRAK_STATUS` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TEL TRAK STATUS',
  `ESO_TEL_TSS_TEMP8` double DEFAULT NULL COMMENT 'original keyword: ESO TEL TSS TEMP8',
  `ESO_TPL_DID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL DID',
  `ESO_TPL_EXPNO` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TPL EXPNO',
  `ESO_TPL_ID` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL ID',
  `ESO_TPL_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL NAME',
  `ESO_TPL_NEXP` int(11) DEFAULT NULL COMMENT 'original keyword: ESO TPL NEXP',
  `ESO_TPL_PRESEQ` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL PRESEQ',
  `ESO_TPL_START` datetime DEFAULT NULL COMMENT 'original keyword: ESO TPL START',
  `ESO_TPL_VERSION` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO TPL VERSION',
  `EXPTIME` double DEFAULT NULL,
  `EXTEND` varchar(200) DEFAULT NULL,
  `EXT_OBJ` varchar(200) DEFAULT NULL,
  `FILETYPE` int(11) DEFAULT NULL,
  `FILTER` varchar(200) DEFAULT NULL,
  `FLATCOR` varchar(200) DEFAULT NULL,
  `FLUXCAL` varchar(200) DEFAULT NULL,
  `FLUXERR` double DEFAULT NULL,
  `GAIN` double DEFAULT NULL,
  `INSTRUME` varchar(200) DEFAULT NULL,
  `IRAF_TLM` datetime DEFAULT NULL COMMENT 'original keyword: IRAF-TLM',
  `LAMNLIN` int(11) DEFAULT NULL,
  `LAMRMS` double DEFAULT NULL,
  `LST` double DEFAULT NULL,
  `LTM1_1` double DEFAULT NULL,
  `LTM2_2` double DEFAULT NULL,
  `MJD_END` double DEFAULT NULL COMMENT 'original keyword: MJD-END',
  `MJD_OBS` double DEFAULT NULL COMMENT 'original keyword: MJD-OBS',
  `M_EPOCH` varchar(200) DEFAULT NULL,
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` int(11) DEFAULT NULL,
  `NDIT` tinyint(4) DEFAULT NULL,
  `OBID1` int(11) DEFAULT NULL,
  `OBJECT` varchar(200) DEFAULT NULL,
  `OBSERVER` varchar(200) DEFAULT NULL,
  `OBSTECH` varchar(200) DEFAULT NULL,
  `ORIGFILE` varchar(200) DEFAULT NULL,
  `ORIGIN` varchar(200) DEFAULT NULL,
  `PI_COI` varchar(200) DEFAULT NULL COMMENT 'original keyword: PI-COI',
  `PROCSOFT` varchar(200) DEFAULT NULL,
  `PRODCATG` varchar(200) DEFAULT NULL,
  `PROG_ID` varchar(200) DEFAULT NULL,
  `PROV1` varchar(200) DEFAULT NULL,
  `PROV2` varchar(200) DEFAULT NULL,
  `QUALITY` varchar(200) DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `RADECSYS` varchar(200) DEFAULT NULL,
  `REFERENC` varchar(200) DEFAULT NULL,
  `SHIFT` double DEFAULT NULL,
  `SIMPLE` varchar(200) DEFAULT NULL,
  `SINGLEXP` varchar(200) DEFAULT NULL,
  `SKYSUB` varchar(200) DEFAULT NULL,
  `SPECSYS` varchar(200) DEFAULT NULL,
  `SPEC_BIN` decimal(5,4) DEFAULT NULL,
  `SPEC_BW` double DEFAULT NULL,
  `SPEC_ERR` double DEFAULT NULL,
  `SPEC_RES` double DEFAULT NULL,
  `SPEC_SYE` double DEFAULT NULL,
  `SPEC_VAL` double DEFAULT NULL,
  `TELAPSE` double DEFAULT NULL,
  `TELESCOP` varchar(200) DEFAULT NULL,
  `TEXPTIME` double DEFAULT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `TMID` double DEFAULT NULL,
  `TOT_FLUX` varchar(200) DEFAULT NULL,
  `TRACE1` varchar(200) DEFAULT NULL,
  `TRIM` varchar(200) DEFAULT NULL,
  `UTC` double DEFAULT NULL,
  `VOCLASS` varchar(200) DEFAULT NULL,
  `VOPUB` varchar(200) DEFAULT NULL,
  `WAT0_001` varchar(200) DEFAULT NULL,
  `WAT1_001` varchar(200) DEFAULT NULL,
  `WAT2_001` varchar(200) DEFAULT NULL,
  `WAVELMAX` double DEFAULT NULL,
  `WAVELMIN` double DEFAULT NULL,
  `WCSDIM` tinyint(4) DEFAULT NULL,
  `XMAX` double DEFAULT NULL,
  `XMIN` double DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` varchar(1000) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `CCDMEAN` double DEFAULT NULL,
  `ESO_OCS_WCS_RTD_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO OCS WCS-RTD ST',
  `LTV1` double DEFAULT NULL,
  `PC1_1` double DEFAULT NULL,
  `PC1_2` double DEFAULT NULL,
  `PC2_1` double DEFAULT NULL,
  `PC2_2` double DEFAULT NULL,
  `APERTURE` double DEFAULT NULL,
  `APNUM1` varchar(200) DEFAULT NULL,
  `BANDID1` varchar(200) DEFAULT NULL,
  `BANDID2` varchar(200) DEFAULT NULL,
  `BANDID3` varchar(200) DEFAULT NULL,
  `BANDID4` varchar(200) DEFAULT NULL,
  `CD3_3` double DEFAULT NULL,
  `MAGSTD` double DEFAULT NULL,
  `CTYPE3` varchar(200) DEFAULT NULL,
  `STDNAME` varchar(200) DEFAULT NULL,
  `LTM3_3` double DEFAULT NULL,
  `NCOMBINE` tinyint(4) DEFAULT NULL,
  `NJITTER` tinyint(4) DEFAULT NULL,
  `NOFFSETS` tinyint(4) DEFAULT NULL,
  `NUSTEP` tinyint(4) DEFAULT NULL,
  `WAT3_001` varchar(200) DEFAULT NULL,
  `TRACE2` varchar(200) DEFAULT NULL,
  `NAXIS3` tinyint(4) DEFAULT NULL,
  `COMMENT` varchar(200) DEFAULT NULL,
  `ESO_INS_LAMP1_NAME` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP1 NAME',
  `ESO_INS_LAMP1_ST` varchar(200) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP1 ST',
  `REFSPEC1` varchar(200) DEFAULT NULL,
  `ASSOC1` varchar(200) DEFAULT NULL,
  `ASSON1` varchar(200) DEFAULT NULL,
  `PROV3` varchar(200) DEFAULT NULL,
  `PROV4` varchar(200) DEFAULT NULL,
  `SENSFUN` varchar(200) DEFAULT NULL,
  `SENSPHOT` varchar(200) DEFAULT NULL,
  `SNR` double DEFAULT NULL,
  `PROV5` varchar(200) DEFAULT NULL,
  `PROV6` varchar(200) DEFAULT NULL,
  `PROV7` varchar(200) DEFAULT NULL,
  `PROV8` varchar(200) DEFAULT NULL,
  `PROV10` varchar(200) DEFAULT NULL,
  `PROV9` varchar(200) DEFAULT NULL,
  `TRACE3` varchar(200) DEFAULT NULL,
  `TRACE4` varchar(200) DEFAULT NULL,
  `TRACE5` varchar(200) DEFAULT NULL,
  `TRACE6` varchar(200) DEFAULT NULL,
  `TRACE7` varchar(200) DEFAULT NULL,
  `TRACE8` varchar(200) DEFAULT NULL,
  `DARKTIME` double DEFAULT NULL,
  `PROV11` varchar(200) DEFAULT NULL,
  `PROV12` varchar(200) DEFAULT NULL,
  `PROV13` varchar(200) DEFAULT NULL,
  `PROV14` varchar(200) DEFAULT NULL,
  `PROV15` varchar(200) DEFAULT NULL,
  `PROV16` varchar(200) DEFAULT NULL,
  `TRACE10` varchar(200) DEFAULT NULL,
  `TRACE11` varchar(200) DEFAULT NULL,
  `TRACE12` varchar(200) DEFAULT NULL,
  `TRACE13` varchar(200) DEFAULT NULL,
  `TRACE14` varchar(200) DEFAULT NULL,
  `TRACE15` varchar(200) DEFAULT NULL,
  `TRACE16` varchar(200) DEFAULT NULL,
  `TRACE9` varchar(200) DEFAULT NULL,
  `IMCMB001` varchar(200) DEFAULT NULL,
  `IMCMB002` varchar(200) DEFAULT NULL,
  `IMCMB003` varchar(200) DEFAULT NULL,
  `IMCMB004` varchar(200) DEFAULT NULL,
  `IMCMB005` varchar(200) DEFAULT NULL,
  `IMCMB006` varchar(200) DEFAULT NULL,
  `IMCMB007` varchar(200) DEFAULT NULL,
  `IMCMB008` varchar(200) DEFAULT NULL,
  `filetype_key_instrument` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_image_or_spectrum` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_reduction_stage` tinyint(4) NOT NULL DEFAULT '0',
  `filetype_key_calibration` tinyint(4) NOT NULL DEFAULT '0',
  `transientBucketId` bigint(20) NOT NULL DEFAULT '0',
  `nameChangeRequired` tinyint(4) NOT NULL DEFAULT '0',
  `esoPhaseIII` tinyint(4) NOT NULL DEFAULT '0',
  `updatedFilename` varchar(200) DEFAULT NULL,
  `filenameUpdated` tinyint(4) NOT NULL DEFAULT '0',
  `objectInFilename` varchar(100) DEFAULT NULL,
  `updateObjectName` tinyint(4) NOT NULL DEFAULT '0',
  `binary_table_associated_spectrum_id` bigint(20) NOT NULL DEFAULT '0',
  `currentFilename` varchar(200) DEFAULT NULL,
  `currentFilepath` varchar(500) DEFAULT NULL,
  `updatedFilepath` varchar(1000) DEFAULT NULL,
  `archivePath` varchar(200) DEFAULT NULL,
  `rewriteFitsHeader` tinyint(4) NOT NULL DEFAULT '0',
  `archivedLocally` tinyint(4) DEFAULT '0',
  `isInTransientBucket` tinyint(4) DEFAULT NULL,
  `DATA_REL` varchar(45) DEFAULT NULL,
  `nelem` int(11) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `EFFRON` double DEFAULT NULL,
  `do_not_release` tinyint(1) NOT NULL DEFAULT '0',
  `flux_scaling_factor` float DEFAULT NULL,
  `ESO_INS_LAMP3_NAME` varchar(100) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP3 NAME',
  `ESO_INS_LAMP3_SET` int(11) DEFAULT NULL COMMENT 'original keyword: ESO INS LAMP3 SET',
  `dryx_comment` varchar(100) DEFAULT NULL,
  `lock_row` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `filename_quality` (`filename`,`QUALITY`) KEY_BLOCK_SIZE=2048,
  UNIQUE KEY `filename` (`filename`) KEY_BLOCK_SIZE=1024,
  KEY `currentFilename` (`currentFilename`) KEY_BLOCK_SIZE=1024,
  KEY `data_rel` (`DATA_REL`) KEY_BLOCK_SIZE=1024,
  KEY `calibratation_reduction_stage` (`filetype_key_reduction_stage`,`filetype_key_image_or_spectrum`) KEY_BLOCK_SIZE=1024
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sofi_spectra_associations`
--

DROP TABLE IF EXISTS `sofi_spectra_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sofi_spectra_associations` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `image_id` int(11) NOT NULL,
  `association_id` int(11) NOT NULL,
  `assoc_keyword` int(11) NOT NULL,
  `added_to_fits_header` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `imageId_assosId` (`image_id`,`association_id`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sofi_spectra_binary_table_extension`
--

DROP TABLE IF EXISTS `sofi_spectra_binary_table_extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sofi_spectra_binary_table_extension` (
  `sofi_spectra_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `APERTURE` double DEFAULT NULL,
  `BITPIX` tinyint(4) DEFAULT NULL,
  `CHECKSUM` varchar(100) DEFAULT NULL,
  `DATASUM` varchar(100) DEFAULT NULL,
  `DECL` double DEFAULT NULL COMMENT 'original keyword: DEC',
  `EXTNAME` varchar(100) DEFAULT NULL,
  `GCOUNT` tinyint(4) DEFAULT NULL,
  `INHERIT` int(11) DEFAULT NULL,
  `LAMRMS` double DEFAULT NULL,
  `NAXIS` tinyint(4) DEFAULT NULL,
  `NAXIS1` int(11) DEFAULT NULL,
  `NAXIS2` tinyint(4) DEFAULT NULL,
  `NELEM` int(11) DEFAULT NULL,
  `OBJECT` varchar(100) DEFAULT NULL,
  `PCOUNT` tinyint(4) DEFAULT NULL,
  `RA` double DEFAULT NULL,
  `SPEC_BW` double DEFAULT NULL,
  `SPEC_ERR` double DEFAULT NULL,
  `SPEC_SYE` double DEFAULT NULL,
  `SPEC_VAL` double DEFAULT NULL,
  `TDMAX1` double DEFAULT NULL,
  `TDMIN1` double DEFAULT NULL,
  `TELAPSE` double DEFAULT NULL,
  `TFIELDS` tinyint(4) DEFAULT NULL,
  `TFORM1` varchar(100) DEFAULT NULL,
  `TFORM2` varchar(100) DEFAULT NULL,
  `TFORM3` varchar(100) DEFAULT NULL,
  `TFORM4` varchar(100) DEFAULT NULL,
  `TFORM5` varchar(100) DEFAULT NULL,
  `TFORM6` varchar(100) DEFAULT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `TMID` double DEFAULT NULL,
  `TTYPE1` varchar(100) DEFAULT NULL,
  `TTYPE2` varchar(100) DEFAULT NULL,
  `TTYPE3` varchar(100) DEFAULT NULL,
  `TTYPE4` varchar(100) DEFAULT NULL,
  `TTYPE5` varchar(100) DEFAULT NULL,
  `TTYPE6` varchar(100) DEFAULT NULL,
  `TUCD1` varchar(100) DEFAULT NULL,
  `TUCD2` varchar(100) DEFAULT NULL,
  `TUCD3` varchar(100) DEFAULT NULL,
  `TUCD4` varchar(100) DEFAULT NULL,
  `TUCD5` varchar(100) DEFAULT NULL,
  `TUCD6` varchar(100) DEFAULT NULL,
  `TUNIT1` varchar(100) DEFAULT NULL,
  `TUNIT2` varchar(100) DEFAULT NULL,
  `TUNIT3` varchar(100) DEFAULT NULL,
  `TUNIT4` varchar(100) DEFAULT NULL,
  `TUNIT5` varchar(100) DEFAULT NULL,
  `TUNIT6` varchar(100) DEFAULT NULL,
  `TUTYP1` varchar(100) DEFAULT NULL,
  `TUTYP2` varchar(100) DEFAULT NULL,
  `TUTYP3` varchar(100) DEFAULT NULL,
  `TUTYP4` varchar(100) DEFAULT NULL,
  `TUTYP5` varchar(100) DEFAULT NULL,
  `TUTYP6` varchar(100) DEFAULT NULL,
  `VOCLASS` varchar(100) DEFAULT NULL,
  `VOPUB` varchar(100) DEFAULT NULL,
  `XTENSION` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `filePath` varchar(100) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `headerExtension` tinyint(4) DEFAULT NULL,
  `SIMPLE` varchar(10) DEFAULT NULL,
  `EXTEND` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`sofi_spectra_id`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `primaryId_UNIQUE` (`sofi_spectra_id`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `filename` (`filename`) KEY_BLOCK_SIZE=1024,
  KEY `sofi_spec_id` (`sofi_spectra_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats_full_release_overview`
--

DROP TABLE IF EXISTS `stats_full_release_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats_full_release_overview` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `filetype` varchar(200) DEFAULT NULL,
  `numberOfFiles` int(11) DEFAULT NULL,
  `dataVolumeBytes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats_ssdr1_overview`
--

DROP TABLE IF EXISTS `stats_ssdr1_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats_ssdr1_overview` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `filetype` varchar(200) DEFAULT NULL,
  `numberOfFiles` int(11) DEFAULT NULL,
  `dataVolumeBytes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats_ssdr2_overview`
--

DROP TABLE IF EXISTS `stats_ssdr2_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats_ssdr2_overview` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `filetype` varchar(200) DEFAULT NULL,
  `numberOfFiles` int(11) DEFAULT NULL,
  `dataVolumeBytes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats_ssdr3_overview`
--

DROP TABLE IF EXISTS `stats_ssdr3_overview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats_ssdr3_overview` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `filetype` varchar(200) DEFAULT NULL,
  `numberOfFiles` int(11) DEFAULT NULL,
  `dataVolumeBytes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcs_catalogue_tables`
--

DROP TABLE IF EXISTS `tcs_catalogue_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcs_catalogue_tables` (
  `id` smallint(5) unsigned NOT NULL,
  `table_name` varchar(40) NOT NULL,
  `description` varchar(60) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcs_cross_matches_old`
--

DROP TABLE IF EXISTS `tcs_cross_matches_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcs_cross_matches_old` (
  `transient_object_id` bigint(20) unsigned DEFAULT NULL,
  `catalogue_object_id` varchar(30) DEFAULT NULL,
  `catalogue_table_id` smallint(5) unsigned DEFAULT NULL,
  `separation` double DEFAULT NULL,
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `z` double DEFAULT NULL,
  `scale` double DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `distance_modulus` double DEFAULT NULL,
  `association_type` varchar(45) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `physical_separation_kpc` double DEFAULT NULL,
  `catalogue_object_type` varchar(45) DEFAULT NULL,
  `catalogue_object_subtype` varchar(45) DEFAULT NULL,
  `association_rank` int(11) DEFAULT NULL,
  `catalogue_table_name` varchar(100) DEFAULT NULL,
  `catalogue_view_name` varchar(100) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  `search_name` varchar(100) DEFAULT NULL,
  `major_axis_arcsec` double DEFAULT NULL,
  `direct_distance` double DEFAULT NULL,
  `direct_distance_scale` double DEFAULT NULL,
  `direct_distance_modulus` double DEFAULT NULL,
  `catalogue_object_ra` double DEFAULT NULL,
  `catalogue_object_dec` double DEFAULT NULL,
  `original_search_radius_arcsec` double DEFAULT NULL,
  `catalogue_view_id` int(11) DEFAULT NULL,
  `catalogue_object_mag` float DEFAULT NULL,
  `catalogue_object_filter` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `key_transient_object_id` (`transient_object_id`),
  KEY `key_catalogue_object_id` (`catalogue_object_id`),
  KEY `idx_separation` (`separation`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcs_helper_catalogue_tables_info`
--

DROP TABLE IF EXISTS `tcs_helper_catalogue_tables_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcs_helper_catalogue_tables_info` (
  `id` smallint(5) unsigned NOT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `description` varchar(60) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `number_of_rows` bigint(20) DEFAULT NULL,
  `reference_url` varchar(200) DEFAULT NULL,
  `reference_text` varchar(70) DEFAULT NULL,
  `notes` mediumtext,
  `vizier_link` varchar(200) DEFAULT NULL,
  `in_ned` tinyint(4) DEFAULT NULL,
  `object_types` varchar(100) DEFAULT NULL,
  `version_number` varchar(45) DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `legacy_table` tinyint(4) DEFAULT '0',
  `old_table_name` varchar(100) DEFAULT NULL,
  `raColName` varchar(45) DEFAULT NULL,
  `decColName` varchar(45) DEFAULT NULL,
  `subTypeColName` varchar(45) DEFAULT NULL,
  `objectNameColName` varchar(100) DEFAULT NULL,
  `redshiftColName` varchar(100) DEFAULT NULL,
  `distanceColName` varchar(45) DEFAULT NULL,
  `object_type_accuracy` tinyint(2) DEFAULT NULL,
  `semiMajorColName` varchar(100) DEFAULT NULL,
  `semiMajorToArcsec` float DEFAULT NULL,
  `transientStream` tinyint(4) DEFAULT '0',
  `filter1ColName` varchar(45) DEFAULT NULL,
  `filterName1ColName` varchar(45) DEFAULT NULL,
  `filterErr1ColName` varchar(45) DEFAULT NULL,
  `filter2ColName` varchar(45) DEFAULT NULL,
  `filterName2ColName` varchar(45) DEFAULT NULL,
  `filterErr2ColName` varchar(45) DEFAULT NULL,
  `filter3ColName` varchar(45) DEFAULT NULL,
  `filterName3ColName` varchar(45) DEFAULT NULL,
  `filterErr3ColName` varchar(45) DEFAULT NULL,
  `filter4ColName` varchar(45) DEFAULT NULL,
  `filterName4ColName` varchar(45) DEFAULT NULL,
  `filterErr4ColName` varchar(45) DEFAULT NULL,
  `filter5ColName` varchar(45) DEFAULT NULL,
  `filterName5ColName` varchar(45) DEFAULT NULL,
  `filterErr5ColName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcs_helper_catalogue_views_info`
--

DROP TABLE IF EXISTS `tcs_helper_catalogue_views_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcs_helper_catalogue_views_info` (
  `id` smallint(5) unsigned NOT NULL,
  `view_name` varchar(100) DEFAULT NULL,
  `number_of_rows` bigint(20) DEFAULT NULL,
  `object_type` varchar(100) DEFAULT NULL,
  `legacy_view` tinyint(4) DEFAULT '0',
  `old_view_name` varchar(100) DEFAULT NULL,
  `table_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcs_stats_catalogues`
--

DROP TABLE IF EXISTS `tcs_stats_catalogues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tcs_stats_catalogues` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `all_transient_associations` double DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `number_of_rows` double DEFAULT NULL,
  `object_types` varchar(100) DEFAULT NULL,
  `table_id` tinyint(4) DEFAULT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `top_ranked_transient_associations` double DEFAULT NULL,
  `transientStream` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `table_id` (`table_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tns_files`
--

DROP TABLE IF EXISTS `tns_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tns_files` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `TNSId` varchar(55) NOT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateObs` datetime DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `spec1phot2` tinyint(4) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `dateLastModified` datetime DEFAULT NULL,
  `comment` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `tnsid_url` (`TNSId`,`url`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tns_photometry`
--

DROP TABLE IF EXISTS `tns_photometry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tns_photometry` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `TNSId` varchar(20) NOT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `exptime` double DEFAULT NULL,
  `filter` varchar(100) DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `magErr` double DEFAULT NULL,
  `magUnit` varchar(100) DEFAULT NULL,
  `objectName` varchar(100) DEFAULT NULL,
  `obsdate` datetime DEFAULT NULL,
  `reportAddedDate` datetime DEFAULT NULL,
  `suggestedType` varchar(100) DEFAULT NULL,
  `survey` varchar(100) DEFAULT NULL,
  `telescope` varchar(100) DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `dateLastModified` datetime DEFAULT NULL,
  `remarks` varchar(800) DEFAULT NULL,
  `sourceComment` varchar(800) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `reportingGroup` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `u_tnsid_obsdate_mag` (`mag`,`obsdate`,`TNSId`),
  UNIQUE KEY `u_tnsid_survey_obsdate` (`TNSId`,`survey`,`obsdate`),
  UNIQUE KEY `u_tnsid_obsdate_objname` (`TNSId`,`obsdate`,`objectName`),
  KEY `idx_transientBucketId` (`transientBucketId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tns_sources`
--

DROP TABLE IF EXISTS `tns_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tns_sources` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `TNSId` varchar(20) NOT NULL,
  `TNSName` varchar(20) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `decSex` varchar(45) DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `discMagFilter` varchar(45) DEFAULT NULL,
  `discSurvey` varchar(100) DEFAULT NULL,
  `discoveryName` varchar(100) DEFAULT NULL,
  `objectUrl` varchar(200) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `raSex` varchar(45) DEFAULT NULL,
  `specType` varchar(100) DEFAULT NULL,
  `transRedshift` double DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `dateLastModified` datetime DEFAULT NULL,
  `hostName` varchar(100) DEFAULT NULL,
  `hostRedshift` double DEFAULT NULL,
  `survey` varchar(100) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `reportingSurvey` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `tnsid` (`TNSId`),
  KEY `idx_transientBucketId` (`transientBucketId`),
  KEY `idx_ingested` (`ingested`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tns_spectra`
--

DROP TABLE IF EXISTS `tns_spectra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tns_spectra` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `TNSId` varchar(45) NOT NULL,
  `TNSuser` varchar(45) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `exptime` double DEFAULT NULL,
  `obsdate` datetime DEFAULT NULL,
  `reportAddedDate` datetime DEFAULT NULL,
  `specType` varchar(100) DEFAULT NULL,
  `survey` varchar(100) DEFAULT NULL,
  `telescope` varchar(100) DEFAULT NULL,
  `transRedshift` double DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `dateLastModified` datetime DEFAULT NULL,
  `remarks` varchar(800) DEFAULT NULL,
  `sourceComment` varchar(800) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `discoveryName` varchar(50) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `TNSName` varchar(45) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `tnsid_survey_obsdate` (`TNSId`,`survey`,`obsdate`),
  UNIQUE KEY `u_tnsid_TNSUser_obsdate` (`TNSId`,`TNSuser`,`obsdate`),
  KEY `idx_transientBucketId` (`transientBucketId`),
  KEY `idx_ingested` (`ingested`),
  KEY `idx_TNSName` (`TNSName`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transientBucket`
--

DROP TABLE IF EXISTS `transientBucket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transientBucket` (
  `primaryKeyId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'The primary key for this table',
  `transientBucketId` bigint(20) NOT NULL COMMENT 'This is set to the primaryKeyId of the **first** entry of this object into the database (i.e. earliest dateCreated)',
  `masterIDFlag` int(11) NOT NULL DEFAULT '0' COMMENT 'If this flag is set (=1) then the transient is assigned this name as it''s master ID. If not set (=0) then there is another entry in this table where the master ID has been set.',
  `name` varchar(40) NOT NULL COMMENT 'the name of the transient given by the reporting survey.',
  `survey` varchar(45) DEFAULT 'unknown' COMMENT 'the survey reporting observation of this transient',
  `raDeg` double DEFAULT NULL COMMENT 'RA is decimal degreed',
  `decDeg` double DEFAULT NULL COMMENT 'DEC in decimal degrees',
  `raDegErr` double DEFAULT NULL,
  `decDegErr` double DEFAULT NULL,
  `observationDate` datetime DEFAULT NULL COMMENT 'the survey observation date',
  `observationMJD` double DEFAULT NULL COMMENT 'the survey observation MJD',
  `magnitude` float DEFAULT NULL COMMENT 'the survey discovery magnitude',
  `magnitudeError` float DEFAULT NULL,
  `filter` varchar(20) DEFAULT NULL COMMENT 'survey discovery filter',
  `transientRedshift` float DEFAULT NULL COMMENT 'redshift as measured from a spectrum of the transient',
  `transientRedshiftNotes` varchar(40) DEFAULT NULL COMMENT 'transient redshift notes',
  `spectralType` varchar(100) DEFAULT NULL COMMENT 'the spectral classification given by the reporting survey (if any)',
  `discoveryPhase` varchar(20) DEFAULT NULL COMMENT 'the discovery phase given by the reporting survey (if any)',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `surveyObjectUrl` varchar(400) DEFAULT NULL COMMENT 'the url for dedicated webpage of transients supplied by the reporting survey (if any)',
  `transientTypePrediction` varchar(40) DEFAULT NULL COMMENT 'an attempt at predicting the transient type by the reporting survey.',
  `transientTypePredicationSource` varchar(40) DEFAULT NULL COMMENT 'the name of the source/catalogue that was used to predict the transient type',
  `hostRedshift` float DEFAULT NULL COMMENT 'redshift measure for the host',
  `hostRedshiftType` varchar(10) DEFAULT NULL COMMENT 'type of redshift measure for the host galaxy\n',
  `referenceImageUrl` varchar(500) DEFAULT NULL COMMENT 'true or false',
  `targetImageUrl` varchar(500) DEFAULT NULL COMMENT 'true or false',
  `subtractedImageUrl` varchar(500) DEFAULT NULL,
  `tripletImageUrl` varchar(500) DEFAULT NULL,
  `htm16ID` bigint(20) unsigned DEFAULT NULL COMMENT 'HTM Level 16',
  `telescope` varchar(100) DEFAULT NULL,
  `instrument` varchar(100) DEFAULT NULL,
  `reducer` varchar(100) DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `lastNonDetectionMJD` double DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `finderImageUrl` varchar(450) DEFAULT NULL,
  `lightcurveURL` varchar(450) DEFAULT NULL,
  `classificationWRTMax` varchar(45) DEFAULT NULL,
  `classificationPhase` int(11) DEFAULT NULL,
  `limitingMag` tinyint(4) DEFAULT '0',
  `sherlockClassification` varchar(200) DEFAULT NULL,
  `tmpFlag` int(11) DEFAULT NULL,
  `replacedByRowId` bigint(20) DEFAULT '0',
  `dateDeleted` datetime DEFAULT NULL,
  `updated` tinyint(4) DEFAULT '0',
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `cz` double DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `htm20ID` bigint(20) DEFAULT NULL,
  `cy` double DEFAULT NULL,
  PRIMARY KEY (`primaryKeyId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `primaryKey_UNIQUE` (`primaryKeyId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `name_observationmjd_magnitude_filter_survey` (`name`,`observationMJD`,`magnitude`,`filter`,`survey`,`replacedByRowId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `name_observationmjd_magnitude_filter` (`name`,`observationMJD`,`magnitude`,`filter`,`replacedByRowId`),
  UNIQUE KEY `name_survey_obsmjd_decDeg_classification` (`name`,`survey`,`decDeg`,`observationMJD`,`replacedByRowId`,`spectralType`) KEY_BLOCK_SIZE=1024,
  KEY `idx_htm16ID` (`htm16ID`) KEY_BLOCK_SIZE=1024,
  KEY `idx_name` (`name`) KEY_BLOCK_SIZE=1024,
  KEY `tbi` (`transientBucketId`),
  KEY `masterflag` (`masterIDFlag`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `idx_transientBucketId` (`transientBucketId`),
  KEY `idx_replacedByRowId` (`replacedByRowId`),
  KEY `idx_sherlockClassifcaition` (`sherlockClassification`),
  KEY `idx_magnitude` (`magnitude`),
  KEY `idx_htm20ID` (`htm20ID`),
  KEY `idx_dateLastModified` (`dateLastModified`),
  KEY `idx_observationmjd` (`observationMJD`),
  KEY `idx_observationDate` (`observationDate`),
  KEY `idx_surveyObjectUrl` (`surveyObjectUrl`),
  KEY `idx_dateCreated` (`dateCreated`),
  KEY `idx_replace_master` (`replacedByRowId`,`masterIDFlag`),
  FULLTEXT KEY `fulltext` (`name`,`survey`,`surveyObjectUrl`),
  FULLTEXT KEY `fulltext_name_survey_surveyObjectUrl` (`name`,`survey`,`surveyObjectUrl`),
  FULLTEXT KEY `fulltext_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transientBucketSummaries`
--

DROP TABLE IF EXISTS `transientBucketSummaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transientBucketSummaries` (
  `transientBucketId` int(11) unsigned NOT NULL,
  `sdss_coverage` tinyint(4) DEFAULT NULL,
  `lastNonDetectionDate` datetime DEFAULT NULL,
  `earliestDetection` datetime DEFAULT NULL,
  `recentClassification` varchar(45) DEFAULT NULL,
  `peakMagnitude` double DEFAULT NULL,
  `absolutePeakMagnitude` decimal(20,17) DEFAULT NULL,
  `distanceMpc` double DEFAULT NULL,
  `has_atel` tinyint(4) DEFAULT NULL,
  `best_redshift` double DEFAULT NULL,
  `masterName` varchar(200) DEFAULT NULL,
  `surveyObjectUrl` varchar(500) DEFAULT NULL,
  `currentMagnitude` double DEFAULT NULL,
  `dateAdded` datetime DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `classificationSurvey` varchar(200) DEFAULT NULL,
  `classificationDate` datetime DEFAULT NULL,
  `transientTypePrediction` varchar(200) DEFAULT NULL,
  `currentMagnitudeEstimate` double DEFAULT NULL,
  `currentMagnitudeEstimateUpdated` datetime DEFAULT NULL,
  `recentSlopeOfLightcurve` double DEFAULT NULL,
  `classificationWRTMax` varchar(45) DEFAULT NULL,
  `classificationPhase` int(11) DEFAULT NULL,
  `classificationAddedBy` varchar(100) DEFAULT NULL,
  `objectAddedToMarshallBy` varchar(100) DEFAULT NULL,
  `currentMagnitudeDate` datetime DEFAULT NULL,
  `lastTBSUpdate` datetime DEFAULT NULL,
  `classificationAddedDate` datetime DEFAULT NULL,
  `sherlockClassification` varchar(200) DEFAULT NULL,
  `earliestMagnitude` double DEFAULT NULL,
  `earliestMagnitudeFilter` varchar(45) DEFAULT NULL,
  `earliestMagnitudeSurvey` varchar(45) DEFAULT NULL,
  `host_redshift` double DEFAULT NULL,
  `gLat` double DEFAULT NULL,
  `gLon` double DEFAULT NULL,
  `separationArcsec` double DEFAULT NULL,
  `currentMagnitudeFilter` varchar(45) DEFAULT NULL,
  `currentMagnitudeSurvey` varchar(45) DEFAULT NULL,
  `updateNeeded` tinyint(4) DEFAULT '1',
  `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`transientBucketId`) KEY_BLOCK_SIZE=1024,
  KEY `tbi` (`transientBucketId`),
  KEY `masterName` (`masterName`),
  KEY `ra_dec` (`raDeg`,`decDeg`),
  KEY `idx_updateNeeded` (`updateNeeded`),
  KEY `idx_surveyObjectUrl` (`surveyObjectUrl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transients_history_logs`
--

DROP TABLE IF EXISTS `transients_history_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transients_history_logs` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `transientBucketId` bigint(20) NOT NULL,
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log` varchar(200) NOT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `unique_index` (`transientBucketId`,`dateCreated`) KEY_BLOCK_SIZE=1024,
  KEY `tbi` (`transientBucketId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `view_efosc_imaging_benetti`
--

DROP TABLE IF EXISTS `view_efosc_imaging_benetti`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_benetti`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_benetti` AS SELECT 
 1 AS `primaryId`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `ASTROMET`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `ELLIPTIC`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTNAME`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FIXPIX`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTV1`,
 1 AS `MBKG`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SINGLEXP`,
 1 AS `TELESCOP`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `XTENSION`,
 1 AS `ZEROCOR`,
 1 AS `ZPIRI`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `PCOUNT`,
 1 AS `SIMPLE`,
 1 AS `BUNIT`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `GAIN`,
 1 AS `MJD_END`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `TEXPTIME`,
 1 AS `ZPGGR`,
 1 AS `ESO_DET_OUT2_CHIP`,
 1 AS `ESO_DET_OUT2_CONAD`,
 1 AS `ESO_DET_OUT2_GAIN`,
 1 AS `ESO_DET_OUT2_ID`,
 1 AS `ESO_DET_OUT2_INDEX`,
 1 AS `ESO_DET_OUT2_NAME`,
 1 AS `ESO_DET_OUT2_NX`,
 1 AS `ESO_DET_OUT2_NY`,
 1 AS `ESO_DET_OUT2_OVSCX`,
 1 AS `ESO_DET_OUT2_OVSCY`,
 1 AS `ESO_DET_OUT2_PRSCX`,
 1 AS `ESO_DET_OUT2_PRSCY`,
 1 AS `ESO_DET_OUT2_RON`,
 1 AS `ESO_DET_OUT2_X`,
 1 AS `ESO_DET_OUT2_Y`,
 1 AS `OBJMASK`,
 1 AS `DARKTIME`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `FRICOR`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `OBID`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `ZPRRI`,
 1 AS `ZPVBV`,
 1 AS `ZPVVR`,
 1 AS `ZPRVR`,
 1 AS `ZPUUB`,
 1 AS `ZPBBV`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `TRACE17`,
 1 AS `TRACE18`,
 1 AS `TRACE19`,
 1 AS `TRACE20`,
 1 AS `TRACE21`,
 1 AS `ZPZIZ`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `TRACE22`,
 1 AS `TRACE23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `TRACE24`,
 1 AS `TRACE25`,
 1 AS `TRACE26`,
 1 AS `TRACE27`,
 1 AS `TRACE28`,
 1 AS `TRACE29`,
 1 AS `CONTNORM`,
 1 AS `DISPELEM`,
 1 AS `EXT_OBJ`,
 1 AS `FLUXERR`,
 1 AS `LTV2`,
 1 AS `SPECSYS`,
 1 AS `TELAPSE`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `OBJ_OLD`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_esophaseiii`
--

DROP TABLE IF EXISTS `view_efosc_imaging_esophaseiii`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_esophaseiii`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_esophaseiii` AS SELECT 
 1 AS `primaryId`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `ASTROMET`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `ELLIPTIC`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTNAME`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FIXPIX`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTV1`,
 1 AS `MBKG`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SINGLEXP`,
 1 AS `TELESCOP`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `XTENSION`,
 1 AS `ZEROCOR`,
 1 AS `ZPIRI`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `PCOUNT`,
 1 AS `SIMPLE`,
 1 AS `BUNIT`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `GAIN`,
 1 AS `MJD_END`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `TEXPTIME`,
 1 AS `ZPGGR`,
 1 AS `ESO_DET_OUT2_CHIP`,
 1 AS `ESO_DET_OUT2_CONAD`,
 1 AS `ESO_DET_OUT2_GAIN`,
 1 AS `ESO_DET_OUT2_ID`,
 1 AS `ESO_DET_OUT2_INDEX`,
 1 AS `ESO_DET_OUT2_NAME`,
 1 AS `ESO_DET_OUT2_NX`,
 1 AS `ESO_DET_OUT2_NY`,
 1 AS `ESO_DET_OUT2_OVSCX`,
 1 AS `ESO_DET_OUT2_OVSCY`,
 1 AS `ESO_DET_OUT2_PRSCX`,
 1 AS `ESO_DET_OUT2_PRSCY`,
 1 AS `ESO_DET_OUT2_RON`,
 1 AS `ESO_DET_OUT2_X`,
 1 AS `ESO_DET_OUT2_Y`,
 1 AS `OBJMASK`,
 1 AS `DARKTIME`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `FRICOR`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `OBID`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `ZPRRI`,
 1 AS `ZPVBV`,
 1 AS `ZPVVR`,
 1 AS `ZPRVR`,
 1 AS `ZPUUB`,
 1 AS `ZPBBV`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `TRACE17`,
 1 AS `TRACE18`,
 1 AS `TRACE19`,
 1 AS `TRACE20`,
 1 AS `TRACE21`,
 1 AS `ZPZIZ`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `TRACE22`,
 1 AS `TRACE23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `TRACE24`,
 1 AS `TRACE25`,
 1 AS `TRACE26`,
 1 AS `TRACE27`,
 1 AS `TRACE28`,
 1 AS `TRACE29`,
 1 AS `CONTNORM`,
 1 AS `DISPELEM`,
 1 AS `EXT_OBJ`,
 1 AS `FLUXERR`,
 1 AS `LTV2`,
 1 AS `SPECSYS`,
 1 AS `TELAPSE`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `OBJ_OLD`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_intermediate`
--

DROP TABLE IF EXISTS `view_efosc_imaging_intermediate`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_intermediate`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_intermediate` AS SELECT 
 1 AS `primaryId`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `ASTROMET`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `ELLIPTIC`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTNAME`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FIXPIX`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTV1`,
 1 AS `MBKG`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SINGLEXP`,
 1 AS `TELESCOP`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `XTENSION`,
 1 AS `ZEROCOR`,
 1 AS `ZPIRI`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `PCOUNT`,
 1 AS `SIMPLE`,
 1 AS `BUNIT`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `GAIN`,
 1 AS `MJD_END`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `TEXPTIME`,
 1 AS `ZPGGR`,
 1 AS `ESO_DET_OUT2_CHIP`,
 1 AS `ESO_DET_OUT2_CONAD`,
 1 AS `ESO_DET_OUT2_GAIN`,
 1 AS `ESO_DET_OUT2_ID`,
 1 AS `ESO_DET_OUT2_INDEX`,
 1 AS `ESO_DET_OUT2_NAME`,
 1 AS `ESO_DET_OUT2_NX`,
 1 AS `ESO_DET_OUT2_NY`,
 1 AS `ESO_DET_OUT2_OVSCX`,
 1 AS `ESO_DET_OUT2_OVSCY`,
 1 AS `ESO_DET_OUT2_PRSCX`,
 1 AS `ESO_DET_OUT2_PRSCY`,
 1 AS `ESO_DET_OUT2_RON`,
 1 AS `ESO_DET_OUT2_X`,
 1 AS `ESO_DET_OUT2_Y`,
 1 AS `OBJMASK`,
 1 AS `DARKTIME`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `FRICOR`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `OBID`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `ZPRRI`,
 1 AS `ZPVBV`,
 1 AS `ZPVVR`,
 1 AS `ZPRVR`,
 1 AS `ZPUUB`,
 1 AS `ZPBBV`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `TRACE17`,
 1 AS `TRACE18`,
 1 AS `TRACE19`,
 1 AS `TRACE20`,
 1 AS `TRACE21`,
 1 AS `ZPZIZ`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `TRACE22`,
 1 AS `TRACE23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `TRACE24`,
 1 AS `TRACE25`,
 1 AS `TRACE26`,
 1 AS `TRACE27`,
 1 AS `TRACE28`,
 1 AS `TRACE29`,
 1 AS `CONTNORM`,
 1 AS `DISPELEM`,
 1 AS `EXT_OBJ`,
 1 AS `FLUXERR`,
 1 AS `LTV2`,
 1 AS `SPECSYS`,
 1 AS `TELAPSE`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `OBJ_OLD`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_raw`
--

DROP TABLE IF EXISTS `view_efosc_imaging_raw`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_raw` AS SELECT 
 1 AS `primaryId`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `ASTROMET`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `ELLIPTIC`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTNAME`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FIXPIX`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTV1`,
 1 AS `MBKG`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SINGLEXP`,
 1 AS `TELESCOP`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `XTENSION`,
 1 AS `ZEROCOR`,
 1 AS `ZPIRI`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `PCOUNT`,
 1 AS `SIMPLE`,
 1 AS `BUNIT`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `GAIN`,
 1 AS `MJD_END`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `TEXPTIME`,
 1 AS `ZPGGR`,
 1 AS `ESO_DET_OUT2_CHIP`,
 1 AS `ESO_DET_OUT2_CONAD`,
 1 AS `ESO_DET_OUT2_GAIN`,
 1 AS `ESO_DET_OUT2_ID`,
 1 AS `ESO_DET_OUT2_INDEX`,
 1 AS `ESO_DET_OUT2_NAME`,
 1 AS `ESO_DET_OUT2_NX`,
 1 AS `ESO_DET_OUT2_NY`,
 1 AS `ESO_DET_OUT2_OVSCX`,
 1 AS `ESO_DET_OUT2_OVSCY`,
 1 AS `ESO_DET_OUT2_PRSCX`,
 1 AS `ESO_DET_OUT2_PRSCY`,
 1 AS `ESO_DET_OUT2_RON`,
 1 AS `ESO_DET_OUT2_X`,
 1 AS `ESO_DET_OUT2_Y`,
 1 AS `OBJMASK`,
 1 AS `DARKTIME`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `FRICOR`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `OBID`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `ZPRRI`,
 1 AS `ZPVBV`,
 1 AS `ZPVVR`,
 1 AS `ZPRVR`,
 1 AS `ZPUUB`,
 1 AS `ZPBBV`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `TRACE17`,
 1 AS `TRACE18`,
 1 AS `TRACE19`,
 1 AS `TRACE20`,
 1 AS `TRACE21`,
 1 AS `ZPZIZ`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `TRACE22`,
 1 AS `TRACE23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `TRACE24`,
 1 AS `TRACE25`,
 1 AS `TRACE26`,
 1 AS `TRACE27`,
 1 AS `TRACE28`,
 1 AS `TRACE29`,
 1 AS `CONTNORM`,
 1 AS `DISPELEM`,
 1 AS `EXT_OBJ`,
 1 AS `FLUXERR`,
 1 AS `LTV2`,
 1 AS `SPECSYS`,
 1 AS `TELAPSE`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `OBJ_OLD`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_reduced`
--

DROP TABLE IF EXISTS `view_efosc_imaging_reduced`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_reduced`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_reduced` AS SELECT 
 1 AS `primaryId`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `ASTROMET`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `ELLIPTIC`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTNAME`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FIXPIX`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTV1`,
 1 AS `MBKG`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SINGLEXP`,
 1 AS `TELESCOP`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `XTENSION`,
 1 AS `ZEROCOR`,
 1 AS `ZPIRI`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `PCOUNT`,
 1 AS `SIMPLE`,
 1 AS `BUNIT`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `GAIN`,
 1 AS `MJD_END`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `TEXPTIME`,
 1 AS `ZPGGR`,
 1 AS `ESO_DET_OUT2_CHIP`,
 1 AS `ESO_DET_OUT2_CONAD`,
 1 AS `ESO_DET_OUT2_GAIN`,
 1 AS `ESO_DET_OUT2_ID`,
 1 AS `ESO_DET_OUT2_INDEX`,
 1 AS `ESO_DET_OUT2_NAME`,
 1 AS `ESO_DET_OUT2_NX`,
 1 AS `ESO_DET_OUT2_NY`,
 1 AS `ESO_DET_OUT2_OVSCX`,
 1 AS `ESO_DET_OUT2_OVSCY`,
 1 AS `ESO_DET_OUT2_PRSCX`,
 1 AS `ESO_DET_OUT2_PRSCY`,
 1 AS `ESO_DET_OUT2_RON`,
 1 AS `ESO_DET_OUT2_X`,
 1 AS `ESO_DET_OUT2_Y`,
 1 AS `OBJMASK`,
 1 AS `DARKTIME`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `FRICOR`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `OBID`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `ZPRRI`,
 1 AS `ZPVBV`,
 1 AS `ZPVVR`,
 1 AS `ZPRVR`,
 1 AS `ZPUUB`,
 1 AS `ZPBBV`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `TRACE17`,
 1 AS `TRACE18`,
 1 AS `TRACE19`,
 1 AS `TRACE20`,
 1 AS `TRACE21`,
 1 AS `ZPZIZ`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `TRACE22`,
 1 AS `TRACE23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `TRACE24`,
 1 AS `TRACE25`,
 1 AS `TRACE26`,
 1 AS `TRACE27`,
 1 AS `TRACE28`,
 1 AS `TRACE29`,
 1 AS `CONTNORM`,
 1 AS `DISPELEM`,
 1 AS `EXT_OBJ`,
 1 AS `FLUXERR`,
 1 AS `LTV2`,
 1 AS `SPECSYS`,
 1 AS `TELAPSE`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `OBJ_OLD`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`,
 1 AS `isInTransientBucket`,
 1 AS `DATA_REL`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `astromet_error_arcsec`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_ssdr1`
--

DROP TABLE IF EXISTS `view_efosc_imaging_ssdr1`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_ssdr1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_ssdr1` AS SELECT 
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ASSOC_SPECTRUM_ID`,
 1 AS `ASSOC_SPECTRUM_NAME`,
 1 AS `ASTROMET`,
 1 AS `astromet_error_arcsec`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `filetype_key_calibration`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `GAIN`,
 1 AS `dryx_comment`,
 1 AS `isInTransientBucket`,
 1 AS `LACOSMIC`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `rewriteFitsHeader`,
 1 AS `RRELEASE`,
 1 AS `TEXPTIME`,
 1 AS `transientBucketId`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_imaging_ssdr2`
--

DROP TABLE IF EXISTS `view_efosc_imaging_ssdr2`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_ssdr2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_imaging_ssdr2` AS SELECT 
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ASSOC_SPECTRUM_ID`,
 1 AS `ASSOC_SPECTRUM_NAME`,
 1 AS `ASTROMET`,
 1 AS `astromet_error_arcsec`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `filetype_key_calibration`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `GAIN`,
 1 AS `dryx_comment`,
 1 AS `isInTransientBucket`,
 1 AS `LACOSMIC`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NCOMBINE`,
 1 AS `OBJECT`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PSF_FWHM`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `rewriteFitsHeader`,
 1 AS `RRELEASE`,
 1 AS `TEXPTIME`,
 1 AS `transientBucketId`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_benetti`
--

DROP TABLE IF EXISTS `view_efosc_spectra_benetti`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_benetti`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_benetti` AS SELECT 
 1 AS `primaryId`,
 1 AS `ARCFILE`,
 1 AS `BITPIX`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `LST`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PCOUNT`,
 1 AS `PI_COI`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SIMPLE`,
 1 AS `TELESCOP`,
 1 AS `UTC`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `ARC`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `BIASSEC`,
 1 AS `BUNIT`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CD3_3`,
 1 AS `CONTNORM`,
 1 AS `CTYPE3`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `ESO_INS_MOS1_LEN`,
 1 AS `ESO_INS_MOS1_POSX`,
 1 AS `ESO_INS_MOS1_POSY`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTM3_3`,
 1 AS `MAGSTD`,
 1 AS `MJD_END`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS3`,
 1 AS `NCOMBINE`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `SINGLEXP`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `STDNAME`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT1_002`,
 1 AS `WAT2_001`,
 1 AS `WAT3_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `ZEROCOR`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `SHIFT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `CA_FLAG`,
 1 AS `EX_FLAG`,
 1 AS `SENSFUN`,
 1 AS `SNR`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `LTV1`,
 1 AS `ESO_DET_WIN1_DIT2`,
 1 AS `ESO_DET_WIN1_UIT2`,
 1 AS `LTV2`,
 1 AS `REFSPEC1`,
 1 AS `ATMOFILE`,
 1 AS `DISPAXIS`,
 1 AS `OBID`,
 1 AS `DARKTIME`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `ASSOC2`,
 1 AS `ASSOC3`,
 1 AS `ASSOC4`,
 1 AS `ASSOC5`,
 1 AS `OBJ_OLD`,
 1 AS `TELE_DEC`,
 1 AS `TELE_RA`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `APNUM2`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_esophaseiii`
--

DROP TABLE IF EXISTS `view_efosc_spectra_esophaseiii`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_esophaseiii`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_esophaseiii` AS SELECT 
 1 AS `primaryId`,
 1 AS `ARCFILE`,
 1 AS `BITPIX`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `LST`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PCOUNT`,
 1 AS `PI_COI`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SIMPLE`,
 1 AS `TELESCOP`,
 1 AS `UTC`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `ARC`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `BIASSEC`,
 1 AS `BUNIT`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CD3_3`,
 1 AS `CONTNORM`,
 1 AS `CTYPE3`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `ESO_INS_MOS1_LEN`,
 1 AS `ESO_INS_MOS1_POSX`,
 1 AS `ESO_INS_MOS1_POSY`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTM3_3`,
 1 AS `MAGSTD`,
 1 AS `MJD_END`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS3`,
 1 AS `NCOMBINE`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `SINGLEXP`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `STDNAME`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT1_002`,
 1 AS `WAT2_001`,
 1 AS `WAT3_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `ZEROCOR`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `SHIFT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `CA_FLAG`,
 1 AS `EX_FLAG`,
 1 AS `SENSFUN`,
 1 AS `SNR`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `LTV1`,
 1 AS `ESO_DET_WIN1_DIT2`,
 1 AS `ESO_DET_WIN1_UIT2`,
 1 AS `LTV2`,
 1 AS `REFSPEC1`,
 1 AS `ATMOFILE`,
 1 AS `DISPAXIS`,
 1 AS `OBID`,
 1 AS `DARKTIME`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `ASSOC2`,
 1 AS `ASSOC3`,
 1 AS `ASSOC4`,
 1 AS `ASSOC5`,
 1 AS `OBJ_OLD`,
 1 AS `TELE_DEC`,
 1 AS `TELE_RA`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `APNUM2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_intermediate`
--

DROP TABLE IF EXISTS `view_efosc_spectra_intermediate`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_intermediate`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_intermediate` AS SELECT 
 1 AS `primaryId`,
 1 AS `ARCFILE`,
 1 AS `BITPIX`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `LST`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PCOUNT`,
 1 AS `PI_COI`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SIMPLE`,
 1 AS `TELESCOP`,
 1 AS `UTC`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `ARC`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `BIASSEC`,
 1 AS `BUNIT`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CD3_3`,
 1 AS `CONTNORM`,
 1 AS `CTYPE3`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `ESO_INS_MOS1_LEN`,
 1 AS `ESO_INS_MOS1_POSX`,
 1 AS `ESO_INS_MOS1_POSY`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTM3_3`,
 1 AS `MAGSTD`,
 1 AS `MJD_END`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS3`,
 1 AS `NCOMBINE`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `SINGLEXP`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `STDNAME`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT1_002`,
 1 AS `WAT2_001`,
 1 AS `WAT3_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `ZEROCOR`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `SHIFT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `CA_FLAG`,
 1 AS `EX_FLAG`,
 1 AS `SENSFUN`,
 1 AS `SNR`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `LTV1`,
 1 AS `ESO_DET_WIN1_DIT2`,
 1 AS `ESO_DET_WIN1_UIT2`,
 1 AS `LTV2`,
 1 AS `REFSPEC1`,
 1 AS `ATMOFILE`,
 1 AS `DISPAXIS`,
 1 AS `OBID`,
 1 AS `DARKTIME`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `ASSOC2`,
 1 AS `ASSOC3`,
 1 AS `ASSOC4`,
 1 AS `ASSOC5`,
 1 AS `OBJ_OLD`,
 1 AS `TELE_DEC`,
 1 AS `TELE_RA`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `APNUM2`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_raw`
--

DROP TABLE IF EXISTS `view_efosc_spectra_raw`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_raw` AS SELECT 
 1 AS `primaryId`,
 1 AS `ARCFILE`,
 1 AS `BITPIX`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `LST`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PCOUNT`,
 1 AS `PI_COI`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SIMPLE`,
 1 AS `TELESCOP`,
 1 AS `UTC`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `ARC`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `BIASSEC`,
 1 AS `BUNIT`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CD3_3`,
 1 AS `CONTNORM`,
 1 AS `CTYPE3`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `ESO_INS_MOS1_LEN`,
 1 AS `ESO_INS_MOS1_POSX`,
 1 AS `ESO_INS_MOS1_POSY`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTM3_3`,
 1 AS `MAGSTD`,
 1 AS `MJD_END`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS3`,
 1 AS `NCOMBINE`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `SINGLEXP`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `STDNAME`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT1_002`,
 1 AS `WAT2_001`,
 1 AS `WAT3_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `ZEROCOR`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `SHIFT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `CA_FLAG`,
 1 AS `EX_FLAG`,
 1 AS `SENSFUN`,
 1 AS `SNR`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `LTV1`,
 1 AS `ESO_DET_WIN1_DIT2`,
 1 AS `ESO_DET_WIN1_UIT2`,
 1 AS `LTV2`,
 1 AS `REFSPEC1`,
 1 AS `ATMOFILE`,
 1 AS `DISPAXIS`,
 1 AS `OBID`,
 1 AS `DARKTIME`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `ASSOC2`,
 1 AS `ASSOC3`,
 1 AS `ASSOC4`,
 1 AS `ASSOC5`,
 1 AS `OBJ_OLD`,
 1 AS `TELE_DEC`,
 1 AS `TELE_RA`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `APNUM2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_reduced`
--

DROP TABLE IF EXISTS `view_efosc_spectra_reduced`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_reduced`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_reduced` AS SELECT 
 1 AS `primaryId`,
 1 AS `ARCFILE`,
 1 AS `BITPIX`,
 1 AS `BSCALE`,
 1 AS `BZERO`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_BITS`,
 1 AS `ESO_DET_CHIP1_DATE`,
 1 AS `ESO_DET_CHIP1_ID`,
 1 AS `ESO_DET_CHIP1_INDEX`,
 1 AS `ESO_DET_CHIP1_NAME`,
 1 AS `ESO_DET_CHIP1_NX`,
 1 AS `ESO_DET_CHIP1_NY`,
 1 AS `ESO_DET_CHIP1_PSZX`,
 1 AS `ESO_DET_CHIP1_PSZY`,
 1 AS `ESO_DET_CHIP1_X`,
 1 AS `ESO_DET_CHIP1_XGAP`,
 1 AS `ESO_DET_CHIP1_Y`,
 1 AS `ESO_DET_CHIP1_YGAP`,
 1 AS `ESO_DET_CHIPS`,
 1 AS `ESO_DET_DATE`,
 1 AS `ESO_DET_DEC`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_RDTTIME`,
 1 AS `ESO_DET_EXP_TYPE`,
 1 AS `ESO_DET_EXP_XFERTIM`,
 1 AS `ESO_DET_FRAM_ID`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_ID`,
 1 AS `ESO_DET_NAME`,
 1 AS `ESO_DET_OUT1_CHIP`,
 1 AS `ESO_DET_OUT1_CONAD`,
 1 AS `ESO_DET_OUT1_GAIN`,
 1 AS `ESO_DET_OUT1_ID`,
 1 AS `ESO_DET_OUT1_INDEX`,
 1 AS `ESO_DET_OUT1_NAME`,
 1 AS `ESO_DET_OUT1_NX`,
 1 AS `ESO_DET_OUT1_NY`,
 1 AS `ESO_DET_OUT1_OVSCX`,
 1 AS `ESO_DET_OUT1_OVSCY`,
 1 AS `ESO_DET_OUT1_PRSCX`,
 1 AS `ESO_DET_OUT1_PRSCY`,
 1 AS `ESO_DET_OUT1_RON`,
 1 AS `ESO_DET_OUT1_X`,
 1 AS `ESO_DET_OUT1_Y`,
 1 AS `ESO_DET_OUTPUTS`,
 1 AS `ESO_DET_OUTREF`,
 1 AS `ESO_DET_RA`,
 1 AS `ESO_DET_READ_CLOCK`,
 1 AS `ESO_DET_READ_MODE`,
 1 AS `ESO_DET_READ_NFRAM`,
 1 AS `ESO_DET_READ_SPEED`,
 1 AS `ESO_DET_SHUT_ID`,
 1 AS `ESO_DET_SHUT_TMCLOS`,
 1 AS `ESO_DET_SHUT_TMOPEN`,
 1 AS `ESO_DET_SHUT_TYPE`,
 1 AS `ESO_DET_SOFW_MODE`,
 1 AS `ESO_DET_WIN1_BINX`,
 1 AS `ESO_DET_WIN1_BINY`,
 1 AS `ESO_DET_WIN1_DIT1`,
 1 AS `ESO_DET_WIN1_DKTM`,
 1 AS `ESO_DET_WIN1_NDIT`,
 1 AS `ESO_DET_WIN1_NX`,
 1 AS `ESO_DET_WIN1_NY`,
 1 AS `ESO_DET_WIN1_ST`,
 1 AS `ESO_DET_WIN1_STRX`,
 1 AS `ESO_DET_WIN1_STRY`,
 1 AS `ESO_DET_WIN1_UIT1`,
 1 AS `ESO_DET_WINDOWS`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_DATE`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_DPOR_POS`,
 1 AS `ESO_INS_DPOR_ST`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_GRIS1_ID`,
 1 AS `ESO_INS_GRIS1_NAME`,
 1 AS `ESO_INS_GRIS1_NO`,
 1 AS `ESO_INS_GRIS1_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_SLIT1_ENC`,
 1 AS `ESO_INS_SLIT1_LEN`,
 1 AS `ESO_INS_SLIT1_NAME`,
 1 AS `ESO_INS_SLIT1_NO`,
 1 AS `ESO_INS_SLIT1_WID`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_WP_NAME`,
 1 AS `ESO_INS_WP_ST`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_DET1_IMGNAME`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `GCOUNT`,
 1 AS `INHERIT`,
 1 AS `INSTRUME`,
 1 AS `LST`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PCOUNT`,
 1 AS `PI_COI`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `SIMPLE`,
 1 AS `TELESCOP`,
 1 AS `UTC`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `ARC`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `BIASSEC`,
 1 AS `BUNIT`,
 1 AS `CCDMEAN`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CD3_3`,
 1 AS `CONTNORM`,
 1 AS `CTYPE3`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_DET_TELE_INT`,
 1 AS `ESO_DET_TELE_NO`,
 1 AS `ESO_DET_TLM1_END`,
 1 AS `ESO_DET_TLM1_ID`,
 1 AS `ESO_DET_TLM1_NAME`,
 1 AS `ESO_DET_TLM1_START`,
 1 AS `ESO_DET_TLM2_END`,
 1 AS `ESO_DET_TLM2_ID`,
 1 AS `ESO_DET_TLM2_NAME`,
 1 AS `ESO_DET_TLM2_START`,
 1 AS `ESO_DET_TLM3_END`,
 1 AS `ESO_DET_TLM3_ID`,
 1 AS `ESO_DET_TLM3_NAME`,
 1 AS `ESO_DET_TLM3_START`,
 1 AS `ESO_DET_TLM4_END`,
 1 AS `ESO_DET_TLM4_ID`,
 1 AS `ESO_DET_TLM4_NAME`,
 1 AS `ESO_DET_TLM4_START`,
 1 AS `ESO_DET_TLM5_END`,
 1 AS `ESO_DET_TLM5_ID`,
 1 AS `ESO_DET_TLM5_NAME`,
 1 AS `ESO_DET_TLM5_START`,
 1 AS `ESO_DET_TLM6_END`,
 1 AS `ESO_DET_TLM6_ID`,
 1 AS `ESO_DET_TLM6_NAME`,
 1 AS `ESO_DET_TLM6_START`,
 1 AS `ESO_INS_MOS1_LEN`,
 1 AS `ESO_INS_MOS1_POSX`,
 1 AS `ESO_INS_MOS1_POSY`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OCS_CON_WCSFITS`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `IRAF_TLM`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `LTM3_3`,
 1 AS `MAGSTD`,
 1 AS `MJD_END`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS3`,
 1 AS `NCOMBINE`,
 1 AS `OBID1`,
 1 AS `OBSTECH`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `REFERENC`,
 1 AS `SINGLEXP`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `STDNAME`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT1_002`,
 1 AS `WAT2_001`,
 1 AS `WAT3_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `ZEROCOR`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `SHIFT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `CA_FLAG`,
 1 AS `EX_FLAG`,
 1 AS `SENSFUN`,
 1 AS `SNR`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `LTV1`,
 1 AS `ESO_DET_WIN1_DIT2`,
 1 AS `ESO_DET_WIN1_UIT2`,
 1 AS `LTV2`,
 1 AS `REFSPEC1`,
 1 AS `ATMOFILE`,
 1 AS `DISPAXIS`,
 1 AS `OBID`,
 1 AS `DARKTIME`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `COMMENT`,
 1 AS `FILTER1`,
 1 AS `GRISM`,
 1 AS `IMAGETYP`,
 1 AS `ST`,
 1 AS `UT`,
 1 AS `OVERSCAN`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `ASSOC2`,
 1 AS `ASSOC3`,
 1 AS `ASSOC4`,
 1 AS `ASSOC5`,
 1 AS `OBJ_OLD`,
 1 AS `TELE_DEC`,
 1 AS `TELE_RA`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `APNUM2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_ssdr1`
--

DROP TABLE IF EXISTS `view_efosc_spectra_ssdr1`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_ssdr1` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ARCFILE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `nelem`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_ssdr2`
--

DROP TABLE IF EXISTS `view_efosc_spectra_ssdr2`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_ssdr2` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ARCFILE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `nelem`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_efosc_spectra_ssdr3`
--

DROP TABLE IF EXISTS `view_efosc_spectra_ssdr3`;
/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr3`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_efosc_spectra_ssdr3` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ARCFILE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LACOSMIC`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `nelem`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_eso_phaseiii_files`
--

DROP TABLE IF EXISTS `view_eso_phaseiii_files`;
/*!50001 DROP VIEW IF EXISTS `view_eso_phaseiii_files`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_eso_phaseiii_files` AS SELECT 
 1 AS `tableName`,
 1 AS `object`,
 1 AS `transientBucketId`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `REFERENC`,
 1 AS `PI_COI`,
 1 AS `DATA_REL`,
 1 AS `OBSERVER`,
 1 AS `obid1`,
 1 AS `ESOphaseIII`,
 1 AS `fileName`,
 1 AS `ASSON1`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_fs_crts_css_summary`
--

DROP TABLE IF EXISTS `view_fs_crts_css_summary`;
/*!50001 DROP VIEW IF EXISTS `view_fs_crts_css_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_fs_crts_css_summary` AS SELECT 
 1 AS `primaryId`,
 1 AS `circularUrl`,
 1 AS `comment`,
 1 AS `commentIngested`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `decDeg`,
 1 AS `filter`,
 1 AS `finderChartUrl`,
 1 AS `finderChartWebpage`,
 1 AS `imagesUrl`,
 1 AS `ingested`,
 1 AS `lightcurveUrl`,
 1 AS `mag`,
 1 AS `name`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `raDeg`,
 1 AS `summaryRow`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `targetImageUrl`,
 1 AS `transientTypePrediction`,
 1 AS `uniqueId`,
 1 AS `htm16ID`,
 1 AS `magErr`,
 1 AS `lastNonDetectionDate`,
 1 AS `lastNonDetectionMJD`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_fs_crts_mls_summary`
--

DROP TABLE IF EXISTS `view_fs_crts_mls_summary`;
/*!50001 DROP VIEW IF EXISTS `view_fs_crts_mls_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_fs_crts_mls_summary` AS SELECT 
 1 AS `primaryId`,
 1 AS `circularUrl`,
 1 AS `comment`,
 1 AS `commentIngested`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `decDeg`,
 1 AS `filter`,
 1 AS `finderChartUrl`,
 1 AS `finderChartWebpage`,
 1 AS `imagesUrl`,
 1 AS `ingested`,
 1 AS `lightcurveUrl`,
 1 AS `mag`,
 1 AS `name`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `raDeg`,
 1 AS `summaryRow`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `targetImageUrl`,
 1 AS `transientTypePrediction`,
 1 AS `uniqueId`,
 1 AS `htm16ID`,
 1 AS `magErr`,
 1 AS `lastNonDetectionDate`,
 1 AS `lastNonDetectionMJD`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_fs_crts_sss_summary`
--

DROP TABLE IF EXISTS `view_fs_crts_sss_summary`;
/*!50001 DROP VIEW IF EXISTS `view_fs_crts_sss_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_fs_crts_sss_summary` AS SELECT 
 1 AS `primaryId`,
 1 AS `circularUrl`,
 1 AS `comment`,
 1 AS `commentIngested`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `decDeg`,
 1 AS `filter`,
 1 AS `finderChartUrl`,
 1 AS `finderChartWebpage`,
 1 AS `imagesUrl`,
 1 AS `ingested`,
 1 AS `lightcurveUrl`,
 1 AS `mag`,
 1 AS `name`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `raDeg`,
 1 AS `summaryRow`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `targetImageUrl`,
 1 AS `transientTypePrediction`,
 1 AS `uniqueId`,
 1 AS `htm16ID`,
 1 AS `magErr`,
 1 AS `lastNonDetectionDate`,
 1 AS `lastNonDetectionMJD`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_fs_ogle_summary`
--

DROP TABLE IF EXISTS `view_fs_ogle_summary`;
/*!50001 DROP VIEW IF EXISTS `view_fs_ogle_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_fs_ogle_summary` AS SELECT 
 1 AS `primaryId`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `decDeg`,
 1 AS `filter`,
 1 AS `ingested`,
 1 AS `lastNonDetectionDate`,
 1 AS `lastNonDetectionMJD`,
 1 AS `lightcurveUrl`,
 1 AS `mag`,
 1 AS `name`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `raDeg`,
 1 AS `referenceFitsUrl`,
 1 AS `referenceImageUrl`,
 1 AS `subtractedFitsUrl`,
 1 AS `subtractedImageUrl`,
 1 AS `summaryRow`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `targetFitsUrl`,
 1 AS `targetImageUrl`,
 1 AS `transientTypePrediction`,
 1 AS `htm16ID`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_object_akas`
--

DROP TABLE IF EXISTS `view_object_akas`;
/*!50001 DROP VIEW IF EXISTS `view_object_akas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_object_akas` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `primaryKeyId`,
 1 AS `name`,
 1 AS `survey`,
 1 AS `surveyObjectUrl`,
 1 AS `referenceImageUrl`,
 1 AS `targetImageUrl`,
 1 AS `subtractedImageUrl`,
 1 AS `tripletImageUrl`,
 1 AS `finderImageUrl`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_object_temporal_data`
--

DROP TABLE IF EXISTS `view_object_temporal_data`;
/*!50001 DROP VIEW IF EXISTS `view_object_temporal_data`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_object_temporal_data` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `name`,
 1 AS `survey`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `magnitude`,
 1 AS `magnitudeError`,
 1 AS `filter`,
 1 AS `surveyObjectUrl`,
 1 AS `referenceImageUrl`,
 1 AS `targetImageUrl`,
 1 AS `subtractedImageUrl`,
 1 AS `tripletImageUrl`,
 1 AS `telescope`,
 1 AS `instrument`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_objectredshifts`
--

DROP TABLE IF EXISTS `view_objectredshifts`;
/*!50001 DROP VIEW IF EXISTS `view_objectredshifts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_objectredshifts` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `transientRedshift`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_objectspectraltypes`
--

DROP TABLE IF EXISTS `view_objectspectraltypes`;
/*!50001 DROP VIEW IF EXISTS `view_objectspectraltypes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_objectspectraltypes` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `spectralType`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_benetti`
--

DROP TABLE IF EXISTS `view_sofi_imaging_benetti`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_benetti`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_benetti` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETA`,
 1 AS `ESO_SEQ_CUMOFFSETD`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_CUMOFFSETY`,
 1 AS `ESO_SEQ_POISSON`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_SEQ_RELOFFSETY`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `GAIN`,
 1 AS `ILLUMCOR`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `NCOMBINE`,
 1 AS `OBJMASK`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `OBID`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `COMMENT`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `ELLIPTIC`,
 1 AS `FLUXCAL`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTCRPIX1`,
 1 AS `NTCRPIX2`,
 1 AS `NUSTEP`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PSF_FWHM`,
 1 AS `PROV12`,
 1 AS `ZPJJH`,
 1 AS `PROV13`,
 1 AS `PROV5`,
 1 AS `PROV14`,
 1 AS `PROV6`,
 1 AS `PROV15`,
 1 AS `PROV7`,
 1 AS `PROV16`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE5`,
 1 AS `TRACE14`,
 1 AS `TRACE6`,
 1 AS `TRACE15`,
 1 AS `TRACE7`,
 1 AS `TRACE16`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `ZPKHK`,
 1 AS `DARKTIME`,
 1 AS `ZPHJH`,
 1 AS `MKILLUM`,
 1 AS `HDRVER`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_esophaseiii`
--

DROP TABLE IF EXISTS `view_sofi_imaging_esophaseiii`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_esophaseiii`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_esophaseiii` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETA`,
 1 AS `ESO_SEQ_CUMOFFSETD`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_CUMOFFSETY`,
 1 AS `ESO_SEQ_POISSON`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_SEQ_RELOFFSETY`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `GAIN`,
 1 AS `ILLUMCOR`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `NCOMBINE`,
 1 AS `OBJMASK`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `OBID`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `COMMENT`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `ELLIPTIC`,
 1 AS `FLUXCAL`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTCRPIX1`,
 1 AS `NTCRPIX2`,
 1 AS `NUSTEP`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PSF_FWHM`,
 1 AS `PROV12`,
 1 AS `ZPJJH`,
 1 AS `PROV13`,
 1 AS `PROV5`,
 1 AS `PROV14`,
 1 AS `PROV6`,
 1 AS `PROV15`,
 1 AS `PROV7`,
 1 AS `PROV16`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE5`,
 1 AS `TRACE14`,
 1 AS `TRACE6`,
 1 AS `TRACE15`,
 1 AS `TRACE7`,
 1 AS `TRACE16`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `ZPKHK`,
 1 AS `DARKTIME`,
 1 AS `ZPHJH`,
 1 AS `MKILLUM`,
 1 AS `HDRVER`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_intermediate`
--

DROP TABLE IF EXISTS `view_sofi_imaging_intermediate`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_intermediate`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_intermediate` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETA`,
 1 AS `ESO_SEQ_CUMOFFSETD`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_CUMOFFSETY`,
 1 AS `ESO_SEQ_POISSON`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_SEQ_RELOFFSETY`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `GAIN`,
 1 AS `ILLUMCOR`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `NCOMBINE`,
 1 AS `OBJMASK`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `OBID`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `COMMENT`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `ELLIPTIC`,
 1 AS `FLUXCAL`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTCRPIX1`,
 1 AS `NTCRPIX2`,
 1 AS `NUSTEP`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PSF_FWHM`,
 1 AS `PROV12`,
 1 AS `ZPJJH`,
 1 AS `PROV13`,
 1 AS `PROV5`,
 1 AS `PROV14`,
 1 AS `PROV6`,
 1 AS `PROV15`,
 1 AS `PROV7`,
 1 AS `PROV16`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE5`,
 1 AS `TRACE14`,
 1 AS `TRACE6`,
 1 AS `TRACE15`,
 1 AS `TRACE7`,
 1 AS `TRACE16`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `ZPKHK`,
 1 AS `DARKTIME`,
 1 AS `ZPHJH`,
 1 AS `MKILLUM`,
 1 AS `HDRVER`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_raw`
--

DROP TABLE IF EXISTS `view_sofi_imaging_raw`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_raw` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETA`,
 1 AS `ESO_SEQ_CUMOFFSETD`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_CUMOFFSETY`,
 1 AS `ESO_SEQ_POISSON`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_SEQ_RELOFFSETY`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `GAIN`,
 1 AS `ILLUMCOR`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `NCOMBINE`,
 1 AS `OBJMASK`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `OBID`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `COMMENT`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `ELLIPTIC`,
 1 AS `FLUXCAL`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTCRPIX1`,
 1 AS `NTCRPIX2`,
 1 AS `NUSTEP`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PSF_FWHM`,
 1 AS `PROV12`,
 1 AS `ZPJJH`,
 1 AS `PROV13`,
 1 AS `PROV5`,
 1 AS `PROV14`,
 1 AS `PROV6`,
 1 AS `PROV15`,
 1 AS `PROV7`,
 1 AS `PROV16`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE5`,
 1 AS `TRACE14`,
 1 AS `TRACE6`,
 1 AS `TRACE15`,
 1 AS `TRACE7`,
 1 AS `TRACE16`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `ZPKHK`,
 1 AS `DARKTIME`,
 1 AS `ZPHJH`,
 1 AS `MKILLUM`,
 1 AS `HDRVER`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_reduced`
--

DROP TABLE IF EXISTS `view_sofi_imaging_reduced`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_reduced`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_reduced` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETA`,
 1 AS `ESO_SEQ_CUMOFFSETD`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_CUMOFFSETY`,
 1 AS `ESO_SEQ_POISSON`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_SEQ_RELOFFSETY`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `GAIN`,
 1 AS `ILLUMCOR`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PIXSCALE`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WCSDIM`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `NCOMBINE`,
 1 AS `OBJMASK`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `TRACE2`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `OBID`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `COMMENT`,
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `CD1_2`,
 1 AS `CD2_1`,
 1 AS `CRDER1`,
 1 AS `CRDER2`,
 1 AS `CSYER1`,
 1 AS `CSYER2`,
 1 AS `CUNIT1`,
 1 AS `CUNIT2`,
 1 AS `ELLIPTIC`,
 1 AS `FLUXCAL`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTCRPIX1`,
 1 AS `NTCRPIX2`,
 1 AS `NUSTEP`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PSF_FWHM`,
 1 AS `PROV12`,
 1 AS `ZPJJH`,
 1 AS `PROV13`,
 1 AS `PROV5`,
 1 AS `PROV14`,
 1 AS `PROV6`,
 1 AS `PROV15`,
 1 AS `PROV7`,
 1 AS `PROV16`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE5`,
 1 AS `TRACE14`,
 1 AS `TRACE6`,
 1 AS `TRACE15`,
 1 AS `TRACE7`,
 1 AS `TRACE16`,
 1 AS `TRACE8`,
 1 AS `TRACE9`,
 1 AS `ZPKHK`,
 1 AS `DARKTIME`,
 1 AS `ZPHJH`,
 1 AS `MKILLUM`,
 1 AS `HDRVER`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`,
 1 AS `isInTransientBucket`,
 1 AS `DATA_REL`,
 1 AS `NTID`,
 1 AS `ESO_INS_LAMP3_NAME`,
 1 AS `ESO_INS_LAMP3_SET`,
 1 AS `EFFRON`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `astromet_error_arcsec`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_ssdr1`
--

DROP TABLE IF EXISTS `view_sofi_imaging_ssdr1`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_ssdr1` AS SELECT 
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `astromet_error_arcsec`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `filetype_key_calibration`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `GAIN`,
 1 AS `isInTransientBucket`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTID`,
 1 AS `OBJECT`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `PSF_FWHM`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `RRELEASE`,
 1 AS `TEXPTIME`,
 1 AS `TMID`,
 1 AS `transientBucketId`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_ssdr2`
--

DROP TABLE IF EXISTS `view_sofi_imaging_ssdr2`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_ssdr2` AS SELECT 
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `astromet_error_arcsec`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `filetype_key_calibration`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `GAIN`,
 1 AS `isInTransientBucket`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTID`,
 1 AS `OBJECT`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `PSF_FWHM`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `RRELEASE`,
 1 AS `TEXPTIME`,
 1 AS `TMID`,
 1 AS `transientBucketId`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_imaging_ssdr3`
--

DROP TABLE IF EXISTS `view_sofi_imaging_ssdr3`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr3`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_imaging_ssdr3` AS SELECT 
 1 AS `ABMAGLIM`,
 1 AS `ABMAGSAT`,
 1 AS `AIRMASS`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `ASTROMET`,
 1 AS `astromet_error_arcsec`,
 1 AS `astromet_rmsx`,
 1 AS `astromet_rmsy`,
 1 AS `astromet_sources`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `filetype_key_calibration`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `GAIN`,
 1 AS `isInTransientBucket`,
 1 AS `MBKG`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NTID`,
 1 AS `OBJECT`,
 1 AS `PHOTSYS`,
 1 AS `PHOTZP`,
 1 AS `PHOTZPER`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `PROV17`,
 1 AS `PROV18`,
 1 AS `PROV19`,
 1 AS `PROV20`,
 1 AS `PROV21`,
 1 AS `PROV22`,
 1 AS `PROV23`,
 1 AS `PROV24`,
 1 AS `PROV25`,
 1 AS `PROV26`,
 1 AS `PROV27`,
 1 AS `PROV28`,
 1 AS `PROV29`,
 1 AS `PROV30`,
 1 AS `PROV31`,
 1 AS `PROV32`,
 1 AS `PROV33`,
 1 AS `PROV34`,
 1 AS `PROV35`,
 1 AS `PROV36`,
 1 AS `PROV37`,
 1 AS `PROV38`,
 1 AS `PROV39`,
 1 AS `PROV40`,
 1 AS `PROV41`,
 1 AS `PROV42`,
 1 AS `PROV43`,
 1 AS `PROV44`,
 1 AS `PROV45`,
 1 AS `PROV46`,
 1 AS `PROV47`,
 1 AS `PROV48`,
 1 AS `PROV49`,
 1 AS `PROV50`,
 1 AS `PROV51`,
 1 AS `PROV52`,
 1 AS `PROV53`,
 1 AS `PROV54`,
 1 AS `PROV55`,
 1 AS `PROV56`,
 1 AS `PROV57`,
 1 AS `PROV58`,
 1 AS `PROV59`,
 1 AS `PROV60`,
 1 AS `PSF_FWHM`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `RRELEASE`,
 1 AS `TEXPTIME`,
 1 AS `TMID`,
 1 AS `transientBucketId`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_benetti`
--

DROP TABLE IF EXISTS `view_sofi_spectra_benetti`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_benetti`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_benetti` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARC`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CONTNORM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPAXIS`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NC_NSAMPPIX`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_NDSAMPLES`,
 1 AS `ESO_DET_NDSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_JITTER_WIDTH`,
 1 AS `ESO_SEQ_NODTHROW`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `PROV2`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `LTV1`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `CD3_3`,
 1 AS `MAGSTD`,
 1 AS `CTYPE3`,
 1 AS `STDNAME`,
 1 AS `LTM3_3`,
 1 AS `NCOMBINE`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NUSTEP`,
 1 AS `WAT3_001`,
 1 AS `TRACE2`,
 1 AS `NAXIS3`,
 1 AS `COMMENT`,
 1 AS `ESO_INS_LAMP1_NAME`,
 1 AS `ESO_INS_LAMP1_ST`,
 1 AS `REFSPEC1`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `SENSFUN`,
 1 AS `SENSPHOT`,
 1 AS `SNR`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV10`,
 1 AS `PROV9`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `DARKTIME`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `TRACE9`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `IMCMB006`,
 1 AS `IMCMB007`,
 1 AS `IMCMB008`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_esophaseiii`
--

DROP TABLE IF EXISTS `view_sofi_spectra_esophaseiii`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_esophaseiii`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_esophaseiii` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARC`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CONTNORM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPAXIS`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NC_NSAMPPIX`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_NDSAMPLES`,
 1 AS `ESO_DET_NDSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_JITTER_WIDTH`,
 1 AS `ESO_SEQ_NODTHROW`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `PROV2`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `LTV1`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `CD3_3`,
 1 AS `MAGSTD`,
 1 AS `CTYPE3`,
 1 AS `STDNAME`,
 1 AS `LTM3_3`,
 1 AS `NCOMBINE`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NUSTEP`,
 1 AS `WAT3_001`,
 1 AS `TRACE2`,
 1 AS `NAXIS3`,
 1 AS `COMMENT`,
 1 AS `ESO_INS_LAMP1_NAME`,
 1 AS `ESO_INS_LAMP1_ST`,
 1 AS `REFSPEC1`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `SENSFUN`,
 1 AS `SENSPHOT`,
 1 AS `SNR`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV10`,
 1 AS `PROV9`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `DARKTIME`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `TRACE9`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `IMCMB006`,
 1 AS `IMCMB007`,
 1 AS `IMCMB008`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_intermediate`
--

DROP TABLE IF EXISTS `view_sofi_spectra_intermediate`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_intermediate`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_intermediate` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARC`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CONTNORM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPAXIS`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NC_NSAMPPIX`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_NDSAMPLES`,
 1 AS `ESO_DET_NDSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_JITTER_WIDTH`,
 1 AS `ESO_SEQ_NODTHROW`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `PROV2`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `LTV1`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `CD3_3`,
 1 AS `MAGSTD`,
 1 AS `CTYPE3`,
 1 AS `STDNAME`,
 1 AS `LTM3_3`,
 1 AS `NCOMBINE`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NUSTEP`,
 1 AS `WAT3_001`,
 1 AS `TRACE2`,
 1 AS `NAXIS3`,
 1 AS `COMMENT`,
 1 AS `ESO_INS_LAMP1_NAME`,
 1 AS `ESO_INS_LAMP1_ST`,
 1 AS `REFSPEC1`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `SENSFUN`,
 1 AS `SENSPHOT`,
 1 AS `SNR`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV10`,
 1 AS `PROV9`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `DARKTIME`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `TRACE9`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `IMCMB006`,
 1 AS `IMCMB007`,
 1 AS `IMCMB008`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`,
 1 AS `archivedLocally`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_raw`
--

DROP TABLE IF EXISTS `view_sofi_spectra_raw`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_raw` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARC`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CONTNORM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPAXIS`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NC_NSAMPPIX`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_NDSAMPLES`,
 1 AS `ESO_DET_NDSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_JITTER_WIDTH`,
 1 AS `ESO_SEQ_NODTHROW`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `PROV2`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `LTV1`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `CD3_3`,
 1 AS `MAGSTD`,
 1 AS `CTYPE3`,
 1 AS `STDNAME`,
 1 AS `LTM3_3`,
 1 AS `NCOMBINE`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NUSTEP`,
 1 AS `WAT3_001`,
 1 AS `TRACE2`,
 1 AS `NAXIS3`,
 1 AS `COMMENT`,
 1 AS `ESO_INS_LAMP1_NAME`,
 1 AS `ESO_INS_LAMP1_ST`,
 1 AS `REFSPEC1`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `SENSFUN`,
 1 AS `SENSPHOT`,
 1 AS `SNR`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV10`,
 1 AS `PROV9`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `DARKTIME`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `TRACE9`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `IMCMB006`,
 1 AS `IMCMB007`,
 1 AS `IMCMB008`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_reduced`
--

DROP TABLE IF EXISTS `view_sofi_spectra_reduced`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_reduced`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_reduced` AS SELECT 
 1 AS `primaryId`,
 1 AS `AIRMASS`,
 1 AS `ARC`,
 1 AS `ARCFILE`,
 1 AS `BIASSEC`,
 1 AS `BITPIX`,
 1 AS `BUNIT`,
 1 AS `CCDMEANT`,
 1 AS `CCDPROC`,
 1 AS `CCDSEC`,
 1 AS `CD1_1`,
 1 AS `CD2_2`,
 1 AS `CDELT1`,
 1 AS `CDELT2`,
 1 AS `CHECKSUM`,
 1 AS `CONTNORM`,
 1 AS `CROSSTAL`,
 1 AS `CRPIX1`,
 1 AS `CRPIX2`,
 1 AS `CRVAL1`,
 1 AS `CRVAL2`,
 1 AS `CTYPE1`,
 1 AS `CTYPE2`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATASUM`,
 1 AS `DATE`,
 1 AS `DATE_OBS`,
 1 AS `DC_FLAG`,
 1 AS `DCLOG1`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPAXIS`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EQUINOX`,
 1 AS `ESO_ADA_ABSROT_END`,
 1 AS `ESO_ADA_ABSROT_START`,
 1 AS `ESO_ADA_GUID_DEC`,
 1 AS `ESO_ADA_GUID_RA`,
 1 AS `ESO_ADA_GUID_STATUS`,
 1 AS `ESO_ADA_POSANG`,
 1 AS `ESO_DET_CHIP_ID`,
 1 AS `ESO_DET_CHIP_NAME`,
 1 AS `ESO_DET_CHIP_NX`,
 1 AS `ESO_DET_CHIP_NY`,
 1 AS `ESO_DET_CHIP_PXSPACE`,
 1 AS `ESO_DET_CHIP_TYPE`,
 1 AS `ESO_DET_CHOP_CYCSKIP`,
 1 AS `ESO_DET_CHOP_FREQ`,
 1 AS `ESO_DET_CHOP_NCYCLES`,
 1 AS `ESO_DET_CHOP_ST`,
 1 AS `ESO_DET_CON_OPMODE`,
 1 AS `ESO_DET_DID`,
 1 AS `ESO_DET_DIT`,
 1 AS `ESO_DET_DITDELAY`,
 1 AS `ESO_DET_EXP_NAME`,
 1 AS `ESO_DET_EXP_NO`,
 1 AS `ESO_DET_EXP_UTC`,
 1 AS `ESO_DET_FILE_CUBE_ST`,
 1 AS `ESO_DET_FRAM_NO`,
 1 AS `ESO_DET_FRAM_TYPE`,
 1 AS `ESO_DET_FRAM_UTC`,
 1 AS `ESO_DET_IRACE_ADC1_DELAY`,
 1 AS `ESO_DET_IRACE_ADC1_ENABLE`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER1`,
 1 AS `ESO_DET_IRACE_ADC1_FILTER2`,
 1 AS `ESO_DET_IRACE_ADC1_HEADER`,
 1 AS `ESO_DET_IRACE_ADC1_NAME`,
 1 AS `ESO_DET_IRACE_SEQCONT`,
 1 AS `ESO_DET_MODE_NAME`,
 1 AS `ESO_DET_NC_NSAMPPIX`,
 1 AS `ESO_DET_NCORRS`,
 1 AS `ESO_DET_NCORRS_NAME`,
 1 AS `ESO_DET_NDIT`,
 1 AS `ESO_DET_NDITSKIP`,
 1 AS `ESO_DET_NDSAMPLES`,
 1 AS `ESO_DET_NDSKIP`,
 1 AS `ESO_DET_RSPEED`,
 1 AS `ESO_DET_RSPEEDADD`,
 1 AS `ESO_DET_WIN_NX`,
 1 AS `ESO_DET_WIN_NY`,
 1 AS `ESO_DET_WIN_STARTX`,
 1 AS `ESO_DET_WIN_STARTY`,
 1 AS `ESO_DET_WIN_TYPE`,
 1 AS `ESO_DPR_CATG`,
 1 AS `ESO_DPR_TECH`,
 1 AS `ESO_DPR_TYPE`,
 1 AS `ESO_INS_COLLIM_ENC`,
 1 AS `ESO_INS_DID`,
 1 AS `ESO_INS_FILT1_ID`,
 1 AS `ESO_INS_FILT1_NAME`,
 1 AS `ESO_INS_FILT1_NO`,
 1 AS `ESO_INS_FILT1_TYPE`,
 1 AS `ESO_INS_FILT2_ID`,
 1 AS `ESO_INS_FILT2_NAME`,
 1 AS `ESO_INS_FILT2_NO`,
 1 AS `ESO_INS_FILT2_TYPE`,
 1 AS `ESO_INS_ID`,
 1 AS `ESO_INS_MODE`,
 1 AS `ESO_INS_OPTI1_ID`,
 1 AS `ESO_INS_OPTI1_NAME`,
 1 AS `ESO_INS_OPTI1_NO`,
 1 AS `ESO_INS_OPTI1_TYPE`,
 1 AS `ESO_INS_OPTI2_ID`,
 1 AS `ESO_INS_OPTI2_NAME`,
 1 AS `ESO_INS_OPTI2_NO`,
 1 AS `ESO_INS_OPTI2_TYPE`,
 1 AS `ESO_INS_OPTI3_ID`,
 1 AS `ESO_INS_OPTI3_NAME`,
 1 AS `ESO_INS_OPTI3_NO`,
 1 AS `ESO_INS_OPTI3_TYPE`,
 1 AS `ESO_INS_PIXSCALE`,
 1 AS `ESO_INS_SWSIM`,
 1 AS `ESO_INS_TEMP_DETSW`,
 1 AS `ESO_INS_TEMP_DETSW_SET`,
 1 AS `ESO_INS_TEMP_MON_NAME1`,
 1 AS `ESO_INS_TEMP_MON_NAME10`,
 1 AS `ESO_INS_TEMP_MON_NAME2`,
 1 AS `ESO_INS_TEMP_MON_NAME3`,
 1 AS `ESO_INS_TEMP_MON_NAME4`,
 1 AS `ESO_INS_TEMP_MON_NAME5`,
 1 AS `ESO_INS_TEMP_MON_NAME6`,
 1 AS `ESO_INS_TEMP_MON_NAME7`,
 1 AS `ESO_INS_TEMP_MON_NAME8`,
 1 AS `ESO_INS_TEMP_MON_NAME9`,
 1 AS `ESO_INS_TEMP_MON_TEMP1`,
 1 AS `ESO_INS_TEMP_MON_TEMP10`,
 1 AS `ESO_INS_TEMP_MON_TEMP2`,
 1 AS `ESO_INS_TEMP_MON_TEMP3`,
 1 AS `ESO_INS_TEMP_MON_TEMP4`,
 1 AS `ESO_INS_TEMP_MON_TEMP5`,
 1 AS `ESO_INS_TEMP_MON_TEMP6`,
 1 AS `ESO_INS_TEMP_MON_TEMP7`,
 1 AS `ESO_INS_TEMP_MON_TEMP8`,
 1 AS `ESO_INS_TEMP_MON_TEMP9`,
 1 AS `ESO_INS_TEMP_VACP`,
 1 AS `ESO_INS_TIME`,
 1 AS `ESO_OBS_DID`,
 1 AS `ESO_OBS_EXECTIME`,
 1 AS `ESO_OBS_GRP`,
 1 AS `ESO_OBS_ID`,
 1 AS `ESO_OBS_NAME`,
 1 AS `ESO_OBS_OBSERVER`,
 1 AS `ESO_OBS_PI_COI_ID`,
 1 AS `ESO_OBS_PI_COI_NAME`,
 1 AS `ESO_OBS_PROG_ID`,
 1 AS `ESO_OBS_START`,
 1 AS `ESO_OBS_TARG_NAME`,
 1 AS `ESO_OBS_TPLNO`,
 1 AS `ESO_OCS_COMP_ID`,
 1 AS `ESO_OCS_DID`,
 1 AS `ESO_OCS_SELECT_ARM`,
 1 AS `ESO_SEQ_CUMOFFSETX`,
 1 AS `ESO_SEQ_JITTER_WIDTH`,
 1 AS `ESO_SEQ_NODTHROW`,
 1 AS `ESO_SEQ_RELOFFSETX`,
 1 AS `ESO_TEL_AIRM_END`,
 1 AS `ESO_TEL_AIRM_START`,
 1 AS `ESO_TEL_ALT`,
 1 AS `ESO_TEL_AMBI_FWHM_END`,
 1 AS `ESO_TEL_AMBI_FWHM_START`,
 1 AS `ESO_TEL_AMBI_PRES_END`,
 1 AS `ESO_TEL_AMBI_PRES_START`,
 1 AS `ESO_TEL_AMBI_RHUM`,
 1 AS `ESO_TEL_AMBI_TEMP`,
 1 AS `ESO_TEL_AMBI_WINDDIR`,
 1 AS `ESO_TEL_AMBI_WINDSP`,
 1 AS `ESO_TEL_AZ`,
 1 AS `ESO_TEL_CHOP_ST`,
 1 AS `ESO_TEL_DATE`,
 1 AS `ESO_TEL_DID`,
 1 AS `ESO_TEL_DOME_STATUS`,
 1 AS `ESO_TEL_FOCU_ID`,
 1 AS `ESO_TEL_FOCU_LEN`,
 1 AS `ESO_TEL_FOCU_SCALE`,
 1 AS `ESO_TEL_FOCU_VALUE`,
 1 AS `ESO_TEL_GEOELEV`,
 1 AS `ESO_TEL_GEOLAT`,
 1 AS `ESO_TEL_GEOLON`,
 1 AS `ESO_TEL_ID`,
 1 AS `ESO_TEL_MOON_DEC`,
 1 AS `ESO_TEL_MOON_RA`,
 1 AS `ESO_TEL_OPER`,
 1 AS `ESO_TEL_PARANG_END`,
 1 AS `ESO_TEL_PARANG_START`,
 1 AS `ESO_TEL_TARG_ALPHA`,
 1 AS `ESO_TEL_TARG_COORDTYPE`,
 1 AS `ESO_TEL_TARG_DELTA`,
 1 AS `ESO_TEL_TARG_EPOCH`,
 1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,
 1 AS `ESO_TEL_TARG_EQUINOX`,
 1 AS `ESO_TEL_TARG_PARALLAX`,
 1 AS `ESO_TEL_TARG_PMA`,
 1 AS `ESO_TEL_TARG_PMD`,
 1 AS `ESO_TEL_TARG_RADVEL`,
 1 AS `ESO_TEL_TH_M1_TEMP`,
 1 AS `ESO_TEL_TRAK_STATUS`,
 1 AS `ESO_TEL_TSS_TEMP8`,
 1 AS `ESO_TPL_DID`,
 1 AS `ESO_TPL_EXPNO`,
 1 AS `ESO_TPL_ID`,
 1 AS `ESO_TPL_NAME`,
 1 AS `ESO_TPL_NEXP`,
 1 AS `ESO_TPL_PRESEQ`,
 1 AS `ESO_TPL_START`,
 1 AS `ESO_TPL_VERSION`,
 1 AS `EXPTIME`,
 1 AS `EXTEND`,
 1 AS `EXT_OBJ`,
 1 AS `FILETYPE`,
 1 AS `FILTER`,
 1 AS `FLATCOR`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `INSTRUME`,
 1 AS `IRAF_TLM`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `LST`,
 1 AS `LTM1_1`,
 1 AS `LTM2_2`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `M_EPOCH`,
 1 AS `NAXIS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NDIT`,
 1 AS `OBID1`,
 1 AS `OBJECT`,
 1 AS `OBSERVER`,
 1 AS `OBSTECH`,
 1 AS `ORIGFILE`,
 1 AS `ORIGIN`,
 1 AS `PI_COI`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROG_ID`,
 1 AS `PROV1`,
 1 AS `PROV2`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `RADECSYS`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SIMPLE`,
 1 AS `SINGLEXP`,
 1 AS `SKYSUB`,
 1 AS `SPECSYS`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_SYE`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TELESCOP`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `TOT_FLUX`,
 1 AS `TRACE1`,
 1 AS `TRIM`,
 1 AS `UTC`,
 1 AS `VOCLASS`,
 1 AS `VOPUB`,
 1 AS `WAT0_001`,
 1 AS `WAT1_001`,
 1 AS `WAT2_001`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `WCSDIM`,
 1 AS `XMAX`,
 1 AS `XMIN`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `dateLastRead`,
 1 AS `filePath`,
 1 AS `filename`,
 1 AS `headerExtension`,
 1 AS `CCDMEAN`,
 1 AS `ESO_OCS_WCS_RTD_ST`,
 1 AS `LTV1`,
 1 AS `PC1_1`,
 1 AS `PC1_2`,
 1 AS `PC2_1`,
 1 AS `PC2_2`,
 1 AS `APERTURE`,
 1 AS `APNUM1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `CD3_3`,
 1 AS `MAGSTD`,
 1 AS `CTYPE3`,
 1 AS `STDNAME`,
 1 AS `LTM3_3`,
 1 AS `NCOMBINE`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `NUSTEP`,
 1 AS `WAT3_001`,
 1 AS `TRACE2`,
 1 AS `NAXIS3`,
 1 AS `COMMENT`,
 1 AS `ESO_INS_LAMP1_NAME`,
 1 AS `ESO_INS_LAMP1_ST`,
 1 AS `REFSPEC1`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `SENSFUN`,
 1 AS `SENSPHOT`,
 1 AS `SNR`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV10`,
 1 AS `PROV9`,
 1 AS `TRACE3`,
 1 AS `TRACE4`,
 1 AS `TRACE5`,
 1 AS `TRACE6`,
 1 AS `TRACE7`,
 1 AS `TRACE8`,
 1 AS `DARKTIME`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `TRACE10`,
 1 AS `TRACE11`,
 1 AS `TRACE12`,
 1 AS `TRACE13`,
 1 AS `TRACE14`,
 1 AS `TRACE15`,
 1 AS `TRACE16`,
 1 AS `TRACE9`,
 1 AS `IMCMB001`,
 1 AS `IMCMB002`,
 1 AS `IMCMB003`,
 1 AS `IMCMB004`,
 1 AS `IMCMB005`,
 1 AS `IMCMB006`,
 1 AS `IMCMB007`,
 1 AS `IMCMB008`,
 1 AS `filetype_key_instrument`,
 1 AS `filetype_key_image_or_spectrum`,
 1 AS `filetype_key_reduction_stage`,
 1 AS `filetype_key_calibration`,
 1 AS `transientBucketId`,
 1 AS `nameChangeRequired`,
 1 AS `esoPhaseIII`,
 1 AS `updatedFilename`,
 1 AS `filenameUpdated`,
 1 AS `objectInFilename`,
 1 AS `updateObjectName`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `updatedFilepath`,
 1 AS `archivePath`,
 1 AS `rewriteFitsHeader`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_ssdr1`
--

DROP TABLE IF EXISTS `view_sofi_spectra_ssdr1`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_ssdr1` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `nelem`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `XMAX`,
 1 AS `XMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_ssdr2`
--

DROP TABLE IF EXISTS `view_sofi_spectra_ssdr2`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_ssdr2` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `nelem`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `XMAX`,
 1 AS `XMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_sofi_spectra_ssdr3`
--

DROP TABLE IF EXISTS `view_sofi_spectra_ssdr3`;
/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr3`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_sofi_spectra_ssdr3` AS SELECT 
 1 AS `AIRMASS`,
 1 AS `APERTURE`,
 1 AS `ASSOC1`,
 1 AS `ASSON1`,
 1 AS `BANDID1`,
 1 AS `BANDID2`,
 1 AS `BANDID3`,
 1 AS `BANDID4`,
 1 AS `binary_table_associated_spectrum_id`,
 1 AS `BITPIX`,
 1 AS `currentFilename`,
 1 AS `currentFilepath`,
 1 AS `DATA_REL`,
 1 AS `DATAMAX`,
 1 AS `DATAMIN`,
 1 AS `DATE_OBS`,
 1 AS `dateCreated`,
 1 AS `DECL`,
 1 AS `DETRON`,
 1 AS `DISPELEM`,
 1 AS `DIT`,
 1 AS `EFFRON`,
 1 AS `esoPhaseIII`,
 1 AS `EXPTIME`,
 1 AS `filename`,
 1 AS `filesize`,
 1 AS `FILTER`,
 1 AS `FLUXCAL`,
 1 AS `FLUXERR`,
 1 AS `GAIN`,
 1 AS `LAMNLIN`,
 1 AS `LAMRMS`,
 1 AS `MJD_END`,
 1 AS `MJD_OBS`,
 1 AS `NAXIS1`,
 1 AS `NAXIS2`,
 1 AS `NCOMBINE`,
 1 AS `NDIT`,
 1 AS `nelem`,
 1 AS `NJITTER`,
 1 AS `NOFFSETS`,
 1 AS `OBJECT`,
 1 AS `PI_COI`,
 1 AS `primaryId`,
 1 AS `PROCSOFT`,
 1 AS `PRODCATG`,
 1 AS `PROV1`,
 1 AS `PROV10`,
 1 AS `PROV11`,
 1 AS `PROV12`,
 1 AS `PROV13`,
 1 AS `PROV14`,
 1 AS `PROV15`,
 1 AS `PROV16`,
 1 AS `PROV2`,
 1 AS `PROV3`,
 1 AS `PROV4`,
 1 AS `PROV5`,
 1 AS `PROV6`,
 1 AS `PROV7`,
 1 AS `PROV8`,
 1 AS `PROV9`,
 1 AS `QUALITY`,
 1 AS `RA`,
 1 AS `REFERENC`,
 1 AS `SHIFT`,
 1 AS `SNR`,
 1 AS `SPEC_BIN`,
 1 AS `SPEC_BW`,
 1 AS `SPEC_ERR`,
 1 AS `SPEC_RES`,
 1 AS `SPEC_VAL`,
 1 AS `TELAPSE`,
 1 AS `TEXPTIME`,
 1 AS `TITLE`,
 1 AS `TMID`,
 1 AS `transientBucketId`,
 1 AS `WAVELMAX`,
 1 AS `WAVELMIN`,
 1 AS `XMAX`,
 1 AS `XMIN`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_tns_photometry_discoveries`
--

DROP TABLE IF EXISTS `view_tns_photometry_discoveries`;
/*!50001 DROP VIEW IF EXISTS `view_tns_photometry_discoveries`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_tns_photometry_discoveries` AS SELECT 
 1 AS `raDeg`,
 1 AS `decDeg`,
 1 AS `objectName`,
 1 AS `survey`,
 1 AS `suggestedType`,
 1 AS `hostRedshift`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_transientbucketmaster`
--

DROP TABLE IF EXISTS `view_transientbucketmaster`;
/*!50001 DROP VIEW IF EXISTS `view_transientbucketmaster`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_transientbucketmaster` AS SELECT 
 1 AS `primaryKeyId`,
 1 AS `transientBucketId`,
 1 AS `masterIDFlag`,
 1 AS `name`,
 1 AS `survey`,
 1 AS `raDeg`,
 1 AS `decDeg`,
 1 AS `raDegErr`,
 1 AS `decDegErr`,
 1 AS `observationDate`,
 1 AS `observationMJD`,
 1 AS `magnitude`,
 1 AS `magnitudeError`,
 1 AS `filter`,
 1 AS `transientRedshift`,
 1 AS `transientRedshiftNotes`,
 1 AS `spectralType`,
 1 AS `discoveryPhase`,
 1 AS `dateCreated`,
 1 AS `dateLastModified`,
 1 AS `surveyObjectUrl`,
 1 AS `transientTypePrediction`,
 1 AS `transientTypePredicationSource`,
 1 AS `hostRedshift`,
 1 AS `hostRedshiftType`,
 1 AS `referenceImageUrl`,
 1 AS `targetImageUrl`,
 1 AS `subtractedImageUrl`,
 1 AS `tripletImageUrl`,
 1 AS `htm20ID`,
 1 AS `htm16ID`,
 1 AS `cx`,
 1 AS `cy`,
 1 AS `cz`,
 1 AS `telescope`,
 1 AS `instrument`,
 1 AS `reducer`,
 1 AS `lastNonDetectionDate`,
 1 AS `lastNonDetectionMJD`,
 1 AS `dateLastRead`,
 1 AS `finderImageUrl`,
 1 AS `lightcurveURL`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_wiserep_object_summaries`
--

DROP TABLE IF EXISTS `view_wiserep_object_summaries`;
/*!50001 DROP VIEW IF EXISTS `view_wiserep_object_summaries`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_wiserep_object_summaries` AS SELECT 
 1 AS `transientBucketId`,
 1 AS `name`,
 1 AS `survey`,
 1 AS `raDeg`,
 1 AS `decDeg`,
 1 AS `spectralType`,
 1 AS `transientRedshift`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `webapp_users`
--

DROP TABLE IF EXISTS `webapp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webapp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(100) NOT NULL,
  `secondname` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL DEFAULT '$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1',
  `permissions` varchar(45) NOT NULL DEFAULT 'edit_users',
  PRIMARY KEY (`id`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `first_second` (`firstname`,`secondname`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_april2016_april2017_stats`
--

DROP TABLE IF EXISTS `zlegacy_april2016_april2017_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_april2016_april2017_stats` (
  `transientBucketId` bigint(20) unsigned NOT NULL,
  `atelNumber` int(11) NOT NULL,
  `classificationDate` datetime DEFAULT NULL,
  `discSurvey` varchar(45) DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `redshift` double DEFAULT NULL,
  `classification` varchar(45) DEFAULT NULL,
  `discName` varchar(100) DEFAULT NULL,
  `tnsName` varchar(100) DEFAULT NULL,
  `atelRa` varchar(45) DEFAULT NULL,
  `atelDec` varchar(45) DEFAULT NULL,
  `classificationPhaseRange` varchar(45) DEFAULT NULL,
  `classificationPhaseDays` int(11) DEFAULT NULL,
  `classificationType` varchar(45) DEFAULT NULL,
  `classificationSubtype` varchar(45) DEFAULT NULL,
  `classificationPhaseBin` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`transientBucketId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_cbats`
--

DROP TABLE IF EXISTS `zlegacy_cbats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_cbats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `ra` varchar(30) DEFAULT NULL,
  `decl` varchar(30) DEFAULT NULL,
  `hostGalaxy` varchar(60) DEFAULT NULL,
  `dateAndPosition` varchar(60) DEFAULT NULL,
  `offsetWE` varchar(20) DEFAULT NULL,
  `offsetNS` varchar(20) DEFAULT NULL,
  `mag` float DEFAULT NULL,
  `discoveryRef` varchar(40) DEFAULT NULL,
  `positionRef` varchar(40) DEFAULT NULL,
  `snType` varchar(20) DEFAULT NULL,
  `name` varchar(20) NOT NULL,
  `discoverers` varchar(300) DEFAULT NULL,
  `raDeg` double NOT NULL,
  `decDeg` double NOT NULL,
  `htm20ID` bigint(20) unsigned DEFAULT NULL,
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `cy` double DEFAULT NULL,
  `cz` double DEFAULT NULL,
  `cbatType` char(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`),
  KEY `idx_htm20ID` (`htm20ID`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_cbat_type` (`cbatType`),
  KEY `name` (`snType`),
  KEY `ra_dec` (`raDeg`,`decDeg`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_asassn_discoveries`
--

DROP TABLE IF EXISTS `zlegacy_fs_asassn_discoveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_asassn_discoveries` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dec_deg` double DEFAULT NULL,
  `decl` varchar(100) DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `discMag` varchar(100) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `ra` varchar(100) DEFAULT NULL,
  `ra_deg` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `htm16ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `candidateid` (`candidateID`),
  KEY `ra_dec` (`dec_deg`,`ra_deg`),
  KEY `htm16` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_brightsnlist_discoveries`
--

DROP TABLE IF EXISTS `zlegacy_fs_brightsnlist_discoveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_brightsnlist_discoveries` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `dateCreated` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `discoveryMag` double DEFAULT NULL,
  `discoveryMjd` double DEFAULT NULL,
  `imageUrl` varchar(300) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `objectUrl` varchar(300) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `survey` varchar(50) DEFAULT 'bright sn list',
  `type` varchar(45) DEFAULT 'SN',
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`),
  KEY `i_htm10ID` (`htm10ID`),
  KEY `i_htm13ID` (`htm13ID`),
  KEY `i_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_lsq`
--

DROP TABLE IF EXISTS `zlegacy_fs_lsq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_lsq` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(20) NOT NULL,
  `ra` varchar(20) DEFAULT NULL,
  `decl` varchar(20) DEFAULT NULL,
  `mag` float DEFAULT NULL,
  `magErr` float DEFAULT NULL COMMENT 'Mag error only available in the recurrence data',
  `observationJD` double DEFAULT NULL COMMENT 'Observation date in JD',
  `discDate` date DEFAULT NULL,
  `discMag` float DEFAULT NULL,
  `suggestedType` varchar(50) DEFAULT NULL,
  `catalogType` varchar(50) DEFAULT NULL,
  `hostZ` float DEFAULT NULL,
  `lastNonDetection` date DEFAULT NULL,
  `tripletImageURL` varchar(512) DEFAULT NULL,
  `obsDate` date DEFAULT NULL,
  `historyURL` varchar(512) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `numPhoto` int(11) DEFAULT NULL,
  `numSpectra` int(11) DEFAULT NULL,
  `specType` varchar(50) DEFAULT NULL,
  `discPhase` int(11) DEFAULT NULL,
  `minObsDate` date DEFAULT NULL,
  `fieldID` int(11) DEFAULT NULL,
  `num3sigpix7` int(11) DEFAULT NULL,
  `num2sigpix7` int(11) DEFAULT NULL,
  `a` float DEFAULT NULL,
  `b` float DEFAULT NULL,
  `symmetry` float DEFAULT NULL,
  `fwhm` float DEFAULT NULL,
  `chipName` varchar(20) DEFAULT NULL,
  `summaryRow` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Summary row flag. 1 = summary row, 0 = recurrence. There should always be one summary row and at least one recurrence.',
  `ingested` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Transient Bucket ingest flag.  Has this data been ingested yet?',
  `ra_deg` double NOT NULL,
  `dec_deg` double NOT NULL,
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `transientZ` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uq_candidateID_observationJD` (`candidateID`,`observationJD`),
  UNIQUE KEY `idx_uq_candidateID_discDate` (`candidateID`,`discDate`),
  KEY `idx_candidateID` (`candidateID`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_lsq_current_summaries`
--

DROP TABLE IF EXISTS `zlegacy_fs_lsq_current_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_lsq_current_summaries` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(20) NOT NULL,
  `ra` varchar(20) DEFAULT NULL,
  `decl` varchar(20) DEFAULT NULL,
  `mag` float DEFAULT NULL,
  `magErr` float DEFAULT NULL COMMENT 'Mag error only available in the recurrence data',
  `observationJD` double DEFAULT NULL COMMENT 'Observation date in JD',
  `discDate` date DEFAULT NULL,
  `discMag` float DEFAULT NULL,
  `suggestedType` varchar(50) DEFAULT NULL,
  `catalogType` varchar(50) DEFAULT NULL,
  `hostZ` float DEFAULT NULL,
  `lastNonDetection` date DEFAULT NULL,
  `tripletImageURL` varchar(512) DEFAULT NULL,
  `obsDate` date DEFAULT NULL,
  `historyURL` varchar(512) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `numPhoto` int(11) DEFAULT NULL,
  `numSpectra` int(11) DEFAULT NULL,
  `specType` varchar(50) DEFAULT NULL,
  `discPhase` int(11) DEFAULT NULL,
  `minObsDate` date DEFAULT NULL,
  `fieldID` int(11) DEFAULT NULL,
  `num3sigpix7` int(11) DEFAULT NULL,
  `num2sigpix7` int(11) DEFAULT NULL,
  `a` float DEFAULT NULL,
  `b` float DEFAULT NULL,
  `symmetry` float DEFAULT NULL,
  `fwhm` float DEFAULT NULL,
  `chipName` varchar(20) DEFAULT NULL,
  `summaryRow` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Summary row flag. 1 = summary row, 0 = recurrence. There should always be one summary row and at least one recurrence.',
  `ingested` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Transient Bucket ingest flag.  Has this data been ingested yet?',
  `ra_deg` double NOT NULL,
  `dec_deg` double NOT NULL,
  `htm16ID` bigint(20) unsigned DEFAULT NULL,
  `transientZ` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uq_candidateID_observationJD` (`candidateID`,`observationJD`),
  UNIQUE KEY `idx_uq_candidateID_discDate` (`candidateID`,`discDate`),
  KEY `idx_candidateID` (`candidateID`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_lsq_discoveries`
--

DROP TABLE IF EXISTS `zlegacy_fs_lsq_discoveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_lsq_discoveries` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `candidateID` varchar(20) DEFAULT NULL,
  `catalogType` varchar(100) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `dec_deg` double DEFAULT NULL,
  `decl` varchar(100) DEFAULT NULL,
  `discDate` datetime DEFAULT NULL,
  `discMag` double DEFAULT NULL,
  `discPhase` varchar(100) DEFAULT NULL,
  `historyURL` varchar(1000) DEFAULT NULL,
  `hostZ` double DEFAULT NULL,
  `isFollowed` tinyint(4) DEFAULT NULL,
  `lastNonDetection` datetime DEFAULT NULL,
  `mag` varchar(100) DEFAULT NULL,
  `minObsDate` datetime DEFAULT NULL,
  `numPhoto` tinyint(4) DEFAULT NULL,
  `numSpectra` tinyint(4) DEFAULT NULL,
  `obsDate` datetime DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `ra` varchar(100) DEFAULT NULL,
  `ra_deg` double DEFAULT NULL,
  `specType` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `subtractedLightcurveURL` varchar(300) DEFAULT NULL,
  `suggestedType` varchar(100) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `tripletImageURL` varchar(1000) DEFAULT NULL,
  `transientBucketId` int(11) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT NULL,
  `survey` varchar(45) NOT NULL DEFAULT 'LSQ',
  `transientHistoryLogAdded` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `candidateid` (`candidateID`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_lsq_recalibrated_data`
--

DROP TABLE IF EXISTS `zlegacy_fs_lsq_recalibrated_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_lsq_recalibrated_data` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `Detector` varchar(200) DEFAULT NULL,
  `Filename` varchar(200) DEFAULT NULL,
  `MJD` double DEFAULT NULL,
  `PhotSource` varchar(100) DEFAULT NULL,
  `ccd` varchar(100) DEFAULT NULL,
  `counts` double DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `dateLastRead` datetime DEFAULT NULL,
  `dcounts` double DEFAULT NULL,
  `dzp` double DEFAULT NULL,
  `filter` varchar(100) DEFAULT NULL,
  `magsys` varchar(100) DEFAULT NULL,
  `mjddisc` double DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `nbad` tinyint(4) DEFAULT NULL,
  `zp` double DEFAULT NULL,
  `csvUpdateDate` datetime NOT NULL,
  `magnitude` double DEFAULT NULL,
  `magnitudeError` double DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `dec_deg` double DEFAULT NULL,
  `ra_deg` double DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `Source` varchar(100) DEFAULT NULL,
  `signaltonoise` double DEFAULT NULL,
  `dryxDiscMJD` double DEFAULT NULL,
  `dryxLastNonDetectionMJD` double DEFAULT NULL,
  `PSFDIR` varchar(100) DEFAULT NULL,
  `Telescope` varchar(100) DEFAULT NULL,
  `chi2` varchar(100) DEFAULT NULL,
  `iscoadd` varchar(100) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name_mjd` (`name`,`MJD`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_fs_tocp`
--

DROP TABLE IF EXISTS `zlegacy_fs_tocp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_fs_tocp` (
  `primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
  `dateCreated` datetime DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `discoveryMjd` double DEFAULT NULL,
  `filter` varchar(100) DEFAULT NULL,
  `magnitude` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `surveyObjectUrl` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `survey` varchar(45) DEFAULT 'tocp',
  `ingested` tinyint(4) DEFAULT NULL,
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `htm13ID` int(11) DEFAULT NULL,
  `htm10ID` int(11) DEFAULT NULL,
  `transientBucketId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `name` (`name`),
  KEY `htm16` (`htm16ID`),
  KEY `ra_dec` (`decDeg`,`raDeg`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`),
  KEY `idx_htm10ID` (`htm13ID`),
  KEY `idx_htm13ID` (`htm13ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_candidates`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_candidates` (
  `cand_id` int(11) unsigned NOT NULL,
  `observer` varchar(20) DEFAULT NULL,
  `obs_date` int(11) DEFAULT NULL,
  `field_id` varchar(10) DEFAULT NULL,
  `user_name` varchar(20) DEFAULT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `cand_index` int(11) DEFAULT NULL,
  `sub_index` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `type` varchar(20) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `jd` double DEFAULT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `ra` double DEFAULT NULL,
  `dec` double DEFAULT NULL,
  `mag` double DEFAULT NULL,
  `mag_err` double DEFAULT NULL,
  `num_3sig_pix7` int(11) DEFAULT NULL,
  `num_2sig_pix7` int(11) DEFAULT NULL,
  `a` double DEFAULT NULL,
  `b` double DEFAULT NULL,
  `symmetry` double DEFAULT NULL,
  `fwhm` double DEFAULT NULL,
  `fake_index` int(11) DEFAULT NULL,
  `chip_name` varchar(10) DEFAULT NULL,
  `reffilename` varchar(50) DEFAULT NULL,
  `newfilename` varchar(50) DEFAULT NULL,
  `subfilename` varchar(50) DEFAULT NULL,
  `gifname` varchar(50) DEFAULT NULL,
  `nn_dist_ref` double DEFAULT NULL,
  `mag_ref` double DEFAULT NULL,
  `fwhm_ref` double DEFAULT NULL,
  `seeing_ref` double DEFAULT NULL,
  `band` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`cand_id`),
  KEY `cand_name` (`cand_name`),
  KEY `cand_index` (`cand_index`),
  KEY `ra_dec` (`ra`,`dec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_comments`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_comments` (
  `comment_id` int(11) unsigned NOT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `user_name` varchar(20) DEFAULT NULL,
  `comment` varchar(200) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment_added` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_id`),
  KEY `cand_name` (`cand_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_followup_status`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_followup_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_followup_status` (
  `cand_name` varchar(20) DEFAULT NULL,
  `snf` varchar(200) DEFAULT NULL,
  `snf_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `carnegie` varchar(200) DEFAULT NULL,
  `carnegie_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `pessto` varchar(200) DEFAULT NULL,
  `pessto_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `oxford` varchar(200) DEFAULT NULL,
  `oxford_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `berkeley` varchar(200) DEFAULT NULL,
  `berkeley_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lcogt` varchar(200) DEFAULT NULL,
  `lcogt_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `other` varchar(200) DEFAULT NULL,
  `other_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_marshall_comments`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_marshall_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_marshall_comments` (
  `id` int(11) unsigned NOT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `comment` varchar(200) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cand_name` (`cand_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_marshall_lc_followup`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_marshall_lc_followup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_marshall_lc_followup` (
  `id` int(11) unsigned NOT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `survey` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cand_name` (`cand_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_ms_lightcurves`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_ms_lightcurves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_ms_lightcurves` (
  `obs_id` int(11) unsigned NOT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `filter` varchar(10) DEFAULT NULL,
  `mjd` double DEFAULT NULL,
  `counts` double DEFAULT NULL,
  `dcounts` double DEFAULT NULL,
  `zp` double DEFAULT NULL,
  `nbad` int(11) DEFAULT NULL,
  `ccd` varchar(10) DEFAULT NULL,
  `dzp` varchar(20) DEFAULT NULL,
  `magsys` varchar(10) DEFAULT NULL,
  `detector` varchar(20) DEFAULT NULL,
  `source` varchar(20) DEFAULT NULL,
  `raDeg` double DEFAULT NULL,
  `decDeg` double DEFAULT NULL,
  `signaltonoise` double DEFAULT NULL,
  `magnitude` double DEFAULT NULL,
  `magnitudeError` double DEFAULT NULL,
  `dryxLastNonDetectionMJD` double DEFAULT NULL,
  `dryxDiscMJD` double DEFAULT NULL,
  `ingested` tinyint(4) DEFAULT '0',
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `magnitudeLimit` double DEFAULT NULL,
  PRIMARY KEY (`obs_id`),
  UNIQUE KEY `obs_id` (`obs_id`),
  UNIQUE KEY `name_mjd` (`cand_name`,`mjd`),
  KEY `name_index` (`cand_name`),
  KEY `ingested` (`ingested`),
  KEY `ra_dec` (`raDeg`,`decDeg`),
  KEY `signal` (`signaltonoise`),
  KEY `mjd` (`mjd`),
  KEY `summary` (`summaryRow`),
  KEY `idx_htm16ID` (`htm16ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zlegacy_lssndb_summary`
--

DROP TABLE IF EXISTS `zlegacy_lssndb_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zlegacy_lssndb_summary` (
  `id` int(11) DEFAULT NULL,
  `cand_name` varchar(20) DEFAULT NULL,
  `disc_date` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `catalog_type` varchar(40) DEFAULT NULL,
  `simbad_type` varchar(40) DEFAULT NULL,
  `ned_type` varchar(40) DEFAULT NULL,
  `sloan_type` varchar(40) DEFAULT NULL,
  `num_photo` int(11) DEFAULT NULL,
  `num_spectra` int(11) DEFAULT NULL,
  `followup_lead` varchar(20) DEFAULT NULL,
  `avg_ra` double DEFAULT NULL,
  `avg_dec` double DEFAULT NULL,
  `screening_date` datetime DEFAULT NULL,
  `followup_approved` int(11) DEFAULT NULL,
  `spec_type` varchar(20) DEFAULT NULL,
  `disc_mag` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `disc_phase` int(11) DEFAULT NULL,
  `variable_followup_approved` int(11) DEFAULT NULL,
  `catalog_z` double DEFAULT NULL,
  `latest_nondiscovery_subtraction` int(11) DEFAULT NULL,
  `spectrum_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `spectrum_phase` int(11) DEFAULT NULL,
  `spectrum_source` varchar(40) DEFAULT NULL,
  `min_obs_date` int(11) DEFAULT NULL,
  `last_obs_date` int(11) DEFAULT NULL,
  `last_mag` double DEFAULT NULL,
  `earliest_detection` date DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `dateLastModified` datetime DEFAULT NULL,
  `survey` varchar(45) NOT NULL DEFAULT 'LSQ',
  `transientHistoryLogAdded` tinyint(4) DEFAULT '0',
  `subtractedLightcurveUrl` varchar(200) DEFAULT NULL,
  `tripletImageURL` varchar(200) DEFAULT NULL,
  `historyURL` varchar(200) DEFAULT NULL,
  `observationMJD` double DEFAULT NULL,
  `ingested` tinyint(4) NOT NULL DEFAULT '0',
  `summaryRow` tinyint(4) DEFAULT NULL,
  `htm16ID` bigint(20) DEFAULT NULL,
  `cz` double DEFAULT NULL,
  `cx` double DEFAULT NULL,
  `htm20ID` bigint(20) DEFAULT NULL,
  `cy` double DEFAULT NULL,
  `qubId` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`qubId`),
  UNIQUE KEY `qubId_UNIQUE` (`qubId`),
  UNIQUE KEY `cand_name_type` (`cand_name`,`type`),
  KEY `htm20` (`htm20ID`),
  KEY `htm16` (`htm16ID`),
  KEY `ingested` (`ingested`),
  KEY `summaryRow` (`summaryRow`),
  KEY `cand_name` (`cand_name`),
  KEY `ra_dec` (`avg_ra`,`avg_dec`),
  KEY `idx_htm20ID` (`htm20ID`),
  KEY `idx_htm16ID` (`htm16ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'marshall'
--
/*!50003 DROP FUNCTION IF EXISTS `does_column_exist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `does_column_exist`(table_name_IN VARCHAR(100), column_name_IN VARCHAR(100)) RETURNS int(11)
RETURN (
    SELECT COUNT(COLUMN_NAME) 
    FROM INFORMATION_SCHEMA.columns 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = table_name_IN 
    AND COLUMN_NAME = column_name_IN
) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_table_column` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `create_table_column`(
    IN table_name_IN VARCHAR(100)
    , IN column_name_IN VARCHAR(100)
    , IN column_definition_IN VARCHAR(100)
)
BEGIN

    SET @columnExists = does_column_exist(table_name_IN, column_name_IN);
    IF (@columnExists = 0) THEN

        SET @ddl = CONCAT('ALTER TABLE ', table_name_IN);
        SET @ddl = CONCAT(@ddl, ' ', 'ADD COLUMN') ;
        SET @ddl = CONCAT(@ddl, ' ', column_name_IN);
        SET @ddl = CONCAT(@ddl, ' ', column_definition_IN);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_new_marshall_objects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `insert_new_marshall_objects`()
BEGIN
INSERT INTO pesstoObjects (
		pesstoObjectsId,
		transientBucketId,
		classifiedFlag,
		marshallWorkflowLocation,
		alertWorkflowLocation,
		publicStatus,
		dateAdded,
		dateLastModified)  
	SELECT 
		distinct transientBucketId, transientBucketId, 0, "Inbox", 'Pending Classification', 1, now(), now()
	FROM
		transientBucket
	WHERE
		transientBucketId NOT IN (SELECT 
				transientBucketId
			FROM
				pesstoObjects) AND transientBucketId > 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_new_transients_into_transientbucketsummaries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `insert_new_transients_into_transientbucketsummaries`()
BEGIN

INSERT ignore INTO transientBucketSummaries (transientBucketId)
select distinct transientBucketId from transientBucket where replacedByRowId = 0 and transientBucketId != 0 and masterIDFlag = 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_object_comment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `insert_object_comment`(transientBucketId_IN BIGINT(11), author_in VARCHAR(100), comment_in VARCHAR(500))
BEGIN
	INSERT INTO pesstoObjectsComments (pesstoObjectsId,
                                                    dateCreated,
                                                    dateLastModified,
                                                    commentAuthor,
                                                    comment
                                                  )
                VALUES (transientBucketId_IN,NOW(),NOW(),author_in,comment_in);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `resurrect_objects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `resurrect_objects`()
BEGIN




insert into transients_history_logs (transientBucketId, log) (SELECT 
    s.transientBucketId, "moved to 'inbox' by marshall's object resurrector"
FROM
    transientBucketSummaries s,
    pesstoObjects p
WHERE
    currentMagnitudeEstimate < 19.5
        AND currentMagnitudeEstimate > 3.0
        AND p.resurrectionCount < 5
        AND sherlockClassification not in ('VS','BS','CV','AGN')
        AND (p.lastTimeReviewed < s.currentMagnitudeEstimateUpdated)
        AND (currentMagnitudeEstimate < p.lastReviewedMag)
        AND currentMagnitudeDate > NOW() - INTERVAL 10 DAY
        AND (p.marshallWorkflowLocation = 'archive'
		OR p.marshallWorkflowLocation = 'followup complete')
        AND s.transientBucketId = p.transientBucketId);
        

update pesstoObjects set snoozed = 2, marshallWorkflowLocation = "inbox", resurrectionCount = resurrectionCount+1  where transientBucketId in (select * from (SELECT 
    s.transientBucketId
FROM
    transientBucketSummaries s,
    pesstoObjects p
WHERE
    currentMagnitudeEstimate < 19.5
        AND currentMagnitudeEstimate > 3.0
        AND p.resurrectionCount < 5
        AND sherlockClassification not in ('VS','BS','CV','AGN')
        AND (p.lastTimeReviewed < s.currentMagnitudeEstimateUpdated)
        AND (currentMagnitudeEstimate < p.lastReviewedMag)
        AND currentMagnitudeDate > NOW() - INTERVAL 10 DAY
        AND (p.marshallWorkflowLocation = 'archive'
        OR p.marshallWorkflowLocation = 'followup complete')
        AND s.transientBucketId = p.transientBucketId) as a);
        

UPDATE pesstoObjects 
SET 
    classifiedFlag = 1
WHERE
    transientBucketId IN (SELECT 
            *
        FROM
            (SELECT DISTINCT
                transientBucketId
            FROM
                transientBucket
            WHERE
                (spectralType IS NOT NULL
                    AND transientBucketId NOT IN (SELECT 
                        transientBucketId
                    FROM
                        pesstoObjects
                    WHERE
                        classifiedFlag = 1))) AS a);
                        

insert into transients_history_logs  (transientBucketId, log) SELECT 
                pesstoObjectsId, CONCAT("moved from ",marshallWorkflowLocation, " to 'review for followup' by marshall code")
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1;


UPDATE pesstoObjects 
SET 
    marshallWorkflowLocation = 'review for followup',
    snoozed = 0
WHERE
    pesstoObjectsId IN (SELECT 
            *
        FROM
            (SELECT 
                pesstoObjectsId
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1) AS alias);
        

update pesstoObjects set lastTimeReviewed = NOW();
        

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sync_marshall_feeder_survey_transientBucketId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `sync_marshall_feeder_survey_transientBucketId`(ARG_fs_table varchar(45))
BEGIN
	set @fs_table = convert(ARG_fs_table using utf8) collate utf8_general_ci;
    
	
	set @object = (select fs_table_column from marshall_fs_column_map where transientBucket_column = "name" and fs_table_name = @fs_table);  
    
    set @survey = (select fs_survey_name from marshall_fs_column_map where fs_table_name = @fs_table limit 1);  
    
    set @myquery = concat('UPDATE ',@fs_table,' a
INNER JOIN 
(
    select distinct name, transientBucketId from transientBucket order by name desc
)AS b
ON a.',@object,' = b.name
set a.transientBucketId = b.transientBucketId
where a.transientBucketId IS NULL;');
	PREPARE stmt FROM @myquery;
	EXECUTE stmt;
    
    
    if @survey is not null then 
		set @tbcolumns = (select CONCAT_WS(',',GROUP_CONCAT(transientBucket_column  order  by primaryId),'survey') from marshall_fs_column_map where fs_table_name = @fs_table);
		set @fscolumns = (select GROUP_CONCAT(fs_table_column  order  by primaryId) from marshall_fs_column_map where fs_table_name = ARG_fs_table);
		set @myquery = concat('insert ignore into transientBucket (transientBucketId,',@tbcolumns,') select transientBucketId,',@fscolumns,',"',@survey,'" from ',@fs_table,' where ingested = 0 and transientBucketId is not null;' );
	else
		set @tbcolumns = (select GROUP_CONCAT(transientBucket_column  order  by primaryId) from marshall_fs_column_map where fs_table_name = @fs_table);
		set @fscolumns = (select GROUP_CONCAT(fs_table_column  order  by primaryId) from marshall_fs_column_map where fs_table_name = @fs_table);
		set @myquery = concat('insert ignore into transientBucket (transientBucketId,',@tbcolumns,') select transientBucketId,',@fscolumns,' from ',@fs_table,' where ingested = 0 and transientBucketId is not null;' );
	end if;
    PREPARE stmt FROM @myquery;
    EXECUTE stmt;
    
    
    set @myquery = concat('update ',ARG_fs_table,' set ingested = 1 where transientBucketId is not null and ingested = 0');
	PREPARE stmt FROM @myquery;
    EXECUTE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_fs_atlas_forced_phot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_fs_atlas_forced_phot`()
BEGIN
	update fs_atlas_forced_phot set apfit = (mag-zp+2.5*log10(peakfit * major * minor / texp))  where peakfit is not null and major is not null and minor is not null and texp is not null and limiting_mag = 0 and apfit is null;
	update fs_atlas_forced_phot set apfit = (mag-zp+2.5*log10(dpeak * major * minor * snr / texp)) where dpeak is not null and snr is not null and major is not null and minor is not null and texp is not null and limiting_mag = 1 and apfit is null;
	update fs_atlas_forced_phot set marshall_limiting_mag = 1 where snr < 5.0 and dpeak is not null and marshall_limiting_mag is null;
	update fs_atlas_forced_phot set marshall_limiting_mag =  0 where snr >= 5.0 and dpeak is not null and marshall_limiting_mag is null;
	update fs_atlas_forced_phot set marshall_mag =  mag where snr >= 5.0 and dpeak is not null and marshall_mag is null;
	update fs_atlas_forced_phot set marshall_mag_error = dm where snr >= 5.0 and dpeak is not null and marshall_mag_error is null;
	update fs_atlas_forced_phot set marshall_mag = cast(mag-2.5*log10(5/snr) as decimal(10,2)) where dpeak is not null and limiting_mag = 1 and mag is not null and marshall_mag is null;
	update fs_atlas_forced_phot set marshall_mag = cast(mag-2.5*log10(dpeak*5/peakfit) as decimal(10,2)) where dpeak is not null and limiting_mag = 0 and mag is not null and snr < 5 and marshall_mag is null;
	update fs_atlas_forced_phot set fnu =(pow(10,-(48.6 + zp)/2.5) * pow(10,-apfit/2.5) * (peakfit*major*minor/texp)) where apfit is not null and zp is not null and peakfit is not null and fnu is null;
	update fs_atlas_forced_phot set fnu_error = (pow(10,-(48.6 + zp)/2.5) * pow(10,-apfit/2.5) * (dpeak*major*minor/texp)) where apfit is not null and zp is not null and dpeak is not null and fnu_error is null;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_fs_ztf` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_fs_ztf`()
BEGIN
	update fs_ztf set filt = 'g' where fid = 1 and filt is null;
	update fs_ztf set filt = 'r' where fid = 2 and filt is null;
	update fs_ztf set filt = 'i' where fid = 3 and filt is null;
    update fs_ztf set primaryId = candidateId where primaryId is null;
	update fs_ztf set  surveyUrl = CONCAT("http://lasair.roe.ac.uk/object/",objectId) where surveyUrl is null;
	update fs_ztf set tripletImageUrl = concat("http://lasair.roe.ac.uk/lasair/static/ztf/stamps/jpg/",SUBSTRING(candidateId, 1, 3),"/candid",candidateId,".jpg") where tripletImageUrl is null and candidateId is not null;


update fs_ztf a, (SELECT 
    objectId, raDeg, decDeg
FROM
    fs_ztf
WHERE
    limitingMag = 0
        AND objectId IN (SELECT 
            *
        FROM
            (SELECT DISTINCT
                objectId
            FROM
                fs_ztf
            WHERE
                limitingMag = 1 AND raDeg IS NULL) AS z) group by objectId) b set a.raDeg=b.raDeg,a.decDeg=b.decDeg where a.objectId=b.objectId and a.raDeg is null;


delete from fs_ztf where raDeg is null and limitingMag = 0;


update fs_ztf set ingested = 1 where (isdiffpos = "f" or  isdiffpos = "0") and ingested  = 0;


delete from fs_ztf where mjd < (TO_SECONDS(UTC_TIMESTAMP())/(3600*24)-678941-42) and transientBucketId is not null and ingested = 1;


delete from fs_ztf where raDeg is null;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_inbox_auto_archiver` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_inbox_auto_archiver`()
BEGIN
	
UPDATE transientBucketSummaries t,
        pesstoObjects p 
    SET 
        marshallWorkflowLocation = 'archive'
    WHERE
        t.mastername LIKE 'ZTF%%'
            AND (t.currentMagnitude > 20.0
            OR ABS(t.gLat) < 10)
            AND p.transientBucketId = t.transientBucketId
            AND marshallWorkflowLocation = "inbox" ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_sherlock_xmatch_counts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_sherlock_xmatch_counts`()
BEGIN

UPDATE tcs_stats_catalogues t 
LEFT JOIN
(SELECT 
    catalogue_table_id, count(*) as 'all_transient_associations'
FROM
    (SELECT DISTINCT
        c.transient_object_id, c.catalogue_table_id
    FROM
        sherlock_crossmatches c, transientBucketSummaries s
    WHERE
        s.transientBucketId = c.transient_object_id) AS alais group by catalogue_table_id) o 
ON t.table_id = o.catalogue_table_id
set t.all_transient_associations=o.all_transient_associations;

update tcs_stats_catalogues set all_transient_associations = 0 where all_transient_associations is null;


UPDATE tcs_stats_catalogues t 
LEFT JOIN
(SELECT 
    catalogue_table_id, count(*) as 'top_ranked_transient_associations'
FROM
    (SELECT DISTINCT
        c.transient_object_id, c.catalogue_table_id
    FROM
        sherlock_crossmatches c, transientBucketSummaries s
    WHERE
        s.transientBucketId = c.transient_object_id and c.rank=1) AS alais group by catalogue_table_id) o 
ON t.table_id = o.catalogue_table_id
set t.top_ranked_transient_associations=o.top_ranked_transient_associations;

update tcs_stats_catalogues set top_ranked_transient_associations = 0 where top_ranked_transient_associations is null;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_single_transientbucket_summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_single_transientbucket_summary`(
	IN thisID BIGINT(20)
)
BEGIN



UPDATE pesstoObjects 
SET 
    classifiedFlag = 1
WHERE
    transientBucketId IN (SELECT 
            *
        FROM
            (SELECT DISTINCT
                transientBucketId
            FROM
                transientBucket
            WHERE
                (spectralType IS NOT NULL
                    AND transientBucketId = thisID)) AS a);
                        
insert into transients_history_logs  (transientBucketId, log) SELECT 
                pesstoObjectsId, CONCAT("moved from ",marshallWorkflowLocation, " to 'review for followup' by marshall code")
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1;

UPDATE pesstoObjects 
SET 
    marshallWorkflowLocation = 'review for followup',
    snoozed = 0
WHERE
    pesstoObjectsId IN (SELECT 
            *
        FROM
            (SELECT 
                pesstoObjectsId
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1 and transientBucketId = thisID) AS alias);
                    

INSERT INTO pesstoObjects (
		pesstoObjectsId,
		transientBucketId,
		classifiedFlag,
		marshallWorkflowLocation,
		alertWorkflowLocation,
		publicStatus,
		dateAdded,
		dateLastModified)  
	SELECT 
		transientBucketId, transientBucketId, 0, "Inbox", 'Pending Classification', 1, now(), now()
	FROM
		transientBucket
	WHERE
		transientBucketId NOT IN (SELECT 
				transientBucketId
			FROM
				pesstoObjects) AND transientBucketId > 0 and transientBucketId = thisID and masterIDFlag = 1;

INSERT ignore INTO transientBucketSummaries (transientBucketId)
select distinct transientBucketId from transientBucket where replacedByRowId = 0 and transientBucketId != 0 and transientBucketId = thisID;


UPDATE transientBucketSummaries 
SET 
    updateNeeded = 1
WHERE
    transientBucketId = thisId;	

UPDATE transientBucketSummaries s,
    transientBucket t 
SET 
    s.masterName = t.name,
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    masterIdFlag = 1 AND replacedByRowId = 0
        AND s.transientBucketId = t.transientBucketId
        AND t.transientBucketId=thisID;
	

UPDATE transientBucket t,
    transientBucketSummaries s 
SET 
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    t.surveyObjectUrl IS NOT NULL
        AND s.surveyObjectUrl IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND t.surveyObjectUrl NOT LIKE '%%astronomerstelegram%%'
        AND t.surveyObjectUrl NOT LIKE '%%roche%%'
        AND replacedByRowId = 0
        AND masterIDFlag = 1
        AND t.transientBucketId=thisID;

UPDATE transientBucket t,
    transientBucketSummaries s 
SET 
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    t.surveyObjectUrl IS NOT NULL
        AND s.surveyObjectUrl IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND t.surveyObjectUrl NOT LIKE '%%astronomerstelegram%%'
        AND t.surveyObjectUrl NOT LIKE '%%roche%%'
        AND replacedByRowId = 0
        AND t.transientBucketId=thisID;
	

UPDATE transientBucketSummaries s,
    transientBucket t 
SET 
    s.objectAddedToMarshallBy = t.reducer
WHERE
    t.reducer IS NOT NULL
        AND t.spectralType IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND replacedByRowId = 0
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;
	

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId,
            AVG(raDeg) AS raDeg,
            AVG(decDeg) AS decDeg,
            MIN(dateCreated) AS dateAdded,
            MIN(magnitude) AS peakMagnitude
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        replacedByRowId = 0 AND limitingMag = 0
            AND magnitude IS NOT NULL
            AND magnitude > 0.0
            AND magnitude < 25.0
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.raDeg = t.raDeg,
    s.decDeg = t.decDeg,
    s.dateAdded = t.dateAdded,
    s.peakMagnitude = t.peakMagnitude
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId,
            AVG(raDeg) AS raDeg,
            AVG(decDeg) AS decDeg
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        replacedByRowId = 0
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                raDeg IS NULL AND updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.raDeg = t.raDeg,
    s.decDeg = t.decDeg
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId, MIN(hostRedshift) AS host_redshift
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        replacedByRowId = 0
            AND hostRedshift IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.host_redshift = t.host_redshift
WHERE
    s.transientBucketId = t.transientBucketId
        AND updateNeeded = 1
        AND t.transientBucketId=thisID;

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS earliestDetection,
            a.magnitude AS earliestMagnitude,
            a.filter AS earliestMagnitudeFilter,
            a.survey AS earliestMagnitudeSurvey
    FROM
        transientBucket a
    JOIN (SELECT 
        MIN(observationDate) AS minval, transientBucketId
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        magnitude IS NOT NULL
            AND limitingMag = 0
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.minval
    WHERE
        a.limitingMag = 0
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
				transientBucketId=thisID and
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) t 
SET 
    s.earliestDetection = t.earliestDetection,
    s.earliestMagnitude = t.earliestMagnitude,
    s.earliestMagnitudeFilter = t.earliestMagnitudeFilter,
    s.earliestMagnitudeSurvey = t.earliestMagnitudeSurvey
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;


UPDATE transientBucketSummaries a,
    (SELECT 
        *
    FROM
        (SELECT 
        s.transientBucketId,
            MAX(t.lastNonDetectionDate) AS lastNonDetectionDate
    FROM
        transientBucket t, transientBucketSummaries s
    WHERE
		t.transientBucketId=thisID and
        t.lastNonDetectionDate < s.earliestDetection
            AND s.transientBucketId = t.transientBucketId
            AND replacedByRowId = 0
            AND t.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
				transientBucketId=thisID and
                updateNeeded = 1)
    GROUP BY s.transientBucketId) AS c
    ORDER BY transientBucketId) b 
SET 
    a.lastNonDetectionDate = b.lastNonDetectionDate
WHERE
    a.transientBucketId = b.transientBucketId
        AND a.updateNeeded = 1
        AND a.transientBucketId=thisID;
    

UPDATE transientBucketSummaries a,
    (SELECT 
        *
    FROM
        (SELECT 
        s.transientBucketId,
            MAX(t.observationDate) AS lastNonDetectionDate
    FROM
        transientBucket t, transientBucketSummaries s
    WHERE
		t.transientBucketId=thisID and
        t.observationDate < s.earliestDetection
            AND (t.observationDate > s.lastNonDetectionDate
            OR s.lastNonDetectionDate IS NULL)
            AND s.transientBucketId = t.transientBucketId
            AND replacedByRowId = 0
            AND t.limitingMag = 1
            AND t.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY s.transientBucketId) AS a
    ORDER BY transientBucketId) b 
SET 
    a.lastNonDetectionDate = b.lastNonDetectionDate
WHERE
    a.transientBucketId = b.transientBucketId
        AND a.updateNeeded = 1
        AND a.transientBucketId=thisID;


UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS currentMagnitudeDate,
            a.magnitude AS currentMagnitude,
            a.filter AS currentMagnitudeFilter,
            a.survey AS currentMagnitudeSurvey
    FROM
        transientBucket a
    JOIN (SELECT 
        *
    FROM
        (SELECT 
        MAX(observationDate) AS maxval, transientBucketId
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        magnitude IS NOT NULL
            AND limitingMag = 0
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS d
    ORDER BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.maxval
    WHERE
        a.limitingMag = 0
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) t 
SET 
    s.currentMagnitudeDate = t.currentMagnitudeDate,
    s.currentMagnitude = t.currentMagnitude,
    s.currentMagnitudeFilter = t.currentMagnitudeFilter,
    s.currentMagnitudeSurvey = t.currentMagnitudeSurvey
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;




UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS classificationDate,
            a.spectralType AS recentClassification,
            a.classificationWRTMax AS classificationWRTMax,
            a.classificationPhase AS classificationPhase,
            a.reducer AS classificationAddedBy,
            a.dateCreated AS classificationAddedDate,
            a.transientRedshift AS best_redshift
    FROM
        transientBucket a
    JOIN (SELECT 
        *
    FROM
        (SELECT 
        MAX(observationDate) AS maxval, transientBucketId
    FROM
        transientBucket
    WHERE
		transientBucketId=thisID and
        spectralType IS NOT NULL
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
				transientBucketId=thisID and
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.maxval
    WHERE
        spectralType IS NOT NULL
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS d
    ORDER BY transientBucketId) t 
SET 
    s.classificationDate = t.classificationDate,
    s.recentClassification = t.recentClassification,
    s.classificationWRTMax = t.classificationWRTMax,
    s.classificationPhase = t.classificationPhase,
    s.classificationAddedBy = t.classificationAddedBy,
    s.classificationAddedDate = t.classificationAddedDate,
    s.best_redshift = t.best_redshift
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1
        AND t.transientBucketId=thisID;

        

UPDATE transientBucketSummaries s,
    sherlock_crossmatches c 
SET 
    s.sherlockClassification = c.association_type,
    s.separationArcsec = c.separationArcsec,
    s.distanceMpc = IF(c.direct_distance,
        c.direct_distance,
        c.distance),
    s.best_redshift = IF(s.best_redshift IS NULL,
        c.z,
        s.best_redshift),
    s.host_redshift = IF(c.z AND c.z != s.host_redshift,
        c.z,
        s.host_redshift)
WHERE
	
    c.rank = 1
        AND s.transientBucketId = c.transient_object_id
        AND c.transient_object_id IN (SELECT 
            *
        FROM
            (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1) AS a)
        AND s.updateNeeded = 1
        AND s.transientBucketId=thisID;


UPDATE transientBucketSummaries 
SET 
    absolutePeakMagnitude = peakMagnitude - (5 * LOG10(distanceMpc * 1000000) - 5)
WHERE
    distanceMpc IS NOT NULL
        AND peakMagnitude IS NOT NULL
        AND peakMagnitude < 24.0
        AND absolutePeakMagnitude IS NULL
        AND transientBucketId=thisID;
    
    

UPDATE transientBucketSummaries s 
SET 
    updateNeeded = 2
WHERE
    updateNeeded = 1
    AND transientBucketId=thisID;


UPDATE transientBucketSummaries t,
        pesstoObjects p 
    SET 
        marshallWorkflowLocation = 'archive'
    WHERE
        t.mastername LIKE 'ZTF%%'
            AND (t.currentMagnitude > 20.0
            OR ABS(t.gLat) < 10)
            AND p.transientBucketId = t.transientBucketId
            AND marshallWorkflowLocation = "inbox"
            AND t.transientBucketId=thisID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_tns_tables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_tns_tables`()
BEGIN
update tns_spectra set ingested  = 1 where survey like "%PESSTO%";
update tns_spectra set TNSName = concat("AT",TNSId) where specType not like "%SN%" and TNSName is null;
update tns_spectra set TNSName = concat("SN",TNSId) where specType  like "%SN%" and TNSName is null;
update tns_spectra p, tns_sources s set p.raDeg = s.raDeg, p.decDeg = s.decDeg where p.TNSId=s.TNSId and s.raDeg is not null;
update tns_photometry p, tns_sources s set p.raDeg = s.raDeg, p.decDeg = s.decDeg where p.TNSId=s.TNSId and s.raDeg is not null;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transientbucketsummaries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_transientbucketsummaries`()
BEGIN


UPDATE pesstoObjects 
SET 
    classifiedFlag = 1
WHERE
    transientBucketId IN (SELECT 
            *
        FROM
            (SELECT DISTINCT
                transientBucketId
            FROM
                transientBucket
            WHERE
                (spectralType IS NOT NULL
                    AND transientBucketId NOT IN (SELECT 
                        transientBucketId
                    FROM
                        pesstoObjects
                    WHERE
                        classifiedFlag = 1))) AS a);
                        

insert into transients_history_logs  (transientBucketId, log) SELECT 
                pesstoObjectsId, CONCAT("moved from ",marshallWorkflowLocation, " to 'review for followup' by marshall code")
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1;


UPDATE pesstoObjects 
SET 
    marshallWorkflowLocation = 'review for followup',
    snoozed = 0
WHERE
    pesstoObjectsId IN (SELECT 
            *
        FROM
            (SELECT 
                pesstoObjectsId
            FROM
                pesstoObjects
            WHERE
                marshallWorkflowLocation in ('pending classification', 'inbox')
                    AND classifiedFlag = 1) AS alias);
                    

INSERT INTO pesstoObjects (
		pesstoObjectsId,
		transientBucketId,
		classifiedFlag,
		marshallWorkflowLocation,
		alertWorkflowLocation,
		publicStatus,
		dateAdded,
		dateLastModified)  
	SELECT 
		transientBucketId, transientBucketId, 0, "Inbox", 'Pending Classification', 1, now(), now()
	FROM
		transientBucket
	WHERE
		transientBucketId NOT IN (SELECT 
				transientBucketId
			FROM
				pesstoObjects) AND transientBucketId > 0 and masterIDFlag = 1;


INSERT ignore INTO transientBucketSummaries (transientBucketId)
select distinct transientBucketId from transientBucket where replacedByRowId = 0 and transientBucketId != 0 and masterIDFlag = 1 and dateLastModified > DATE_SUB(curdate(), INTERVAL 1 WEEK);


UPDATE transientBucketSummaries 
SET 
    updateNeeded = 1
WHERE
    transientBucketId IN (SELECT 
            *
        FROM
            (SELECT 
                a.transientBucketId
            FROM
                transientBucketSummaries a, (SELECT 
                transientBucketId, MAX(dateLastModified) AS dateLastModified
            FROM
                transientBucket
            WHERE
                dateLastModified > DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
            GROUP BY transientBucketId) b
            WHERE
                a.transientBucketId = b.transientBucketId
                    AND a.dateLastModified < b.dateLastModified
                    AND a.updateNeeded NOT IN (1 , 2)) c);	


UPDATE transientBucketSummaries s,
    transientBucket t 
SET 
    s.masterName = t.name,
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    masterIdFlag = 1 AND replacedByRowId = 0
        AND s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;
       

UPDATE transientBucket t,
    transientBucketSummaries s 
SET 
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    t.surveyObjectUrl IS NOT NULL
        AND s.surveyObjectUrl IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND t.surveyObjectUrl NOT LIKE '%%astronomerstelegram%%'
        AND t.surveyObjectUrl NOT LIKE '%%roche%%'
        AND replacedByRowId = 0
        AND masterIDFlag = 1;

UPDATE transientBucket t,
    transientBucketSummaries s 
SET 
    s.surveyObjectUrl = t.surveyObjectUrl
WHERE
    t.surveyObjectUrl IS NOT NULL
        AND s.surveyObjectUrl IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND t.surveyObjectUrl NOT LIKE '%%astronomerstelegram%%'
        AND t.surveyObjectUrl NOT LIKE '%%roche%%'
        AND replacedByRowId = 0;
      

UPDATE transientBucketSummaries s,
    transientBucket t 
SET 
    s.objectAddedToMarshallBy = t.reducer
WHERE
    t.reducer IS NOT NULL
        AND t.spectralType IS NULL
        AND t.transientBucketId = s.transientBucketId
        AND replacedByRowId = 0
        AND s.updateNeeded = 1;
      

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId,
            AVG(raDeg) AS raDeg,
            AVG(decDeg) AS decDeg,
            MIN(dateCreated) AS dateAdded,
            MIN(magnitude) AS peakMagnitude
    FROM
        transientBucket
    WHERE
        replacedByRowId = 0 AND limitingMag = 0
            AND magnitude IS NOT NULL
            AND magnitude > 0.0
            AND magnitude < 25.0
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.raDeg = t.raDeg,
    s.decDeg = t.decDeg,
    s.dateAdded = t.dateAdded,
    s.peakMagnitude = t.peakMagnitude
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;


UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId,
            AVG(raDeg) AS raDeg,
            AVG(decDeg) AS decDeg
    FROM
        transientBucket
    WHERE
        replacedByRowId = 0
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                raDeg IS NULL AND updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.raDeg = t.raDeg,
    s.decDeg = t.decDeg
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;

UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        transientBucketId, MIN(hostRedshift) AS host_redshift
    FROM
        transientBucket
    WHERE
        replacedByRowId = 0
            AND hostRedshift IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS a
    ORDER BY transientBucketId) t 
SET 
    s.host_redshift = t.host_redshift
WHERE
    s.transientBucketId = t.transientBucketId
        AND updateNeeded = 1;


UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS earliestDetection,
            a.magnitude AS earliestMagnitude,
            a.filter AS earliestMagnitudeFilter,
            a.survey AS earliestMagnitudeSurvey
    FROM
        transientBucket a
    JOIN (SELECT 
        MIN(observationDate) AS minval, transientBucketId
    FROM
        transientBucket
    WHERE
        magnitude IS NOT NULL
            AND limitingMag = 0
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.minval
    WHERE
        a.limitingMag = 0
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) t 
SET 
    s.earliestDetection = t.earliestDetection,
    s.earliestMagnitude = t.earliestMagnitude,
    s.earliestMagnitudeFilter = t.earliestMagnitudeFilter,
    s.earliestMagnitudeSurvey = t.earliestMagnitudeSurvey
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;


UPDATE transientBucketSummaries a,
    (SELECT 
        *
    FROM
        (SELECT 
        s.transientBucketId,
            MAX(t.lastNonDetectionDate) AS lastNonDetectionDate
    FROM
        transientBucket t, transientBucketSummaries s
    WHERE
        t.lastNonDetectionDate < s.earliestDetection
            AND s.transientBucketId = t.transientBucketId
            AND replacedByRowId = 0
            AND t.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY s.transientBucketId) AS c
    ORDER BY transientBucketId) b 
SET 
    a.lastNonDetectionDate = b.lastNonDetectionDate
WHERE
    a.transientBucketId = b.transientBucketId
        AND a.updateNeeded = 1;
    

UPDATE transientBucketSummaries a,
    (SELECT 
        *
    FROM
        (SELECT 
        s.transientBucketId,
            MAX(t.observationDate) AS lastNonDetectionDate
    FROM
        transientBucket t, transientBucketSummaries s
    WHERE
        t.observationDate < s.earliestDetection
            AND (t.observationDate > s.lastNonDetectionDate
            OR s.lastNonDetectionDate IS NULL)
            AND s.transientBucketId = t.transientBucketId
            AND replacedByRowId = 0
            AND t.limitingMag = 1
            AND t.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY s.transientBucketId) AS a
    ORDER BY transientBucketId) b 
SET 
    a.lastNonDetectionDate = b.lastNonDetectionDate
WHERE
    a.transientBucketId = b.transientBucketId
        AND a.updateNeeded = 1;


UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS currentMagnitudeDate,
            a.magnitude AS currentMagnitude,
            a.filter AS currentMagnitudeFilter,
            a.survey AS currentMagnitudeSurvey
    FROM
        transientBucket a
    JOIN (SELECT 
        *
    FROM
        (SELECT 
        MAX(observationDate) AS maxval, transientBucketId
    FROM
        transientBucket
    WHERE
        magnitude IS NOT NULL
            AND limitingMag = 0
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS d
    ORDER BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.maxval
    WHERE
        a.limitingMag = 0
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) t 
SET 
    s.currentMagnitudeDate = t.currentMagnitudeDate,
    s.currentMagnitude = t.currentMagnitude,
    s.currentMagnitudeFilter = t.currentMagnitudeFilter,
    s.currentMagnitudeSurvey = t.currentMagnitudeSurvey
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;




UPDATE transientBucketSummaries s,
    (SELECT 
        *
    FROM
        (SELECT 
        a.transientBucketId,
            a.observationDate AS classificationDate,
            a.spectralType AS recentClassification,
            a.classificationWRTMax AS classificationWRTMax,
            a.classificationPhase AS classificationPhase,
            a.reducer AS classificationAddedBy,
            a.dateCreated AS classificationAddedDate,
            a.transientRedshift AS best_redshift
    FROM
        transientBucket a
    JOIN (SELECT 
        *
    FROM
        (SELECT 
        MAX(observationDate) AS maxval, transientBucketId
    FROM
        transientBucket
    WHERE
        spectralType IS NOT NULL
            AND replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS c
    ORDER BY transientBucketId) AS b ON a.transientBucketId = b.transientBucketId
        AND a.observationDate = b.maxval
    WHERE
        spectralType IS NOT NULL
            AND a.replacedByRowId = 0
            AND observationDate IS NOT NULL
            AND a.transientBucketId IN (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1)
    GROUP BY transientBucketId) AS d
    ORDER BY transientBucketId) t 
SET 
    s.classificationDate = t.classificationDate,
    s.recentClassification = t.recentClassification,
    s.classificationWRTMax = t.classificationWRTMax,
    s.classificationPhase = t.classificationPhase,
    s.classificationAddedBy = t.classificationAddedBy,
    s.classificationAddedDate = t.classificationAddedDate,
    s.best_redshift = t.best_redshift
WHERE
    s.transientBucketId = t.transientBucketId
        AND s.updateNeeded = 1;

        

UPDATE transientBucketSummaries s,
    sherlock_crossmatches c 
SET 
    s.sherlockClassification = c.association_type,
    s.separationArcsec = c.separationArcsec,
    s.distanceMpc = IF(c.direct_distance,
        c.direct_distance,
        c.distance),
    s.best_redshift = IF(s.best_redshift IS NULL,
        c.z,
        s.best_redshift),
    s.host_redshift = IF(c.z AND c.z != s.host_redshift,
        c.z,
        s.host_redshift)
WHERE
    c.rank = 1
        AND s.transientBucketId = c.transient_object_id
        AND c.transient_object_id IN (SELECT 
            *
        FROM
            (SELECT 
                transientBucketId
            FROM
                transientBucketSummaries
            WHERE
                updateNeeded = 1) AS a)
        AND s.updateNeeded = 1;


UPDATE transientBucketSummaries 
SET 
    absolutePeakMagnitude = peakMagnitude - (5 * LOG10(distanceMpc * 1000000) - 5)
WHERE
    distanceMpc IS NOT NULL
        AND peakMagnitude IS NOT NULL
        AND peakMagnitude < 24.0
        AND absolutePeakMagnitude IS NULL;
    
    

UPDATE transientBucketSummaries s 
SET 
    updateNeeded = 2
WHERE
    updateNeeded = 1; 


UPDATE transientBucketSummaries t,
        pesstoObjects p 
    SET 
        marshallWorkflowLocation = 'archive'
    WHERE
        t.mastername LIKE 'ZTF%%'
            AND (t.currentMagnitude > 20.0
            OR ABS(t.gLat) < 10)
            AND p.transientBucketId = t.transientBucketId
            AND marshallWorkflowLocation = "inbox";


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transientBucket_atlas_sources` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_transientBucket_atlas_sources`()
BEGIN
	
	UPDATE transientBucket t,
            (SELECT DISTINCT
                transientBucketId,
                    targetImageUrl,
                    referenceImageUrl,
                    subtractedImageUrl
            FROM
                transientBucket
            WHERE
                survey = 'atlas'
                    AND targetImageUrl like "%%atlas4%%" and dateDeleted is null) m 
        SET 
            t.targetImageUrl = m.targetImageUrl,
            t.referenceImageUrl = m.referenceImageUrl,
            t.subtractedImageUrl = m.subtractedImageUrl
        WHERE
            t.transientBucketId = m.transientBucketId
                AND survey = 'ATLAS FP';
                
    
        UPDATE transientBucket t,
            (SELECT DISTINCT
                transientBucketId,
                    surveyObjectUrl
            FROM
                transientBucket
            WHERE
                survey = 'atlas'
                    AND surveyObjectUrl like "%atlas4%" and dateDeleted is null) m 
        SET 
            t.surveyObjectUrl = m.surveyObjectUrl
        WHERE
            t.transientBucketId = m.transientBucketId
                AND t.survey = 'ATLAS FP' and (t.surveyObjectUrl not like "%atlas4%" or t.surveyObjectUrl  is null);
                
	
        UPDATE transientBucket 
        SET 
            masterIdFlag = 1
        WHERE
            primaryKeyId IN (SELECT 
                    *
                FROM
                    (SELECT 
                        primaryKeyId
                    FROM
                        transientBucket
                    WHERE
                        survey = 'ATLAS FP'
                            AND transientBucketId IN (SELECT DISTINCT
                                transientBucketId
                            FROM
                                transientBucket
                            WHERE
                                survey = 'atlas' AND masterIDFlag = 1 and surveyObjectURL not like "%wis-tns%" and dateDeleted is null)
                    GROUP BY transientBucketId) a);
                    
	
        UPDATE transientBucket 
        SET 
            dateDeleted = NOW(),
            replacedbyRowId = -1
        WHERE
            survey = 'atlas' AND dateDeleted IS NULL and surveyObjectURL not like "%%wis-tns%%"
                AND transientBucketId IN (SELECT 
                    *
                FROM
                    (SELECT DISTINCT
                        transientBucketId
                    FROM
                        transientBucket
                    WHERE
                        survey = 'ATLAS FP'  and limitingMag = 0) a);
                        
	
    UPDATE transientBucket 
        SET 
            surveyObjectUrl = CONCAT('https://star.pst.qub.ac.uk/sne/atlas4/candidate/',
                    SUBSTRING_INDEX(SUBSTRING_INDEX(referenceImageUrl, '_', 2),
                            '/',
                            - 1))
        WHERE
            survey = 'ATLAS FP'
                AND surveyObjectUrl IS NULL
                AND referenceImageUrl IS NOT NULL;
                
	
	update transientBucket t, (select distinct candidateId, objectURL from fs_atlas where objectURL is not null) a set surveyObjectUrl=objectURL where t.surveyObjectUrl is null and t.name=a.candidateId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transientbucket_observation_dates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_transientbucket_observation_dates`()
BEGIN
	UPDATE transientBucket set observationMJD = null where observationMJD = 0;
UPDATE transientBucket set observationMJD = observationMJD - 2400000.5 where observationMJD > 245000;

UPDATE ignore transientBucket 
SET 
    observationDate = FROM_UNIXTIME((observationMJD + 678941) * (3600 * 24) - TO_SECONDS('1970-01-01 00:00:00') + TO_SECONDS(UTC_TIMESTAMP()) - TO_SECONDS(CURRENT_TIMESTAMP()))
WHERE
    observationMJD IS NOT NULL and observationDate is null;

UPDATE ignore transientBucket 
SET 
    observationMjd = TO_SECONDS(observationDate) / (3600 * 24) - 678941
WHERE
    observationMjd IS NULL
        AND observationDate IS NOT NULL;
delete from transientBucket where observationMJD is null;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transients_with_no_masteridflag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_transients_with_no_masteridflag`()
BEGIN

IF (@fix > 0) THEN
   update transientBucket set masterIDFlag  = 0 where masterIDFlag  = 1 and replacedByRowId = 0 and transientBucketId in (select transientBucketId FROM
    (SELECT DISTINCT
        transientBucketId, COUNT(*) AS count
    FROM
        transientBucket
    WHERE
        masterIDFlag = 1
        and replacedByRowId = 0
    GROUP BY transientBucketId) AS a
WHERE
    count > 1) and primaryKeyId not in (select * from 
(select  
    MIN(primaryKeyId)
FROM
    transientBucket
WHERE
	replacedByRowId = 0 GROUP BY transientBucketId) as b);
END IF;
    
update transientBucket set masterIDFlag  = 0 where masterIDFlag  = 1 and replacedByRowId != 0;


update transientBucket t, transientBucketSummaries s set t.masterIDFlag = 1, s.updateNeeded = 1 where t.transientBucketId = s.transientBucketId and t.primaryKeyId in (select * from 
(select  
    MIN(primaryKeyId)
FROM
    transientBucket
WHERE
	replacedByRowId = 0 AND
    transientBucketId NOT IN (SELECT 
            *
        FROM
            (SELECT DISTINCT
                transientBucketId
            FROM
                transientBucket
            WHERE
                masterIDFlag = 1 and replacedByRowId = 0) AS a)
GROUP BY transientBucketId) as b);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transient_akas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_transient_akas`()
BEGIN
INSERT IGNORE INTO marshall_transient_akas (transientBucketId, name)
select distinct transientBucketId, name from transientBucket where name not like "atel_%" and dateCreated > DATE_SUB(curdate(), INTERVAL 3 WEEK) order by transientBucketId;


update
        fs_atlas_forced_phot a, transientBucket t
set t.surveyObjectUrl=CONCAT('https://star.pst.qub.ac.uk/sne/atlas4/candidate/', a.atlas_object_id)
WHERE
    t.surveyObjectUrl IS NULL
        AND t.name = a.atlas_designation
        AND a.atlas_designation IN (SELECT 
            name
        FROM
            marshall_transient_akas
        WHERE
            url IS NULL and name like "ATLAS%");

update marshall_transient_akas set url = concat("https://lasair.roe.ac.uk/object/",name) where name like "ZTF%" and url is null;
update marshall_transient_akas set url = concat("https://wis-tns.weizmann.ac.il/object/",name) where (name like "AT20%" or name like "AT19%" or name like "SN19%" or name like "SN20%") and url is null;
update marshall_transient_akas a, (select distinct name, surveyObjectUrl from transientBucket where name like "LSQ%" and surveyObjectUrl is not null and surveyObjectUrl  like "%nersc%") t set a.url = t.surveyObjectUrl where a.name=t.name and a.url is null;
update marshall_transient_akas a, (select distinct name, surveyObjectUrl from transientBucket where (name like "PS1%" or name like "PS2%") and surveyObjectUrl is not null and surveyObjectUrl like "%star.pst%") t set a.url = t.surveyObjectUrl where a.name=t.name and a.url is null;
update marshall_transient_akas a, (select distinct name, surveyObjectUrl from transientBucket where name like "ATLAS%" and surveyObjectUrl is not null and surveyObjectUrl like "%star.pst%") t set a.url = t.surveyObjectUrl where a.name=t.name and a.url is null;
update marshall_transient_akas a, (select distinct name, surveyObjectUrl from transientBucket where (name like "CSS%" or name like "MLS%" or name like "SSS%") and surveyObjectUrl is not null and surveyObjectUrl like "%nesssi%") t set a.url = t.surveyObjectUrl where a.name=t.name and a.url is null;
update marshall_transient_akas a, (select distinct name, surveyObjectUrl from transientBucket where name like "PSN%" and surveyObjectUrl is not null and surveyObjectUrl like "%cbat%") t set a.url = t.surveyObjectUrl where a.name=t.name and a.url is null;
update marshall_transient_akas set url = concat("http://gsaweb.ast.cam.ac.uk/alerts/alert/",name) where name like "Gaia%" and url is null;
update marshall_transient_akas set url = "http://www.astronomy.ohio-state.edu/asassn/sn_list.html" where (name like "ASASSN-1%" and name not like "ASASSN-19%") and url is null;
update marshall_transient_akas set url = "http://ogle.astrouw.edu.pl/ogle4/transients/" where name like "OGLE%" and url is null;


UPDATE marshall_transient_akas c,
    (SELECT 
        a.name,
            REPLACE(b.name, 'AT', 'http://asassn.china-vo.org/public/lc?dir=') AS url
    FROM
        marshall_transient_akas a
    INNER JOIN marshall_transient_akas b ON a.transientBucketId = b.transientBucketId
    WHERE
        b.name LIKE 'AT2%'
            AND (a.name LIKE 'ASASSN-19%'
            OR a.name LIKE 'ASASSN-2%')
            AND a.url IS NULL
            AND LENGTH(b.name) > 8
            AND b.name NOT LIKE '%19a%'
            AND b.name NOT LIKE '%19b%'
            AND b.name LIKE '%19%') d 
SET 
    c.url = d.url
WHERE
    c.name = d.name;
    

UPDATE marshall_transient_akas c,
    (SELECT 
        a.name,
            REPLACE(b.name, 'SN', 'http://asassn.china-vo.org/public/lc?dir=') AS url
    FROM
        marshall_transient_akas a
    INNER JOIN marshall_transient_akas b ON a.transientBucketId = b.transientBucketId
    WHERE
        b.name LIKE 'SN2%'
            AND (a.name LIKE 'ASASSN-19%'
            OR a.name LIKE 'ASASSN-2%')
            AND a.url IS NULL
            AND LENGTH(b.name) > 8
            AND b.name NOT LIKE '%19a%'
            AND b.name NOT LIKE '%19b%'
            AND b.name LIKE '%19%') d 
SET 
    c.url = d.url
WHERE
    c.name = d.name;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `_subview_object_akas`
--

/*!50001 DROP VIEW IF EXISTS `_subview_object_akas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `_subview_object_akas` AS select 1 AS `transientBucketId`,1 AS `primaryKeyId`,1 AS `name`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `referenceImageUrl`,1 AS `targetImageUrl`,1 AS `subtractedImageUrl`,1 AS `tripletImageUrl`,1 AS `finderImageUrl` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_benetti`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_benetti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_benetti` AS select 1 AS `primaryId`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `ASTROMET`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `ELLIPTIC`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTNAME`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FIXPIX`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTV1`,1 AS `MBKG`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SINGLEXP`,1 AS `TELESCOP`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `XTENSION`,1 AS `ZEROCOR`,1 AS `ZPIRI`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `PCOUNT`,1 AS `SIMPLE`,1 AS `BUNIT`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `GAIN`,1 AS `MJD_END`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `TEXPTIME`,1 AS `ZPGGR`,1 AS `ESO_DET_OUT2_CHIP`,1 AS `ESO_DET_OUT2_CONAD`,1 AS `ESO_DET_OUT2_GAIN`,1 AS `ESO_DET_OUT2_ID`,1 AS `ESO_DET_OUT2_INDEX`,1 AS `ESO_DET_OUT2_NAME`,1 AS `ESO_DET_OUT2_NX`,1 AS `ESO_DET_OUT2_NY`,1 AS `ESO_DET_OUT2_OVSCX`,1 AS `ESO_DET_OUT2_OVSCY`,1 AS `ESO_DET_OUT2_PRSCX`,1 AS `ESO_DET_OUT2_PRSCY`,1 AS `ESO_DET_OUT2_RON`,1 AS `ESO_DET_OUT2_X`,1 AS `ESO_DET_OUT2_Y`,1 AS `OBJMASK`,1 AS `DARKTIME`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `FRICOR`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `OBID`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `ZPRRI`,1 AS `ZPVBV`,1 AS `ZPVVR`,1 AS `ZPRVR`,1 AS `ZPUUB`,1 AS `ZPBBV`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `TRACE17`,1 AS `TRACE18`,1 AS `TRACE19`,1 AS `TRACE20`,1 AS `TRACE21`,1 AS `ZPZIZ`,1 AS `PROV22`,1 AS `PROV23`,1 AS `TRACE22`,1 AS `TRACE23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `TRACE24`,1 AS `TRACE25`,1 AS `TRACE26`,1 AS `TRACE27`,1 AS `TRACE28`,1 AS `TRACE29`,1 AS `CONTNORM`,1 AS `DISPELEM`,1 AS `EXT_OBJ`,1 AS `FLUXERR`,1 AS `LTV2`,1 AS `SPECSYS`,1 AS `TELAPSE`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `OBJ_OLD`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_esophaseiii`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_esophaseiii`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_esophaseiii` AS select 1 AS `primaryId`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `ASTROMET`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `ELLIPTIC`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTNAME`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FIXPIX`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTV1`,1 AS `MBKG`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SINGLEXP`,1 AS `TELESCOP`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `XTENSION`,1 AS `ZEROCOR`,1 AS `ZPIRI`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `PCOUNT`,1 AS `SIMPLE`,1 AS `BUNIT`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `GAIN`,1 AS `MJD_END`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `TEXPTIME`,1 AS `ZPGGR`,1 AS `ESO_DET_OUT2_CHIP`,1 AS `ESO_DET_OUT2_CONAD`,1 AS `ESO_DET_OUT2_GAIN`,1 AS `ESO_DET_OUT2_ID`,1 AS `ESO_DET_OUT2_INDEX`,1 AS `ESO_DET_OUT2_NAME`,1 AS `ESO_DET_OUT2_NX`,1 AS `ESO_DET_OUT2_NY`,1 AS `ESO_DET_OUT2_OVSCX`,1 AS `ESO_DET_OUT2_OVSCY`,1 AS `ESO_DET_OUT2_PRSCX`,1 AS `ESO_DET_OUT2_PRSCY`,1 AS `ESO_DET_OUT2_RON`,1 AS `ESO_DET_OUT2_X`,1 AS `ESO_DET_OUT2_Y`,1 AS `OBJMASK`,1 AS `DARKTIME`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `FRICOR`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `OBID`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `ZPRRI`,1 AS `ZPVBV`,1 AS `ZPVVR`,1 AS `ZPRVR`,1 AS `ZPUUB`,1 AS `ZPBBV`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `TRACE17`,1 AS `TRACE18`,1 AS `TRACE19`,1 AS `TRACE20`,1 AS `TRACE21`,1 AS `ZPZIZ`,1 AS `PROV22`,1 AS `PROV23`,1 AS `TRACE22`,1 AS `TRACE23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `TRACE24`,1 AS `TRACE25`,1 AS `TRACE26`,1 AS `TRACE27`,1 AS `TRACE28`,1 AS `TRACE29`,1 AS `CONTNORM`,1 AS `DISPELEM`,1 AS `EXT_OBJ`,1 AS `FLUXERR`,1 AS `LTV2`,1 AS `SPECSYS`,1 AS `TELAPSE`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `OBJ_OLD`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_intermediate`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_intermediate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_intermediate` AS select 1 AS `primaryId`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `ASTROMET`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `ELLIPTIC`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTNAME`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FIXPIX`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTV1`,1 AS `MBKG`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SINGLEXP`,1 AS `TELESCOP`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `XTENSION`,1 AS `ZEROCOR`,1 AS `ZPIRI`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `PCOUNT`,1 AS `SIMPLE`,1 AS `BUNIT`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `GAIN`,1 AS `MJD_END`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `TEXPTIME`,1 AS `ZPGGR`,1 AS `ESO_DET_OUT2_CHIP`,1 AS `ESO_DET_OUT2_CONAD`,1 AS `ESO_DET_OUT2_GAIN`,1 AS `ESO_DET_OUT2_ID`,1 AS `ESO_DET_OUT2_INDEX`,1 AS `ESO_DET_OUT2_NAME`,1 AS `ESO_DET_OUT2_NX`,1 AS `ESO_DET_OUT2_NY`,1 AS `ESO_DET_OUT2_OVSCX`,1 AS `ESO_DET_OUT2_OVSCY`,1 AS `ESO_DET_OUT2_PRSCX`,1 AS `ESO_DET_OUT2_PRSCY`,1 AS `ESO_DET_OUT2_RON`,1 AS `ESO_DET_OUT2_X`,1 AS `ESO_DET_OUT2_Y`,1 AS `OBJMASK`,1 AS `DARKTIME`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `FRICOR`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `OBID`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `ZPRRI`,1 AS `ZPVBV`,1 AS `ZPVVR`,1 AS `ZPRVR`,1 AS `ZPUUB`,1 AS `ZPBBV`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `TRACE17`,1 AS `TRACE18`,1 AS `TRACE19`,1 AS `TRACE20`,1 AS `TRACE21`,1 AS `ZPZIZ`,1 AS `PROV22`,1 AS `PROV23`,1 AS `TRACE22`,1 AS `TRACE23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `TRACE24`,1 AS `TRACE25`,1 AS `TRACE26`,1 AS `TRACE27`,1 AS `TRACE28`,1 AS `TRACE29`,1 AS `CONTNORM`,1 AS `DISPELEM`,1 AS `EXT_OBJ`,1 AS `FLUXERR`,1 AS `LTV2`,1 AS `SPECSYS`,1 AS `TELAPSE`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `OBJ_OLD`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_raw`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_raw` AS select 1 AS `primaryId`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `ASTROMET`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `ELLIPTIC`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTNAME`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FIXPIX`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTV1`,1 AS `MBKG`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SINGLEXP`,1 AS `TELESCOP`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `XTENSION`,1 AS `ZEROCOR`,1 AS `ZPIRI`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `PCOUNT`,1 AS `SIMPLE`,1 AS `BUNIT`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `GAIN`,1 AS `MJD_END`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `TEXPTIME`,1 AS `ZPGGR`,1 AS `ESO_DET_OUT2_CHIP`,1 AS `ESO_DET_OUT2_CONAD`,1 AS `ESO_DET_OUT2_GAIN`,1 AS `ESO_DET_OUT2_ID`,1 AS `ESO_DET_OUT2_INDEX`,1 AS `ESO_DET_OUT2_NAME`,1 AS `ESO_DET_OUT2_NX`,1 AS `ESO_DET_OUT2_NY`,1 AS `ESO_DET_OUT2_OVSCX`,1 AS `ESO_DET_OUT2_OVSCY`,1 AS `ESO_DET_OUT2_PRSCX`,1 AS `ESO_DET_OUT2_PRSCY`,1 AS `ESO_DET_OUT2_RON`,1 AS `ESO_DET_OUT2_X`,1 AS `ESO_DET_OUT2_Y`,1 AS `OBJMASK`,1 AS `DARKTIME`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `FRICOR`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `OBID`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `ZPRRI`,1 AS `ZPVBV`,1 AS `ZPVVR`,1 AS `ZPRVR`,1 AS `ZPUUB`,1 AS `ZPBBV`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `TRACE17`,1 AS `TRACE18`,1 AS `TRACE19`,1 AS `TRACE20`,1 AS `TRACE21`,1 AS `ZPZIZ`,1 AS `PROV22`,1 AS `PROV23`,1 AS `TRACE22`,1 AS `TRACE23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `TRACE24`,1 AS `TRACE25`,1 AS `TRACE26`,1 AS `TRACE27`,1 AS `TRACE28`,1 AS `TRACE29`,1 AS `CONTNORM`,1 AS `DISPELEM`,1 AS `EXT_OBJ`,1 AS `FLUXERR`,1 AS `LTV2`,1 AS `SPECSYS`,1 AS `TELAPSE`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `OBJ_OLD`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_reduced`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_reduced`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_reduced` AS select 1 AS `primaryId`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `ASTROMET`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `ELLIPTIC`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTNAME`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FIXPIX`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTV1`,1 AS `MBKG`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SINGLEXP`,1 AS `TELESCOP`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `XTENSION`,1 AS `ZEROCOR`,1 AS `ZPIRI`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `PCOUNT`,1 AS `SIMPLE`,1 AS `BUNIT`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `GAIN`,1 AS `MJD_END`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `TEXPTIME`,1 AS `ZPGGR`,1 AS `ESO_DET_OUT2_CHIP`,1 AS `ESO_DET_OUT2_CONAD`,1 AS `ESO_DET_OUT2_GAIN`,1 AS `ESO_DET_OUT2_ID`,1 AS `ESO_DET_OUT2_INDEX`,1 AS `ESO_DET_OUT2_NAME`,1 AS `ESO_DET_OUT2_NX`,1 AS `ESO_DET_OUT2_NY`,1 AS `ESO_DET_OUT2_OVSCX`,1 AS `ESO_DET_OUT2_OVSCY`,1 AS `ESO_DET_OUT2_PRSCX`,1 AS `ESO_DET_OUT2_PRSCY`,1 AS `ESO_DET_OUT2_RON`,1 AS `ESO_DET_OUT2_X`,1 AS `ESO_DET_OUT2_Y`,1 AS `OBJMASK`,1 AS `DARKTIME`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `FRICOR`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `OBID`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `ZPRRI`,1 AS `ZPVBV`,1 AS `ZPVVR`,1 AS `ZPRVR`,1 AS `ZPUUB`,1 AS `ZPBBV`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `TRACE17`,1 AS `TRACE18`,1 AS `TRACE19`,1 AS `TRACE20`,1 AS `TRACE21`,1 AS `ZPZIZ`,1 AS `PROV22`,1 AS `PROV23`,1 AS `TRACE22`,1 AS `TRACE23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `TRACE24`,1 AS `TRACE25`,1 AS `TRACE26`,1 AS `TRACE27`,1 AS `TRACE28`,1 AS `TRACE29`,1 AS `CONTNORM`,1 AS `DISPELEM`,1 AS `EXT_OBJ`,1 AS `FLUXERR`,1 AS `LTV2`,1 AS `SPECSYS`,1 AS `TELAPSE`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `OBJ_OLD`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally`,1 AS `isInTransientBucket`,1 AS `DATA_REL`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `astromet_error_arcsec` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_ssdr1`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_ssdr1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_ssdr1` AS select 1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ASSOC_SPECTRUM_ID`,1 AS `ASSOC_SPECTRUM_NAME`,1 AS `ASTROMET`,1 AS `astromet_error_arcsec`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `filetype_key_calibration`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `GAIN`,1 AS `dryx_comment`,1 AS `isInTransientBucket`,1 AS `LACOSMIC`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `rewriteFitsHeader`,1 AS `RRELEASE`,1 AS `TEXPTIME`,1 AS `transientBucketId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_imaging_ssdr2`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_imaging_ssdr2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_imaging_ssdr2` AS select 1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ASSOC_SPECTRUM_ID`,1 AS `ASSOC_SPECTRUM_NAME`,1 AS `ASTROMET`,1 AS `astromet_error_arcsec`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `filetype_key_calibration`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `GAIN`,1 AS `dryx_comment`,1 AS `isInTransientBucket`,1 AS `LACOSMIC`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NCOMBINE`,1 AS `OBJECT`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PSF_FWHM`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `rewriteFitsHeader`,1 AS `RRELEASE`,1 AS `TEXPTIME`,1 AS `transientBucketId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_benetti`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_benetti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_benetti` AS select 1 AS `primaryId`,1 AS `ARCFILE`,1 AS `BITPIX`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `LST`,1 AS `MJD_OBS`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PCOUNT`,1 AS `PI_COI`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SIMPLE`,1 AS `TELESCOP`,1 AS `UTC`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `ARC`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `BIASSEC`,1 AS `BUNIT`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CD3_3`,1 AS `CONTNORM`,1 AS `CTYPE3`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `ESO_INS_MOS1_LEN`,1 AS `ESO_INS_MOS1_POSX`,1 AS `ESO_INS_MOS1_POSY`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTM3_3`,1 AS `MAGSTD`,1 AS `MJD_END`,1 AS `M_EPOCH`,1 AS `NAXIS3`,1 AS `NCOMBINE`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `SINGLEXP`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `STDNAME`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT1_002`,1 AS `WAT2_001`,1 AS `WAT3_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `ZEROCOR`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `SHIFT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `CA_FLAG`,1 AS `EX_FLAG`,1 AS `SENSFUN`,1 AS `SNR`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `LTV1`,1 AS `ESO_DET_WIN1_DIT2`,1 AS `ESO_DET_WIN1_UIT2`,1 AS `LTV2`,1 AS `REFSPEC1`,1 AS `ATMOFILE`,1 AS `DISPAXIS`,1 AS `OBID`,1 AS `DARKTIME`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `ASSOC2`,1 AS `ASSOC3`,1 AS `ASSOC4`,1 AS `ASSOC5`,1 AS `OBJ_OLD`,1 AS `TELE_DEC`,1 AS `TELE_RA`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `APNUM2`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_esophaseiii`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_esophaseiii`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_esophaseiii` AS select 1 AS `primaryId`,1 AS `ARCFILE`,1 AS `BITPIX`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `LST`,1 AS `MJD_OBS`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PCOUNT`,1 AS `PI_COI`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SIMPLE`,1 AS `TELESCOP`,1 AS `UTC`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `ARC`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `BIASSEC`,1 AS `BUNIT`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CD3_3`,1 AS `CONTNORM`,1 AS `CTYPE3`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `ESO_INS_MOS1_LEN`,1 AS `ESO_INS_MOS1_POSX`,1 AS `ESO_INS_MOS1_POSY`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTM3_3`,1 AS `MAGSTD`,1 AS `MJD_END`,1 AS `M_EPOCH`,1 AS `NAXIS3`,1 AS `NCOMBINE`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `SINGLEXP`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `STDNAME`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT1_002`,1 AS `WAT2_001`,1 AS `WAT3_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `ZEROCOR`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `SHIFT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `CA_FLAG`,1 AS `EX_FLAG`,1 AS `SENSFUN`,1 AS `SNR`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `LTV1`,1 AS `ESO_DET_WIN1_DIT2`,1 AS `ESO_DET_WIN1_UIT2`,1 AS `LTV2`,1 AS `REFSPEC1`,1 AS `ATMOFILE`,1 AS `DISPAXIS`,1 AS `OBID`,1 AS `DARKTIME`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `ASSOC2`,1 AS `ASSOC3`,1 AS `ASSOC4`,1 AS `ASSOC5`,1 AS `OBJ_OLD`,1 AS `TELE_DEC`,1 AS `TELE_RA`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `APNUM2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_intermediate`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_intermediate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_intermediate` AS select 1 AS `primaryId`,1 AS `ARCFILE`,1 AS `BITPIX`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `LST`,1 AS `MJD_OBS`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PCOUNT`,1 AS `PI_COI`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SIMPLE`,1 AS `TELESCOP`,1 AS `UTC`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `ARC`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `BIASSEC`,1 AS `BUNIT`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CD3_3`,1 AS `CONTNORM`,1 AS `CTYPE3`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `ESO_INS_MOS1_LEN`,1 AS `ESO_INS_MOS1_POSX`,1 AS `ESO_INS_MOS1_POSY`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTM3_3`,1 AS `MAGSTD`,1 AS `MJD_END`,1 AS `M_EPOCH`,1 AS `NAXIS3`,1 AS `NCOMBINE`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `SINGLEXP`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `STDNAME`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT1_002`,1 AS `WAT2_001`,1 AS `WAT3_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `ZEROCOR`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `SHIFT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `CA_FLAG`,1 AS `EX_FLAG`,1 AS `SENSFUN`,1 AS `SNR`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `LTV1`,1 AS `ESO_DET_WIN1_DIT2`,1 AS `ESO_DET_WIN1_UIT2`,1 AS `LTV2`,1 AS `REFSPEC1`,1 AS `ATMOFILE`,1 AS `DISPAXIS`,1 AS `OBID`,1 AS `DARKTIME`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `ASSOC2`,1 AS `ASSOC3`,1 AS `ASSOC4`,1 AS `ASSOC5`,1 AS `OBJ_OLD`,1 AS `TELE_DEC`,1 AS `TELE_RA`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `APNUM2`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_raw`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_raw` AS select 1 AS `primaryId`,1 AS `ARCFILE`,1 AS `BITPIX`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `LST`,1 AS `MJD_OBS`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PCOUNT`,1 AS `PI_COI`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SIMPLE`,1 AS `TELESCOP`,1 AS `UTC`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `ARC`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `BIASSEC`,1 AS `BUNIT`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CD3_3`,1 AS `CONTNORM`,1 AS `CTYPE3`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `ESO_INS_MOS1_LEN`,1 AS `ESO_INS_MOS1_POSX`,1 AS `ESO_INS_MOS1_POSY`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTM3_3`,1 AS `MAGSTD`,1 AS `MJD_END`,1 AS `M_EPOCH`,1 AS `NAXIS3`,1 AS `NCOMBINE`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `SINGLEXP`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `STDNAME`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT1_002`,1 AS `WAT2_001`,1 AS `WAT3_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `ZEROCOR`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `SHIFT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `CA_FLAG`,1 AS `EX_FLAG`,1 AS `SENSFUN`,1 AS `SNR`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `LTV1`,1 AS `ESO_DET_WIN1_DIT2`,1 AS `ESO_DET_WIN1_UIT2`,1 AS `LTV2`,1 AS `REFSPEC1`,1 AS `ATMOFILE`,1 AS `DISPAXIS`,1 AS `OBID`,1 AS `DARKTIME`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `ASSOC2`,1 AS `ASSOC3`,1 AS `ASSOC4`,1 AS `ASSOC5`,1 AS `OBJ_OLD`,1 AS `TELE_DEC`,1 AS `TELE_RA`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `APNUM2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_reduced`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_reduced`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_reduced` AS select 1 AS `primaryId`,1 AS `ARCFILE`,1 AS `BITPIX`,1 AS `BSCALE`,1 AS `BZERO`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_BITS`,1 AS `ESO_DET_CHIP1_DATE`,1 AS `ESO_DET_CHIP1_ID`,1 AS `ESO_DET_CHIP1_INDEX`,1 AS `ESO_DET_CHIP1_NAME`,1 AS `ESO_DET_CHIP1_NX`,1 AS `ESO_DET_CHIP1_NY`,1 AS `ESO_DET_CHIP1_PSZX`,1 AS `ESO_DET_CHIP1_PSZY`,1 AS `ESO_DET_CHIP1_X`,1 AS `ESO_DET_CHIP1_XGAP`,1 AS `ESO_DET_CHIP1_Y`,1 AS `ESO_DET_CHIP1_YGAP`,1 AS `ESO_DET_CHIPS`,1 AS `ESO_DET_DATE`,1 AS `ESO_DET_DEC`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_RDTTIME`,1 AS `ESO_DET_EXP_TYPE`,1 AS `ESO_DET_EXP_XFERTIM`,1 AS `ESO_DET_FRAM_ID`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_ID`,1 AS `ESO_DET_NAME`,1 AS `ESO_DET_OUT1_CHIP`,1 AS `ESO_DET_OUT1_CONAD`,1 AS `ESO_DET_OUT1_GAIN`,1 AS `ESO_DET_OUT1_ID`,1 AS `ESO_DET_OUT1_INDEX`,1 AS `ESO_DET_OUT1_NAME`,1 AS `ESO_DET_OUT1_NX`,1 AS `ESO_DET_OUT1_NY`,1 AS `ESO_DET_OUT1_OVSCX`,1 AS `ESO_DET_OUT1_OVSCY`,1 AS `ESO_DET_OUT1_PRSCX`,1 AS `ESO_DET_OUT1_PRSCY`,1 AS `ESO_DET_OUT1_RON`,1 AS `ESO_DET_OUT1_X`,1 AS `ESO_DET_OUT1_Y`,1 AS `ESO_DET_OUTPUTS`,1 AS `ESO_DET_OUTREF`,1 AS `ESO_DET_RA`,1 AS `ESO_DET_READ_CLOCK`,1 AS `ESO_DET_READ_MODE`,1 AS `ESO_DET_READ_NFRAM`,1 AS `ESO_DET_READ_SPEED`,1 AS `ESO_DET_SHUT_ID`,1 AS `ESO_DET_SHUT_TMCLOS`,1 AS `ESO_DET_SHUT_TMOPEN`,1 AS `ESO_DET_SHUT_TYPE`,1 AS `ESO_DET_SOFW_MODE`,1 AS `ESO_DET_WIN1_BINX`,1 AS `ESO_DET_WIN1_BINY`,1 AS `ESO_DET_WIN1_DIT1`,1 AS `ESO_DET_WIN1_DKTM`,1 AS `ESO_DET_WIN1_NDIT`,1 AS `ESO_DET_WIN1_NX`,1 AS `ESO_DET_WIN1_NY`,1 AS `ESO_DET_WIN1_ST`,1 AS `ESO_DET_WIN1_STRX`,1 AS `ESO_DET_WIN1_STRY`,1 AS `ESO_DET_WIN1_UIT1`,1 AS `ESO_DET_WINDOWS`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_DATE`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_DPOR_POS`,1 AS `ESO_INS_DPOR_ST`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_GRIS1_ID`,1 AS `ESO_INS_GRIS1_NAME`,1 AS `ESO_INS_GRIS1_NO`,1 AS `ESO_INS_GRIS1_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_SLIT1_ENC`,1 AS `ESO_INS_SLIT1_LEN`,1 AS `ESO_INS_SLIT1_NAME`,1 AS `ESO_INS_SLIT1_NO`,1 AS `ESO_INS_SLIT1_WID`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_WP_NAME`,1 AS `ESO_INS_WP_ST`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_DET1_IMGNAME`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `GCOUNT`,1 AS `INHERIT`,1 AS `INSTRUME`,1 AS `LST`,1 AS `MJD_OBS`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PCOUNT`,1 AS `PI_COI`,1 AS `RA`,1 AS `RADECSYS`,1 AS `SIMPLE`,1 AS `TELESCOP`,1 AS `UTC`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `ARC`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `BIASSEC`,1 AS `BUNIT`,1 AS `CCDMEAN`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CD3_3`,1 AS `CONTNORM`,1 AS `CTYPE3`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_DET_TELE_INT`,1 AS `ESO_DET_TELE_NO`,1 AS `ESO_DET_TLM1_END`,1 AS `ESO_DET_TLM1_ID`,1 AS `ESO_DET_TLM1_NAME`,1 AS `ESO_DET_TLM1_START`,1 AS `ESO_DET_TLM2_END`,1 AS `ESO_DET_TLM2_ID`,1 AS `ESO_DET_TLM2_NAME`,1 AS `ESO_DET_TLM2_START`,1 AS `ESO_DET_TLM3_END`,1 AS `ESO_DET_TLM3_ID`,1 AS `ESO_DET_TLM3_NAME`,1 AS `ESO_DET_TLM3_START`,1 AS `ESO_DET_TLM4_END`,1 AS `ESO_DET_TLM4_ID`,1 AS `ESO_DET_TLM4_NAME`,1 AS `ESO_DET_TLM4_START`,1 AS `ESO_DET_TLM5_END`,1 AS `ESO_DET_TLM5_ID`,1 AS `ESO_DET_TLM5_NAME`,1 AS `ESO_DET_TLM5_START`,1 AS `ESO_DET_TLM6_END`,1 AS `ESO_DET_TLM6_ID`,1 AS `ESO_DET_TLM6_NAME`,1 AS `ESO_DET_TLM6_START`,1 AS `ESO_INS_MOS1_LEN`,1 AS `ESO_INS_MOS1_POSX`,1 AS `ESO_INS_MOS1_POSY`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OCS_CON_WCSFITS`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `IRAF_TLM`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `LTM3_3`,1 AS `MAGSTD`,1 AS `MJD_END`,1 AS `M_EPOCH`,1 AS `NAXIS3`,1 AS `NCOMBINE`,1 AS `OBID1`,1 AS `OBSTECH`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `REFERENC`,1 AS `SINGLEXP`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `STDNAME`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT1_002`,1 AS `WAT2_001`,1 AS `WAT3_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `ZEROCOR`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `SHIFT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `CA_FLAG`,1 AS `EX_FLAG`,1 AS `SENSFUN`,1 AS `SNR`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `LTV1`,1 AS `ESO_DET_WIN1_DIT2`,1 AS `ESO_DET_WIN1_UIT2`,1 AS `LTV2`,1 AS `REFSPEC1`,1 AS `ATMOFILE`,1 AS `DISPAXIS`,1 AS `OBID`,1 AS `DARKTIME`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `COMMENT`,1 AS `FILTER1`,1 AS `GRISM`,1 AS `IMAGETYP`,1 AS `ST`,1 AS `UT`,1 AS `OVERSCAN`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `ASSOC2`,1 AS `ASSOC3`,1 AS `ASSOC4`,1 AS `ASSOC5`,1 AS `OBJ_OLD`,1 AS `TELE_DEC`,1 AS `TELE_RA`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `APNUM2` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_ssdr1`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_ssdr1` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ARCFILE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `nelem`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_ssdr2`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_ssdr2` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ARCFILE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `nelem`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_efosc_spectra_ssdr3`
--

/*!50001 DROP VIEW IF EXISTS `view_efosc_spectra_ssdr3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_efosc_spectra_ssdr3` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ARCFILE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LACOSMIC`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `nelem`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_eso_phaseiii_files`
--

/*!50001 DROP VIEW IF EXISTS `view_eso_phaseiii_files`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_eso_phaseiii_files` AS select 1 AS `tableName`,1 AS `object`,1 AS `transientBucketId`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `REFERENC`,1 AS `PI_COI`,1 AS `DATA_REL`,1 AS `OBSERVER`,1 AS `obid1`,1 AS `ESOphaseIII`,1 AS `fileName`,1 AS `ASSON1` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_fs_crts_css_summary`
--

/*!50001 DROP VIEW IF EXISTS `view_fs_crts_css_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_fs_crts_css_summary` AS select 1 AS `primaryId`,1 AS `circularUrl`,1 AS `comment`,1 AS `commentIngested`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `decDeg`,1 AS `filter`,1 AS `finderChartUrl`,1 AS `finderChartWebpage`,1 AS `imagesUrl`,1 AS `ingested`,1 AS `lightcurveUrl`,1 AS `mag`,1 AS `name`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `raDeg`,1 AS `summaryRow`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `targetImageUrl`,1 AS `transientTypePrediction`,1 AS `uniqueId`,1 AS `htm16ID`,1 AS `magErr`,1 AS `lastNonDetectionDate`,1 AS `lastNonDetectionMJD` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_fs_crts_mls_summary`
--

/*!50001 DROP VIEW IF EXISTS `view_fs_crts_mls_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_fs_crts_mls_summary` AS select 1 AS `primaryId`,1 AS `circularUrl`,1 AS `comment`,1 AS `commentIngested`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `decDeg`,1 AS `filter`,1 AS `finderChartUrl`,1 AS `finderChartWebpage`,1 AS `imagesUrl`,1 AS `ingested`,1 AS `lightcurveUrl`,1 AS `mag`,1 AS `name`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `raDeg`,1 AS `summaryRow`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `targetImageUrl`,1 AS `transientTypePrediction`,1 AS `uniqueId`,1 AS `htm16ID`,1 AS `magErr`,1 AS `lastNonDetectionDate`,1 AS `lastNonDetectionMJD` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_fs_crts_sss_summary`
--

/*!50001 DROP VIEW IF EXISTS `view_fs_crts_sss_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_fs_crts_sss_summary` AS select 1 AS `primaryId`,1 AS `circularUrl`,1 AS `comment`,1 AS `commentIngested`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `decDeg`,1 AS `filter`,1 AS `finderChartUrl`,1 AS `finderChartWebpage`,1 AS `imagesUrl`,1 AS `ingested`,1 AS `lightcurveUrl`,1 AS `mag`,1 AS `name`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `raDeg`,1 AS `summaryRow`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `targetImageUrl`,1 AS `transientTypePrediction`,1 AS `uniqueId`,1 AS `htm16ID`,1 AS `magErr`,1 AS `lastNonDetectionDate`,1 AS `lastNonDetectionMJD` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_fs_ogle_summary`
--

/*!50001 DROP VIEW IF EXISTS `view_fs_ogle_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_fs_ogle_summary` AS select 1 AS `primaryId`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `decDeg`,1 AS `filter`,1 AS `ingested`,1 AS `lastNonDetectionDate`,1 AS `lastNonDetectionMJD`,1 AS `lightcurveUrl`,1 AS `mag`,1 AS `name`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `raDeg`,1 AS `referenceFitsUrl`,1 AS `referenceImageUrl`,1 AS `subtractedFitsUrl`,1 AS `subtractedImageUrl`,1 AS `summaryRow`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `targetFitsUrl`,1 AS `targetImageUrl`,1 AS `transientTypePrediction`,1 AS `htm16ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_object_akas`
--

/*!50001 DROP VIEW IF EXISTS `view_object_akas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_object_akas` AS select 1 AS `transientBucketId`,1 AS `primaryKeyId`,1 AS `name`,1 AS `survey`,1 AS `surveyObjectUrl`,1 AS `referenceImageUrl`,1 AS `targetImageUrl`,1 AS `subtractedImageUrl`,1 AS `tripletImageUrl`,1 AS `finderImageUrl` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_object_temporal_data`
--

/*!50001 DROP VIEW IF EXISTS `view_object_temporal_data`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_object_temporal_data` AS select 1 AS `transientBucketId`,1 AS `name`,1 AS `survey`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `magnitude`,1 AS `magnitudeError`,1 AS `filter`,1 AS `surveyObjectUrl`,1 AS `referenceImageUrl`,1 AS `targetImageUrl`,1 AS `subtractedImageUrl`,1 AS `tripletImageUrl`,1 AS `telescope`,1 AS `instrument` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_objectredshifts`
--

/*!50001 DROP VIEW IF EXISTS `view_objectredshifts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_objectredshifts` AS select 1 AS `transientBucketId`,1 AS `transientRedshift` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_objectspectraltypes`
--

/*!50001 DROP VIEW IF EXISTS `view_objectspectraltypes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_objectspectraltypes` AS select 1 AS `transientBucketId`,1 AS `spectralType` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_benetti`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_benetti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_benetti` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETA`,1 AS `ESO_SEQ_CUMOFFSETD`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_CUMOFFSETY`,1 AS `ESO_SEQ_POISSON`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_SEQ_RELOFFSETY`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `GAIN`,1 AS `ILLUMCOR`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `NCOMBINE`,1 AS `OBJMASK`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `OBID`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `COMMENT`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `ELLIPTIC`,1 AS `FLUXCAL`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTCRPIX1`,1 AS `NTCRPIX2`,1 AS `NUSTEP`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PSF_FWHM`,1 AS `PROV12`,1 AS `ZPJJH`,1 AS `PROV13`,1 AS `PROV5`,1 AS `PROV14`,1 AS `PROV6`,1 AS `PROV15`,1 AS `PROV7`,1 AS `PROV16`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE5`,1 AS `TRACE14`,1 AS `TRACE6`,1 AS `TRACE15`,1 AS `TRACE7`,1 AS `TRACE16`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `ZPKHK`,1 AS `DARKTIME`,1 AS `ZPHJH`,1 AS `MKILLUM`,1 AS `HDRVER`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_esophaseiii`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_esophaseiii`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_esophaseiii` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETA`,1 AS `ESO_SEQ_CUMOFFSETD`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_CUMOFFSETY`,1 AS `ESO_SEQ_POISSON`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_SEQ_RELOFFSETY`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `GAIN`,1 AS `ILLUMCOR`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `NCOMBINE`,1 AS `OBJMASK`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `OBID`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `COMMENT`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `ELLIPTIC`,1 AS `FLUXCAL`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTCRPIX1`,1 AS `NTCRPIX2`,1 AS `NUSTEP`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PSF_FWHM`,1 AS `PROV12`,1 AS `ZPJJH`,1 AS `PROV13`,1 AS `PROV5`,1 AS `PROV14`,1 AS `PROV6`,1 AS `PROV15`,1 AS `PROV7`,1 AS `PROV16`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE5`,1 AS `TRACE14`,1 AS `TRACE6`,1 AS `TRACE15`,1 AS `TRACE7`,1 AS `TRACE16`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `ZPKHK`,1 AS `DARKTIME`,1 AS `ZPHJH`,1 AS `MKILLUM`,1 AS `HDRVER`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_intermediate`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_intermediate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_intermediate` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETA`,1 AS `ESO_SEQ_CUMOFFSETD`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_CUMOFFSETY`,1 AS `ESO_SEQ_POISSON`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_SEQ_RELOFFSETY`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `GAIN`,1 AS `ILLUMCOR`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `NCOMBINE`,1 AS `OBJMASK`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `OBID`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `COMMENT`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `ELLIPTIC`,1 AS `FLUXCAL`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTCRPIX1`,1 AS `NTCRPIX2`,1 AS `NUSTEP`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PSF_FWHM`,1 AS `PROV12`,1 AS `ZPJJH`,1 AS `PROV13`,1 AS `PROV5`,1 AS `PROV14`,1 AS `PROV6`,1 AS `PROV15`,1 AS `PROV7`,1 AS `PROV16`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE5`,1 AS `TRACE14`,1 AS `TRACE6`,1 AS `TRACE15`,1 AS `TRACE7`,1 AS `TRACE16`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `ZPKHK`,1 AS `DARKTIME`,1 AS `ZPHJH`,1 AS `MKILLUM`,1 AS `HDRVER`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_raw`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_raw` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETA`,1 AS `ESO_SEQ_CUMOFFSETD`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_CUMOFFSETY`,1 AS `ESO_SEQ_POISSON`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_SEQ_RELOFFSETY`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `GAIN`,1 AS `ILLUMCOR`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `NCOMBINE`,1 AS `OBJMASK`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `OBID`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `COMMENT`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `ELLIPTIC`,1 AS `FLUXCAL`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTCRPIX1`,1 AS `NTCRPIX2`,1 AS `NUSTEP`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PSF_FWHM`,1 AS `PROV12`,1 AS `ZPJJH`,1 AS `PROV13`,1 AS `PROV5`,1 AS `PROV14`,1 AS `PROV6`,1 AS `PROV15`,1 AS `PROV7`,1 AS `PROV16`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE5`,1 AS `TRACE14`,1 AS `TRACE6`,1 AS `TRACE15`,1 AS `TRACE7`,1 AS `TRACE16`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `ZPKHK`,1 AS `DARKTIME`,1 AS `ZPHJH`,1 AS `MKILLUM`,1 AS `HDRVER`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_reduced`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_reduced`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_reduced` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETA`,1 AS `ESO_SEQ_CUMOFFSETD`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_CUMOFFSETY`,1 AS `ESO_SEQ_POISSON`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_SEQ_RELOFFSETY`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `GAIN`,1 AS `ILLUMCOR`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PIXSCALE`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WCSDIM`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `NCOMBINE`,1 AS `OBJMASK`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `TRACE2`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `OBID`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `COMMENT`,1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `CD1_2`,1 AS `CD2_1`,1 AS `CRDER1`,1 AS `CRDER2`,1 AS `CSYER1`,1 AS `CSYER2`,1 AS `CUNIT1`,1 AS `CUNIT2`,1 AS `ELLIPTIC`,1 AS `FLUXCAL`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTCRPIX1`,1 AS `NTCRPIX2`,1 AS `NUSTEP`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PSF_FWHM`,1 AS `PROV12`,1 AS `ZPJJH`,1 AS `PROV13`,1 AS `PROV5`,1 AS `PROV14`,1 AS `PROV6`,1 AS `PROV15`,1 AS `PROV7`,1 AS `PROV16`,1 AS `PROV8`,1 AS `PROV9`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE5`,1 AS `TRACE14`,1 AS `TRACE6`,1 AS `TRACE15`,1 AS `TRACE7`,1 AS `TRACE16`,1 AS `TRACE8`,1 AS `TRACE9`,1 AS `ZPKHK`,1 AS `DARKTIME`,1 AS `ZPHJH`,1 AS `MKILLUM`,1 AS `HDRVER`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally`,1 AS `isInTransientBucket`,1 AS `DATA_REL`,1 AS `NTID`,1 AS `ESO_INS_LAMP3_NAME`,1 AS `ESO_INS_LAMP3_SET`,1 AS `EFFRON`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `astromet_error_arcsec` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_ssdr1`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_ssdr1` AS select 1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `astromet_error_arcsec`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `filetype_key_calibration`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `GAIN`,1 AS `isInTransientBucket`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTID`,1 AS `OBJECT`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `PSF_FWHM`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `RRELEASE`,1 AS `TEXPTIME`,1 AS `TMID`,1 AS `transientBucketId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_ssdr2`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_ssdr2` AS select 1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `astromet_error_arcsec`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `filetype_key_calibration`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `GAIN`,1 AS `isInTransientBucket`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTID`,1 AS `OBJECT`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `PSF_FWHM`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `RRELEASE`,1 AS `TEXPTIME`,1 AS `TMID`,1 AS `transientBucketId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_imaging_ssdr3`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_imaging_ssdr3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_imaging_ssdr3` AS select 1 AS `ABMAGLIM`,1 AS `ABMAGSAT`,1 AS `AIRMASS`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `ASTROMET`,1 AS `astromet_error_arcsec`,1 AS `astromet_rmsx`,1 AS `astromet_rmsy`,1 AS `astromet_sources`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `filetype_key_calibration`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `GAIN`,1 AS `isInTransientBucket`,1 AS `MBKG`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NTID`,1 AS `OBJECT`,1 AS `PHOTSYS`,1 AS `PHOTZP`,1 AS `PHOTZPER`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `PROV17`,1 AS `PROV18`,1 AS `PROV19`,1 AS `PROV20`,1 AS `PROV21`,1 AS `PROV22`,1 AS `PROV23`,1 AS `PROV24`,1 AS `PROV25`,1 AS `PROV26`,1 AS `PROV27`,1 AS `PROV28`,1 AS `PROV29`,1 AS `PROV30`,1 AS `PROV31`,1 AS `PROV32`,1 AS `PROV33`,1 AS `PROV34`,1 AS `PROV35`,1 AS `PROV36`,1 AS `PROV37`,1 AS `PROV38`,1 AS `PROV39`,1 AS `PROV40`,1 AS `PROV41`,1 AS `PROV42`,1 AS `PROV43`,1 AS `PROV44`,1 AS `PROV45`,1 AS `PROV46`,1 AS `PROV47`,1 AS `PROV48`,1 AS `PROV49`,1 AS `PROV50`,1 AS `PROV51`,1 AS `PROV52`,1 AS `PROV53`,1 AS `PROV54`,1 AS `PROV55`,1 AS `PROV56`,1 AS `PROV57`,1 AS `PROV58`,1 AS `PROV59`,1 AS `PROV60`,1 AS `PSF_FWHM`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `RRELEASE`,1 AS `TEXPTIME`,1 AS `TMID`,1 AS `transientBucketId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_benetti`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_benetti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_benetti` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARC`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CONTNORM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPAXIS`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NC_NSAMPPIX`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_NDSAMPLES`,1 AS `ESO_DET_NDSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_JITTER_WIDTH`,1 AS `ESO_SEQ_NODTHROW`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `PROV2`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `LTV1`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `CD3_3`,1 AS `MAGSTD`,1 AS `CTYPE3`,1 AS `STDNAME`,1 AS `LTM3_3`,1 AS `NCOMBINE`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NUSTEP`,1 AS `WAT3_001`,1 AS `TRACE2`,1 AS `NAXIS3`,1 AS `COMMENT`,1 AS `ESO_INS_LAMP1_NAME`,1 AS `ESO_INS_LAMP1_ST`,1 AS `REFSPEC1`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `PROV3`,1 AS `PROV4`,1 AS `SENSFUN`,1 AS `SENSPHOT`,1 AS `SNR`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV10`,1 AS `PROV9`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `DARKTIME`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `TRACE9`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `IMCMB006`,1 AS `IMCMB007`,1 AS `IMCMB008`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_esophaseiii`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_esophaseiii`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_esophaseiii` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARC`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CONTNORM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPAXIS`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NC_NSAMPPIX`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_NDSAMPLES`,1 AS `ESO_DET_NDSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_JITTER_WIDTH`,1 AS `ESO_SEQ_NODTHROW`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `PROV2`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `LTV1`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `CD3_3`,1 AS `MAGSTD`,1 AS `CTYPE3`,1 AS `STDNAME`,1 AS `LTM3_3`,1 AS `NCOMBINE`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NUSTEP`,1 AS `WAT3_001`,1 AS `TRACE2`,1 AS `NAXIS3`,1 AS `COMMENT`,1 AS `ESO_INS_LAMP1_NAME`,1 AS `ESO_INS_LAMP1_ST`,1 AS `REFSPEC1`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `PROV3`,1 AS `PROV4`,1 AS `SENSFUN`,1 AS `SENSPHOT`,1 AS `SNR`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV10`,1 AS `PROV9`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `DARKTIME`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `TRACE9`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `IMCMB006`,1 AS `IMCMB007`,1 AS `IMCMB008`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_intermediate`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_intermediate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_intermediate` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARC`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CONTNORM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPAXIS`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NC_NSAMPPIX`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_NDSAMPLES`,1 AS `ESO_DET_NDSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_JITTER_WIDTH`,1 AS `ESO_SEQ_NODTHROW`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `PROV2`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `LTV1`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `CD3_3`,1 AS `MAGSTD`,1 AS `CTYPE3`,1 AS `STDNAME`,1 AS `LTM3_3`,1 AS `NCOMBINE`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NUSTEP`,1 AS `WAT3_001`,1 AS `TRACE2`,1 AS `NAXIS3`,1 AS `COMMENT`,1 AS `ESO_INS_LAMP1_NAME`,1 AS `ESO_INS_LAMP1_ST`,1 AS `REFSPEC1`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `PROV3`,1 AS `PROV4`,1 AS `SENSFUN`,1 AS `SENSPHOT`,1 AS `SNR`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV10`,1 AS `PROV9`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `DARKTIME`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `TRACE9`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `IMCMB006`,1 AS `IMCMB007`,1 AS `IMCMB008`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader`,1 AS `archivedLocally` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_raw`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_raw` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARC`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CONTNORM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPAXIS`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NC_NSAMPPIX`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_NDSAMPLES`,1 AS `ESO_DET_NDSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_JITTER_WIDTH`,1 AS `ESO_SEQ_NODTHROW`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `PROV2`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `LTV1`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `CD3_3`,1 AS `MAGSTD`,1 AS `CTYPE3`,1 AS `STDNAME`,1 AS `LTM3_3`,1 AS `NCOMBINE`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NUSTEP`,1 AS `WAT3_001`,1 AS `TRACE2`,1 AS `NAXIS3`,1 AS `COMMENT`,1 AS `ESO_INS_LAMP1_NAME`,1 AS `ESO_INS_LAMP1_ST`,1 AS `REFSPEC1`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `PROV3`,1 AS `PROV4`,1 AS `SENSFUN`,1 AS `SENSPHOT`,1 AS `SNR`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV10`,1 AS `PROV9`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `DARKTIME`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `TRACE9`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `IMCMB006`,1 AS `IMCMB007`,1 AS `IMCMB008`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_reduced`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_reduced`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_reduced` AS select 1 AS `primaryId`,1 AS `AIRMASS`,1 AS `ARC`,1 AS `ARCFILE`,1 AS `BIASSEC`,1 AS `BITPIX`,1 AS `BUNIT`,1 AS `CCDMEANT`,1 AS `CCDPROC`,1 AS `CCDSEC`,1 AS `CD1_1`,1 AS `CD2_2`,1 AS `CDELT1`,1 AS `CDELT2`,1 AS `CHECKSUM`,1 AS `CONTNORM`,1 AS `CROSSTAL`,1 AS `CRPIX1`,1 AS `CRPIX2`,1 AS `CRVAL1`,1 AS `CRVAL2`,1 AS `CTYPE1`,1 AS `CTYPE2`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATASUM`,1 AS `DATE`,1 AS `DATE_OBS`,1 AS `DC_FLAG`,1 AS `DCLOG1`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPAXIS`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EQUINOX`,1 AS `ESO_ADA_ABSROT_END`,1 AS `ESO_ADA_ABSROT_START`,1 AS `ESO_ADA_GUID_DEC`,1 AS `ESO_ADA_GUID_RA`,1 AS `ESO_ADA_GUID_STATUS`,1 AS `ESO_ADA_POSANG`,1 AS `ESO_DET_CHIP_ID`,1 AS `ESO_DET_CHIP_NAME`,1 AS `ESO_DET_CHIP_NX`,1 AS `ESO_DET_CHIP_NY`,1 AS `ESO_DET_CHIP_PXSPACE`,1 AS `ESO_DET_CHIP_TYPE`,1 AS `ESO_DET_CHOP_CYCSKIP`,1 AS `ESO_DET_CHOP_FREQ`,1 AS `ESO_DET_CHOP_NCYCLES`,1 AS `ESO_DET_CHOP_ST`,1 AS `ESO_DET_CON_OPMODE`,1 AS `ESO_DET_DID`,1 AS `ESO_DET_DIT`,1 AS `ESO_DET_DITDELAY`,1 AS `ESO_DET_EXP_NAME`,1 AS `ESO_DET_EXP_NO`,1 AS `ESO_DET_EXP_UTC`,1 AS `ESO_DET_FILE_CUBE_ST`,1 AS `ESO_DET_FRAM_NO`,1 AS `ESO_DET_FRAM_TYPE`,1 AS `ESO_DET_FRAM_UTC`,1 AS `ESO_DET_IRACE_ADC1_DELAY`,1 AS `ESO_DET_IRACE_ADC1_ENABLE`,1 AS `ESO_DET_IRACE_ADC1_FILTER1`,1 AS `ESO_DET_IRACE_ADC1_FILTER2`,1 AS `ESO_DET_IRACE_ADC1_HEADER`,1 AS `ESO_DET_IRACE_ADC1_NAME`,1 AS `ESO_DET_IRACE_SEQCONT`,1 AS `ESO_DET_MODE_NAME`,1 AS `ESO_DET_NC_NSAMPPIX`,1 AS `ESO_DET_NCORRS`,1 AS `ESO_DET_NCORRS_NAME`,1 AS `ESO_DET_NDIT`,1 AS `ESO_DET_NDITSKIP`,1 AS `ESO_DET_NDSAMPLES`,1 AS `ESO_DET_NDSKIP`,1 AS `ESO_DET_RSPEED`,1 AS `ESO_DET_RSPEEDADD`,1 AS `ESO_DET_WIN_NX`,1 AS `ESO_DET_WIN_NY`,1 AS `ESO_DET_WIN_STARTX`,1 AS `ESO_DET_WIN_STARTY`,1 AS `ESO_DET_WIN_TYPE`,1 AS `ESO_DPR_CATG`,1 AS `ESO_DPR_TECH`,1 AS `ESO_DPR_TYPE`,1 AS `ESO_INS_COLLIM_ENC`,1 AS `ESO_INS_DID`,1 AS `ESO_INS_FILT1_ID`,1 AS `ESO_INS_FILT1_NAME`,1 AS `ESO_INS_FILT1_NO`,1 AS `ESO_INS_FILT1_TYPE`,1 AS `ESO_INS_FILT2_ID`,1 AS `ESO_INS_FILT2_NAME`,1 AS `ESO_INS_FILT2_NO`,1 AS `ESO_INS_FILT2_TYPE`,1 AS `ESO_INS_ID`,1 AS `ESO_INS_MODE`,1 AS `ESO_INS_OPTI1_ID`,1 AS `ESO_INS_OPTI1_NAME`,1 AS `ESO_INS_OPTI1_NO`,1 AS `ESO_INS_OPTI1_TYPE`,1 AS `ESO_INS_OPTI2_ID`,1 AS `ESO_INS_OPTI2_NAME`,1 AS `ESO_INS_OPTI2_NO`,1 AS `ESO_INS_OPTI2_TYPE`,1 AS `ESO_INS_OPTI3_ID`,1 AS `ESO_INS_OPTI3_NAME`,1 AS `ESO_INS_OPTI3_NO`,1 AS `ESO_INS_OPTI3_TYPE`,1 AS `ESO_INS_PIXSCALE`,1 AS `ESO_INS_SWSIM`,1 AS `ESO_INS_TEMP_DETSW`,1 AS `ESO_INS_TEMP_DETSW_SET`,1 AS `ESO_INS_TEMP_MON_NAME1`,1 AS `ESO_INS_TEMP_MON_NAME10`,1 AS `ESO_INS_TEMP_MON_NAME2`,1 AS `ESO_INS_TEMP_MON_NAME3`,1 AS `ESO_INS_TEMP_MON_NAME4`,1 AS `ESO_INS_TEMP_MON_NAME5`,1 AS `ESO_INS_TEMP_MON_NAME6`,1 AS `ESO_INS_TEMP_MON_NAME7`,1 AS `ESO_INS_TEMP_MON_NAME8`,1 AS `ESO_INS_TEMP_MON_NAME9`,1 AS `ESO_INS_TEMP_MON_TEMP1`,1 AS `ESO_INS_TEMP_MON_TEMP10`,1 AS `ESO_INS_TEMP_MON_TEMP2`,1 AS `ESO_INS_TEMP_MON_TEMP3`,1 AS `ESO_INS_TEMP_MON_TEMP4`,1 AS `ESO_INS_TEMP_MON_TEMP5`,1 AS `ESO_INS_TEMP_MON_TEMP6`,1 AS `ESO_INS_TEMP_MON_TEMP7`,1 AS `ESO_INS_TEMP_MON_TEMP8`,1 AS `ESO_INS_TEMP_MON_TEMP9`,1 AS `ESO_INS_TEMP_VACP`,1 AS `ESO_INS_TIME`,1 AS `ESO_OBS_DID`,1 AS `ESO_OBS_EXECTIME`,1 AS `ESO_OBS_GRP`,1 AS `ESO_OBS_ID`,1 AS `ESO_OBS_NAME`,1 AS `ESO_OBS_OBSERVER`,1 AS `ESO_OBS_PI_COI_ID`,1 AS `ESO_OBS_PI_COI_NAME`,1 AS `ESO_OBS_PROG_ID`,1 AS `ESO_OBS_START`,1 AS `ESO_OBS_TARG_NAME`,1 AS `ESO_OBS_TPLNO`,1 AS `ESO_OCS_COMP_ID`,1 AS `ESO_OCS_DID`,1 AS `ESO_OCS_SELECT_ARM`,1 AS `ESO_SEQ_CUMOFFSETX`,1 AS `ESO_SEQ_JITTER_WIDTH`,1 AS `ESO_SEQ_NODTHROW`,1 AS `ESO_SEQ_RELOFFSETX`,1 AS `ESO_TEL_AIRM_END`,1 AS `ESO_TEL_AIRM_START`,1 AS `ESO_TEL_ALT`,1 AS `ESO_TEL_AMBI_FWHM_END`,1 AS `ESO_TEL_AMBI_FWHM_START`,1 AS `ESO_TEL_AMBI_PRES_END`,1 AS `ESO_TEL_AMBI_PRES_START`,1 AS `ESO_TEL_AMBI_RHUM`,1 AS `ESO_TEL_AMBI_TEMP`,1 AS `ESO_TEL_AMBI_WINDDIR`,1 AS `ESO_TEL_AMBI_WINDSP`,1 AS `ESO_TEL_AZ`,1 AS `ESO_TEL_CHOP_ST`,1 AS `ESO_TEL_DATE`,1 AS `ESO_TEL_DID`,1 AS `ESO_TEL_DOME_STATUS`,1 AS `ESO_TEL_FOCU_ID`,1 AS `ESO_TEL_FOCU_LEN`,1 AS `ESO_TEL_FOCU_SCALE`,1 AS `ESO_TEL_FOCU_VALUE`,1 AS `ESO_TEL_GEOELEV`,1 AS `ESO_TEL_GEOLAT`,1 AS `ESO_TEL_GEOLON`,1 AS `ESO_TEL_ID`,1 AS `ESO_TEL_MOON_DEC`,1 AS `ESO_TEL_MOON_RA`,1 AS `ESO_TEL_OPER`,1 AS `ESO_TEL_PARANG_END`,1 AS `ESO_TEL_PARANG_START`,1 AS `ESO_TEL_TARG_ALPHA`,1 AS `ESO_TEL_TARG_COORDTYPE`,1 AS `ESO_TEL_TARG_DELTA`,1 AS `ESO_TEL_TARG_EPOCH`,1 AS `ESO_TEL_TARG_EPOCHSYSTEM`,1 AS `ESO_TEL_TARG_EQUINOX`,1 AS `ESO_TEL_TARG_PARALLAX`,1 AS `ESO_TEL_TARG_PMA`,1 AS `ESO_TEL_TARG_PMD`,1 AS `ESO_TEL_TARG_RADVEL`,1 AS `ESO_TEL_TH_M1_TEMP`,1 AS `ESO_TEL_TRAK_STATUS`,1 AS `ESO_TEL_TSS_TEMP8`,1 AS `ESO_TPL_DID`,1 AS `ESO_TPL_EXPNO`,1 AS `ESO_TPL_ID`,1 AS `ESO_TPL_NAME`,1 AS `ESO_TPL_NEXP`,1 AS `ESO_TPL_PRESEQ`,1 AS `ESO_TPL_START`,1 AS `ESO_TPL_VERSION`,1 AS `EXPTIME`,1 AS `EXTEND`,1 AS `EXT_OBJ`,1 AS `FILETYPE`,1 AS `FILTER`,1 AS `FLATCOR`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `INSTRUME`,1 AS `IRAF_TLM`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `LST`,1 AS `LTM1_1`,1 AS `LTM2_2`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `M_EPOCH`,1 AS `NAXIS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NDIT`,1 AS `OBID1`,1 AS `OBJECT`,1 AS `OBSERVER`,1 AS `OBSTECH`,1 AS `ORIGFILE`,1 AS `ORIGIN`,1 AS `PI_COI`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROG_ID`,1 AS `PROV1`,1 AS `PROV2`,1 AS `QUALITY`,1 AS `RA`,1 AS `RADECSYS`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SIMPLE`,1 AS `SINGLEXP`,1 AS `SKYSUB`,1 AS `SPECSYS`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_SYE`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TELESCOP`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `TOT_FLUX`,1 AS `TRACE1`,1 AS `TRIM`,1 AS `UTC`,1 AS `VOCLASS`,1 AS `VOPUB`,1 AS `WAT0_001`,1 AS `WAT1_001`,1 AS `WAT2_001`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `WCSDIM`,1 AS `XMAX`,1 AS `XMIN`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `dateLastRead`,1 AS `filePath`,1 AS `filename`,1 AS `headerExtension`,1 AS `CCDMEAN`,1 AS `ESO_OCS_WCS_RTD_ST`,1 AS `LTV1`,1 AS `PC1_1`,1 AS `PC1_2`,1 AS `PC2_1`,1 AS `PC2_2`,1 AS `APERTURE`,1 AS `APNUM1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `CD3_3`,1 AS `MAGSTD`,1 AS `CTYPE3`,1 AS `STDNAME`,1 AS `LTM3_3`,1 AS `NCOMBINE`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `NUSTEP`,1 AS `WAT3_001`,1 AS `TRACE2`,1 AS `NAXIS3`,1 AS `COMMENT`,1 AS `ESO_INS_LAMP1_NAME`,1 AS `ESO_INS_LAMP1_ST`,1 AS `REFSPEC1`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `PROV3`,1 AS `PROV4`,1 AS `SENSFUN`,1 AS `SENSPHOT`,1 AS `SNR`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV10`,1 AS `PROV9`,1 AS `TRACE3`,1 AS `TRACE4`,1 AS `TRACE5`,1 AS `TRACE6`,1 AS `TRACE7`,1 AS `TRACE8`,1 AS `DARKTIME`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `TRACE10`,1 AS `TRACE11`,1 AS `TRACE12`,1 AS `TRACE13`,1 AS `TRACE14`,1 AS `TRACE15`,1 AS `TRACE16`,1 AS `TRACE9`,1 AS `IMCMB001`,1 AS `IMCMB002`,1 AS `IMCMB003`,1 AS `IMCMB004`,1 AS `IMCMB005`,1 AS `IMCMB006`,1 AS `IMCMB007`,1 AS `IMCMB008`,1 AS `filetype_key_instrument`,1 AS `filetype_key_image_or_spectrum`,1 AS `filetype_key_reduction_stage`,1 AS `filetype_key_calibration`,1 AS `transientBucketId`,1 AS `nameChangeRequired`,1 AS `esoPhaseIII`,1 AS `updatedFilename`,1 AS `filenameUpdated`,1 AS `objectInFilename`,1 AS `updateObjectName`,1 AS `binary_table_associated_spectrum_id`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `updatedFilepath`,1 AS `archivePath`,1 AS `rewriteFitsHeader` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_ssdr1`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_ssdr1` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `nelem`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `XMAX`,1 AS `XMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_ssdr2`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_ssdr2` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `nelem`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `XMAX`,1 AS `XMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_sofi_spectra_ssdr3`
--

/*!50001 DROP VIEW IF EXISTS `view_sofi_spectra_ssdr3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_sofi_spectra_ssdr3` AS select 1 AS `AIRMASS`,1 AS `APERTURE`,1 AS `ASSOC1`,1 AS `ASSON1`,1 AS `BANDID1`,1 AS `BANDID2`,1 AS `BANDID3`,1 AS `BANDID4`,1 AS `binary_table_associated_spectrum_id`,1 AS `BITPIX`,1 AS `currentFilename`,1 AS `currentFilepath`,1 AS `DATA_REL`,1 AS `DATAMAX`,1 AS `DATAMIN`,1 AS `DATE_OBS`,1 AS `dateCreated`,1 AS `DECL`,1 AS `DETRON`,1 AS `DISPELEM`,1 AS `DIT`,1 AS `EFFRON`,1 AS `esoPhaseIII`,1 AS `EXPTIME`,1 AS `filename`,1 AS `filesize`,1 AS `FILTER`,1 AS `FLUXCAL`,1 AS `FLUXERR`,1 AS `GAIN`,1 AS `LAMNLIN`,1 AS `LAMRMS`,1 AS `MJD_END`,1 AS `MJD_OBS`,1 AS `NAXIS1`,1 AS `NAXIS2`,1 AS `NCOMBINE`,1 AS `NDIT`,1 AS `nelem`,1 AS `NJITTER`,1 AS `NOFFSETS`,1 AS `OBJECT`,1 AS `PI_COI`,1 AS `primaryId`,1 AS `PROCSOFT`,1 AS `PRODCATG`,1 AS `PROV1`,1 AS `PROV10`,1 AS `PROV11`,1 AS `PROV12`,1 AS `PROV13`,1 AS `PROV14`,1 AS `PROV15`,1 AS `PROV16`,1 AS `PROV2`,1 AS `PROV3`,1 AS `PROV4`,1 AS `PROV5`,1 AS `PROV6`,1 AS `PROV7`,1 AS `PROV8`,1 AS `PROV9`,1 AS `QUALITY`,1 AS `RA`,1 AS `REFERENC`,1 AS `SHIFT`,1 AS `SNR`,1 AS `SPEC_BIN`,1 AS `SPEC_BW`,1 AS `SPEC_ERR`,1 AS `SPEC_RES`,1 AS `SPEC_VAL`,1 AS `TELAPSE`,1 AS `TEXPTIME`,1 AS `TITLE`,1 AS `TMID`,1 AS `transientBucketId`,1 AS `WAVELMAX`,1 AS `WAVELMIN`,1 AS `XMAX`,1 AS `XMIN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_tns_photometry_discoveries`
--

/*!50001 DROP VIEW IF EXISTS `view_tns_photometry_discoveries`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_tns_photometry_discoveries` AS select 1 AS `raDeg`,1 AS `decDeg`,1 AS `objectName`,1 AS `survey`,1 AS `suggestedType`,1 AS `hostRedshift` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_transientbucketmaster`
--

/*!50001 DROP VIEW IF EXISTS `view_transientbucketmaster`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_transientbucketmaster` AS select 1 AS `primaryKeyId`,1 AS `transientBucketId`,1 AS `masterIDFlag`,1 AS `name`,1 AS `survey`,1 AS `raDeg`,1 AS `decDeg`,1 AS `raDegErr`,1 AS `decDegErr`,1 AS `observationDate`,1 AS `observationMJD`,1 AS `magnitude`,1 AS `magnitudeError`,1 AS `filter`,1 AS `transientRedshift`,1 AS `transientRedshiftNotes`,1 AS `spectralType`,1 AS `discoveryPhase`,1 AS `dateCreated`,1 AS `dateLastModified`,1 AS `surveyObjectUrl`,1 AS `transientTypePrediction`,1 AS `transientTypePredicationSource`,1 AS `hostRedshift`,1 AS `hostRedshiftType`,1 AS `referenceImageUrl`,1 AS `targetImageUrl`,1 AS `subtractedImageUrl`,1 AS `tripletImageUrl`,1 AS `htm20ID`,1 AS `htm16ID`,1 AS `cx`,1 AS `cy`,1 AS `cz`,1 AS `telescope`,1 AS `instrument`,1 AS `reducer`,1 AS `lastNonDetectionDate`,1 AS `lastNonDetectionMJD`,1 AS `dateLastRead`,1 AS `finderImageUrl`,1 AS `lightcurveURL` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_wiserep_object_summaries`
--

/*!50001 DROP VIEW IF EXISTS `view_wiserep_object_summaries`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `view_wiserep_object_summaries` AS select 1 AS `transientBucketId`,1 AS `name`,1 AS `survey`,1 AS `raDeg`,1 AS `decDeg`,1 AS `spectralType`,1 AS `transientRedshift` */;
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

-- Dump completed on 2020-05-26 12:17:48
-- MySQL dump 10.13  Distrib 5.7.26, for macos10.14 (x86_64)
--
-- Host: localhost    Database: marshall
-- ------------------------------------------------------
-- Server version	5.7.26

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
-- Table structure for table `meta_workflow_lists_counts`
--

DROP TABLE IF EXISTS `meta_workflow_lists_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_workflow_lists_counts` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `listname` varchar(100) DEFAULT NULL,
  `count` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `primaryId_UNIQUE` (`primaryId`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `listname_unique` (`listname`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta_workflow_lists_counts`
--

LOCK TABLES `meta_workflow_lists_counts` WRITE;
/*!40000 ALTER TABLE `meta_workflow_lists_counts` DISABLE KEYS */;
INSERT INTO `meta_workflow_lists_counts` VALUES (1,'archive',0),(2,'following',0),(3,'followup complete',0),(4,'review for followup',0),(5,'pending observation',0),(6,'inbox',0),(7,'external alert released',0),(8,'pending classification',0),(9,'pessto classification released',0),(10,'archived without alert',0),(11,'queued for atel',0),(17,'classified',0),(19,'all',0),(20,'snoozed',0);
/*!40000 ALTER TABLE `meta_workflow_lists_counts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webapp_users`
--

DROP TABLE IF EXISTS `webapp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webapp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(100) NOT NULL,
  `secondname` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL DEFAULT '$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1',
  `permissions` varchar(45) NOT NULL DEFAULT 'edit_users',
  PRIMARY KEY (`id`) KEY_BLOCK_SIZE=1024,
  UNIQUE KEY `first_second` (`firstname`,`secondname`) KEY_BLOCK_SIZE=1024
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webapp_users`
--

LOCK TABLES `webapp_users` WRITE;
/*!40000 ALTER TABLE `webapp_users` DISABLE KEYS */;
INSERT INTO `webapp_users` VALUES (1,'yen-chen','pan','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(2,'alejandro','clocchiatt','noaccess','edit_users'),(3,'nicolas','jerkstrand','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(4,'anders','nyholm','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(5,'andrea','pastorello','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(6,'andy','howell','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(8,'antonia','morales-garoffolo','noaccess','edit_users'),(9,'ariel','goobar','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(10,'armin','rest','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(11,'Assaf','Sternberg','noaccess','edit_users'),(12,'avet','harutyunyan','noaccess','edit_users'),(13,'avishay','gal-yam','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(14,'brian','schmidt','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(15,'charlie','baltay','noaccess','edit_users'),(16,'chris','ashall','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(17,'christophe','balland','noaccess','edit_users'),(18,'claes','fransson','noaccess','edit_users'),(19,'claudia','gutierrez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(20,'Cosimo','Inserra','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(21,'cristina','barbarino','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(22,'cristina','knapic','noaccess','edit_users'),(24,'darryl','wright','noaccess','edit_users'),(25,'david','bersier','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(26,'david','rabinowitz','noaccess','edit_users'),(27,'David','Young','$5$rounds=110000$xUZS2oqgUMEL3eSv$.OL5UMZ7lOpDOcZ5LcMZaX.tg/IxZjZeZ/hcapmwcX/','superadmin'),(28,'elisabeth','gall','noaccess','edit_users'),(29,'ellie','hadjiyska','noaccess','edit_users'),(30,'Emille','Ishida','noaccess','edit_users'),(31,'emir','karamehmetoglu','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(32,'emma','riley','noaccess','edit_users'),(33,'emma','walker','noaccess','edit_users'),(34,'enrico','cappellaro','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(35,'eric','hsiao','noaccess','edit_users'),(36,'erkki','kankare','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(37,'fang','yuan','noaccess','edit_users'),(38,'Felipe','Olivares','noaccess','edit_users'),(39,'flora','cellier-holtzem','noaccess','edit_users'),(40,'Francesco','Taddia','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(41,'francisco','forster','noaccess','edit_users'),(42,'franciso','forster','noaccess','edit_users'),(43,'Franz','Bauer','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(44,'Giacomo','Terreran','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(45,'giorgos','dimitriadis','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(46,'Giorgos','Leloudas','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(47,'giuliano','pignata','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(48,'hanindyo','kuncarayakti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(49,'heather','campbell','noaccess','edit_users'),(50,'Iair','Arcavi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(51,'isobel','hook','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(52,'jayne','doe','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(53,'jean-baptiste','marquette','noaccess','edit_users'),(54,'jesper','sollerman','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(55,'joe','anderson','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(56,'joe','lyman','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(57,'Joe','Polshaw','noaccess','edit_users'),(58,'joel','johansson','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(59,'john','danziger','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(60,'john','eldridge','noaccess','edit_users'),(61,'jonathan','mackey','noaccess','edit_users'),(62,'jordi','isern','noaccess','edit_users'),(63,'jose','maza','noaccess','edit_users'),(64,'justyn','maund','noaccess','edit_users'),(65,'Katalin','Takats','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(66,'kate','maguire','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(67,'Ken','Smith','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(68,'laura','greggio','noaccess','edit_users'),(69,'laurent','le-guillou','noaccess','edit_users'),(70,'leonardo','tartaglia','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(71,'letizia','pumo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(72,'linda','astman','noaccess','edit_users'),(73,'lindsay','magill','noaccess','edit_users'),(74,'lluis','galbany','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(75,'luca','zampieri','noaccess','edit_users'),(76,'lukasz','wyrzykowski','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(77,'marco','limongi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(78,'marco','molinaro','noaccess','edit_users'),(79,'marek','kowalski','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(80,'maria','teresa-botticella','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(81,'mario','hamuy','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(82,'mark','huber','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(83,'Mark','Magee','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(84,'mark','sullivan','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(85,'markus','kromer','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(86,'massimo','dall\'ora','no access','edit_users'),(87,'massimo','della-valle','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(88,'massimo','turatto','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(89,'mathilde','fleury','noaccess','edit_users'),(90,'matt','mccrum','noaccess','edit_users'),(91,'matthew','nicholl','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(92,'mattia','bulla','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(93,'mattias','ergon','noaccess','edit_users'),(94,'max','stritzinger','noaccess','edit_users'),(95,'Michael','Childress','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(96,'michel','dennefeld','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(97,'milena','bufano','noaccess','edit_users'),(98,'morgan','fraser','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(99,'nadejda','blagorodnova','noaccess','edit_users'),(100,'nancy','elias-rosa','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(101,'nando','patat','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(102,'neil','meharg','noaccess','edit_users'),(103,'nicholas','walton','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(104,'nicolas','regnault','noaccess','edit_users'),(105,'norbert','langer','noaccess','edit_users'),(106,'ofer','yaron','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(107,'Paolo','Mazzali','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(108,'peter','lundqvist','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(109,'peter','nugent','noaccess','edit_users'),(110,'phil','james','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(111,'Philipp','Podsiadlowski','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(112,'pierre-francois','leget','noaccess','edit_users'),(113,'pignata','giuliano','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(114,'rahman','amanullah','noaccess','edit_users'),(115,'reynald','pain','noaccess','edit_users'),(116,'ricardo','smareglia','noaccess','edit_users'),(117,'richard','scalzo','noaccess','edit_users'),(118,'robert','firth','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(119,'rubina','kotak','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(120,'sandra','benitez','noaccess','edit_users'),(121,'santiago','gonzalez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(122,'sebastien','bongard','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(123,'seppo','mattila','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(124,'simon','hodgkin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(125,'sina','rostami','noaccess','edit_users'),(126,'stefan','taubenberger','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(127,'stefano','benetti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(128,'Stefano','Valenti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(129,'stephan','hachinger','noaccess','edit_users'),(130,'stephane','blondin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(131,'Stephen','Smartt','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(132,'steve','schulze','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(133,'steven','margheim','noaccess','edit_users'),(134,'stuart','sim','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(135,'susanna','spiro','noaccess','edit_users'),(136,'sylvain','baumont','noaccess','edit_users'),(137,'Thomas','De','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(138,'Ting-Wan','Chen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(139,'tuomas','kangas','noaccess','edit_users'),(140,'ulrich','feindt','noaccess','edit_users'),(141,'Vahagn','Harutyunyan','noaccess','edit_users'),(142,'vallery','stanishev','noaccess','edit_users'),(143,'wolfgang','hillebrandt','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(145,'griffin','hosseinzadeh','noaccess','edit_users'),(147,'nicolas','chotard','noaccess','edit_users'),(149,'fang','huang','noaccess','edit_users'),(151,'marine','ducrot','noaccess','edit_users'),(153,'matt','smith','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(155,'jussi','harmanen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(157,'christoffer','fremling','noaccess','edit_users'),(159,'john','doe','noaccess','edit_users'),(161,'mikael','normann','noaccess','edit_users'),(163,'katia','migotto','noaccess','edit_users'),(165,'lina','tomasella','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(167,'paula','zelaya','noaccess','edit_users'),(169,'sergio','campana','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(171,'chris','frohmaier','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(173,'natasha','karpenka','noaccess','edit_users'),(175,'regis','cartier','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(177,'szymon','prajs','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(179,'ken','chambers','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(181,'steven','williams','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(183,'assaf','horesh','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(185,'heather','flewelling','noaccess','edit_users'),(186,'alessandro','razza','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(187,'ismael','pessa','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(188,'tania','moraga','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(189,'claudia','agliozzo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(190,'patrice','bouchet','noaccess','edit_users'),(191,'simon','prentice','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(192,'thomas','de.jaeger','noaccess','edit_users'),(193,'kate','furnell','noaccess','edit_users'),(194,'john','tonry','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(195,'larry','denneau','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(196,'andrei','sherst','noaccess','edit_users'),(197,'brian','stalder','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(198,'aren','heinze','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(200,'michele','sasdelli','noaccess','edit_users'),(201,'remy.le','breton','noaccess','edit_users'),(202,'ilan','manulis','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(203,'ayan','mitra','noaccess','edit_users'),(204,'aleksandar','cikota','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(205,'tamar','faran','noaccess','edit_users'),(206,'peter','jonker','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(207,'nancy','ellman','noaccess','edit_users'),(208,'curtis','mccully','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(209,'ira','bar','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(211,'anais','moller','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(212,'brad','tucker','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(213,'tom','reynolds','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(214,'ashley','ruiter','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(215,'ivo','seitenzahl','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(216,'bonnie','zhang','noaccess','edit_users'),(217,'lawrence','short','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(218,'michael','coughlin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(219,'peter','clark','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(220,'miika','pursiainen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(221,'pilar','ruiz-lapuente','noaccess','edit_users'),(222,'azalee','bostroem','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(223,'lixin','yu','noaccess','edit_users'),(224,'lingzhi','wang','noaccess','edit_users'),(225,'osmar','rodriguez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(226,'david','oneill','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(227,'yongzhi','cai','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(228,'andreas','floers','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(229,'zach','cano','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(230,'silvia','piranomonte','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(231,'francesca','onori','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(232,'aleksandra','hamanowicz','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(233,'rupak','roy','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(234,'paolo','davanzo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(235,'eliana','palazzi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(236,'giacomo','cannizzaro','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(237,'mariusz','gromadzki','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(238,'jan','bolmer','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(239,'stefano','covino','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(240,'frederic','daigne','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(241,'valerio','d.elia','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(242,'kasper.elm','heintz','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(243,'andrea','melandri','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(244,'jesse','palmerio','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(245,'andrea','rossi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(246,'boris','sbarufatti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(247,'pat','schady','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(248,'giulia','stratta','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(249,'gianpiero','tagliaferri','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(250,'susanna','vergani','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(251,'luca','izzo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(252,'krzysztof','rybicki','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(253,'daniel','kusters','noaccess','edit_users'),(254,'marica','branchesi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(258,'nicola','masetti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(259,'jakob','nordin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(260,'anna','franckowiak','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(262,'mickael','rigault','noaccess','edit_users'),(264,'nora','strotjohann','noaccess','edit_users'),(265,'valery','brinnel','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(266,'jakob','van.santen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(267,'matteo','giomi','noaccess','edit_users'),(270,'paul','groot','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(271,'enzo','brocato','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(272,'zuzanna','kostrzewa','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(273,'luke','shingles','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(274,'maria','patterson','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(275,'tim','naylor','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(276,'carlos','contreras','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(277,'roberta','carini','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(278,'david','homan','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(279,'christian','vogl','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(280,'zhitong','li','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(281,'annalisa','de.cia','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(282,'filomena','bufano','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(283,'marco','berton','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(284,'elena','mason','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(285,'paolo','ochner','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(286,'andy','lawrence','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(287,'charlotte','angus','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(288,'luc','dessart','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(289,'daniel','perley','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(292,'zhihao','chen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(293,'nikola','knezevic','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(294,'owen','mcbrien','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(295,'dave','morris','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(296,'emma','callis','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(297,'phil','wiseman','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(298,'roy','williams','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(299,'daniele','malesani','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(300,'lana','salmon','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(301,'antonio','martin.carrillo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(302,'lorraine','hanlon','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(303,'david','murphy','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(304,'david','sand','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(305,'ruoyu','zhu','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(306,'achille','fiore','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(307,'kristhell','lopez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(312,'christa','gall','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(313,'wolfgang','kerzendorf','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(314,'shane','moran','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(315,'sadie','jones','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(316,'thomas','wevers','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(317,'john','lightfoot','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(318,'enrico','congiu','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(319,'adam','rubin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(320,'massimiliano','de.pasquale','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(321,'priscila','pessi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(322,'maayane.tamar','soumag','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(323,'daichi','hiramatsu','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(324,'jamie','burke','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(325,'tomas','muller','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(326,'robert','stein','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(327,'noel','castro.segura','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(328,'matthew','grayling','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(329,'philip','short','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(330,'tassilo','schweyer','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(331,'matt','nicholl','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(332,'jen','hjorth','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(333,'ilya','mandel','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(334,'felipe','olivares.estay','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(335,'jonathan','pineda','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(336,'andrea','reguitti','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(337,'jens','hjorth','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(338,'ana','sagues.carracedo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(339,'sasha','kozyreva','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(340,'fabio','ragosta','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(341,'kelly','skillen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(344,'deepak','eappachen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(350,'maria','vincenzi','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(351,'craig','pellegrino','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(352,'lisa','kelsey','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(353,'sean','brennan','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(354,'barnabas','barna','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(355,'jacob','teffs','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(361,'nada','ihanec','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(362,'ignacio','sanchez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(363,'elizabeth','swann','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(365,'ido','irani','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(366,'teppo','heikkila','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(367,'marco','landoni','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(368,'shubham','srivastav','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(369,'nico','meza','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(370,'laureano','martinez','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(371,'takashi','nagao','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(372,'jose','prieto','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(373,'juanita','antilen','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(374,'yize','dong','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(375,'michael','lundquist','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(376,'jennifer','andrews','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(377,'sam','wyatt','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(378,'rachael','amaro','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(379,'emmanouela','paraskeva','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(380,'kuntal','mistra','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(382,'samantha','goldwasser','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(383,'miguel','perez-torres','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(384,'matthew','temple','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(387,'meg','schwamb','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(388,'rachel','bruch','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(391,'james','gillanders','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(394,'panos','charalampopoulos','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(395,'eleonora','parrag','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(396,'michael','fulton','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(397,'giorgio','valerin','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(398,'pietro','schipani','$5$rounds=535000$HFlOOKhWYrcCGuB9$qPERc0JMQ8Rp4GOECwBxMHR7BLua1jqVRXgR4YJlUV6','view_users'),(399,'kyle','medler','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(400,'cristina','cristina','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(401,'emma','reilly','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(402,'nicolas','meza','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(403,'erez','zimmerman','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(404,'melissa','amenouche','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(406,'maxime','deckers','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(407,'arianna','zanon','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(409,'antonia','morales.garoffolo','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(410,'kuntal','misra','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(411,'anne','inkenhaag','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(412,'quinn','wang','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users'),(413,'ryan','ridden.harper','$5$rounds=110000$MAKWStjFVWb2dqhG$oqBc8072dGM.mtWRmEFQ.WnhSZ79hn9yphtE8QflxT1','edit_users');
/*!40000 ALTER TABLE `webapp_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marshall_fs_column_map`
--

DROP TABLE IF EXISTS `marshall_fs_column_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marshall_fs_column_map` (
  `primaryId` int(11) NOT NULL AUTO_INCREMENT,
  `fs_table_name` varchar(45) NOT NULL,
  `fs_survey_name` varchar(45) DEFAULT NULL,
  `transientBucket_column` varchar(45) DEFAULT NULL,
  `fs_table_column` varchar(45) NOT NULL,
  PRIMARY KEY (`primaryId`),
  UNIQUE KEY `unquie_fs_table_name_fs_table_column` (`fs_table_name`,`fs_table_column`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marshall_fs_column_map`
--

LOCK TABLES `marshall_fs_column_map` WRITE;
/*!40000 ALTER TABLE `marshall_fs_column_map` DISABLE KEYS */;
INSERT INTO `marshall_fs_column_map` VALUES (18,'fs_asassn_sne','ASAS-SN','observationDate','Date'),(21,'fs_asassn_sne','ASAS-SN','name','ID'),(24,'fs_asassn_sne','ASAS-SN','raDeg','RA'),(28,'fs_asassn_sne','ASAS-SN','magnitude','V_disc'),(29,'fs_asassn_sne','ASAS-SN','decDeg','decl'),(30,'fs_asassn_sne','ASAS-SN','surveyObjectUrl','surveyUrl'),(32,'fs_asassn_transients','ASAS-SN','magnitude','Vmag'),(34,'fs_asassn_transients','ASAS-SN','decDeg','decDeg'),(35,'fs_asassn_transients','ASAS-SN','observationDate','discDate'),(36,'fs_asassn_transients','ASAS-SN','name','name'),(37,'fs_asassn_transients','ASAS-SN','raDeg','raDeg'),(38,'fs_asassn_transients','ASAS-SN','spectralType','specClass'),(40,'fs_asassn_transients','ASAS-SN','surveyObjectUrl','surveyUrl'),(47,'fs_atlas','ATLAS','name','candidateID'),(48,'fs_atlas','ATLAS','raDeg','ra_deg'),(49,'fs_atlas','ATLAS','decDeg','dec_deg'),(50,'fs_atlas','ATLAS','magnitude','mag'),(51,'fs_atlas','ATLAS','magnitudeError','magErr'),(52,'fs_atlas','ATLAS','filter','filter'),(53,'fs_atlas','ATLAS','observationMJD','observationMJD'),(54,'fs_atlas','ATLAS','observationDate','discDate'),(56,'fs_atlas','ATLAS','transientTypePrediction','suggestedType'),(58,'fs_atlas','ATLAS','hostRedshift','hostZ'),(59,'fs_atlas','ATLAS','targetImageUrl','targetImageURL'),(60,'fs_atlas','ATLAS','referenceImageUrl','refImageURL'),(61,'fs_atlas','ATLAS','subtractedImageUrl','diffImageURL'),(62,'fs_atlas','ATLAS','surveyObjectUrl','objectURL'),(79,'fs_atlas_forced_phot','ATLAS FP','name','atlas_designation'),(80,'fs_atlas_forced_phot','ATLAS FP','observationMJD','mjd_obs'),(81,'fs_atlas_forced_phot','ATLAS FP','filter','filter'),(87,'fs_atlas_forced_phot','ATLAS FP','raDeg','raDeg'),(88,'fs_atlas_forced_phot','ATLAS FP','decDeg','decDeg'),(107,'fs_atlas_forced_phot','ATLAS FP','magnitude','marshall_mag'),(108,'fs_atlas_forced_phot','ATLAS FP','limitingMag','marshall_limiting_mag'),(109,'fs_atlas_forced_phot','ATLAS','magnitudeError','marshall_mag_error'),(191,'fs_crts_css','CRTS','decDeg','decDeg'),(192,'fs_crts_css','CRTS','filter','filter'),(193,'fs_crts_css','CRTS','finderImageUrl','finderChartUrl'),(196,'fs_crts_css','CRTS','lightcurveURL','lightcurveUrl'),(197,'fs_crts_css','CRTS','magnitude','mag'),(198,'fs_crts_css','CRTS','name','name'),(199,'fs_crts_css','CRTS','observationDate','observationDate'),(200,'fs_crts_css','CRTS','observationMJD','observationMJD'),(201,'fs_crts_css','CRTS','raDeg','raDeg'),(202,'fs_crts_css','CRTS','surveyObjectUrl','surveyObjectUrl'),(203,'fs_crts_css','CRTS','targetImageUrl','targetImageUrl'),(204,'fs_crts_css','CRTS','transientTypePrediction','transientTypePrediction'),(206,'fs_crts_css','CRTS','magnitudeError','magErr'),(207,'fs_crts_css','CRTS','lastNonDetectionDate','lastNonDetectionDate'),(208,'fs_crts_css','CRTS','lastNonDetectionMJD','lastNonDetectionMJD'),(222,'fs_crts_mls','CRTS','decDeg','decDeg'),(223,'fs_crts_mls','CRTS','filter','filter'),(224,'fs_crts_mls','CRTS','finderImageUrl','finderChartUrl'),(227,'fs_crts_mls','CRTS','lightcurveURL','lightcurveUrl'),(228,'fs_crts_mls','CRTS','magnitude','mag'),(229,'fs_crts_mls','CRTS','name','name'),(230,'fs_crts_mls','CRTS','observationDate','observationDate'),(231,'fs_crts_mls','CRTS','observationMJD','observationMJD'),(232,'fs_crts_mls','CRTS','raDeg','raDeg'),(233,'fs_crts_mls','CRTS','surveyObjectUrl','surveyObjectUrl'),(234,'fs_crts_mls','CRTS','targetImageUrl','targetImageUrl'),(235,'fs_crts_mls','CRTS','transientTypePrediction','transientTypePrediction'),(237,'fs_crts_mls','CRTS','magnitudeError','magErr'),(238,'fs_crts_mls','CRTS','lastNonDetectionDate','lastNonDetectionDate'),(239,'fs_crts_mls','CRTS','lastNonDetectionMJD','lastNonDetectionMJD'),(253,'fs_crts_sss','CRTS','decDeg','decDeg'),(254,'fs_crts_sss','CRTS','filter','filter'),(255,'fs_crts_sss','CRTS','finderImageUrl','finderChartUrl'),(258,'fs_crts_sss','CRTS','lightcurveURL','lightcurveUrl'),(259,'fs_crts_sss','CRTS','magnitude','mag'),(260,'fs_crts_sss','CRTS','name','name'),(261,'fs_crts_sss','CRTS','observationDate','observationDate'),(262,'fs_crts_sss','CRTS','observationMJD','observationMJD'),(263,'fs_crts_sss','CRTS','raDeg','raDeg'),(264,'fs_crts_sss','CRTS','surveyObjectUrl','surveyObjectUrl'),(265,'fs_crts_sss','CRTS','targetImageUrl','targetImageUrl'),(266,'fs_crts_sss','CRTS','transientTypePrediction','transientTypePrediction'),(268,'fs_crts_sss','CRTS','magnitudeError','magErr'),(269,'fs_crts_sss','CRTS','lastNonDetectionDate','lastNonDetectionDate'),(270,'fs_crts_sss','CRTS','lastNonDetectionMJD','lastNonDetectionMJD'),(280,'fs_des','DES','decDeg','decDeg'),(281,'fs_des','DES','filter','filter'),(282,'fs_des','DES','lastNonDetectionDate','lastNonDetectionDate'),(283,'fs_des','DES','lastNonDetectionMJD','lastNonDetectionMJD'),(284,'fs_des','DES','limitingMag','limitingMag'),(285,'fs_des','DES','magnitude','magnitude'),(286,'fs_des','DES','magnitudeError','magnitudeError'),(287,'fs_des','DES','name','name'),(288,'fs_des','DES','observationDate','observationDate'),(289,'fs_des','DES','observationMJD','observationMJD'),(290,'fs_des','DES','raDeg','raDeg'),(293,'fs_des','DES','surveyObjectUrl','surveyUrl'),(294,'fs_des','DES','transientTypePrediction','transientTypePrediction'),(295,'fs_des','DES','finderImageUrl','finderImageUrl'),(296,'fs_des','DES','subtractedImageUrl','diffUrl'),(297,'fs_des','DES','referenceImageUrl','refUrl'),(298,'fs_des','DES','targetImageUrl','tarUrl'),(311,'fs_gaia','Gaia','name','candidateID'),(312,'fs_gaia','Gaia','decDeg','dec_deg'),(313,'fs_gaia','Gaia','observationDate','discDate'),(315,'fs_gaia','Gaia','filter','filter'),(316,'fs_gaia','Gaia','magnitude','mag'),(317,'fs_gaia','Gaia','surveyObjectUrl','objectURL'),(318,'fs_gaia','Gaia','observationMJD','observationMJD'),(319,'fs_gaia','Gaia','raDeg','ra_deg'),(389,'fs_master','MASTER','tripletImageUrl','imageUrl'),(390,'fs_master','MASTER','magnitude','magnitude'),(392,'fs_master','MASTER','name','name'),(394,'fs_master','MASTER','transientTypePrediction','type'),(395,'fs_master','MASTER','observationMJD','discoveryMjd'),(396,'fs_master','MASTER','decDeg','decDeg'),(397,'fs_master','MASTER','raDeg','raDeg'),(398,'fs_master','MASTER','filter','filter'),(399,'fs_master','MASTER','surveyObjectUrl','candidateUrl'),(420,'fs_ogle','OGLE','decDeg','decDeg'),(421,'fs_ogle','OGLE','filter','filter'),(422,'fs_ogle','OGLE','lastNonDetectionDate','lastNonDetectionDate'),(423,'fs_ogle','OGLE','lastNonDetectionMJD','lastNonDetectionMJD'),(424,'fs_ogle','OGLE','lightcurveURL','lightcurveUrl'),(425,'fs_ogle','OGLE','magnitude','mag'),(426,'fs_ogle','OGLE','name','name'),(427,'fs_ogle','OGLE','observationDate','observationDate'),(428,'fs_ogle','OGLE','observationMJD','observationMJD'),(429,'fs_ogle','OGLE','raDeg','raDeg'),(431,'fs_ogle','OGLE','referenceImageUrl','referenceImageUrl'),(433,'fs_ogle','OGLE','subtractedImageUrl','subtractedImageUrl'),(434,'fs_ogle','OGLE','surveyObjectUrl','surveyObjectUrl'),(436,'fs_ogle','OGLE','targetImageUrl','targetImageUrl'),(437,'fs_ogle','OGLE','transientTypePrediction','transientTypePrediction'),(440,'fs_ogle','OGLE','magnitudeError','magErr'),(441,'fs_ogle','OGLE','limitingMag','limitingMag'),(450,'fs_panstarrs','PanSTARRS','name','candidateID'),(451,'fs_panstarrs','PanSTARRS','raDeg','ra_deg'),(452,'fs_panstarrs','PanSTARRS','decDeg','dec_deg'),(453,'fs_panstarrs','PanSTARRS','magnitude','mag'),(454,'fs_panstarrs','PanSTARRS','magnitudeError','magErr'),(455,'fs_panstarrs','PanSTARRS','filter','filter'),(456,'fs_panstarrs','PanSTARRS','observationMJD','observationMJD'),(457,'fs_panstarrs','PanSTARRS','observationDate','discDate'),(459,'fs_panstarrs','PanSTARRS','transientTypePrediction','suggestedType'),(461,'fs_panstarrs','PanSTARRS','hostRedshift','hostZ'),(462,'fs_panstarrs','PanSTARRS','targetImageUrl','targetImageURL'),(463,'fs_panstarrs','PanSTARRS','referenceImageUrl','refImageURL'),(464,'fs_panstarrs','PanSTARRS','subtractedImageUrl','diffImageURL'),(465,'fs_panstarrs','PanSTARRS','surveyObjectUrl','objectURL'),(481,'fs_skymapper','SkyMapper','decDeg','DECL'),(482,'fs_skymapper','SkyMapper','raDeg','RA'),(483,'fs_skymapper','SkyMapper','transientTypePrediction','bestType'),(484,'fs_skymapper','SkyMapper','name','candidateID'),(485,'fs_skymapper','SkyMapper','surveyObjectUrl','candidateURL'),(488,'fs_skymapper','SkyMapper','subtractedImageUrl','diffThumbURL'),(492,'fs_skymapper','SkyMapper','filter','filt'),(493,'fs_skymapper','SkyMapper','magnitude','mag'),(494,'fs_skymapper','SkyMapper','magnitudeError','magerr'),(495,'fs_skymapper','SkyMapper','observationMJD','mjd'),(496,'fs_skymapper','SkyMapper','targetImageUrl','newThumbURL'),(498,'fs_skymapper','SkyMapper','lastNonDetectionMJD','noneMJD'),(501,'fs_skymapper','SkyMapper','referenceImageUrl','refThumbURL'),(512,'fs_tns_transients',NULL,'decDeg','decDeg'),(514,'fs_tns_transients',NULL,'observationDate','discDate'),(515,'fs_tns_transients',NULL,'magnitude','discMag'),(516,'fs_tns_transients',NULL,'filter','discMagFilter'),(519,'fs_tns_transients',NULL,'hostRedshift','hostRedshift'),(520,'fs_tns_transients',NULL,'name','objectName'),(521,'fs_tns_transients',NULL,'surveyObjectUrl','objectUrl'),(522,'fs_tns_transients',NULL,'raDeg','raDeg'),(525,'fs_tns_transients',NULL,'spectralType','specType'),(526,'fs_tns_transients',NULL,'transientRedshift','transRedshift'),(527,'fs_tns_transients',NULL,'lastNonDetectionDate','lastNonDetectionDate'),(530,'fs_tns_transients',NULL,'lastNonDetectionDate','lastNonDetectionDateParsed'),(558,'fs_user_added',NULL,'name','candidateID'),(559,'fs_user_added',NULL,'raDeg','ra_deg'),(560,'fs_user_added',NULL,'decDeg','dec_deg'),(561,'fs_user_added',NULL,'magnitude','mag'),(562,'fs_user_added',NULL,'magnitudeError','magErr'),(563,'fs_user_added',NULL,'filter','filter'),(564,'fs_user_added',NULL,'observationMJD','observationMJD'),(565,'fs_user_added',NULL,'observationDate','discDate'),(567,'fs_user_added',NULL,'transientTypePrediction','suggestedType'),(569,'fs_user_added',NULL,'hostRedshift','hostZ'),(570,'fs_user_added',NULL,'targetImageUrl','targetImageURL'),(571,'fs_user_added',NULL,'surveyObjectUrl','objectURL'),(589,'fs_ztf','ZTF','name','objectId'),(590,'fs_ztf','ZTF','raDeg','raDeg'),(591,'fs_ztf','ZTF','decDeg','decDeg'),(592,'fs_ztf','ZTF','observationMJD','mjd'),(594,'fs_ztf','ZTF','magnitude','magpsf'),(595,'fs_ztf','ZTF','magnitudeError','sigmapsf'),(600,'fs_ztf','ZTF','filter','filt'),(601,'fs_ztf','ZTF','surveyObjectUrl','surveyUrl'),(602,'fs_ztf','ZTF','tripletImageUrl','tripletImageUrl'),(604,'fs_ztf','ZTF','limitingMag','limitingMag'),(793,'atel_coordinates',NULL,'raDeg','raDeg'),(794,'atel_coordinates',NULL,'decDeg','decDeg'),(798,'atel_coordinates',NULL,'name','atelName'),(799,'atel_coordinates',NULL,'surveyObjectUrl','atelUrl'),(1017,'fs_tns_transients',NULL,'survey','survey'),(1018,'fs_user_added',NULL,'survey','survey'),(1021,'tns_sources','TNS','name','TNSName'),(1022,'tns_sources','TNS','decDeg','decDeg'),(1024,'tns_sources','TNS','observationDate','discDate'),(1025,'tns_sources','TNS','magnitude','discMag'),(1026,'tns_sources','TNS','filter','discMagFilter'),(1029,'tns_sources','TNS','surveyObjectUrl','objectUrl'),(1030,'tns_sources','TNS','raDeg','raDeg'),(1031,'tns_sources','TNS','spectralType','specType'),(1033,'tns_sources','TNS','transientRedshift','transRedshift'),(1035,'tns_sources','TNS','hostRedshift','hostRedshift'),(1040,'tns_spectra',NULL,'observationDate','obsdate'),(1042,'tns_spectra',NULL,'spectralType','specType'),(1044,'tns_spectra',NULL,'transientRedshift','transRedshift'),(1047,'tns_spectra',NULL,'observationMJD','observationMJD'),(1053,'tns_spectra',NULL,'name','TNSName'),(1055,'tns_spectra',NULL,'raDeg','raDeg'),(1056,'tns_spectra',NULL,'decDeg','decDeg'),(1060,'tns_photometry',NULL,'filter','filter'),(1061,'tns_photometry',NULL,'limitingMag','limitingMag'),(1062,'tns_photometry',NULL,'magnitude','mag'),(1063,'tns_photometry',NULL,'magnitudeError','magErr'),(1065,'tns_photometry',NULL,'name','objectName'),(1066,'tns_photometry',NULL,'observationDate','obsdate'),(1069,'tns_photometry',NULL,'survey','survey'),(1072,'tns_photometry',NULL,'observationMJD','observationMJD'),(1088,'tns_spectra',NULL,'survey','survey'),(1089,'tns_photometry',NULL,'raDeg','raDeg'),(1090,'tns_photometry',NULL,'decDeg','decDeg');
/*!40000 ALTER TABLE `marshall_fs_column_map` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-26 12:17:48
