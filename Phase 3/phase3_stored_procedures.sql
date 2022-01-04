-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase III: Stored Procedures & Views [v0] Tuesday, November 9, 2021 @ 12:00am EDT
-- Team __
-- Kavya Ahuja (Kahuja7)
-- Roshen Jegajeevan (rjegajeevan3)
-- Nikita Jakkam (njakkam3)
-- Sunny Patel (spatel725)
-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.


-- ID: 1a
-- Name: register_customer
drop procedure if exists register_customer;
delimiter //
create procedure register_customer (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12),
    in i_cc_number varchar(19),
    in i_cvv char(3),
    in i_exp_date date,
    in i_location varchar(50)
) 
sp_main: begin
-- TODO: Implement your solution here
	if (select count(*) from Accounts where email = i_email) = 1 then leave sp_main; end if;
	insert into Accounts Values (i_email,i_first_name,i_last_name,i_password);
	insert into Clients Values (i_email, i_phone_number);
	insert into Customer Values (i_email, i_cc_number,i_cvv,i_exp_date, i_location);
end //
delimiter ;

-- ID: 1b
-- Name: register_owner
drop procedure if exists register_owner;
delimiter //
create procedure register_owner (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12)
) 
sp_main: begin
	if (select count(*) from Accounts where email = i_email) = 1 then leave sp_main; end if;
    insert into Accounts Values (i_email,i_first_name,i_last_name,i_password);
    insert into Clients Values (i_email, i_phone_number);
    insert into Owners Values (i_email);

end //
delimiter ;

-- ID: 1c
-- Name: remove_owner
drop procedure if exists remove_owner;
delimiter //
create procedure remove_owner ( 
    in i_owner_email varchar(50)
)
sp_main: begin
-- TODO: Implement your solution here
	if (select count(*) from Property where owner_email = i_owner_email) >= 1 then leave sp_main; end if;
	DELETE FROM Review where Owner_Email = i_owner_email;
    DELETE FROM Customers_Rate_Owners where Owner_Email = i_owner_email;
    DELETE FROM Owners where Email = i_owner_email;
    if (select count(*) from Customer where Email = i_owner_email) >= 1 then leave sp_main; end if;
    DELETE FROM Clients where Email = i_owner_email;
    DELETE FROM Accounts where Email = i_owner_email;
end //
delimiter ;

