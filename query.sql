SELECT category.title, 
    ABS(cast(median(costs.value) as int) - 1500) as category_median, 
    COUNT(costs) as cost_count
FROM costs
JOIN category
    ON costs.category_id = category.id
GROUP BY category.title
ORDER BY category_median ASC, cost_count DESC;