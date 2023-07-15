-- MADE BY PAM --
-- from the terminal run:
-- psql < soccer_league.sql

DROP DATABASE IF EXISTS soccer_leagues_db;

CREATE DATABASE soccer_leagues_db;
											
\c soccer_leagues_db
											
-- All of the teams in the league
-- All of the goals scored by every player for each game
-- All of the players in the league and their corresponding teams
-- All of the referees who have been part of each game
-- All of the matches played between teams
-- All of the start and end dates for season that a league has
-- The standings/rankings of each team in the league (This doesn’t have to be its own table if the data can be captured somehow).

CREATE TABLE seasons 
(
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE leagues 
(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    season_id INTEGER REFERENCES seasons (id) ON DELETE SET NULL

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
    team_id INTEGER REFERENCES teams (id) ON DELETE SET NULL,
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
    goal_scorer_player_id INTEGER REFERENCES players (id) ON DELETE SET NULL,
    goalie_player_id INTEGER REFERENCES players (id) ON DELETE SET NULL

);

INSERT INTO seasons 
    (start_date, end_date) 
VALUES
    ('2022-08-01', '2023-05-31'),
    ('2023-08-01', '2024-05-31');


INSERT INTO leagues 
    (name, season_id)
VALUES
    ('Premier League', 1),
    ('La Liga', 1),
    ('Bundesliga', 2);

INSERT INTO referees 
    (first_name, last_name)
VALUES
    ('John', 'Smith'),
    ('Michael', 'Johnson'),
    ('David', 'Williams');

INSERT INTO teams 
    (team_name, league_id)
VALUES
    ('Manchester United', 1),
    ('Liverpool', 1),
    ('Real Madrid', 2),
    ('Barcelona', 2),
    ('Bayern Munich', 3),
    ('Borussia Dortmund', 3);


INSERT INTO players 
    (first_name, last_name, team_id, position)
VALUES
    ('Harry',   'Kane'  ,         1 , 'Forward'     ),
    ('Bruno',   'Fernandes'  ,    1 , 'Midfielder'  ),
    ('Mohamed', 'Salah'  ,        2 , 'Forward'     ),
    ('Virgil',  'van Dijk'  ,     2 , 'Defender'    ),
    ('Karim',   'Benzema'  ,      3 , 'Forward'     ),
    ('Sergio',  'Ramos'  ,        3 , 'Defender'    ),
    ('Lionel',  'Messi'  ,        4 , 'Forward'     ),
    ('Gerard',  'Pique'  ,        4 , 'Defender'    ),
    ('Robert',  'Lewandowski'  ,  5 , 'Forward'     ),
    ('Erling',  'Haaland'  ,      5 , 'Forward'     ),
    ('Marco',   'Reus'  ,         6 , 'Midfielder'  ),
    ('Mats',    'Hummels'  ,      6 , 'Defender'    );

INSERT INTO matches 
    (home_team_id, home_score, away_team_id, away_score, referee_id, match_duration)
VALUES
    (1, 2, 2, 1, 1, '01:45:00'),
    (3, 3, 4, 2, 2, '02:00:00'),
    (5, 1, 6, 1, 3, '01:30:00'),
    (2, 0, 1, 2, 1, '01:50:00'),
    (4, 2, 3, 1, 2, '02:15:00'),
    (6, 0, 5, 3, 3, '01:40:00');

INSERT INTO match_goals 
    (match_id, goal_scorer_player_id, goalie_player_id)
VALUES
    (1,  1   ,  4  ),
    (1,  2   ,  4  ),
    (1,  2   ,  3  ),
    (2,  3   ,  1  ),
    (2,  4   ,  2  ),
    (3,  5   ,  6  ),
    (3,  6   ,  5  ),
    (4,  7   ,  8  ),
    (4,  8   ,  7  ),
    (5,  9   ,  12 ),
    (5,  10  ,  11 ),
    (6,  11  ,  10 ),
    (6,  12  ,  9  );

-- get all matches 
SELECT
    m.id AS match_id,
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    CASE
        -- Home team won
        WHEN m.home_score > m.away_score THEN t1.team_name
        -- Away team won  
        WHEN m.home_score < m.away_score THEN t2.team_name  
        ELSE 'Draw'  -- Match ended in a draw
    END AS winner,
    m.match_duration
FROM matches m
JOIN teams t1 ON t1.id = m.home_team_id
JOIN teams t2 ON t2.id = m.away_team_id;

-- rank the players 
SELECT
    p.first_name,
    p.last_name,
    COUNT(*) AS total_goals
FROM
    players p
JOIN
    match_goals mg ON mg.goal_scorer_player_id = p.id
GROUP BY
    p.first_name,
    p.last_name
ORDER BY
    total_goals DESC;


-- rank the teams
SELECT
    t.team_name,
    COUNT(*) AS total_matches,
    SUM(CASE
        -- Home team won --
        WHEN m.home_team_id = t.id AND m.home_score > m.away_score THEN 2
        -- Away team won --
        WHEN m.away_team_id = t.id AND m.home_score < m.away_score THEN 2
        -- DRAW --
        WHEN m.home_team_id = t.id AND m.home_score = m.away_score THEN 1
        WHEN m.away_team_id = t.id AND m.home_score = m.away_score THEN 1  
        ELSE 0 -- Team lost
    END) AS total_points,
    SUM(CASE
        -- Home team drew 
        WHEN m.home_team_id = t.id AND m.home_score = m.away_score THEN 1  
        -- Away team drew 
        WHEN m.away_team_id = t.id AND m.home_score = m.away_score THEN 1  
        ELSE 0 -- team lost or won
    END) AS total_draws
FROM
    teams t
LEFT JOIN
    matches m ON m.home_team_id = t.id OR m.away_team_id = t.id
GROUP BY
    t.team_name
ORDER BY
    total_points DESC;


