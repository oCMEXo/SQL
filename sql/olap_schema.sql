-- Файл: sql/olap_schema.sql
-- Описание: Создание схемы OLAP базы данных

-- Создание таблицы Dim_Time
CREATE TABLE Dim_Time (
  time_id SERIAL PRIMARY KEY
  , date DATE NOT NULL
  , month INTEGER NOT NULL
  , year INTEGER NOT NULL
  , UNIQUE (date)
);

-- Создание таблицы Dim_Users (SCD Type 2)
CREATE TABLE Dim_Users (
  user_id SERIAL PRIMARY KEY
  , username VARCHAR(50) NOT NULL
  , email VARCHAR(100) NOT NULL
  , start_date TIMESTAMP NOT NULL
  , end_date TIMESTAMP
  , is_active BOOLEAN NOT NULL DEFAULT TRUE
  , UNIQUE (username, start_date)
);

-- Создание таблицы Dim_Videos
CREATE TABLE Dim_Videos (
  video_id SERIAL PRIMARY KEY
  , title VARCHAR(200) NOT NULL
  , genre_id INTEGER
  , UNIQUE (title)
);

-- Создание таблицы Dim_Genres
CREATE TABLE Dim_Genres (
  genre_id SERIAL PRIMARY KEY
  , genre_name VARCHAR(50) NOT NULL
  , UNIQUE (genre_name)
);

-- Создание таблицы Fact_Video_Views
CREATE TABLE Fact_Video_Views (
  view_id SERIAL PRIMARY KEY
  , time_id INTEGER REFERENCES Dim_Time(time_id)
  , user_id INTEGER REFERENCES Dim_Users(user_id)
  , video_id INTEGER REFERENCES Dim_Videos(video_id)
  , total_views BIGINT NOT NULL
);

-- Создание таблицы Fact_User_Activity
CREATE TABLE Fact_User_Activity (
  activity_id SERIAL PRIMARY KEY
  , time_id INTEGER REFERENCES Dim_Time(time_id)
  , user_id INTEGER REFERENCES Dim_Users(user_id)
  , total_likes BIGINT NOT NULL
  , total_comments BIGINT NOT NULL
);

-- Создание мостовой таблицы Bridge_Playlist_Videos
CREATE TABLE Bridge_Playlist_Videos (
  bridge_id SERIAL PRIMARY KEY
  , playlist_id INTEGER
  , video_id INTEGER REFERENCES Dim_Videos(video_id)
  , video_count INTEGER NOT NULL
  , UNIQUE (playlist_id, video_id)
);