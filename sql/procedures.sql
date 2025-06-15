-- Файл: sql/procedures.sql
-- Описание: Хранимые процедуры для аналитики видеоконтента

CREATE OR REPLACE PROCEDURE get_popular_genres(min_views INTEGER)
LANGUAGE SQL AS $ $
SELECT
  g.genre_name
  , COUNT(vw.view_id) AS total_views
FROM
  Genres g
  JOIN Videos v
ON v.genre_id = g.genre_id
JOIN Views vw
ON v.video_id = vw.video_id
GROUP BY
  g.genre_id
  , g.genre_name
HAVING
  COUNT(vw.view_id) >= min_views
ORDER BY
  total_views DESC;
$ $;

-- Пример вызова процедуры
CALL get_popular_genres(1);