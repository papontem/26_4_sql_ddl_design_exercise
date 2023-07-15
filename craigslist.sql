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


CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    preferred_region INTEGER REFERENCES regions (id) ON DELETE NULL
);

CREATE TABLE posts
(
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    text_description TEXT, 
    post_location TEXT,
    user INTEGER REFERENCES users (id) ON DELETE CASCADE,
    post_region INTEGER REFERENCES regions (id) ON DELETE NULL

);

CREATE TABLE regions
(
    id SERIAL PRIMARY KEY,
    region TEXT NOT NULL
);

-- users <--O:M--> posts
CREATE TABLE user_posts

-- users <--M:O--> regions
CREATE TABLE user_regions

-- posts <--M:M--> regions
CREATE TABLE post_regions