-- from the terminal run:
-- psql < outer_space.sql

DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

\c outer_space

-- Create the galaxies table
CREATE TABLE galaxies
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

-- Create the stars table
CREATE TABLE stars
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  galaxy_id INTEGER REFERENCES galaxies (id) ON DELETE CASCADE
);

-- Create the planets table
CREATE TABLE planets
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  orbit_in_E_yrs FLOAT NOT NULL,
  orbiting_star_id INTEGER REFERENCES stars (id) ON DELETE CASCADE,
  galaxy_id INTEGER REFERENCES galaxies (id) ON DELETE CASCADE
);

-- Create the moons table
CREATE TABLE moons
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  planet_id INTEGER REFERENCES planets (id) NOT NULL
 
);


-- Insert data into the galaxies table
INSERT INTO galaxies 
	(name)
VALUES 
	('Milky Way');

-- Insert data into the stars table
INSERT INTO stars 
	(name, galaxy_id)
VALUES 
	('The Sun', 1),
	('Proxima Centauri', 1),
	('Gliese 876', 1);

-- Insert data into the planets table
INSERT INTO planets
	(name, orbit_in_E_yrs, orbiting_star_id, galaxy_id)
VALUES 
	('Earth',			  	 1.00,  	1,	 1	),
	('Mars', 			  	 1.88,  	1,	 1	),
	('Venus',			  	 0.62,  	1,	 1	),
	('Neptune', 		  	 164.8, 	1,	 1	),
	('Proxima Centauri b',	 0.03,  	2,	 1	),
	('Gliese 876 b',		 0.23,  	3,	 1	);

-- Insert data into the moons table
INSERT INTO moons 
	(name, planet_id )
VALUES 
	('The Moon',1),
	('Phobos',2),
	('Deimos',2),
	('Naiad',4),
	('Thalassa',4),
	('Despina',4),
	('Galatea',4),
	('Larissa',4),
	('S/2004 N 1',4),
	('Proteus',4),
	('Triton',4),
	('Nereid',4),
	('Halimede',4),
	('Sao',4),
	('Laomedeia',4),
	('Psamathe',4),
	('Neso',4);

-- get all planets
SELECT
    p.name AS planet_name,
    m.name AS moon_name,
    s.name AS orbits_star_name,
    p.orbit_in_E_yrs AS star_orbit_in_Earth_years
FROM planets p
JOIN stars s ON p.orbiting_star_id = s.id
LEFT JOIN moons m ON m.planet_id = p.id
LEFT JOIN planets pm ON pm.id = m.planet_id;



-- -- PAM: THE GIVEN ORIGINAL SCHEMA -- --  
/*  PAM Critique: repeating values sun, milky way, able to make other tables to normalize data, 
	long moons array for neptune stands out too much,
	we can create a moons table where each can have its parent body id refer to a planet ,
	could just call orbital_period_in_years -> orbit_in_earth_years (orbit_in_E_yrs)
*/
-- CREATE TABLE planets
-- (
--   id SERIAL PRIMARY KEY,
--   name TEXT NOT NULL,
--   orbital_period_in_years FLOAT NOT NULL,
--   orbits_around TEXT NOT NULL,
--   galaxy TEXT NOT NULL,
--   moons TEXT[]
-- );

-- INSERT INTO planets
--   (name, orbital_period_in_years, orbits_around, galaxy, moons)
-- VALUES
--   ('Earth', 1.00, 'The Sun', 'Milky Way', '{"The Moon"}'),
--   ('Mars', 1.88, 'The Sun', 'Milky Way', '{"Phobos", "Deimos"}'),
--   ('Venus', 0.62, 'The Sun', 'Milky Way', '{}'),
--   ('Neptune', 164.8, 'The Sun', 'Milky Way', '{"Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "S/2004 N 1", "Proteus", "Triton", "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso"}'),
--   ('Proxima Centauri b', 0.03, 'Proxima Centauri', 'Milky Way', '{}'),
--   ('Gliese 876 b', 0.23, 'Gliese 876', 'Milky Way', '{}');