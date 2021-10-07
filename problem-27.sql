-- NAME Pratham Jaiswal
-- ROLL NUMBER 27
-- DIV D
-- BATCH B2

-- CHIT 27

CREATE DATABASE product_ship;

USE product_ship;

CREATE TABLE customer (
	cust_id INT PRIMARY KEY,
	cust_name VARChAR(50),
	annual_revenue INT,
	cust_type VARCHAR(30) CHECK(cust_type IN ('manufacturer', 'wholesaler', 'retailer'))
);

CREATE TABLE shipment (
	shipment_no INT primary key,
	cust_id INT NOT NULL,
	weight INT,
	truck_no INT,
	destination VARCHAR(50),
	ship_date DATE 
);

CREATE TABLE truck (
	truck_no INT PRIMARY KEY,
	driver_name VARCHAR(50)
);

CREATE TABLE city (
	city_name VARCHAR(30) PRIMARY KEY,
	population INT
);

INSERT INTO customer VALUES
(1, "Pratham Jaiswal", 1000, 'manufacturer'),
(2, "Dennis Ritchie", 1947, 'manufacturer'),
(3, "James Gosling", 2000, 'manufacturer'),
(4, "Guido van Rossum", 200, 'wholesaler'),
(5, "Rasmus Lerdorf", 600, 'retailer');

INSERT INTO shipment VALUES
(1, 1, 50, 1, 'Pune', '2021-09-18'),
(2, 2, 100, 2, 'Navsari', '2020-09-18'),
(3, 3, 150, 1, 'Surat', '2019-09-18'),
(4, 1, 200, 2, 'Ratlam', '2018-09-18'),
(5, 2, 250, 1, 'Indore', '2017-09-18'),
(6, 3, 300, 2, 'Ahmedabad', '2016-09-18'),
(7, 2, 50, 1, 'Pune', '2015-09-18'),
(8, 3, 100, 2, 'Pune', '2014-09-18'),
(9, 4, 50, 1, 'Pune', '2015-09-18'),
(10, 5, 100, 2, 'Pune', '2014-09-18'),
(11, 5, 50, 1, 'Surat', '2015-09-18');

INSERT INTO truck VALUES 
(1, 'Donald Chamberlin'),
(2, 'Raymond Boyce');

INSERT INTO city VALUES
('Pune', 40000000),
('Navsari', 100000),
('Surat', 1000000),
('Ratlam', 400000),
('Indore', 20000000),
('Ahmedabad', 30000000);

-- List the names of drivers who have delivered shipments weighing over 100 pounds
SELECT DISTINCT(truck.driver_name) FROM shipment, truck
WHERE shipment.weight > 100 
	AND truck.truck_no = shipment.truck_no;

-- List the name and annual revenure of customers who have sent shipments weighing over 100 pounds.
SELECT customer.cust_name, customer.annual_revenue FROM customer, shipment
WHERE shipment.weight > 100
GROUP BY customer.cust_id;

-- List the name and annual revenue of customers whose shipments have been delivered by truck driver jensen (here considering 'Raymond Boyce')
SELECT customer.cust_name, customer.annual_revenue FROM customer, shipment, truck
WHERE truck.driver_name = 'Raymond Boyce' 
	AND truck.truck_no = shipment.truck_no 
	AND shipment.cust_id = customer.cust_id
GROUP BY customer.cust_id;

-- List customers who had shipments delivered by every truck.
SELECT cust_name FROM customer 
WHERE cust_id IN (
	SELECT cust_id
	FROM shipment
	GROUP BY cust_id
	HAVING COUNT(DISTINCT truck_no) = (SELECT COUNT(*) FROM truck)
);

-- List cities that have received shipments from every customer.
SELECT destination FROM shipment
GROUP BY destination
HAVING COUNT(DISTINCT cust_id) = (SELECT COUNT(*) FROM customer);

-- List drivers who have delivered shipments to every city.
SELECT truck.driver_name FROM truck, shipment
WHERE truck.truck_no = shipment.truck_no
GROUP BY truck.truck_no
HAVING COUNT(DISTINCT shipment.destination) = (SELECT COUNT(*) FROM city);

-- Customers who are manufacturers or have sent a package to St. Louis.
SELECT customer.* FROM customer, shipment
WHERE customer.cust_type = 'manufacturer' 
	OR (shipment.cust_id = customer.cust_id 
		AND shipment.destination = 'Pune'
	)
GROUP BY customer.cust_id;

-- Cities of population over 1 million which have received a 100 pound package from customer 311
SELECT city.city_name FROM city, shipment
WHERE shipment.destination = city.city_name 
	AND shipment.weight = 100 
	AND shipment.cust_id = 3 
	AND city.population > 10000000;

-- Trucks driven by  Jake Stinson which have never delivered a shipment to Denver
SELECT truck.truck_no from truck, shipment
WHERE truck.driver_name = 'Donald Chamberlin' 
	AND shipment.truck_no = truck.truck_no 
	AND shipment.destination != 'Denver'
GROUP BY truck.truck_no;

-- Customers with annual revenue over $10 million which have sent packages under 1 pound to cities with population less than 10,000
SELECT customer.cust_name FROM customer, shipment, city
WHERE customer.annual_revenue > 100 
	AND shipment.cust_id = customer.cust_id 
	AND shipment.weight < 100 
	AND shipment.destination = city.city_name 
	AND city.population < 100000;

-- END
