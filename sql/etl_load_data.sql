-- Установка соединения
SELECT
  dblink_connect(
    'myconn'
    , 'host=127.0.0.1 user=postgres password=new_secure_password dbname=video_content_db'
  );

-- Обновление метаданных последней загрузки (после успешной загрузки)
DO
  $ $
  BEGIN
    -- Загрузка dim_time (только новые даты)
    INSERT INTO
      dim_time (date, month, year)
    SELECT DISTINCT
      date
      , month
      , year
    FROM
      dblink(
        'myconn'
        , '
        SELECT DISTINCT DATE(view_date) AS date, EXTRACT(MONTH FROM view_date) AS month, EXTRACT(YEAR FROM view_date) AS year 
        FROM Views 
        WHERE view_date > (SELECT last_load_timestamp FROM etl_log WHERE table_name = ''Views'')
    '
      ) AS t(date DATE, month INTEGER, year INTEGER)
    ON CONFLICT (date)
    DO
      NOTHING;

      -- Загрузка fact_video_views (только новые или изменённые просмотры)
      INSERT INTO
        fact_video_views (time_id, user_id, video_id, total_views)
      SELECT
        t.time_id
        , u.user_id
        , v.video_id
        , COUNT(*) AS total_views
      FROM
        dblink(
          'myconn'
          , '
        SELECT user_id, video_id, view_date 
        FROM Views 
        WHERE view_date > (SELECT last_load_timestamp FROM etl_log WHERE table_name = ''Views'')
    '
        ) AS v(
          user_id INTEGER
          , video_id INTEGER
          , view_date TIMESTAMP
        )
        JOIN dim_time t
      ON DATE(v.view_date) = t.date
      JOIN dim_users u
      ON v.user_id = u.user_id
      JOIN dim_videos v
      ON v.video_id = v.video_id
      GROUP BY
        t.time_id
        , u.user_id
        , v.video_id
      ON CONFLICT (time_id, user_id, video_id)
    DO
      UPDATE
      SET total_views = EXCLUDED.total_views
      WHERE
        fact_video_views.total_views != EXCLUDED.total_views;

      -- Обновление метки времени последней загрузки
      UPDATE
        etl_log
      SET last_load_timestamp = CURRENT_TIMESTAMP
      WHERE
        table_name = 'Views';
  END $ $;

  -- Закрытие соединения
  SELECT
    dblink_disconnect('myconn');