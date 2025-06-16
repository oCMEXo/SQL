SELECT v.video_id, COUNT(v.view_id) as view_count
FROM Views v
GROUP BY v.video_id
ORDER BY view_count DESC
LIMIT 5;


SELECT v.video_id, vid.title, COUNT(v.view_id) as view_count
FROM Views v
JOIN Videos vid ON v.video_id = vid.video_id
GROUP BY v.video_id, vid.title
ORDER BY view_count DESC
LIMIT 5;