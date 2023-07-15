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
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    season_id INT REFERENCES seasons (id) ON DELTE SET NULL

);

CREATE TABLE seasons 
(
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE teams 
(
    id SERIAL PRIMARY KEY,
    team_name TEXT,
    league_id INTEGER REFERENCES leagues (id) ON DELETE SET NULL
);

CREATE TABLE players 
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    team_id INT REFERENCES teams (id) ON DELETE SET NULL,
    position TEXT 

);

CREATE TABLE referees 
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL

);

CREATE TABLE matches 
(
    id SERIAL PRIMARY KEY,
    home_team_id INTEGER REFERENCES teams (id),
    home_score INTEGER,
    away_team_id INTEGER REFERENCES teams (id),
    away_score INTEGER,
    referee_id INTEGER REFERENCES referees (id),
    match_duration TIME
);

CREATE TABLE match_goals 
(
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches (id) ON DELETE CASCADE,
    goal_scorer_player_id INTEGER REFERENCES players (id) ON DELETE NULL,
    goalie_player_id INTEGER REFERENCES players (id) ON DELETE NULL

);
 