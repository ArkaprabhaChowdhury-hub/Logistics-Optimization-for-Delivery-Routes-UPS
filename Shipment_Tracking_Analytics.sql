# The following query identifies and lists the last checkpoint and time for each order using subqueries with the row_number() window function 
Select Order_ID, 
       Checkpoint,
       Checkpoint_Time 
       from (
            Select Order_ID, 
                   Checkpoint, 
                   Checkpoint_Time, 
                   row_number() over (
                                     Partition by Order_ID 
                                     order by Checkpoint_Time 
	  desc
                                     ) as rn 
			from shipment_tracking 
            ) t 
            where rn = 1;
            
            
# The query used below identifies and lists the most common delay reasons excluding "None"
SELECT 
    Delay_Reason, COUNT(*) AS total_occurrences
FROM
    shipment_tracking
WHERE
    Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY total_occurrences DESC;


# The following query identifies orders with more than 2 delayed checkpoints
SELECT 
    Order_ID, COUNT(*) AS delayed_chkpnts
FROM
    shipment_tracking
WHERE
    Delay_Reason <> 'None'
GROUP BY Order_ID
HAVING COUNT(*)> 2;