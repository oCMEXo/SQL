SELECT t.year, SUM(fv.total_views) as total_views
FROM dim_time t
JOIN fact_video_views fv ON t.time_id = fv.time_id
GROUP BY t.year
ORDER BY t.year;

