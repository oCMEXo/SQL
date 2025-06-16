SELECT DATE(view_date) as view_date, COUNT(view_id) as daily_views
FROM Views
GROUP BY DATE(view_date)
ORDER BY view_date;