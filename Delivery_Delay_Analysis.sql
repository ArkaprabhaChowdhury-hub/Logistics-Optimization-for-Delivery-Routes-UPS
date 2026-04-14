# The following query calculates the delivery delay in days for each order 
SELECT 
    Order_ID,
    Order_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date,
            Expected_Delivery_Date) AS Delivery_Delay_Days
FROM
    orders;
    

# The query used below identifies and presents the top 10 delayed routes based on average delay days    
SELECT 
    Route_ID,
    ROUND(AVG(DATEDIFF(Actual_Delivery_Date,
                    Expected_Delivery_Date)),
            2) AS avg_del
FROM
    orders
GROUP BY Route_ID
ORDER BY avg_del DESC
LIMIT 10;


# The following query uses dense_rank() function as a window function to assign ranks to all orders by delay within each warehouse                                 
Select Order_ID, Warehouse_ID, 
Expected_Delivery_Date, 
Actual_Delivery_Date, 
datediff(Actual_Delivery_Date, Expected_Delivery_Date) as Delay, 
dense_rank() over (partition by Warehouse_ID order by datediff(Actual_Delivery_Date, Expected_Delivery_Date) 
Desc)
 as del_rank 
 from orders;   