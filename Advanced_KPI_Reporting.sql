# The following query calculates and shows Average Delivery Delay per Region (Start_Location)
SELECT 
    Start_Location AS region,
    ROUND(AVG(Traffic_Delay_Min)) AS avg_del_delay
FROM
    routes
GROUP BY region
ORDER BY avg_del_delay DESC;


# The following query calculates On-Time Delivery % using the given formula (Total On-Time Deliveries / Total Deliveries) * 100
SELECT 
    ROUND((SUM(CASE
                WHEN Delivery_Status = 'On Time' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100
            ) AS on_time_delivery_percentage
FROM
    orders;


# The query below calculates and gives the average traffic delay for each route 
SELECT 
    Route_ID, AVG(Traffic_Delay_Min) AS avg_traffic_del
FROM
    routes
GROUP BY Route_ID
ORDER BY avg_traffic_del DESC;