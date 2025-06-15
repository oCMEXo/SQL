-- Файл: sql/test_data.sql
-- Описание: Тестовые данные для базы данных видеоконтента

INSERT INTO
  Genres (genre_name)
VALUES
  ('Комедия')
  , ('Драма')
  , ('Образование')
  , ('Экшен');

INSERT INTO
  Users (username, email)
VALUES
  ('user1', 'user1@example.com')
  , ('user2', 'user2@example.com')
  , ('user3', 'user3@example.com');

INSERT INTO
  Videos (
    title
    , description
    , duration
    , file_path
    , user_id
    , genre_id
  )
VALUES
  (
    'Смешное видео'
    , 'Котик прыгает в коробку'
    , 120
    , 's3://videos/cat.mp4'
    , 1
    , 1
  )
  , (
    'Урок SQL'
    , 'Основы баз данных'
    , 600
    , 's3://videos/sql_lesson.mp4'
    , 2
    , 3
  )
  , (
    'Экшен-фильм'
    , 'Погоня за сокровищами'
    , 7200
    , 's3://videos/action.mp4'
    , 3
    , 4
  );

INSERT INTO
  Comments (video_id, user_id, comment_text)
VALUES
  (1, 2, 'Очень смешно!')
  , (2, 1, 'Полезный урок, спасибо!')
  , (3, 2, 'Классный фильм!');

INSERT INTO
  Likes (user_id, video_id, like_type)
VALUES
  (1, 2, TRUE)
  , (2, 1, TRUE)
  , (3, 1, FALSE);

INSERT INTO
  Views (user_id, video_id)
VALUES
  (1, 1)
  , (2, 1)
  , (2, 2)
  , (3, 3);

INSERT INTO
  Playlists (title, user_id)
VALUES
  ('Мои любимые видео', 1)
  , ('Уроки', 2);

INSERT INTO
  PlaylistVideos (playlist_id, video_id)
VALUES
  (1, 1)
  , (2, 2);