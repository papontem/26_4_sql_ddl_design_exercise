-- from the terminal run:
-- psql < music.sql
DROP DATABASE IF EXISTS music;

CREATE DATABASE music;

\c music

CREATE TABLE artists
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE albums
(
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL
);

CREATE TABLE producers
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE songs
(
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  duration_in_seconds INTEGER NOT NULL,
  release_date DATE NOT NULL,
  artist_id INTEGER REFERENCES artists (id) NOT NULL,
  co_artist_id INTEGER REFERENCES artists (id),
  album_id INTEGER REFERENCES albums (id) NOT NULL,
  producer_id INTEGER REFERENCES producers (id) NOT NULL,
  co_producer_id INTEGER REFERENCES producers (id)
);

INSERT INTO artists (name)
VALUES
  ('Hanson'),
  ('Queen'),
  ('Mariah Carey'),
  ('Boyz II Men'),
  ('Lady Gaga'),
  ('Bradley Cooper'),
  ('Nickelback'),
  ('Jay Z'),
  ('Alicia Keys'),
  ('Katy Perry'),
  ('Juicy J'),
  ('Maroon 5'),
  ('Christina Aguilera'),
  ('Avril Lavigne'),
  ('Destiny''s Child');

INSERT INTO albums (title)
VALUES
  ('Middle of Nowhere'),
  ('A Night at the Opera'),
  ('Daydream'),
  ('A Star Is Born'),
  ('Silver Side Up'),
  ('The Blueprint 3'),
  ('Prism'),
  ('Hands All Over'),
  ('Let Go'),
  ('The Writing''s on the Wall');

INSERT INTO producers (name)
VALUES
  ('Dust Brothers'),
  ('Stephen Lironi'),
  ('Roy Thomas Baker'),
  ('Walter Afanasieff'),
  ('Benjamin Rice'),
  ('Rick Parashar'),
  ('Al Shux'),
  ('Max Martin'),
  ('Cirkut'),
  ('Shellback'),
  ('Benny Blanco'),
  ('The Matrix'),
  ('Darkchild');

INSERT INTO songs
  (title,     duration_in_seconds, release_date, artist_id , co_artist_id  , album_id, producer_id, co_producer_id)
VALUES
  ('MMMBop'                 , 238, '1997-04-15', 1         , NULL          , 1       , 1          , 2    ),
  ('Bohemian Rhapsody'      , 355, '1975-10-31', 2         , NULL          , 2       , 3          , NULL ),
  ('One Sweet Day'          , 282, '1995-11-14', 3         , 4             , 3       , 4          , NULL ),
  ('Shallow'                , 216, '2018-09-27', 5         , 6             , 4       , 5          , NULL ),
  ('How You Remind Me'      , 223, '2001-08-21', 7         , NULL          , 5       , 6          , NULL ),
  ('New York State of Mind' , 276, '2009-10-20', 8         , 9             , 6       , 7          , NULL ),
  ('Dark Horse'             , 215, '2013-12-17', 10        , 11            , 7       , 8          , 9    ),
  ('Moves Like Jagger'      , 201, '2011-06-21', 12        , 13            , 8       , 10         , 11   ),
  ('Complicated'            , 244, '2002-05-14', 14        , NULL          , 9       , 12         , NULL ),
  ('Say My Name'            , 240, '1999-11-07', 15        , NULL          , 10      , 13         , NULL );





-- SHOW EVEYTHING A BIT NICER
SELECT
  s.id AS song_id,
  s.title AS song_title,
  LPAD(s.duration_in_seconds::text, 12) AS duration_in_seconds,
  s.release_date AS song_release_date,
  CASE
    WHEN s.co_artist_id IS NULL THEN a.name
    ELSE CONCAT(a.name, ' and ', a_co.name)
  END AS Made_By,
  al.title AS album_title,
  CASE
    WHEN p_co.id IS NULL THEN p.name
    ELSE CONCAT(p.name, ' and ', p_co.name)
  END AS Produced_By
FROM
  songs s
JOIN
  artists a ON a.id = s.artist_id
LEFT JOIN
  artists a_co ON a_co.id = s.co_artist_id
JOIN
  albums al ON al.id = s.album_id
