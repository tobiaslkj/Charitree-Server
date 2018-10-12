-- MySQL Script generated by MySQL Workbench
-- Fri Oct 12 15:44:59 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Charitree
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Charitree
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Charitree` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `Charitree` ;

-- -----------------------------------------------------
-- Table `Charitree`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`User` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(40) NOT NULL,
  `firstName` VARCHAR(20) NULL,
  `lastName` VARCHAR(20) NULL,
  `password` VARCHAR(80) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`CampaignManager`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`CampaignManager` (
  `cid` INT NOT NULL,
  `UEN` VARCHAR(10) NULL,
  `organizationName` VARCHAR(45) NULL,
  PRIMARY KEY (`cid`),
  INDEX `fk_CampaignManager_User1_idx` (`cid` ASC),
  CONSTRAINT `fk_CampaignManager_User1`
    FOREIGN KEY (`cid`)
    REFERENCES `Charitree`.`User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street_name` VARCHAR(45) NULL,
  `unit` VARCHAR(10) NULL,
  `zip` VARCHAR(6) NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `user_id`),
  INDEX `fk_Address_User1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Address_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `Charitree`.`User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Campaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Campaign` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `CampaginManager_cid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Campaign_CampaignManager1_idx` (`CampaginManager_cid` ASC),
  CONSTRAINT `fk_Campaign_CampaignManager1`
    FOREIGN KEY (`CampaginManager_cid`)
    REFERENCES `Charitree`.`CampaignManager` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Donations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Donations` (
  `User_id` INT NOT NULL,
  `Campaign_id` INT NOT NULL,
  `status` TINYINT(3) NULL,
  `Donationscol` VARCHAR(45) NULL,
  PRIMARY KEY (`User_id`, `Campaign_id`),
  INDEX `fk_User_has_Campaign_Campaign1_idx` (`Campaign_id` ASC),
  INDEX `fk_User_has_Campaign_User1_idx` (`User_id` ASC),
  CONSTRAINT `fk_User_has_Campaign_User1`
    FOREIGN KEY (`User_id`)
    REFERENCES `Charitree`.`User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_Campaign_Campaign1`
    FOREIGN KEY (`Campaign_id`)
    REFERENCES `Charitree`.`Campaign` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Items` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Donations_has_Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Donations_has_Items` (
  `Donations_User_id` INT NOT NULL,
  `Donations_Campaign_id` INT NOT NULL,
  `Items_id` INT NOT NULL,
  `qty` INT NULL,
  PRIMARY KEY (`Donations_User_id`, `Donations_Campaign_id`, `Items_id`),
  INDEX `fk_Donations_has_Items_Items1_idx` (`Items_id` ASC),
  INDEX `fk_Donations_has_Items_Donations1_idx` (`Donations_User_id` ASC, `Donations_Campaign_id` ASC),
  CONSTRAINT `fk_Donations_has_Items_Donations1`
    FOREIGN KEY (`Donations_User_id` , `Donations_Campaign_id`)
    REFERENCES `Charitree`.`Donations` (`User_id` , `Campaign_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Donations_has_Items_Items1`
    FOREIGN KEY (`Items_id`)
    REFERENCES `Charitree`.`Items` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Charitree`.`Session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Charitree`.`Session` (
  `session_id` INT NOT NULL AUTO_INCREMENT,
  `session_token` VARCHAR(60) NULL,
  `session_expire` DATETIME NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`session_id`),
  INDEX `fk_Session_User1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Session_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `Charitree`.`User` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