-- ID: 2a
-- Name: schedule_flight
drop procedure if exists schedule_flight;
delimiter //
create procedure schedule_flight (
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_from_airport char(3),
    in i_to_airport char(3),
    in i_departure_time time,
    in i_arrival_time time,
    in i_flight_date date,
    in i_cost decimal(6, 2),
    in i_capacity int,
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
	if i_from_airport = i_to_airport then leave sp_main; end if;
	if i_flight_date = i_current_date then leave sp_main; end if;
    insert into Flight Values (i_flight_num + i_airline_name, i_airline_name, i_from_airport, i_to_airport, i_departure_time, i_arrival_time, i_flight_date, i_cost, i_capacity);
end //
delimiter ;


-- ID: 2b
-- Name: remove_flight
drop procedure if exists remove_flight;
delimiter //
create procedure remove_flight ( 
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
) 
sp_main: begin
-- TODO: Implement your solution here
	if (select flight_date from Flight where flight_num = i_flight_num and Airline_name = i_airline_name) < i_current_date then leave sp_main; end if;
    DELETE FROM Book where Flight_Num = i_flight_num and Airline_name = i_airline_name;
    DELETE FROM Flight where Flight_Num = i_flight_num and Airline_name = i_airline_name;
end //
delimiter ;

-- ID: 3a
-- Name: book_flight
drop procedure if exists book_flight;
delimiter //
create procedure book_flight (
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_num_seats int,
    in i_current_date date
)

sp_main: begin
-- TODO: Implement your solution here
	if (select capacity from flight where flight_num = i_flight_num and airline_name = i_airline_name) <= i_num_seats then leave sp_main; end if;
    if (select flight_date from Flight where flight_num = i_flight_num and Airline_name = i_airline_name) < i_current_date then leave sp_main; end if;
    if (select Was_Cancelled from Book where Customer = i_customer_email and Flight_num = i_flight_num and Airline_Name = i_airline_name) = 1 then leave sp_main; end if;
    if (select count(*) from Book where Customer = i_customer_email and Flight_num = i_flight_num and Airline_Name = i_airline_name) = 0 then
		insert into Book Values (i_customer_email, i_flight_num, i_airline_name, i_num_seats, 0);
	else
		if (select capacity from flight where flight_num = i_flight_num and airline_name = i_airline_name) >= (i_num_seats + (select Num_seats from book where Customer = i_customer_email and Flight_num = i_flight_num and Airline_Name = i_airline_name)) then
			update book set num_seats = num_seats + i_num_seats where Customer = i_customer_email and Flight_num = i_flight_num and Airline_Name = i_airline_name;
		end if;
	end if;
end //
delimiter ;


-- ID: 3b
-- Name: cancel_flight_booking
drop procedure if exists cancel_flight_booking;
delimiter //
create procedure cancel_flight_booking ( 
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
)
sp_main: begin

if (select count(*) from Book where customer = i_customer_email and flight_num = i_flight_num and Airline_name = i_airline_name) = 0 then leave sp_main; end if;
if (select flight_date from Flight where flight_num = i_flight_num and Airline_name = i_airline_name) < i_current_date then leave sp_main; end if;
Update Book set was_cancelled = 1 where customer = i_customer_email and Flight_Num = i_flight_num and Airline_name = i_airline_name;

end //
delimiter ;



-- ID: 3c
-- Name: view_flight
create or replace view view_flight (
    flight_id,
    flight_date,
    airline,
    destination,
    seat_cost,
    num_empty_seats,
    total_spent
) as
-- TODO: replace this select query with your solution
-- TODO: replace this select query with your solution
select f.flight_num, f.flight_date, f.airline_name, f.to_airport, f.cost,
ifnull(capacity - booked_seats, capacity) as 'num_empty_seats', f.cost * ifnull(booked_seats, 0) + (0.2 *f.cost * ifnull(cancelled_seats, 0)) as total_spent
from flight f left outer join 
(select flight_num, airline_name, was_cancelled, sum(num_seats) as booked_seats from book
where was_cancelled = 0 group by flight_num, airline_name) as table2
on f.flight_num = table2.flight_num and f.airline_name = table2.airline_name
left join(select flight_num, airline_name, was_cancelled, sum(num_seats) as cancelled_seats from book 
where was_cancelled = 1 group by flight_num, airline_name) as table3
on f.flight_num = table3.flight_num and f.airline_name = table3.airline_name;



-- ID: 4a
-- Name: add_property
drop procedure if exists add_property;
delimiter //
create procedure add_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_description varchar(500),
    in i_capacity int,
    in i_cost decimal(6, 2),
    in i_street varchar(50),
    in i_city varchar(50),
    in i_state char(2),
    in i_zip char(5),
    in i_nearest_airport_id char(3),
    in i_dist_to_airport int
) 
sp_main: begin
-- TODO: Implement your solution here
if (select count(*) from property where property_name = i_property_name and owner_email = i_owner_email) >= 1 then leave sp_main; end if;
insert into property Values (i_property_name, i_owner_email, i_description, i_capacity, i_cost, i_street, i_city, i_state, i_zip);
if (select count(*) from airport where airport_id = i_nearest_airport_id) >= 1 then 
	if (i_dist_to_airport is not null and i_dist_to_airport <> '' and i_nearest_airport_id is not null and i_nearest_airport_id <> '') then 
		insert into is_close_to values (i_property_name, i_owner_email, i_nearest_airport_id, i_dist_to_airport);
	end if;
end if;
end //
delimiter ;
-- call add_property('7mark','mscott22@gmail.com', 'apat', 4, 222, 'cent', 'atlanta', 'GA', '30024', 'ATL', '2');
-- ID: 4b
-- Name: remove_property
drop procedure if exists remove_property;
delimiter //
create procedure remove_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_current_date date
)
sp_main: begin

