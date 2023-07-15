-- MADE BY PAM --
-- from the terminal run:
-- psql < soccer_league.sql

DROP DATABASE IF EXISTS soccer_leagues_db;

CREATE DATABASE soccer_leagues_db;
											
\c soccer_league
											
-- All of the teams in the league
-- All of the goals scored by every player for each game
-- All of the players in the league and their corresponding teams
-- All of the referees who have been part of each game
-- All of the matches played between teams
-- All of the start and end dates for season that a league has
-- The standings/rankings of each team in the league (This doesn’t have to be its own table if the data can be captured somehow).

CREATE TABLE leagues 
(
    id SERIAL PRIMARY KEY

);
CREATE TABLE seasons 
(
    id SERIAL PRIMARY KEY
);
CREATE TABLE teams 
(
    id SERIAL PRIMARY KEY
);
CREATE TABLE players 
(
    id SERIAL PRIMARY KEY
);
CREATE TABLE referees 
(
    id SERIAL PRIMARY KEY

);
CREATE TABLE matches 
(
    id SERIAL PRIMARY KEY

);
CREATE TABLE match_goals 
(
    id SERIAL PRIMARY KEY

);