JOIN
  producers p ON p.id = s.producer_id
LEFT JOIN
  producers p_co ON p_co.id = s.co_producer_id;

-- -- SHOW EVEYTHING
-- SELECT
--   s.id AS song_id,
--   s.title AS song_title,
--   s.duration_in_seconds,
--   s.release_date AS song_release_date,
--   a.id AS artist_id,
--   a.name AS artist_name,
--   a_co.id AS co_artist_id,
--   a_co.name AS co_artist_name,
--   al.id AS album_id,
--   al.title AS album_title,
--   p.id AS producer_id,
--   p.name AS producer_name,
--   p_co.id AS co_producer_id,
--   p_co.name AS co_producer_name
-- FROM
--   songs s
-- JOIN
--   artists a ON a.id = s.artist_id
-- LEFT JOIN
--   artists a_co ON a_co.id = s.co_artist_id
-- JOIN
--   albums al ON al.id = s.album_id
-- JOIN
--   producers p ON p.id = s.producer_id
-- LEFT JOIN
--   producers p_co ON p_co.id = s.co_producer_id;



-- -- PAM: THE GIVEN ORIGINAL SCHEMA -- --  
/*  Critique: we can put aritist, album and producers into their own tables.
also the date format can be confusing so im gonna change that to YYYY-MM-DD,
as for now we dont see more than 2 artists or more than 2 producers for every single song,
 so for now i think we can add a co artist and a co-producer section.
*/
-- DROP DATABASE IF EXISTS music;

-- CREATE DATABASE music;

-- \c music

-- CREATE TABLE songs
-- (
--   id SERIAL PRIMARY KEY,
--   title TEXT NOT NULL,
--   duration_in_seconds INTEGER NOT NULL,
--   release_date DATE NOT NULL,
--   artists TEXT[] NOT NULL,
--   album TEXT NOT NULL,
--   producers TEXT[] NOT NULL
-- );

-- INSERT INTO songs
--   (title              ,duration_in_seconds, release_date, artists                      , album                          , producers)
-- VALUES
--   ('MMMBop'                  ,  238 ,      '04-15-1997' ,  '{"Hanson"}'                           ,  'Middle of Nowhere'           ,  '{"Dust Brothers" ,  "Stephen Lironi"}' ),
--   ('Bohemian Rhapsody'       ,  355 ,      '10-31-1975' ,  '{"Queen"}'                            ,  'A Night at the Opera'        ,  '{"Roy Thomas Baker"}'                  ),
--   ('One Sweet Day'           ,  282 ,      '11-14-1995' ,  '{"Mariah Cary" ,  "Boyz II Men"}'     ,  'Daydream'                    ,  '{"Walter Afanasieff"}'                 ),
--   ('Shallow'                 ,  216 ,      '09-27-2018' ,  '{"Lady Gaga" ,  "Bradley Cooper"}'    ,  'A Star Is Born'              ,  '{"Benjamin Rice"}'                     ),
--   ('How You Remind Me'       ,  223 ,      '08-21-2001' ,  '{"Nickelback"}'                       ,  'Silver Side Up'              ,  '{"Rick Parashar"}'                     ),
--   ('New York State of Mind'  ,  276 ,      '10-20-2009' ,  '{"Jay Z" ,  "Alicia Keys"}'           ,  'The Blueprint 3'             ,  '{"Al Shux"}'                           ),
--   ('Dark Horse'              ,  215 ,      '12-17-2013' ,  '{"Katy Perry" ,  "Juicy J"}'          ,  'Prism'                       ,  '{"Max Martin" ,  "Cirkut"}'            ),
--   ('Moves Like Jagger'       ,  201 ,      '06-21-2011' ,  '{"Maroon 5" ,  "Christina Aguilera"}' ,  'Hands All Over'              ,  '{"Shellback" ,  "Benny Blanco"}'       ),
--   ('Complicated'             ,  244 ,      '05-14-2002' ,  '{"Avril Lavigne"}'                    ,  'Let Go'                      ,  '{"The Matrix"}'                        ),
--   ('Say My Name'             ,  240 ,      '11-07-1999' ,  '{"Destiny''s Child"}'                 ,  'The Writing''s on the Wall'  ,  '{"Darkchild"}'                         );