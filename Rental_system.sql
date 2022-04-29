DROP DATABASE IF EXISTS `rental_db`;
CREATE DATABASE `rental_db`;
USE `rental_db`;
 
-- Create `vehicles` table
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
   `veh_reg_no`  VARCHAR(8)    NOT NULL,
   `category`    ENUM('car', 'truck')  NOT NULL DEFAULT 'car',  
                 -- Enumeration of one of the items in the list
   `brand`       VARCHAR(30)   NOT NULL DEFAULT '',
   `desc`        VARCHAR(256)  NOT NULL DEFAULT '',
                 -- desc is a keyword (for descending) and must be back-quoted
   `photo`       BLOB          NULL,   -- binary large object of up to 64KB
                 -- to be implemented later
   `daily_rate`  DECIMAL(6,2)  NOT NULL DEFAULT 9999.99,
                 -- set default to max value
   PRIMARY KEY (`veh_reg_no`),
   INDEX (`category`)  -- Build index on this column for fast search
) ENGINE=InnoDB;
   -- MySQL provides a few ENGINEs.
   -- The InnoDB Engine supports foreign keys and transactions
DESC `vehicles`;
SHOW CREATE TABLE `vehicles`;
SHOW INDEX FROM `vehicles`;
 
-- Create `customers` table
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
   `customer_id`  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
                  -- Always use INT for AUTO_INCREMENT column to avoid run-over
   `name`         VARCHAR(30)   NOT NULL DEFAULT '',
   `address`      VARCHAR(80)   NOT NULL DEFAULT '',
   `phone`        VARCHAR(15)   NOT NULL DEFAULT '',
   `discount`     DOUBLE        NOT NULL DEFAULT 0.0,
   PRIMARY KEY (`customer_id`),
   UNIQUE INDEX (`phone`),  -- Build index on this unique-value column
   INDEX (`name`)           -- Build index on this column
) ENGINE=InnoDB;
DESC `customers`;
SHOW CREATE TABLE `customers`;
SHOW INDEX FROM `customers`;
 
