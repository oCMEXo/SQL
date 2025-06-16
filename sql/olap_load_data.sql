
SET search_path
TO
  olap_video_analytics;

INSERT INTO
  Dim_Time (date, month, year)
SELECT DISTINCT
  DATE(view_date)
  , EXTRACT(
    MONTH
    FROM
      view_date
  )
  , EXTRACT(
    YEAR
    FROM
      view_date
  )
FROM
  dblink(
    'dbname=video_content_db'
    , 'SELECT view_date FROM Views'
  ) AS t(view_date TIMESTAMP)
ON CONFLICT (date)
DO
  NOTHING;

  INSERT INTO
    Dim_Users (username, email, start_date, end_date, is_active)
  SELECT
    username
    , email
    , registration_date
    , NULL
    , TRUE
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT username, email, registration_date FROM Users'
    ) AS t(
      username VARCHAR(50)
      , email VARCHAR(100)
      , registration_date TIMESTAMP
    )
  ON CONFLICT (username, start_date)
DO
  NOTHING;

  INSERT INTO
    Dim_Videos (title, genre_id)
  SELECT
    title
    , genre_id
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT title, genre_id FROM Videos'
    ) AS t(title VARCHAR(200), genre_id INTEGER)
  ON CONFLICT (title)
DO
  NOTHING;

  INSERT INTO
    Dim_Genres (genre_name)
  SELECT
    genre_name
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT genre_name FROM Genres'
    ) AS t(genre_name VARCHAR(50))
  ON CONFLICT (genre_name)
DO
  NOTHING;

  INSERT INTO
    Fact_Video_Views (time_id, user_id, video_id, total_views)
  SELECT
    t.time_id
    , u.user_id
    , v.video_id
    , COUNT(*) as total_views
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT user_id, video_id, view_date FROM Views'
    ) AS v(
      user_id INTEGER
      , video_id INTEGER
      , view_date TIMESTAMP
    )
    JOIN Dim_Time t
  ON DATE(v.view_date) = t.date
  JOIN Dim_Users u
  ON v.user_id = u.user_id
  JOIN Dim_Videos dv
  ON v.video_id = dv.video_id
  GROUP BY
    t.time_id
    , u.user_id
    , v.video_id
  ON CONFLICT (time_id, user_id, video_id)
DO
  UPDATE
  SET total_views = EXCLUDED.total_views;

  INSERT INTO
    Fact_User_Activity (time_id, user_id, total_likes, total_comments)
  SELECT
    t.time_id
    , u.user_id
    , COUNT(DISTINCT l.like_id) as total_likes
    , COUNT(DISTINCT c.comment_id) as total_comments
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT user_id, like_date, comment_date FROM Likes l FULL OUTER JOIN Comments c ON l.user_id = c.user_id'
    ) AS a(
      user_id INTEGER
      , like_date TIMESTAMP
      , comment_date TIMESTAMP
    )
    JOIN Dim_Time t
  ON DATE(COALESCE(a.like_date, a.comment_date)) = t.date
  JOIN Dim_Users u
  ON a.user_id = u.user_id
  GROUP BY
    t.time_id
    , u.user_id
  ON CONFLICT (time_id, user_id)
DO
  UPDATE
  SET total_likes = EXCLUDED.total_likes, total_comments = EXCLUDED.total_comments;

  INSERT INTO
    Bridge_Playlist_Videos (playlist_id, video_id, video_count)
  SELECT
    p.playlist_id
    , v.video_id
    , COUNT(*) as video_count
  FROM
    dblink(
      'dbname=video_content_db'
      , 'SELECT playlist_id, video_id FROM PlaylistVideos'
    ) AS pv(playlist_id INTEGER, video_id INTEGER)
    JOIN Dim_Videos v
  ON pv.video_id = v.video_id
  GROUP BY
    p.playlist_id
    , v.video_id
  ON CONFLICT (playlist_id, video_id)
DO
  UPDATE
  SET video_count = EXCLUDED.video_count;