-- Файл: sql/load_data.sql
-- Описание: Скрипт для загрузки данных из .csv в OLTP базу данных (перезапускать)

-- Временное отключение ограничений внешних ключей для вставки
SET CONSTRAINTS ALL
DEFERRED;

-- Загрузка Genres во временную таблицу
CREATE TEMP TABLE temp_genres (genre_name VARCHAR(50));
COPY temp_genres
FROM
  'D:\Course_BD\data_for_oltp - Genres.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
INSERT INTO
  Genres (genre_name)
SELECT DISTINCT
  genre_name
FROM
  temp_genres
ON CONFLICT (genre_name)
DO
  NOTHING;
  DROP TABLE temp_genres;

  -- Загрузка Users во временную таблицу
  CREATE TEMP TABLE temp_users (
    username VARCHAR(50)
    , email VARCHAR(100)
    , registration_date TIMESTAMP
  );
  COPY temp_users
  FROM
    'D:\Course_BD\data_for_oltp - Users.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Users (username, email, registration_date)
  SELECT
    username
    , email
    , registration_date
  FROM
    temp_users
  ON CONFLICT (username)
DO
  UPDATE
  SET email = EXCLUDED.email, registration_date = EXCLUDED.registration_date
  WHERE
    Users.email != EXCLUDED.email
    OR Users.registration_date != EXCLUDED.registration_date;
  DROP TABLE temp_users;

  -- Загрузка Videos во временную таблицу
  CREATE TEMP TABLE temp_videos (
    title VARCHAR(200)
    , description TEXT
    , duration INTEGER
    , file_path VARCHAR(500)
    , upload_date TIMESTAMP
    , username VARCHAR(50)
    , genre VARCHAR(50)
  );
  COPY temp_videos
  FROM
    'D:\Course_BD\data_for_oltp - Videos.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Videos (
      title
      , description
      , duration
      , file_path
      , upload_date
      , user_id
      , genre_id
    )
  SELECT
    t.title
    , t.description
    , t.duration
    , t.file_path
    , t.upload_date
    , u.user_id
    , g.genre_id
  FROM
    temp_videos t
    JOIN Users u
  ON t.username = u.username
  JOIN Genres g
  ON t.genre = g.genre_name
  ON CONFLICT (title)
DO
  UPDATE
  SET description = EXCLUDED.description, duration = EXCLUDED.duration, file_path = EXCLUDED.file_path, upload_date = EXCLUDED.upload_date, user_id = EXCLUDED.user_id, genre_id = EXCLUDED.genre_id
  WHERE
    Videos.description != EXCLUDED.description
    OR Videos.duration != EXCLUDED.duration
    OR Videos.file_path != EXCLUDED.file_path
    OR Videos.upload_date != EXCLUDED.upload_date
    OR Videos.user_id != EXCLUDED.user_id
    OR Videos.genre_id != EXCLUDED.genre_id;
  DROP TABLE temp_videos;

  -- Загрузка Comments во временную таблицу
  CREATE TEMP TABLE temp_comments (
    video_title VARCHAR(200)
    , username VARCHAR(50)
    , comment_text TEXT
    , comment_date TIMESTAMP
  );
  COPY temp_comments
  FROM
    'D:\Course_BD\data_for_oltp - Comments.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Comments (video_id, user_id, comment_text, comment_date)
  SELECT
    v.video_id
    , u.user_id
    , tc.comment_text
    , tc.comment_date
  FROM
    temp_comments tc
    JOIN Videos v
  ON tc.video_title = v.title
  JOIN Users u
  ON tc.username = u.username
  ON CONFLICT (video_id, user_id, comment_date)
DO
  UPDATE
  SET comment_text = EXCLUDED.comment_text
  WHERE
    Comments.comment_text != EXCLUDED.comment_text;
  DROP TABLE temp_comments;

  -- Загрузка Likes во временную таблицу
  CREATE TEMP TABLE temp_likes (
    username VARCHAR(50)
    , video_title VARCHAR(200)
    , like_type BOOLEAN
    , like_date TIMESTAMP
  );
  COPY temp_likes
  FROM
    'D:\Course_BD\data_for_oltp - Likes.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Likes (user_id, video_id, like_type, like_date)
  SELECT
    u.user_id
    , v.video_id
    , tl.like_type
    , tl.like_date
  FROM
    temp_likes tl
    JOIN Users u
  ON tl.username = u.username
  JOIN Videos v
  ON tl.video_title = v.title
  ON CONFLICT (user_id, video_id, like_date)
