# Looking for duplicate Order_ID records
SELECT 
    Order_ID, COUNT(Order_ID) AS dup_ordrs
FROM
    orders
GROUP BY Order_ID
HAVING dup_ordrs > 1;
# When executed, the query shows that there are no duplicate entries pertaining to Order_ID


# The following query is implemented for replacing null values in Traffic_Delay_Min with the average delay for that route using a window function
SELECT
    Route_ID,
    Start_Location,
    End_Location,
    Distance_KM,
    Average_Travel_Time_Min,
    round(COALESCE(Traffic_Delay_Min, avg(Traffic_Delay_Min) OVER (PARTITION BY Route_ID))) AS Traffic_Delay_Min
FROM
    routes;
    
    
# The following queries use DDL commands to change all date columns into YYYY-MM-DD format
ALTER TABLE orders MODIFY COLUMN Order_Date DATE, MODIFY COLUMN Expected_Delivery_Date DATE, MODIFY COLUMN Actual_Delivery_Date DATE;
SELECT 
    *
FROM
    orders;

# and another query for shipment_tracking
ALTER TABLE shipment_tracking MODIFY COLUMN Checkpoint_Time DATE;
SELECT 
    *
FROM
    shipment_tracking;
    
    
# The following query is used to make sure that no Actual_Delivery_Date is before Order_Date and also implements a case clause to check for conditions and flagging the the date check accordingly
SELECT 
    Order_ID,
    Order_Date,
    Actual_Delivery_Date,
    CASE
        WHEN Actual_Delivery_Date < Order_Date THEN 'Invalid'
        ELSE 'Valid'
    END AS Delivery_dt_chk
FROM
    orders;