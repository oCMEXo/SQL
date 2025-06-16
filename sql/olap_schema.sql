
CREATE TABLE Dim_Time (
  time_id SERIAL PRIMARY KEY
  , date DATE NOT NULL
  , month INTEGER NOT NULL
  , year INTEGER NOT NULL
  , UNIQUE (date)
);

CREATE TABLE Dim_Users (
  user_id SERIAL PRIMARY KEY
  , username VARCHAR(50) NOT NULL
  , email VARCHAR(100) NOT NULL
  , start_date TIMESTAMP NOT NULL
  , end_date TIMESTAMP
  , is_active BOOLEAN NOT NULL DEFAULT TRUE
  , UNIQUE (username, start_date)
);

CREATE TABLE Dim_Videos (
  video_id SERIAL PRIMARY KEY
  , title VARCHAR(200) NOT NULL
  , genre_id INTEGER
  , UNIQUE (title)
);

CREATE TABLE Dim_Genres (
  genre_id SERIAL PRIMARY KEY
  , genre_name VARCHAR(50) NOT NULL
  , UNIQUE (genre_name)
);

CREATE TABLE Fact_Video_Views (
  view_id SERIAL PRIMARY KEY
  , time_id INTEGER REFERENCES Dim_Time(time_id)
  , user_id INTEGER REFERENCES Dim_Users(user_id)
  , video_id INTEGER REFERENCES Dim_Videos(video_id)
  , total_views BIGINT NOT NULL
);

CREATE TABLE Fact_User_Activity (
  activity_id SERIAL PRIMARY KEY
  , time_id INTEGER REFERENCES Dim_Time(time_id)
  , user_id INTEGER REFERENCES Dim_Users(user_id)
  , total_likes BIGINT NOT NULL
  , total_comments BIGINT NOT NULL
);

CREATE TABLE Bridge_Playlist_Videos (
  bridge_id SERIAL PRIMARY KEY
  , playlist_id INTEGER
  , video_id INTEGER REFERENCES Dim_Videos(video_id)
  , video_count INTEGER NOT NULL
  , UNIQUE (playlist_id, video_id)
);