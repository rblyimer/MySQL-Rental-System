# Rental-System
Dimitri runs a small car rental company with 10 cars and 5 trucks. He engages you to design a web portal to put his operation online.

For the initial phase, the web portal shall provide these basic functions:

Maintaining the records of the vehicles and customers.
Inquiring about the availability of vehicles, and
Reserving a vehicle for rental.

Here are some requirements that will give you more context to how his business should run.

A customer record contains his/her name, address, and phone number.
A vehicle, identified by the vehicle registration number, can be rented on a daily basis. The rental rate is different for different vehicles. There is a discount of 20% for rental of 7 days or more.
A customer can rent a vehicle from a start date to an end date. A special customer discount, ranging from 0-50%, can be given to preferred customers.

*NOTE: You do not have to actually create a website for this... this is just the scenario for the project.

Below are some of the questions you will be answering for your project.
For each of the following points, please return a query that will satisfy the statement.



## 1. Customer 'Angel' has rented 'SBA1111A' from today for 10 days. (Hint: You need to insert a rental record. 
Use a SELECT subquery to get the customer_id to do this you will need to use parenthesis 
for your subquery as one of your values. Use CURDATE() (or NOW()) for today, and DATE_ADD(CURDATE(), INTERVAL x unit) to compute a future date.)

## 2. Customer 'Kumar' has rented 'GA5555E' from tomorrow for 3 months.

## 3. List all rental records (start date, end date) with vehicle's registration number, brand, and customer name, 
sorted by vehicle's categories followed by start date.

## 4. List all the expired rental records (end_date before CURDATE()).

## 5. List the vehicles rented out on '2012-01-10' (not available for rental), in columns of vehicle registration no, customer name, start date and end date. 
(Hint: the given date is in between the start_date and end_date.)

## 6. List all vehicles rented out today, in columns registration number, customer name, start date, end date.

## 7. Similarly, list the vehicles rented out (not available for rental) for the period from '2012-01-03' to '2012-01-18'. 
(Hint: start_date is inside the range; or end_date is inside the range; or start_date is before the range and end_date is beyond the range.)

## 8. List the vehicles (registration number, brand and description) available for rental (not rented out) on '2012-01-10' 
(Hint: You could use a subquery based on a earlier query).

## 9. Similarly, list the vehicles available for rental for the period from '2012-01-03' to '2012-01-18'.

## 10. Similarly, list the vehicles available for rental from today for 10 days.
