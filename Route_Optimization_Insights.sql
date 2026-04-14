# The following query calculates Average delivery time in days for each route
SELECT 
    Route_ID,
    Start_Location,
    End_Location,
    ROUND((Average_Travel_Time_Min + Traffic_Delay_Min) / 1440,
            3) AS Avg_Delivery_Time_Days
FROM
    routes;


# The query below calculates Average traffic delay for each route
SELECT 
    Route_ID, ROUND(AVG(Traffic_Delay_Min)) AS avg_trf_del
FROM
    routes
GROUP BY Route_ID;


# The following query is used to calculate Distance-to-time efficiency ratio using the given formula (Distance_KM / Average_Travel_Time_Min) for each route
SELECT 
    Route_ID,
    ROUND(Distance_KM / Average_Travel_Time_Min, 2) AS dist_time_efficiency
FROM
    routes;
    
 
# The query mentioned below identifies and shows bottom 3 routes with the worst efficiency ratio
SELECT 
    Route_ID,
    Distance_KM,
    Average_Travel_Time_Min,
    ROUND(Distance_KM / IFNULL(Average_Travel_Time_Min, 0),
            2) AS efficiency_ratio
FROM
    routes
ORDER BY efficiency_ratio ASC
LIMIT 3;


# The following query identifies and gives routes with >20% delayed shipments without using joins as there is already a recognizable relationship between orders, routes and shipmentment_tracking tables (Route_ID in routes table to Route_ID in orders tables and Order_ID in orders table to Order_ID in shipment_tracking table) 
SELECT 
    o.Route_ID,
    COUNT(o.Order_ID) AS Total_Shipments,
    SUM(CASE
        WHEN o.Delivery_Status = 'Delayed' THEN 1
        ELSE 0
    END) AS Delayed_Count,
    (SUM(CASE
        WHEN o.Delivery_Status = 'Delayed' THEN 1
        ELSE 0
    END) / COUNT(o.Order_ID)) * 100 AS Delay_Percentage
FROM
    Orders o
GROUP BY o.Route_ID
HAVING Delay_Percentage > 20;


# Some recommendations of potential routes for optimization are :
-- 1. Routes with a high rate of delay like Route_ID - R002 are at critical risk and need immediate action. In this case, the route might not be the issue, maybe it's the departure time which can be affected by traffic or possible warehouse bottlenecks. UPS can perform Time of the Day Analysis to get a better insight on the matter and also switch departured timings by a few hours to avoid the identified congestion.
-- 2. Routes with high delay even within a short distance - If we comapare the fields, Average_Travel_Time against Distance_KM from the routes table we'll get to see many routes where the speed is significantly quite lower than the average. The issue here probably is frequent stops along the trip, UPS can use a routing strategy based on small geophraphic zones so that they don't have to carry out one exhausting long trip through a city with huge number of deliveries.
-- 3. Routes with hostile weather - If we cross-referrence the Delay_Reason field from the Shipment_Tracking table, we can see that Route_ID - R005 always shows "Weather" as Delay_Reason maybe because it uses a high-risk area (prone to hostile acts of nature, floods, etc.). UPS can pave an alternative path for a more flexible and practical rerouting strategy to resolve the matter.
 


