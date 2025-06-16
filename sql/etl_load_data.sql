DO $$
BEGIN
    PERFORM dblink_disconnect('myconn');
EXCEPTION WHEN OTHERS THEN
END $$;

DO $$
BEGIN
    PERFORM dblink_connect('myconn', 'host=127.0.0.1 user=postgres password=qwerty dbname=video_content_db');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Connection failed: %', SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO dim_time (date, month, year)
    SELECT DISTINCT DATE(view_date) AS date, EXTRACT(MONTH FROM view_date) AS month, EXTRACT(YEAR FROM view_date) AS year
    FROM dblink('myconn', '
        SELECT view_date
        FROM Views
        WHERE view_date > COALESCE((SELECT last_load_timestamp FROM etl_log WHERE table_name = ''Views''), ''1900-01-01'')
    ') AS v(view_date TIMESTAMP)
    ON CONFLICT (date) DO NOTHING;

    INSERT INTO fact_video_views (time_id, user_id, video_id, total_views)
    SELECT t.time_id, u.user_id, dv.video_id, COUNT(*) AS total_views
    FROM dblink('myconn', '
        SELECT user_id, video_id, view_date
        FROM Views
        WHERE view_date > COALESCE((SELECT last_load_timestamp FROM etl_log WHERE table_name = ''Views''), ''1900-01-01'')
    ') AS v(user_id INTEGER, video_id INTEGER, view_date TIMESTAMP)
    JOIN dim_time t ON DATE(v.view_date) = t.date
    JOIN dim_users u ON v.user_id = u.user_id
    JOIN dim_videos dv ON v.video_id = dv.video_id
    GROUP BY t.time_id, u.user_id, dv.video_id
    ON CONFLICT ON CONSTRAINT fact_video_views_unique DO UPDATE
    SET total_views = EXCLUDED.total_views
    WHERE fact_video_views.total_views != EXCLUDED.total_views;

    PERFORM dblink_exec('myconn', '
        UPDATE etl_log
        SET last_load_timestamp = CURRENT_TIMESTAMP
        WHERE table_name = ''Views''
    ');
END $$;

SELECT dblink_disconnect('myconn');