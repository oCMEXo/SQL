-- Файл: views.sql
-- Описание: Представления для аналитики видеоконтента

CREATE VIEW video_stats AS
SELECT
  v.video_id
  , v.title
  , v.view_count
  , COUNT(DISTINCT c.comment_id) as comment_count
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
  LEFT JOIN Comments c
ON v.video_id = c.video_id
LEFT JOIN Likes l
ON v.video_id = l.video_id
GROUP BY
  v.video_id
  , v.title
  , v.view_count;