-- Create `rental_records` table
DROP TABLE IF EXISTS `rental_records`;
CREATE TABLE `rental_records` (
   `rental_id`    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
   `veh_reg_no`   VARCHAR(8)    NOT NULL, 
   `customer_id`  INT UNSIGNED  NOT NULL,
   `start_date`   DATE          NOT NULL DEFAULT('0000-00-00'),
   `end_date`     DATE          NOT NULL DEFAULT('0000-00-00'),
   `lastUpdated`  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      -- Keep the created and last updated timestamp for auditing and security
   PRIMARY KEY (`rental_id`),
   FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
      ON DELETE RESTRICT ON UPDATE CASCADE,
      -- Disallow deletion of parent record if there are matching records here
      -- If parent record (customer_id) changes, update the matching records here
   FOREIGN KEY (`veh_reg_no`) REFERENCES `vehicles` (`veh_reg_no`)
      ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
DESC `rental_records`;
SHOW CREATE TABLE `rental_records`;
SHOW INDEX FROM `rental_records`;

-- Inserting test records
INSERT INTO `vehicles` VALUES
   ('SBA1111A', 'car', 'NISSAN SUNNY 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
   ('SBB2222B', 'car', 'TOYOTA ALTIS 1.6L', '4 Door Saloon, Automatic', NULL, 99.99),
   ('SBC3333C', 'car', 'HONDA CIVIC 1.8L',  '4 Door Saloon, Automatic', NULL, 119.99),
   ('GA5555E', 'truck', 'NISSAN CABSTAR 3.0L',  'Lorry, Manual ', NULL, 89.99),
   ('GA6666F', 'truck', 'OPEL COMBO 1.6L',  'Van, Manual', NULL, 69.99);
   -- No photo yet, set to NULL
SELECT * FROM `vehicles`;
 
INSERT INTO `customers` VALUES
   (1001, 'Angel', '8 Happy Ave', '88888888', 0.1),
   (NULL, 'Mohammed Ali', '1 Kg Java', '99999999', 0.15),
   (NULL, 'Kumar', '5 Serangoon Road', '55555555', 0),
   (NULL, 'Kevin Jones', '2 Sunset boulevard', '22222222', 0.2);
SELECT * FROM `customers`;
 
INSERT INTO `rental_records` VALUES
  (NULL, 'SBA1111A', 1001, '2012-01-01', '2012-01-21', NULL),
  (NULL, 'SBA1111A', 1001, '2012-02-01', '2012-02-05', NULL),
  (NULL, 'GA5555E',  1003, '2012-01-05', '2012-01-31', NULL),
  (NULL, 'GA6666F',  1004, '2012-01-20', '2012-02-20', NULL);
SELECT * FROM rental_records;
SELECT * FROM customers;
SELECT * FROM vehicles;

/*1: Customer 'Angel' has rented 'SBA1111A' from today for 10 days. */
INSERT INTO rental_records VALUES
   (NULL, 'SBA1111A', 
	(SELECT customer_id FROM customers WHERE name='Angel'),
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 10 DAY),
    NULL);
    
/*2: Customer 'Kumar' has rented 'GA5555E' from tomorrow for 3 months.*/
INSERT INTO rental_records VALUES
   (NULL, 'GA5555E', 
    (SELECT customer_id FROM customers WHERE name='Kumar'),
    DATE_ADD(CURDATE(), INTERVAL 1 DAY),
    DATE_ADD(CURDATE(), INTERVAL 3 MONTH),
    NULL); 
    
/*3: List all rental records (start date, end date) with vehicle's registration number, brand, 
and customer name, sorted by vehicle's categories followed by start date.*/
SELECT
   r.start_date  AS `Start Date`,
   r.end_date    AS `End Date`,
   r.veh_reg_no  AS `Vehicle Registration no`,
   v.brand       AS `Brand`,
   c.name        AS `Customer Name`
FROM rental_records AS r
   INNER JOIN vehicles  AS v USING (veh_reg_no)
   INNER JOIN customers AS c USING (customer_id)
ORDER BY v.category, start_date;

/*4: List all the expired rental records */
SELECT * FROM rental_records WHERE end_date < CURDATE();

/*5: List the vehicles rented out on '2012-01-10' (not available for rental), 
in columns of vehicle registration no, customer name, start date and end date.*/
SELECT
   r.veh_reg_no AS `Vehicle Registration no`,
   c.name AS `Customer Name`,
   r.start_date AS `Start Date`,
   r.end_date AS `End Date`
FROM rental_records AS r
   INNER JOIN vehicles AS v USING (veh_reg_no)
   INNER JOIN customers AS c USING (customer_id)
WHERE '2012-01-10' BETWEEN start_date AND end_date;

/*6. List all vehicles rented out today, in columns registration number, 
customer name, start date, end date. */
SELECT
   veh_reg_no AS `Registration no`,
   name AS `Customer Name`,
   start_date AS `Start Date`,
   end_date AS `End Date`
FROM rental_records
   INNER JOIN customers USING (customer_id)
WHERE
   CURDATE() BETWEEN start_date AND end_date;
   
/*7.Similarly, list the vehicles rented out (not available for rental) 
for the period from '2012-01-03' to '2012-01-18'.*/
SELECT
   r.veh_reg_no AS `Registration No`,
   c.name AS `Customer Name`,
   r.start_date AS `Start Date`,
   r.end_date AS `End Date`
FROM rental_records AS r
   INNER JOIN vehicles AS v USING (veh_reg_no)
   INNER JOIN customers AS c USING (customer_id)
WHERE start_date BETWEEN '2012-01-03' AND '2012-01-18'
   OR (start_date < '2012-01-03' AND end_date > '2012-01-18');
   
/*8: List the vehicles (registration number, brand and description) 
   available for rental (not rented out) on '2012-01-10' */
SELECT
   veh_reg_no AS `Registration No`,
   brand AS `Brand`,
   vehicles.desc AS `Description`
FROM vehicles
WHERE veh_reg_no NOT IN
(SELECT DISTINCT veh_reg_no FROM rental_records
 WHERE '2012-01-10' BETWEEN start_date AND end_date);
 
 /*9: Similarly, list the vehicles available for rental for the period 
 from '2012-01-03' to '2012-01-18'. */
SELECT veh_reg_no, brand, vehicles.desc FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
SELECT veh_reg_no FROM rental_records
WHERE (start_date > '2012-01-03' AND start_date < '2012-01-18') OR
(end_date < '2012-01-03' AND end_date < '2012-01-18') OR 
(start_date < '2012-01-03' AND end_date > '2012-01-18')
);

/* 10. Similarly, list the vehicles available for rental from today for 10 days.*/
SELECT DISTINCT
vehicles.veh_reg_no AS 'Registration No',
vehicles.brand AS 'Brand',
vehicles.desc AS Description
FROM vehicles
LEFT JOIN rental_records ON vehicles.veh_reg_no = rental_records.veh_reg_no
WHERE vehicles.veh_reg_no NOT IN  (
SELECT veh_reg_no 
FROM rental_records 
WHERE rental_records.start_date BETWEEN curdate() AND date_add(curdate(), INTERVAL 10 DAY));




    