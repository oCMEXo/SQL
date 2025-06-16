

DO $$
BEGIN
    PERFORM dblink_connect('myconn', 'host=127.0.0.1 user=postgres password=qwerty dbname=video_content_db');
    RAISE NOTICE 'Connection successful';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Connection failed: %', SQLERRM;
END $$;