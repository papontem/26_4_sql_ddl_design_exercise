-- from the terminal run:
-- psql < air_traffic.sql

DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

\c air_traffic

CREATE TABLE passengers
(
	id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL
);

CREATE TABLE locations
(
	id SERIAL PRIMARY KEY,
	country TEXT NOT NULL,
	city TEXT NOT NULL
);

CREATE TABLE airlines
(
	id SERIAL PRIMARY KEY,
	airline_name TEXT NOT NULL
);

CREATE TABLE tickets
(
	id SERIAL PRIMARY KEY,
	seat TEXT NOT NULL,
	passenger_id INTEGER REFERENCES passengers (id) ON DELETE SET NULL,
	departure TIMESTAMP NOT NULL,
	arrival TIMESTAMP NOT NULL,
	airline_id INTEGER REFERENCES airlines (id) ON DELETE SET NULL,
	from_location_id INTEGER REFERENCES locations (id) ON DELETE SET NULL,
	to_location_id INTEGER REFERENCES locations (id) ON DELETE SET NULL
);

INSERT INTO passengers (first_name, last_name)
VALUES
	('Jennifer', 'Finch'),  
	('Thadeus', 'Gathercoal'),  
	('Sonja', 'Pauley'),  
	('Jennifer', 'Finch'),  
	('Waneta', 'Skeleton'),  
	('Thadeus', 'Gathercoal'),  
	('Berkie', 'Wycliff'),  
	('Alvin', 'Leathes'),  
	('Berkie', 'Wycliff'),  
	('Cory', 'Squibbes');

INSERT INTO airlines (airline_name)
VALUES
	('United'),  
	('British Airways'),  
	('Delta'),  
	('TUI Fly Belgium'),  
	('Air China'),  
	('American Airlines'),  
	('Avianca Brasil');

INSERT INTO locations (country, city)
VALUES
	('United States', 'Washington DC'),
	('Japan', 'Tokyo'),
	('United States', 'Los Angeles'),
	('United States', 'Seattle'),
	('France', 'Paris'),
	('UAE', 'Dubai'),
	('United States', 'New York'),
	('United States', 'Cedar Rapids'),
	('United States', 'Charlotte'),
	('Brazil', 'Sao Paolo');

INSERT INTO tickets
	(passenger_id, seat, departure, arrival, airline_id, from_location_id, to_location_id)
VALUES
	( 1, '33B' , '2018-04-08 09:00:00', '2018-04-08 12:00:00', 1, 1, 8),
	( 2, '8A'  , '2018-12-19 12:45:00', '2018-12-19 16:15:00', 2, 2, 7),
	( 3, '12F' , '2018-01-02 07:00:00', '2018-01-02 08:03:00', 3, 3, 9),
	( 4, '20A' , '2018-04-15 16:50:00', '2018-04-15 21:00:00', 3, 4, 10),
	( 5, '23D' , '2018-08-01 18:30:00', '2018-08-01 21:50:00', 4, 5, 6),
	( 6, '18C' , '2018-10-31 01:15:00', '2018-10-31 12:55:00', 5, 7, 5),
	( 7, '9E'  , '2019-02-06 06:00:00', '2019-02-06 07:47:00', 1, 8, 4),
	( 8, '1A'  , '2018-12-22 14:42:00', '2018-12-22 15:56:00', 6, 9, 3),
	( 9, '32B' , '2019-02-06 16:28:00', '2019-02-06 19:18:00', 6, 10, 2),
	(10, '10D' , '2019-01-20 19:30:00', '2019-01-20 22:45:00', 7, 5, 1);


-- show tickets complete information
SELECT 
    t.id AS ticket_id,
    t.seat,
	CONCAT(p.first_name , ' , ', p.last_name) AS passenger,
    t.departure,
    t.arrival,
    a.airline_name AS airline,
    CONCAT(from_loc.city, ', ', from_loc.country) AS from,
    CONCAT(to_loc.city, ', ', to_loc.country) AS to
