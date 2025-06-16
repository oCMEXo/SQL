SELECT u.username, v.title, SUM(fv.total_views) as total_views
FROM fact_video_views fv
JOIN dim_users u ON fv.user_id = u.user_id
JOIN dim_videos v ON fv.video_id = v.video_id
GROUP BY u.username, v.title
ORDER BY total_views DESC;


SELECT user_id, video_id, COUNT(*)
FROM fact_video_views
GROUP BY user_id, video_id
HAVING COUNT(*) > 1;