if ( select start_date from Reserve where property_name =  i_property_name and owner_email = i_owner_email ) = current_date then 
    if (select was_cancelled from Reserved where property_name =  i_property_name and owner_email = i_owner_email ) = 0 then leave sp_main; end if;
end if;
delete from Reserve where property_name =  i_property_name and owner_email = i_owner_email;
delete from Amenity where property_name =  i_property_name and Property_Owner = i_owner_email;
delete from Is_Close_to where property_name =  i_property_name and owner_email = i_owner_email;
delete from Property where property_name =  i_property_name and owner_email = i_owner_email;
    
end //
delimiter ;



-- ID: 5a
-- Name: reserve_property
drop procedure if exists reserve_property;
delimiter //
create procedure reserve_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_start_date date,
    in i_end_date date,
    in i_num_guests int,
    in i_current_date date
)
sp_main: begin
    if (select count(*) from Reserve where Property_Name = i_property_name and owner_email = i_owner_email and Customer = i_customer_email) >= 1 then leave sp_main; end if;
	if (select start_date from Reserve where property_name =  i_property_name and owner_email = i_owner_email and Customer = i_customer_email) < current_date then leave sp_main; end if;
    if (select start_date from Reserve where property_name =  i_property_name and owner_email = i_owner_email and Customer = i_customer_email) BETWEEN i_start_date AND i_end_date then leave sp_main; end if;
    if (select end_date from Reserve where property_name =  i_property_name and owner_email = i_owner_email and Customer = i_customer_email) BETWEEN i_start_date AND i_end_date then leave sp_main; end if;
    if (select capacity from property where property_name = i_property_name and owner_email = i_owner_email) < i_num_guests then leave sp_main; end if;
	insert into Reserve Values (i_property_name, i_owner_email, i_customer_email, i_start_date, i_end_date, i_num_guests, 0);
end //
delimiter ;


-- ID: 5b
-- Name: cancel_property_reservation
drop procedure if exists cancel_property_reservation;
delimiter //
create procedure cancel_property_reservation (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_current_date date
)
sp_main: begin
if (select count(*) from Reserve where customer = i_customer_email and property_name = i_property_name and owner_email = i_owner_email ) = 0 then leave sp_main; end if;
if (select start_date from Reserve where customer = i_customer_email and property_name = i_property_name and owner_email = i_owner_email) < i_current_date then leave sp_main; end if;
if (select Was_Cancelled from Reserve where customer = i_customer_email and property_name = i_property_name and owner_email = i_owner_email) = 1 then leave sp_main; end if;
update Reserve set Was_Cancelled = 1 where customer = i_customer_email and property_name = i_property_name and owner_email = i_owner_email;


end //
delimiter ;



-- ID: 5c
-- Name: customer_review_property
drop procedure if exists customer_review_property;
delimiter //
create procedure customer_review_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_content varchar(500),
    in i_score int,
    in i_current_date date
)
sp_main: begin

if ( select start_date from Reserve where property_name = i_property_name and Owner_Email = i_owner_email and  Customer = i_customer_email) < i_current_date then
	if  (select was_cancelled from Reserve where property_name = i_property_name and Owner_Email = i_owner_email and  Customer = i_customer_email ) = 1 then leave sp_main; end if;
end if; 


if (select count(*) from Review where property_name = i_property_name and Owner_Email = i_owner_email and  Customer = i_customer_email) = 1 then leave sp_main; end if;
insert into Review values(i_property_name, i_owner_email,i_customer_email,i_content,i_score);


    
end //
delimiter ;


-- ID: 5d
-- Name: view_properties
create or replace view view_properties (
    property_name, 
    average_rating_score, 
    description, 
    address, 
    capacity, 
    cost_per_night
) as
-- TODO: replace this select query with your solution
select property.property_name, AVG(score) as average_rating_score, descr as description, 
concat_ws(',',street,city,state,zip) as address, capacity, cost as cost_per_night 
from property left outer join review on property.Property_Name = review.property_name 
and property.Owner_Email = review.Owner_email 
group by property_name, description, address, capacity, cost_per_night;


