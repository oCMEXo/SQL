
CREATE TABLE Genres (
  genre_id SERIAL PRIMARY KEY
  , genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY
  , username VARCHAR(50) NOT NULL UNIQUE
  , email VARCHAR(100) NOT NULL
  , registration_date TIMESTAMP NOT NULL
);

CREATE TABLE Videos (
  video_id SERIAL PRIMARY KEY
  , title VARCHAR(200) NOT NULL UNIQUE
  , description TEXT
  , duration INTEGER
  , file_path VARCHAR(500)
  , upload_date TIMESTAMP
  , user_id INTEGER REFERENCES Users(user_id)
  , genre_id INTEGER REFERENCES Genres(genre_id)
);

CREATE TABLE Comments (
  comment_id SERIAL PRIMARY KEY
  , video_id INTEGER REFERENCES Videos(video_id)
  , user_id INTEGER REFERENCES Users(user_id)
  , comment_text TEXT
  , comment_date TIMESTAMP
  , UNIQUE (video_id, user_id, comment_date)
);

CREATE TABLE Likes (
  like_id SERIAL PRIMARY KEY
  , user_id INTEGER REFERENCES Users(user_id)
  , video_id INTEGER REFERENCES Videos(video_id)
  , like_type BOOLEAN
  , like_date TIMESTAMP
  , UNIQUE (user_id, video_id, like_date)
);

CREATE TABLE Views (
  view_id SERIAL PRIMARY KEY
  , user_id INTEGER REFERENCES Users(user_id)
  , video_id INTEGER REFERENCES Videos(video_id)
  , view_date TIMESTAMP
  , UNIQUE (user_id, video_id, view_date)
);

CREATE TABLE Playlists (
  playlist_id SERIAL PRIMARY KEY
  , title VARCHAR(200) NOT NULL UNIQUE
  , user_id INTEGER REFERENCES Users(user_id)
  , created_date TIMESTAMP
);

CREATE TABLE PlaylistVideos (
  playlist_video_id SERIAL PRIMARY KEY
  , playlist_id INTEGER REFERENCES Playlists(playlist_id)
  , video_id INTEGER REFERENCES Videos(video_id)
  , added_date TIMESTAMP
  , UNIQUE (playlist_id, video_id)
);