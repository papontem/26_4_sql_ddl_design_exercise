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
    region TEXT VARCHAR(100),
    PRIMARY KEY(id)
);

CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    username TEXT VARCHAR(25) UNIQUE,
    user_preffered_region_id INTEGER  REFERENCES regions (id) ON DELETE NULL,
);

CREATE TABLE posts
(
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    user_id INTEGER REFERENCES users (id) NOT NULL ON DELETE CASCADE,
    text_description TEXT, 
    post_location TEXT,
    post_region INTEGER REFERENCES regions (id) NOT NULL ON DELETE NULL
);

CREATE TABLE categories
(
    id SERIAL PRIMARY KEY,
    category TEXT VARCHAR(30) NOT NULL,
);