-- ID: 5e
-- Name: view_individual_property_reservations
drop procedure if exists view_individual_property_reservations;
delimiter //
create procedure view_individual_property_reservations (
    in i_property_name varchar(50),
    in i_owner_email varchar(50)
)
sp_main: begin
    drop table if exists view_individual_property_reservations;
    create table view_individual_property_reservations (
        property_name varchar(50),
        start_date date,
        end_date date,
        customer_email varchar(50),
        customer_phone_num char(12),
        total_booking_cost decimal(6,2),
        rating_score int,
        review varchar(500)
    ) as
    -- TODO: replace this select query with your solution
    select property.property_name, start_date, end_date, customer as customer_email, 
	(select phone_number from clients join reserve on clients.email = reserve.customer where i_property_name = reserve.property_name and customer_email = reserve.customer) as customer_phone_num, 
	(((datediff(end_date, start_date) + 1) * cost) - (((datediff(end_date, start_date)+ 1) * cost) * reserve.was_cancelled * .8)) as total_booking_cost, 
	(select score from review natural join reserve where i_property_name = property_name and review.customer = reserve.customer and review.owner_email = reserve.owner_email and customer_email = reserve.customer) as rating_score, 
	(select content from review natural join reserve where i_property_name = property_name and review.customer = reserve.customer and review.owner_email = reserve.owner_email and customer_email = reserve.customer) as review
	from Property left outer join Reserve on property.property_name = reserve.property_name where property.property_name = i_property_name and i_owner_email = property.owner_email;

end //
delimiter ;


