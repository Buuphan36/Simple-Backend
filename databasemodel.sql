-- -----------------------------------------------------
-- Schema HealthcareDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` TINYINT NOT NULL AUTO_INCREMENT,
  `user_firstname` VARCHAR(45) NOT NULL,
  `user_lastname` VARCHAR(45) NOT NULL,
  `user_email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `region` ;

CREATE TABLE IF NOT EXISTS `region` (
  `region_id` TINYINT NOT NULL AUTO_INCREMENT,
  `region_name` VARCHAR(45) NOT NULL,
  `region_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`region_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `account_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account_type` ;

CREATE TABLE IF NOT EXISTS `account_type` (
  `account_type_id` TINYINT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`account_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account` ;

CREATE TABLE IF NOT EXISTS `account` (
  `account_id` TINYINT NOT NULL AUTO_INCREMENT,
  `account_user_id` TINYINT NOT NULL,
  `account_region` TINYINT NOT NULL,
  `account_type` TINYINT NOT NULL,
  `account_create_time` TIMESTAMP NOT NULL,
  `account_password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`account_id`),
  INDEX `account_type_FK_idx` (`account_type` ASC) VISIBLE,
  INDEX `account_region_FK_idx` (`account_region` ASC) VISIBLE,
  INDEX `account_user_id_FK_idx` (`account_user_id` ASC) INVISIBLE,
  CONSTRAINT `account_user_id_FK`
    FOREIGN KEY (`account_user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `account_region_FK`
    FOREIGN KEY (`account_region`)
    REFERENCES `region` (`region_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `account_type_FK`
    FOREIGN KEY (`account_type`)
    REFERENCES `account_type` (`account_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `payment_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `payment_type` ;

CREATE TABLE IF NOT EXISTS `payment_type` (
  `payment_type_id` TINYINT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `zipcode` INT NOT NULL,
  `state` CHAR(2) NOT NULL,
  PRIMARY KEY (`payment_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `billing_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `billing_info` ;

CREATE TABLE IF NOT EXISTS `billing_info` (
  `billing_id` TINYINT NOT NULL AUTO_INCREMENT,
  `user` TINYINT NOT NULL,
  `payment_type` TINYINT NOT NULL,
  `amount` DECIMAL(6,2) NOT NULL,
  INDEX `billing_user_FK_idx` (`user` ASC) VISIBLE,
  PRIMARY KEY (`billing_id`),
  INDEX `billing_payment_type_idx` (`payment_type` ASC) VISIBLE,
  CONSTRAINT `billing_user_FK`
    FOREIGN KEY (`user`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `billing_payment_type`
    FOREIGN KEY (`payment_type`)
    REFERENCES `payment_type` (`payment_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `credit_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `credit_card` ;

CREATE TABLE IF NOT EXISTS `credit_card` (
  `type_id` TINYINT NOT NULL AUTO_INCREMENT,
  `payment_type` TINYINT NOT NULL,
  `card_number` INT NOT NULL,
  `bank_name` VARCHAR(45) NOT NULL,
  `exp_date` DATETIME NOT NULL,
  `cvv` INT NOT NULL,
  PRIMARY KEY (`type_id`, `payment_type`),
  INDEX `credit_card_payment_type_idx` (`payment_type` ASC) VISIBLE,
  CONSTRAINT `credit_card_payment_type_FK`
    FOREIGN KEY (`payment_type`)
    REFERENCES `payment_type` (`payment_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `debit_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `debit_card` ;

CREATE TABLE IF NOT EXISTS `debit_card` (
  `type_id` TINYINT NOT NULL AUTO_INCREMENT,
  `payment_type` TINYINT NOT NULL,
  `card_number` INT NOT NULL,
  `bank_name` VARCHAR(45) NOT NULL,
  `exp_date` DATETIME NOT NULL,
  `cvv` INT NOT NULL,
  PRIMARY KEY (`type_id`, `payment_type`),
  INDEX `debit_card_payment_type_idx` (`payment_type` ASC) VISIBLE,
  CONSTRAINT `debit_card_payment_type_FK`
    FOREIGN KEY (`payment_type`)
    REFERENCES `payment_type` (`payment_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bank_account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bank_account` ;

CREATE TABLE IF NOT EXISTS `bank_account` (
  `type_id` TINYINT NOT NULL AUTO_INCREMENT,
  `payment_type` TINYINT NOT NULL,
  `bank` VARCHAR(45) NOT NULL,
  `routing` INT NOT NULL,
  `acc_number` INT NOT NULL,
  PRIMARY KEY (`type_id`, `payment_type`),
  INDEX `bank_account_payment_type_idx` (`payment_type` ASC) VISIBLE,
  CONSTRAINT `bank_account_payment_type_FK`
    FOREIGN KEY (`payment_type`)
    REFERENCES `payment_type` (`payment_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `healthcare_plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `healthcare_plan` ;

CREATE TABLE IF NOT EXISTS `healthcare_plan` (
  `healthcare_plan_id` TINYINT NOT NULL AUTO_INCREMENT,
  `healthcare_plan_cost` DECIMAL(6,2) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`healthcare_plan_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `available_plans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `available_plans` ;

CREATE TABLE IF NOT EXISTS `available_plans` (
  `available_plans_id` TINYINT NOT NULL AUTO_INCREMENT,
  `account_type` TINYINT NOT NULL,
  `plan` TINYINT NOT NULL,
  PRIMARY KEY (`available_plans_id`),
  INDEX `available_plans_acc_type_idx` (`account_type` ASC) VISIBLE,
  INDEX `available_plans_plan_idx` (`plan` ASC) VISIBLE,
  CONSTRAINT `available_plans_acc_type_FK`
    FOREIGN KEY (`account_type`)
    REFERENCES `account_type` (`account_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `available_plans_plan_FK`
    FOREIGN KEY (`plan`)
    REFERENCES `healthcare_plan` (`healthcare_plan_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `medical_field`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `medical_field` ;

CREATE TABLE IF NOT EXISTS `medical_field` (
  `medical_field_id` TINYINT NOT NULL AUTO_INCREMENT,
  `field_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medical_field_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doctor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `doctor` ;

CREATE TABLE IF NOT EXISTS `doctor` (
  `doctor_id` TINYINT NOT NULL AUTO_INCREMENT,
  `doctor_name` VARCHAR(45) NOT NULL,
  `doctor_specialty` TINYINT NOT NULL,
  PRIMARY KEY (`doctor_id`),
  INDEX `doctor_specialty_FK_idx` (`doctor_specialty` ASC) INVISIBLE,
  CONSTRAINT `doctor_specialty_FK`
    FOREIGN KEY (`doctor_specialty`)
    REFERENCES `medical_field` (`medical_field_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profile` ;

CREATE TABLE IF NOT EXISTS `profile` (
  `profile_id` TINYINT NOT NULL AUTO_INCREMENT,
  `account` TINYINT NOT NULL,
  `alias` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`profile_id`),
  INDEX `profile_account_FK_idx` (`account` ASC) VISIBLE,
  CONSTRAINT `profile_account_FK`
    FOREIGN KEY (`account`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `session` ;

CREATE TABLE IF NOT EXISTS `session` (
  `session_id` TINYINT NOT NULL AUTO_INCREMENT,
  `user` TINYINT NOT NULL,
  `session_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`session_id`),
  INDEX `session_user_FK_idx` (`user` ASC) VISIBLE,
  CONSTRAINT `session_user_FK`
    FOREIGN KEY (`user`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `medical_exam`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `medical_exam` ;

CREATE TABLE IF NOT EXISTS `medical_exam` (
  `medical_exam_id` TINYINT NOT NULL AUTO_INCREMENT,
  `patient` TINYINT NOT NULL,
  `examiner` TINYINT NOT NULL,
  `schedule` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medical_exam_id`),
  INDEX `patient_name_FK_idx` (`patient` ASC) VISIBLE,
  INDEX `examiner_idx` (`examiner` ASC) VISIBLE,
  CONSTRAINT `patient_name_FK`
    FOREIGN KEY (`patient`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `examiner_FK`
    FOREIGN KEY (`examiner`)
    REFERENCES `doctor` (`doctor_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `medical_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `medical_service` ;

CREATE TABLE IF NOT EXISTS `medical_service` (
  `medical_service_id` TINYINT NOT NULL AUTO_INCREMENT,
  `medical_service_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medical_service_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `available_medical_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `available_medical_service` ;

CREATE TABLE IF NOT EXISTS `available_medical_service` (
  `medical_service_id` TINYINT NOT NULL AUTO_INCREMENT,
  `user_id` TINYINT NOT NULL,
  `service_id` TINYINT NOT NULL,
  PRIMARY KEY (`medical_service_id`),
  INDEX `user_id_FK_idx` (`user_id` ASC) VISIBLE,
  INDEX `service_id_FK_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `user_id_FK`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `service_id_FK`
    FOREIGN KEY (`service_id`)
    REFERENCES `medical_service` (`medical_service_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;