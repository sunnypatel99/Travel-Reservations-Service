-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase II: Create Table & Insert Statements [v0] Thursday, October 14, 2021 @ 2:00pm EDT

-- Team 56
-- Kavya Ahuja (kahuja7)
-- Nikita Jakkam (njakkam3)
-- Sunny Patel (spatel725)
-- Roshen Jegajeevan (rjegajeevan3)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------
DROP DATABASE IF EXISTS travel_reservations_service;
CREATE DATABASE IF NOT EXISTS travel_reservations_service;
USE travel_reservations_service;

DROP TABLE IF EXISTS account;
CREATE TABLE account(
email char(50) NOT NULL,
fname char(100),
lname char(100),
password char(50) NOT NULL,
PRIMARY KEY(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS client;
CREATE TABLE client(
email char(50) NOT NULL,
phone_number char(50) NOT NULL,
UNIQUE KEY(phone_number),
PRIMARY KEY(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
email char(50) NOT NULL,
PRIMARY KEY(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
email char(50) NOT NULL,
credit_card decimal(16,0) NOT NULL,
cvv decimal(3,0) NOT NULL,
exp_date date NOT NULL,
current_location char(50) NOT NULL,
UNIQUE KEY(credit_card),
PRIMARY KEY(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS owner;
CREATE TABLE owner(
email char(50) NOT NULL,
PRIMARY KEY (email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS airline;
CREATE TABLE airline(
name char(50) NOT NULL,
rating decimal(3,1),
PRIMARY KEY (name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
airport_id char(3) NOT NULL,
name char(50) NOT NULL,
time_zone char(3) NOT NULL,
street char(50) NOT NULL,
city char(50) NOT NULL,
state char(2) NOT NULL,
zip char(5) NOT NULL,
UNIQUE KEY name (name),
UNIQUE KEY (street,city,state,zip),
PRIMARY KEY (airport_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
flight_num decimal(10,0) NOT NULL,
airline_name char(50) NOT NULL,
from_airport char(3) NOT NULL,
to_airport char(3) NOT NULL,
departure_time char(50) NOT NULL,
arrival_time char(50) NOT NULL,
date date NOT NULL,
cost_per_seat decimal(5,0) NOT NULL,
capacity decimal(3,0) NOT NULL,
PRIMARY KEY (flight_num,airline_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS property;
CREATE TABLE property(
property_name char(50) NOT NULL,
owner_email char(50) NOT NULL,
description varchar(300) NOT NULL,
capacity decimal(5,0) NOT NULL,
cost_per_night_per_person decimal(5,0) NOT NULL,
street char(50) NOT NULL,
city char(50) NOT NULL,
state char(2) NOT NULL,
zip decimal(5,0) NOT NULL,
UNIQUE KEY (street,city,state,zip),
PRIMARY KEY (owner_email,property_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS isCloseTo;
CREATE TABLE isCloseTo(
property_name char(50) NOT NULL,
owner_email char(50) NOT NULL,
airport_id char(3) NOT NULL,
distance int(2) NOT NULL,
CONSTRAINT limit_distance CHECK (distance < 50),
PRIMARY KEY (property_name,owner_email,airport_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS reserve;
CREATE TABLE reserve(
property_name char(50) NOT NULL,
owner_email char(50) NOT NULL,
customer_email char(50) NOT NULL,
start_date date NOT NULL,
end_date date NOT NULL,
num_guests decimal(10,0) NOT NULL,
PRIMARY KEY (customer_email,owner_email ,property_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS review;
CREATE TABLE review(
property_name char(50) NOT NULL,
owner_email char(50) NOT NULL,
customer_email char(50) NOT NULL,
content varchar(300) NOT NULL,
score int(1) NOT NULL,
CONSTRAINT rev_score CHECK (score >= 1 or score <= 5),
CONSTRAINT content_length CHECK (LENGTH(content) >= 10 and LENGTH(content) <= 300),
PRIMARY KEY (customer_email,owner_email,property_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS book;
CREATE TABLE book(
customer_email char(50) NOT NULL,
flight_num decimal(10,0) NOT NULL,
airline_name char(50) NOT NULL,
num_seats decimal(10,0) NOT NULL,
PRIMARY KEY (customer_email,flight_num,airline_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS customerRateOwner;
CREATE TABLE customerRateOwner(
owner_email char(50) NOT NULL,
customer_email char(50) NOT NULL,
score int(1),
CONSTRAINT c_score_o CHECK (score >= 1 or score <= 5),
PRIMARY KEY (customer_email,owner_email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS ownerRateCustomer;
CREATE TABLE ownerRateCustomer(
owner_email char(50) NOT NULL,
customer_email char(50) NOT NULL,
score int(1),
CONSTRAINT o_score_c CHECK (score >= 1 or score <= 5),
PRIMARY KEY (customer_email,owner_email)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS amenities;
CREATE TABLE amenities(
property_name char(50) NOT NULL,
owner_email char(50) NOT NULL,
amenity_name char(50) NOT NULL,
PRIMARY KEY (property_name,owner_email,amenity_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS attractions;
CREATE TABLE attractions(
airport_id char(3) NOT NULL,
attraction_name char(50) NOT NULL,
PRIMARY KEY (airport_id, attraction_name)
)ENGINE=InnoDB;

ALTER TABLE client ADD CONSTRAINT client_email FOREIGN KEY (email) REFERENCES account(email);
ALTER TABLE admin ADD CONSTRAINT admin_email FOREIGN KEY (email) REFERENCES account(email);
ALTER TABLE customer ADD CONSTRAINT customer_email FOREIGN KEY (email) REFERENCES account(email);
ALTER TABLE owner ADD CONSTRAINT owner_email FOREIGN KEY (email) REFERENCES account(email);
ALTER TABLE flight ADD CONSTRAINT name_of_airline FOREIGN KEY (airline_name) REFERENCES airline(name);
ALTER TABLE flight ADD CONSTRAINT airport_from FOREIGN KEY (from_airport) REFERENCES airport(airport_id);
ALTER TABLE flight ADD CONSTRAINT airport_to FOREIGN KEY (to_airport) REFERENCES airport(airport_id);
ALTER TABLE property ADD CONSTRAINT owner FOREIGN KEY (owner_email) REFERENCES owner(email);
ALTER TABLE isCloseTo ADD CONSTRAINT airport FOREIGN KEY (airport_id) REFERENCES airport(airport_id);
ALTER TABLE isCloseTo ADD CONSTRAINT owner_email_prop_name FOREIGN KEY (owner_email,property_name) REFERENCES property(owner_email,property_name);
ALTER TABLE reserve ADD CONSTRAINT customer FOREIGN KEY (customer_email) REFERENCES customer(email);
ALTER TABLE reserve ADD CONSTRAINT owner_prop_name FOREIGN KEY (owner_email,property_name) REFERENCES property(owner_email,property_name);
ALTER TABLE review ADD CONSTRAINT cust_email FOREIGN KEY (customer_email) REFERENCES customer(email);
ALTER TABLE review ADD CONSTRAINT owner_email_propname FOREIGN KEY (owner_email,property_name) REFERENCES property(owner_email,property_name);
ALTER TABLE book ADD CONSTRAINT custemail FOREIGN KEY (customer_email) REFERENCES customer(email);
ALTER TABLE book ADD CONSTRAINT airline_name_flight_num FOREIGN KEY (airline_name,flight_num) REFERENCES flight(airline_name,flight_num);
ALTER TABLE customerRateOwner ADD CONSTRAINT own_mail FOREIGN KEY (owner_email) REFERENCES owner(email);
ALTER TABLE customerRateOwner ADD CONSTRAINT c_email FOREIGN KEY (customer_email) REFERENCES customer(email);
ALTER TABLE ownerRateCustomer ADD CONSTRAINT o_mail FOREIGN KEY (owner_email) REFERENCES owner(email);
ALTER TABLE ownerRateCustomer ADD CONSTRAINT c_mail FOREIGN KEY (customer_email) REFERENCES customer(email);
ALTER TABLE amenities ADD CONSTRAINT o_email_p_name FOREIGN KEY (owner_email,property_name) REFERENCES property(owner_email,property_name);
ALTER TABLE attractions ADD CONSTRAINT airport_id FOREIGN KEY (airport_id) REFERENCES airport(airport_id);

INSERT INTO account VALUES
('mmoss1@travelagency.com','Mark','Moss','password1'),
('asmith@travelagency.com','Aviva','Smith','password2'),
('mscott22@gmail.com','Michael','Scott','password3'),
('arthurread@gmail.com','Arthur','Read','password4'),
('jwayne@gmail.com','John','Wayne','password5'),
('gburdell3@gmail.com','George','Burdell','password6'),
('mj23@gmail.com','Michael','Jordan','password7'),
('lebron6@gmail.com','Lebron','James','password8'),
('msmith5@gmail.com','Michael','Smith','password9'),
('ellie2@gmail.com','Ellie','Johnson','password10'),
('scooper3@gmail.com','Sheldon','Cooper','password11'),
('mgeller5@gmail.com','Monica','Geller','password12'),
('cbing10@gmail.com','Chandler','Bing','password13'),
('hwmit@gmail.com','Howard','Wolowitz','password14'),
('swilson@gmail.com','Samantha','Wilson','password16'),
('aray@tiktok.com','Addison','Ray','password17'),
('cdemilio@tiktok.com','Charlie','Demilio','password18'),
('bshelton@gmail.com','Blake','Shelton','password19'),
('lbryan@gmail.com','Luke','Bryan','password20'),
('tswift@gmail.com','Taylor','Swift','password21'),
('jseinfeld@gmail.com','Jerry','Seinfeld','password22'),
('maddiesmith@gmail.com','Madison','Smith','password23'),
('johnthomas@gmail.com','John','Thomas','password24'),
('boblee15@gmail.com','Bob','Lee','password25');

INSERT INTO client VALUES
('mscott22@gmail.com','555-123-4567'),
('arthurread@gmail.com','555-234-5678'),
('jwayne@gmail.com','555-345-6789'),
('gburdell3@gmail.com','555-456-7890'),
('mj23@gmail.com','555-567-8901'),
('lebron6@gmail.com','555-678-9012'),
('msmith5@gmail.com','555-789-0123'),
('ellie2@gmail.com','555-890-1234'),
('scooper3@gmail.com','678-123-4567'),
('mgeller5@gmail.com','678-234-5678'),
('cbing10@gmail.com','678-345-6789'),
('hwmit@gmail.com','678-456-7890'),
('swilson@gmail.com','770-123-4567'),
('aray@tiktok.com','770-234-5678'),
('cdemilio@tiktok.com','770-345-6789'),
('bshelton@gmail.com','770-456-7890'),
('lbryan@gmail.com','770-567-8901'),
('tswift@gmail.com','770-678-9012'),
('jseinfeld@gmail.com','770-789-0123'),
('maddiesmith@gmail.com','770-890-1234'),
('johnthomas@gmail.com','404-770-5555'),
('boblee15@gmail.com','404-678-5555');

INSERT INTO admin VALUES
('mmoss1@travelagency.com'),
('asmith@travelagency.com');

INSERT INTO customer VALUES
('scooper3@gmail.com',6518555974461663,551,'2024-02-01',''),
('mgeller5@gmail.com',2328567043101965,644,'2024-03-01',''),
('cbing10@gmail.com',8387952398279291,201,'2023-02-01',''),
('hwmit@gmail.com',6558859698525299,102,'2023-04-01',''),
('swilson@gmail.com',9383321241981836,455,'2022-08-01',''),
('aray@tiktok.com',3110266979495605,744,'2022-08-01',''),
('cdemilio@tiktok.com',2272355540784744,606,'2025-02-01',''),
('bshelton@gmail.com',9276763978834273,862,'2023-09-01',''),
('lbryan@gmail.com',4652372688643798,258,'2023-05-01',''),
('tswift@gmail.com',5478842044367471,857,'2024-12-01',''),
('jseinfeld@gmail.com',3616897712963372,295,'2022-06-01',''),
('maddiesmith@gmail.com',9954569863556952,794,'2022-07-01',''),
('johnthomas@gmail.com',7580327437245356,269,' 2025-10-01',''),
('boblee15@gmail.com',7907351371614248,858,'2025-11-01','');


INSERT INTO owner VALUES
('mscott22@gmail.com'),
('arthurread@gmail.com'),
('jwayne@gmail.com'),
('gburdell3@gmail.com'),
('mj23@gmail.com'),
('lebron6@gmail.com'),
('msmith5@gmail.com'),
('ellie2@gmail.com'),
('scooper3@gmail.com'),
('mgeller5@gmail.com'),
('cbing10@gmail.com'),
('hwmit@gmail.com');

INSERT INTO airline VALUES
('Delta Airlines',4.7),
('Southwest Airlines',4.4),
('American Airlines',4.6),
('United Airlines',4.2),
('JetBlue Airways',3.6),
('Spirit Airlines',3.3),
('WestJet',3.9),
('Interjet',3.7);


INSERT INTO airport VALUES
('ATL',"Atlanta Hartsfield Jackson Airport",'EST',"6000 N Terminal Pkwy",'Atlanta','GA','30320'),
('JFK',"John F Kennedy International Airport",'EST',"455 Airport Ave",'Queens','NY','11430'),
('LGA',"Laguardia Airport",'EST',"790 Airport St",'Queens','NY','11371'),
('LAX',"Lost Angeles International Airport",'PST',"1 World Way",'Los Angeles','CA','90045'),
('SJC',"Norman Y. Mineta San Jose International Airport",'PST',"1702 Airport Blvd",'San Jose','CA','95110'),
('ORD',"O'Hare International Airport",'CST',"10000 W O'Hare Ave",'Chicago','IL','60666'),
('MIA',"Miami International Airport",'EST',"2100 NW 42nd Ave",'Miami','FL','33126'),
('DFW',"Dallas International Airport",'CST',"2400 Aviation DR",'Dallas','TX','75261');



INSERT INTO flight VALUES
(1,'Delta Airlines','ATL','JFK',' 10:00 AM',' 12:00 PM','2021-10-18',400,150),
(2,'Southwest Airlines','ORD','MIA',' 10:30 AM',' 2:30 PM','2021-10-18',350,125),
(3,'American Airlines','MIA','DFW',' 1:00 PM',' 4:00 PM','2021-10-18',350,125),
(4,'United Airlines','ATL','LGA',' 4:30 PM',' 6:30 PM','2021-10-18',400,100),
(5,'JetBlue Airways','LGA','ATL',' 11:00 AM',' 1:00 PM','2021-10-19',400,130),
(6,'Spirit Airlines','SJC','ATL',' 12:30 PM',' 9:30 PM','2021-10-19',650,140),
(7,'WestJet','LGA','SJC',' 1:00 PM',' 4:00 PM','2021-10-19',700,100),
(8,'Interjet','MIA','ORD',' 7:30 PM',' 9:30 PM','2021-10-19',350,125),
(9,'Delta Airlines','JFK','ATL',' 8:00 AM',' 10:00 AM','2021-10-20',375,150),
(10,'Delta Airlines','LAX','ATL',' 9:15 AM',' 6:15 PM','2021-10-20',700,110),
(11,'Southwest Airlines','LAX','ORD',' 12:07 PM',' 7:07 PM','2021-10-20',600,95),
(12,'United Airlines','MIA','ATL',' 3:35 PM',' 5:35 PM','2021-10-20',275,115);


INSERT INTO property VALUES
('Atlanta Great Property','scooper3@gmail.com','This is right in the middle of Atlanta near many attractions!',4,600,'2nd St','ATL','GA',30008),
('House near Georgia Tech','gburdell3@gmail.com','Super close to bobby dodde stadium!',3,275,'North Ave','ATL','GA',30008),
('New York City Property','cbing10@gmail.com','A view of the whole city. Great property!',2,750,'123 Main St','NYC','NY',10008),
('Statue of Libery Property','mgeller5@gmail.com','You can see the statue of liberty from the porch',5,1000,'1st St','NYC','NY',10009),
('Los Angeles Property','arthurread@gmail.com','',3,700,'10th St','LA','CA',90008),
('LA Kings House','arthurread@gmail.com','This house is super close to the LA kinds stadium!',4,750,'Kings St','La','CA',90011),
('Beautiful San Jose Mansion','arthurread@gmail.com','Huge house that can sleep 12 people. Totally worth it!',12,900,'Golden Bridge Pkwt','San Jose','CA',90001),
('LA Lakers Property','lebron6@gmail.com','This house is right near the LA lakers stadium. You might even meet Lebron James!',4,850,'Lebron Ave','LA','CA',90011),
('Chicago Blackhawks House','hwmit@gmail.com','This is a great property!',3,775,'Blackhawks St','Chicago','IL',60176),
('Chicago Romantic Getaway','mj23@gmail.com','This is a great property!',2,1050,'23rd Main St','Chicago','IL',60176),
('Beautiful Beach Property','msmith5@gmail.com','You can walk out of the house and be on the beach!',2,975,'456 Beach Ave','Miami','FL',33101),
('Family Beach House','ellie2@gmail.com','You can literally walk onto the beach and see it from the patio!',6,850,'1132 Beach Ave','Miami','FL',33101),
('Texas Roadhouse','mscott22@gmail.com','This property is right in the center of Dallas, Texas!',3,450,'17th Street','Dallas','TX',75043),
('Texas Longhorns House','mscott22@gmail.com','You can walk to the longhorns stadium from here!',10,600,'1125 Longhorns Way','Dallas','TX',75001);


INSERT INTO isCloseTo VALUES
('Atlanta Great Property','scooper3@gmail.com','ATL',12),
('House near Georgia Tech','gburdell3@gmail.com','ATL',7),
('New York City Property','cbing10@gmail.com','JFK',10),
('Statue of Libery Property','mgeller5@gmail.com','JFK',8),
('New York City Property','cbing10@gmail.com','LGA',25),
('Statue of Libery Property','mgeller5@gmail.com','LGA',19),
('Los Angeles Property','arthurread@gmail.com','LAX',9),
('LA Kings House','arthurread@gmail.com','LAX',12),
('Beautiful San Jose Mansion','arthurread@gmail.com','SJC',8),
('Beautiful San Jose Mansion','arthurread@gmail.com','LAX',30),
('LA Lakers Property','lebron6@gmail.com','LAX',6),
('Chicago Blackhawks House','hwmit@gmail.com','ORD',11),
('Chicago Romantic Getaway','mj23@gmail.com','ORD',13),
('Beautiful Beach Property','msmith5@gmail.com','MIA',21),
('Family Beach House','ellie2@gmail.com','MIA',19),
('Texas Roadhouse','mscott22@gmail.com','DFW',8),
('Texas Longhorns House','mscott22@gmail.com','DFW',17);


INSERT INTO reserve VALUES
('House near Georgia Tech','gburdell3@gmail.com','swilson@gmail.com','2021-10-19','2021-10-25',3),
('New York City Property','cbing10@gmail.com','aray@tiktok.com','2021-10-18','2021-10-23',2),
('New York City Property','cbing10@gmail.com','cdemilio@tiktok.com','2021-10-24','2021-10-30',2),
('Statue of Libery Property','mgeller5@gmail.com','bshelton@gmail.com','2021-10-18','2021-10-22',4),
('Los Angeles Property','arthurread@gmail.com','lbryan@gmail.com','2021-10-19','2021-10-25',2),
('Beautiful San Jose Mansion','arthurread@gmail.com','tswift@gmail.com','2021-10-19','2021-10-22',10),
('LA Lakers Property','lebron6@gmail.com','jseinfeld@gmail.com','2021-10-19','2021-10-24',4),
('Chicago Blackhawks House','hwmit@gmail.com','maddiesmith@gmail.com','2021-10-19','2021-10-23',2),
('Chicago Romantic Getaway','mj23@gmail.com','aray@tiktok.com','2021-11-01','2021-11-07',2),
('Beautiful Beach Property','msmith5@gmail.com','cbing10@gmail.com','2021-10-18','2021-10-25',2),
('Family Beach House','ellie2@gmail.com','hwmit@gmail.com','2021-10-18','2021-10-28',5);


INSERT INTO book VALUES
('swilson@gmail.com',5,'JetBlue Airways',5),
('aray@tiktok.com',1,'Delta Airlines',1),
('bshelton@gmail.com',4,'United Airlines',4),
('lbryan@gmail.com',7,'WestJet',7),
('tswift@gmail.com',7,'WestJet',7),
('jseinfeld@gmail.com',7,'WestJet',7),
('maddiesmith@gmail.com',8,'Interjet',8),
('cbing10@gmail.com',2,'Southwest Airlines',2),
('hwmit@gmail.com',2,'Southwest Airlines',2);


INSERT INTO ownerRateCustomer VALUES
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',3),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',4),
('lebron6@gmail.com','jseinfeld@gmail.com',1),
('hwmit@gmail.com','maddiesmith@gmail.com',2);

INSERT INTO customerRateOwner VALUES
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',4),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',3),
('lebron6@gmail.com','jseinfeld@gmail.com',2),
('hwmit@gmail.com','maddiesmith@gmail.com',5);

INSERT INTO amenities VALUES
('Atlanta Great Property','scooper3@gmail.com','A/C & Heating'),
('Atlanta Great Property','scooper3@gmail.com','Pets allowed'),
('Atlanta Great Property','scooper3@gmail.com','Wifi & TV'),
('Atlanta Great Property','scooper3@gmail.com','Washer and Dryer'),
('House near Georgia Tech','gburdell3@gmail.com','Wifi & TV'),
('House near Georgia Tech','gburdell3@gmail.com','Washer and Dryer'),
('House near Georgia Tech','gburdell3@gmail.com','Full Kitchen'),
('New York City Property','cbing10@gmail.com','A/C & Heating'),
('New York City Property','cbing10@gmail.com','Wifi & TV'),
('Statue of Libery Property','mgeller5@gmail.com','A/C & Heating'),
('Statue of Libery Property','mgeller5@gmail.com','Wifi & TV'),
('Los Angeles Property','arthurread@gmail.com','A/C & Heating'),
('Los Angeles Property','arthurread@gmail.com','Pets allowed'),
('Los Angeles Property','arthurread@gmail.com','Wifi & TV'),
('LA Kings House','arthurread@gmail.com','A/C & Heating'),
('LA Kings House','arthurread@gmail.com','Wifi & TV'),
('LA Kings House','arthurread@gmail.com','Washer and Dryer'),
('LA Kings House','arthurread@gmail.com','Full Kitchen'),
('Beautiful San Jose Mansion','arthurread@gmail.com','A/C & Heating'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Pets allowed'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Wifi & TV'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Washer and Dryer'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Full Kitchen'),
('LA Lakers Property','lebron6@gmail.com','A/C & Heating'),
('LA Lakers Property','lebron6@gmail.com','Wifi & TV'),
('LA Lakers Property','lebron6@gmail.com','Washer and Dryer'),
('LA Lakers Property','lebron6@gmail.com','Full Kitchen'),
('Chicago Blackhawks House','hwmit@gmail.com','A/C & Heating'),
('Chicago Blackhawks House','hwmit@gmail.com','Wifi & TV'),
('Chicago Blackhawks House','hwmit@gmail.com','Washer and Dryer'),
('Chicago Blackhawks House','hwmit@gmail.com','Full Kitchen'),
('Chicago Romantic Getaway','mj23@gmail.com','A/C & Heating'),
('Chicago Romantic Getaway','mj23@gmail.com','Wifi & TV'),
('Beautiful Beach Property','msmith5@gmail.com','A/C & Heating'),
('Beautiful Beach Property','msmith5@gmail.com','Wifi & TV'),
('Beautiful Beach Property','msmith5@gmail.com','Washer and Dryer'),
('Family Beach House','ellie2@gmail.com','A/C & Heating'),
('Family Beach House','ellie2@gmail.com','Pets allowed'),
('Family Beach House','ellie2@gmail.com','Wifi & TV'),
('Family Beach House','ellie2@gmail.com','Washer and Dryer'),
('Family Beach House','ellie2@gmail.com','Full Kitchen'),
('Texas Roadhouse','mscott22@gmail.com','A/C & Heating'),
('Texas Roadhouse','mscott22@gmail.com','Pets allowed'),
('Texas Roadhouse','mscott22@gmail.com','Wifi & TV'),
('Texas Roadhouse','mscott22@gmail.com','Washer and Dryer'),
('Texas Longhorns House','mscott22@gmail.com','A/C & Heating'),
('Texas Longhorns House','mscott22@gmail.com','Pets allowed'),
('Texas Longhorns House','mscott22@gmail.com','Wifi & TV'),
('Texas Longhorns House','mscott22@gmail.com','Washer and Dryer'),
('Texas Longhorns House','mscott22@gmail.com','Full Kitchen');

INSERT INTO attractions VALUES
('ATL','The Coke Factory'),
('ATL','The Georgia Aquarium'),
('JFK','The Statue of Liberty'),
('JFK','The Empire State Building'),
('LGA','The Statue of Liberty'),
('LGA','The Empire State Building'),
('LAX','Lost Angeles Lakers Stadium'),
('LAX','Los Angeles Kings Stadium'),
('SJC','Winchester Mystery House'),
('SJC','San Jose Earthquakes Soccer Team'),
('ORD','Chicago Blackhawks Stadium'),
('ORD','Chicago Bulls Stadium'),
('MIA','Crandon Park Beach'),
('MIA','Miami Heat Basketball Stadium'),
('DFW','Texas Longhorns Stadium'),
('DFW','The Original Texas Roadhouse');












