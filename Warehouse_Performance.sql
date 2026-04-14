# The following query identifies and shows the top 3 warehouses with the highest average processing time
SELECT 
    Warehouse_ID,
    Location,
    ROUND(AVG(Processing_Time_Min)) AS avg_pro_time
FROM
    warehouses
GROUP BY Warehouse_ID , Location
ORDER BY avg_pro_time DESC
LIMIT 3;


# The query mentioned below compares total shipments with delayed shipments for each warehouse and also calculates and shows delay rate for better analysis of the performance
SELECT 
    Warehouse_ID,
    COUNT(Order_ID) AS Total_Shipments,
    SUM(CASE
        WHEN Delivery_Status = 'Delayed' THEN 1
        ELSE 0
    END) AS Delayed_Shipments,
    ROUND((SUM(CASE
                WHEN Delivery_Status = 'Delayed' THEN 1
                ELSE 0
            END) / COUNT(Order_ID)) * 100,
            2) AS Delay_Rate_Percentage
FROM
    Orders
GROUP BY Warehouse_ID
ORDER BY Delay_Rate_Percentage DESC;


# The following query is To identify bottleneck warehouses using CTEs to isolate the warehouse processing time and compare it against the global average processing time across all warehouses
WITH OrderProcessingTime AS (
   SELECT 
        o.Order_ID,
        o.Warehouse_ID,
        DATEDIFF(
            STR_TO_DATE(MIN(t.Checkpoint_Time), '%d-%m-%Y'), 
            STR_TO_DATE(o.Order_Date, '%d-%m-%Y')
        ) AS days_to_process
    FROM Orders o
    JOIN Shipment_Tracking t ON o.Order_ID = t.Order_ID
    WHERE t.Checkpoint = 'Checkpoint 1'
    GROUP BY o.Order_ID, o.Warehouse_ID, o.Order_Date
),
WarehousePerformance AS (
    SELECT 
        Warehouse_ID,
        AVG(days_to_process) AS avg_warehouse_process_time
    FROM OrderProcessingTime
    GROUP BY Warehouse_ID
),
GlobalMetric AS (
    SELECT AVG(days_to_process) AS global_avg_time 
    FROM OrderProcessingTime
)
SELECT 
    wp.Warehouse_ID,
    ROUND(wp.avg_warehouse_process_time, 2) AS Avg_Processing_Days,
    ROUND(gm.global_avg_time, 2) AS Global_Avg_Days,
    ROUND(wp.avg_warehouse_process_time - gm.global_avg_time, 2) AS Days_Over_Average
FROM WarehousePerformance wp
CROSS JOIN GlobalMetric gm
WHERE wp.avg_warehouse_process_time > gm.global_avg_time
ORDER BY Days_Over_Average DESC;
# When executed, the above query shows an empty table with only the field or column headers as required by the query because none of the records in the data met the conditions. The are no bottleneck warehouses with with higher processing time that the global average  

# The following query is used Rank to warehouses based on on-time delivery percentage for better Warehouse performance analysis
SELECT 
    Warehouse_ID,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) AS On_Time_Count,
    ROUND(
        (SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS On_Time_Percentage,
    RANK() OVER (
        ORDER BY (SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) / COUNT(*)) DESC
    ) AS Performance_Rank
FROM Orders
GROUP BY Warehouse_ID
ORDER BY Performance_Rank;