-- ID: 6a
-- Name: customer_rates_owner
drop procedure if exists customer_rates_owner;
delimiter //
create procedure customer_rates_owner (
    in i_customer_email varchar(50),
    in i_owner_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
#if (select count(*) from Customer where email = i_customer_email) = 0 then leave sp_main; end if;
    #if (select count(*) from owners where email = i_owner_email) = 0 then leave sp_main; end if;
	#if (SELECT Was_Cancelled FROM reserve WHERE owner_email = i_owner_email AND Customer = i_customer_email) = 1 then leave sp_main; end if;
	#if (SELECT End_Date FROM reserve WHERE owner_email = i_owner_email AND Customer = i_customer_email) > i_current_date  then leave sp_main; end if;
	#if (select count(*) from customers_rate_owners where owner_email = i_owner_email AND Customer = i_customer_email) > 0 then leave sp_main; end if;
    #insert into customers_rate_owners Values(i_customer_email,i_owner_email,i_score);
    
if (select count(*) from Customer where email = i_customer_email) = 0 then leave sp_main; end if;
if (select count(*) from owners where email = i_owner_email) = 0 then leave sp_main; end if;
if (select count(*) from reserve where customer = i_customer_email and owner_email = i_owner_email) = 0 then leave sp_main; end if;
if (SELECT Was_Cancelled FROM reserve WHERE owner_email = i_owner_email AND Customer = i_customer_email) = 1 then leave sp_main; end if;
if (select count(*) from customers_rate_owners where owner_email = i_owner_email AND Customer = i_customer_email) > 0 then leave sp_main; end if;
insert into customers_rate_owners Values(i_customer_email,i_owner_email,i_score);

end //
delimiter ;


-- ID: 6b
-- Name: owner_rates_customer
drop procedure if exists owner_rates_customer;
delimiter //
create procedure owner_rates_customer (
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
if (select count(*) from Customer where email = i_customer_email) = 0 then leave sp_main; end if;
if (select count(*) from owners where email = i_owner_email) = 0 then leave sp_main; end if;
if (select count(*) from reserve where customer = i_customer_email and owner_email = i_owner_email) = 0 then leave sp_main; end if;
if (SELECT Was_Cancelled FROM reserve WHERE owner_email = i_owner_email AND Customer = i_customer_email) = 1 then leave sp_main; end if;
if (select count(*) from owners_rate_customers where owner_email = i_owner_email AND Customer = i_customer_email) > 0 then leave sp_main; end if;
insert into owners_rate_customers Values(i_owner_email,i_customer_email,i_score);

end //
delimiter ;


-- ID: 7a
-- Name: view_airports
create or replace view view_airports (
    airport_id, 
    airport_name, 
    time_zone, 
    total_arriving_flights, 
    total_departing_flights, 
    avg_departing_flight_cost
) as
-- TODO: replace this select query with your solution    
SELECT A.Airport_ID AS airport_id, A.Airport_Name AS airport_name, time_zone,
coalesce(T.count,0) AS total_arriving_flights, coalesce(F.count,0) AS total_departing_flights, F.minC AS avg_departing_flight_cost FROM
airport A LEFT JOIN (SELECT From_airport,Count(*) AS count, AVG(cost) AS minC FROM flight GROUP BY From_airport) F
ON A.Airport_id = F.From_airport
LEFT JOIN (SELECT To_Airport,Count(*) AS count FROM flight GROUP BY To_Airport) T
ON A.Airport_id = T.To_Airport;

-- ID: 7b
-- Name: view_airlines
create or replace view view_airlines (
    airline_name, 
    rating, 
    total_flights, 
    min_flight_cost
) as
-- TODO: replace this select query with your solution
SELECT A.Airline_Name AS airline_name,A.Rating AS rating ,Count(Flight_Num) AS total_flights,MIN(Cost) AS min_flight_cost
FROM airline A LEFT JOIN flight F ON A.Airline_Name = F.Airline_Name
GROUP BY A.Airline_Name;


-- ID: 8a
-- Name: view_customers
create or replace view view_customers (
    customer_name, 
    avg_rating, 
    location, 
    is_owner, 
    total_seats_purchased
) as
-- TODO: replace this select query with your solution
-- view customers
SELECT CONCAT(First_Name,' ',Last_Name) AS customer_name ,AVG(R.score) AS avg_rating,(C.Location) AS location, 
CASE WHEN O.Email IS NULL THEN 0 ELSE 1 END AS is_owner,coalesce(SUM(B.Num_Seats),0) AS total_seats_purchased
FROM customer C LEFT JOIN owners O ON C.Email = O.Email
LEFT JOIN book B ON C.Email = B.Customer
LEFT JOIN owners_rate_customers R ON C.email = R.Customer
LEFT JOIN accounts A ON C.Email = A.Email
GROUP BY C.Email;


-- ID: 8b
-- Name: view_owners
create or replace view view_owners (
    owner_name, 
    avg_rating, 
    num_properties_owned, 
    avg_property_rating
) as
-- TODO: replace this select query with your solution
SELECT CONCAT(First_Name,' ',Last_Name) AS owner_name, AVG(C.Score) AS avg_rating,COUNT(DISTINCT P.Property_Name) AS num_properties_owned,AVG(R.score) AS avg_property_rating FROM
owners O LEFT JOIN reserve RE on O.email = RE.Owner_email
LEFT JOIN property P on O.Email = P.owner_email
LEFT JOIN review R on P.property_name = R.property_name
LEFT JOIN customers_rate_owners C ON RE.Owner_email = C.Owner_email AND RE.Customer = C.Customer
LEFT JOIN accounts A ON O.Email = A.Email
GROUP BY O.Email;



-- ID: 9a
-- Name: process_date
drop procedure if exists process_date;
delimiter //
create procedure process_date ( 
    in i_current_date date
)
sp_main: begin

Update customer, (select email, to_airport, flight_date, 
case when flight_date = i_current_date then (select state from airport where airport_id = to_airport) else location end as location 
from customer left outer join 
(select b.customer, b.flight_num,b.airline_name, f.to_airport, f.flight_date from book b join flight f 
on b.flight_num = f.flight_num and b.airline_name = f.airline_name where was_cancelled = 0) as t2 
on customer.email = t2.customer) as t2
set customer.location = t2.location
where customer.email = t2.email;

    
end //
delimiter ;


