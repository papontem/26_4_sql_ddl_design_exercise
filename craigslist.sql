-- MADE BY PAM --
-- from the terminal run:
-- psql < craigslist_db.sql

DROP DATABASE IF EXISTS craigslist_db;

CREATE DATABASE craigslist_db;

\c craigslist_db

-- Region: of the craigslist post (San Francisco, Atlanta, Seattle, etc)
-- Users: username, preferred region
-- Posts: title, text, user , post location, post region
-- Categories: that each post belongs to

CREATE TABLE regions
(
    id SERIAL PRIMARY KEY,
    region VARCHAR(100)
);

CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) UNIQUE,
    user_preffered_region_id INTEGER REFERENCES regions (id) ON DELETE SET NULL
);

CREATE TABLE categories
(
    id SERIAL PRIMARY KEY,
    category VARCHAR(30) NOT NULL
);

CREATE TABLE posts
(
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users (id) ON DELETE CASCADE,
    post_region INTEGER REFERENCES regions (id) ON DELETE SET NULL,
    category_id INTEGER REFERENCES categories (id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    text_description TEXT, 
    post_location TEXT
);



INSERT INTO regions (region)
VALUES 
    ('Texas'),
    ('Atlanta'),
    ('Seattle'),
    ('California'),
    ('New York'),
    ('Florida');

INSERT INTO users (username, user_preffered_region_id)
VALUES 
    ('JohnDoe', 1),
    ('JaneSmith', 2),
    ('MikeJohnson', NULL),
    ('SarahJones', NULL),
    ('MarkWilson', 6),
    ('EmilyBrown', 5);

INSERT INTO categories (category)
VALUES 
    ('Cars'),
    ('Electronics'),
    ('Furniture'),
    ('Sports'),
    ('Jobs'),
    ('Real Estate');

INSERT INTO posts (user_id, post_region, category_id , title, text_description, post_location)
VALUES 
    (1, 1, 1, 'CARS CARS CARS', 'I have a warehouse sale with great deals on brand new 2023 8 Wheel Drive Corpse Consuming Grand Native American Road Ravager 3000s. Call now to get your hands on one!', 'Car Dealer Emporium, 345 West End Blvd'),
    (2, 2, 2,'Selling Electronics', 'I am selling a slightly used electronic item. It has one month left on its warranty. Shipping available with a $50 shipping fee.', NULL),
    (3, 3, 3,'Free Chair', 'I have a free chair available. It''s located outside at 123 Mistletoe Can Dr. Please pick it up if interested.', '123 Mistletoe Can Dr.'),
    (4, 2, 4,'Selling Bicycles', 'I have a variety of bicycles for sale. From mountain bikes to city cruisers. Contact me for more details.', '123 Main St'),
    (5, 1, 5,'Job Opportunity', 'We are hiring! Looking for motivated individuals to join our team. Competitive salary and benefits. Apply now!', '456 Elm Ave'),
    (6, 3, 6,'Apartment for Rent', 'Spacious 2-bedroom apartment available for rent. Great location and amenities. Contact for viewing.', '789 Oak Dr');





-- get everything 0_0 neatly -- 
SELECT
    p.id AS post_id,
    p.title AS post_title,
    u.username AS user_username,
    c.category AS category,
    CONCAT(SUBSTRING(p.text_description FROM 1 FOR 30), '...') AS text_description,
    CONCAT(p.post_location, ', ', r.region) AS address
FROM
    posts p
    JOIN users u ON p.user_id = u.id
    JOIN regions r ON p.post_region = r.id
    JOIN categories c ON p.category_id = c.id;
