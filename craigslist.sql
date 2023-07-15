-- MADE BY PAM --
-- from the terminal run:
-- psql < craigslist_db.sql

DROP DATABASE IF EXISTS craigslist_db;

CREATE DATABASE craigslist_db;

\c craigslist_db

-- The region of the craigslist post (San Francisco, Atlanta, Seattle, etc)
-- Users and preferred region
-- Posts: contains title, text, the user who has posted, the location of the posting, the region of the posting
-- Categories that each post belongs to


-- DEFINING REGIONS 
-- regions <--O:M--> XYZ
CREATE TABLE regions
(
    id SERIAL PRIMARY KEY,
    country TEXT,
    state TEXT,
    city TEXT 
);

-- DEFINING USERS  
CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    username TEXT VARCHAR(20) UNIQUE NOT NULL,
    email TEXT NOT NULL,
    phone TEXT UNIQUE,
    user_region_id INTEGER REFERENCES regions (id) ON DELETE SET NULL
);

-- DEFINING POSTS  
CREATE TABLE posts
(
    id SERIAL PRIMARY KEY,
    title TEXT VARCHAR(50) NOT NULL,
    user INTEGER REFERENCES users (id) ON DELETE CASCADE,
    post_region_id INTEGER REFERENCES regions (id) ON DELETE SET NULL,
    text_description TEXT VARCHAR(1000), 
    post_location TEXT,

);

-- DEFINING RELATION TABLES
-- users <--O:M--> posts
CREATE TABLE user_post_relations
(
    id PRIMARY KEY,
    user_id INTEGER REFERENCES users (id) ON DELETE CASCADE,
    post_id INTEGER REFERENCES posts (id) ON DELETE CASCADE
);


-- Inserting records into the 'region' table
INSERT INTO regions (country, state, city)
VALUES
    ('Australia', 'Tasmania', 'Hobart'),
    ('United States', 'New York', 'New York'),
    ('France', NULL, 'Paris');

-- Inserting records into the 'users' table
INSERT INTO users 
    (
        usernamem, email, phone, region_id
    )
VALUES
    ('John123',             'john.doe@example.com',     '123-456-7890', 1),
    ('alex808',             'alex.garcia@example.com',  '555-123-4567', 2),
    ('jane_Smith',          'jane.smith@example.com',   '987-654-3210', 3),
    ('Untouchable Inc.',    'untouchable@example.com',  '444-987-7890', NULL);

-- Inserting records into the 'posts' table
INSERT INTO posts (title, user_id, post_region_id, text_description, post_location)
VALUES
    ('Selling iPhone X', 1, 2, 'I am selling my iPhone X. It is in excellent condition. Not Stolen can provide original box', 'Downtown Manhattan'),
    ('Job Opening: Software Engineer', 2, 1, 'Looking for a Junior Software Developer with 5 year rxperience. Apply now!', '456 Smith Street'),
    ('Apartment for Rent', 3, 3, 'Spacious apartment available for rent in Paris city center.', '123 Rue de la Paix');




-- -- users <--M:O--> regions
-- CREATE TABLE user_region_relations
-- (
--     id PRIMARY KEY,
--     user_id INTEGER REFERENCES users (id) ON DELETE CASCADE,
--     region_id INTEGER REFERENCES regions (id) ON DELETE CASCADE
-- );

-- -- posts <--M:M--> regions
-- CREATE TABLE post_region_relations
-- (
--     id PRIMARY KEY,
--     post_id INTEGER REFERENCES posts (id) ON DELETE CASCADE,
--     region_id INTEGER REFERENCES regions (id) ON DELETE CASCADE
-- );



    