DO
  UPDATE
  SET like_type = EXCLUDED.like_type
  WHERE
    Likes.like_type != EXCLUDED.like_type;
  DROP TABLE temp_likes;

  -- Загрузка Views во временную таблицу
  CREATE TEMP TABLE temp_views (
    username VARCHAR(50)
    , video_title VARCHAR(200)
    , view_date TIMESTAMP
  );
  COPY temp_views
  FROM
    'D:\Course_BD\data_for_oltp - Views.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Views (user_id, video_id, view_date)
  SELECT
    u.user_id
    , v.video_id
    , tv.view_date
  FROM
    temp_views tv
    JOIN Users u
  ON tv.username = u.username
  JOIN Videos v
  ON tv.video_title = v.title
  ON CONFLICT (user_id, video_id, view_date)
DO
  NOTHING;
  DROP TABLE temp_views;

  -- Загрузка Playlists во временную таблицу
  CREATE TEMP TABLE temp_playlists (
    title VARCHAR(200)
    , username VARCHAR(50)
    , created_date TIMESTAMP
  );
  COPY temp_playlists
  FROM
    'D:\Course_BD\data_for_oltp - Playlists.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    Playlists (title, user_id, created_date)
  SELECT
    tp.title
    , u.user_id
    , tp.created_date
  FROM
    temp_playlists tp
    JOIN Users u
  ON tp.username = u.username
  ON CONFLICT (title)
DO
  UPDATE
  SET user_id = EXCLUDED.user_id, created_date = EXCLUDED.created_date
  WHERE
    Playlists.user_id != EXCLUDED.user_id
    OR Playlists.created_date != EXCLUDED.created_date;
  DROP TABLE temp_playlists;

  -- Загрузка PlaylistVideos во временную таблицу
  CREATE TEMP TABLE temp_playlistvideos (
    playlist_title VARCHAR(200)
    , video_title VARCHAR(200)
    , added_date TIMESTAMP
  );
  COPY temp_playlistvideos
  FROM
    'D:\Course_BD\data_for_oltp - PlaylistVideos.csv'
  WITH (FORMAT CSV, HEADER, DELIMITER ',');
  INSERT INTO
    PlaylistVideos (playlist_id, video_id, added_date)
  SELECT
    p.playlist_id
    , v.video_id
    , tpv.added_date
  FROM
    temp_playlistvideos tpv
    JOIN Playlists p
  ON tpv.playlist_title = p.title
  JOIN Videos v
  ON tpv.video_title = v.title
  ON CONFLICT (playlist_id, video_id)
DO
  UPDATE
  SET added_date = EXCLUDED.added_date
  WHERE
    PlaylistVideos.added_date != EXCLUDED.added_date;
  DROP TABLE temp_playlistvideos;

  -- Включение обратно ограничений внешних ключей
  SET CONSTRAINTS ALL
  IMMEDIATE;

  -- Проверка загруженных данных
  SELECT
    'Genres' AS table_name
    , COUNT(*)
  FROM
    Genres
  UNION
  SELECT
    'Users'
    , COUNT(*)
  FROM
    Users
  UNION
  SELECT
    'Videos'
    , COUNT(*)
  FROM
    Videos
  UNION
  SELECT
    'Comments'
    , COUNT(*)
  FROM
    Comments
  UNION
  SELECT
    'Likes'
    , COUNT(*)
  FROM
    Likes
  UNION
  SELECT
    'Views'
    , COUNT(*)
  FROM
    Views
  UNION
  SELECT
    'Playlists'
    , COUNT(*)
  FROM
    Playlists
  UNION
  SELECT
    'PlaylistVideos'
    , COUNT(*)
  FROM
    PlaylistVideos;