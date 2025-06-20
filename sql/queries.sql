
SELECT
  v.video_id
  , v.title
  , v.view_count
FROM
  Videos v
ORDER BY
  v.view_count DESC
LIMIT
  5;

SELECT
  v.title
  , v.description
  , g.genre_name
FROM
  Videos v
  JOIN Genres g
ON v.genre_id = g.genre_id
WHERE
  g.genre_name = 'Комедия';

SELECT
  c.comment_text
  , u.username
  , c.comment_date
FROM
  Comments c
  JOIN Users u
ON c.user_id = u.user_id
WHERE
  c.video_id = 1
ORDER BY
  c.comment_date DESC;

SELECT
  v.title
  , SUM(
    CASE
      WHEN l.like_type = TRUE THEN 1
      ELSE 0
    END
  ) as likes
  , SUM(
    CASE
      WHEN l.like_type = FALSE THEN 1
      ELSE 0
    END
  ) as dislikes
FROM
  Videos v
  LEFT JOIN Likes l
ON v.video_id = l.video_id
GROUP BY
  v.video_id
  , v.title;

SELECT
  p.title as playlist_title
  , v.title as video_title
FROM
  Playlists p
  JOIN PlaylistVideos pv
ON p.playlist_id = pv.playlist_id
JOIN Videos v
ON pv.video_id = v.video_id
WHERE
  p.user_id = 1;