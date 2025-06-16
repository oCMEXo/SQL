SELECT u.username, COUNT(v.view_id) as view_count
FROM Views v
JOIN Users u ON v.user_id = u.user_id
GROUP BY u.username
ORDER BY view_count DESC;


SELECT v.user_id, COUNT(v.view_id) as view_count
FROM Views v
GROUP BY v.user_id
ORDER BY view_count DESC;