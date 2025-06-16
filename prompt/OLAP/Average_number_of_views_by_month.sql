SELECT t.month, AVG(fv.total_views) as avg_views
FROM dim_time t
JOIN fact_video_views fv ON t.time_id = fv.time_id
GROUP BY t.month
ORDER BY t.month;