FROM
    tickets t
    JOIN passengers p ON t.passenger_id = p.id
    JOIN airlines a ON t.airline_id = a.id
    JOIN locations from_loc ON t.from_location_id = from_loc.id
    JOIN locations to_loc ON t.to_location_id = to_loc.id;





-- -- PAM: THE GIVEN ORIGINAL SCHEMA -- --  
/* PAMS CRITIQUE
  you have from location to location broken into seperete collumns of city and country,
   we easily just put those city airports in a table for locations.
  We can have a table for passengers, and airlines. 
-- */
-- DROP DATABASE IF EXISTS air_traffic;

-- CREATE DATABASE air_traffic;

-- \c air_traffic

-- CREATE TABLE tickets
-- (
-- 	id SERIAL PRIMARY KEY,
-- 	first_name TEXT NOT NULL,
-- 	last_name TEXT NOT NULL,
-- 	seat TEXT NOT NULL,
-- 	departure TIMESTAMP NOT NULL,
-- 	arrival TIMESTAMP NOT NULL,
-- 	airline TEXT NOT NULL,
-- 	from_city TEXT NOT NULL,
-- 	from_country TEXT NOT NULL,
-- 	to_city TEXT NOT NULL,
-- 	to_country TEXT NOT NULL
-- );

-- INSERT INTO tickets
-- 	(first_name  , last_name     , seat   , departure            , arrival              , airline               , from_city          , from_country     , to_city          , to_country       )
-- VALUES
-- 	('Jennifer'  , 'Finch'       , '33B'  , '2018-04-08 09:00:00', '2018-04-08 12:00:00', 'United'              , 'Washington DC'    , 'United States'  , 'Seattle'        , 'United States'  ),
-- 	('Thadeus'   , 'Gathercoal'  , '8A'   , '2018-12-19 12:45:00', '2018-12-19 16:15:00', 'British Airways'     , 'Tokyo'            , 'Japan'          , 'London'         , 'United Kingdom' ),
-- 	('Sonja'     , 'Pauley'      , '12F'  , '2018-01-02 07:00:00', '2018-01-02 08:03:00', 'Delta'               , 'Los Angeles'      , 'United States'  , 'Las Vegas'      , 'United States'  ),
-- 	('Jennifer'  , 'Finch'       , '20A'  , '2018-04-15 16:50:00', '2018-04-15 21:00:00', 'Delta'               , 'Seattle'          , 'United States'  , 'Mexico City'    , 'Mexico'         ),
-- 	('Waneta'    , 'Skeleton'    , '23D'  , '2018-08-01 18:30:00', '2018-08-01 21:50:00', 'TUI Fly Belgium'     , 'Paris'            , 'France'         , 'Casablanca'     , 'Morocco'        ),
-- 	('Thadeus'   , 'Gathercoal'  , '18C'  , '2018-10-31 01:15:00', '2018-10-31 12:55:00', 'Air China'           , 'Dubai'            , 'UAE'            , 'Beijing'        , 'China'          ),
-- 	('Berkie'    , 'Wycliff'     , '9E'   , '2019-02-06 06:00:00', '2019-02-06 07:47:00', 'United'              , 'New York'         , 'United States'  , 'Charlotte'      , 'United States'  ),
-- 	('Alvin'     , 'Leathes'     , '1A'   , '2018-12-22 14:42:00', '2018-12-22 15:56:00', 'American Airlines'   , 'Cedar Rapids'     , 'United States'  , 'Chicago'        , 'United States'  ),
-- 	('Berkie'    , 'Wycliff'     , '32B'  , '2019-02-06 16:28:00', '2019-02-06 19:18:00', 'American Airlines'   , 'Charlotte'        , 'United States'  , 'New Orleans'    , 'United States'  ),
-- 	('Cory'      , 'Squibbes'    , '10D'  , '2019-01-20 19:30:00', '2019-01-20 22:45:00', 'Avianca Brasil'      , 'Sao Paolo'        , 'Brazil'         , 'Santiago'       , 'Chile'          );