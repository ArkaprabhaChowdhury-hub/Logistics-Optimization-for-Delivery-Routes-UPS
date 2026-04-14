# The following query is used to assign a rank to the agents per route by on-time delivery percentage
Select Agent_ID, Route_id, On_Time_Percentage, rank() over (Partition by Route_id order by On_Time_Percentage DESC) as agent_rank from deliveryagents;


# The query below identifies and shows agents with deliveries on-time % < 80%. 
SELECT 
    Agent_ID, Route_ID, On_Time_Percentage
FROM
    DeliveryAgents
WHERE
    On_Time_Percentage < 80;
    

# The query below compares the average speed of the top 5 vs the bottom 5 agents using subqueries with UNION ALL    
SELECT 
    'Top 5 Agents' AS Category,
    ROUND(AVG(Avg_Speed_KM_HR), 2) AS Avg_Speed
FROM
    (SELECT 
        Avg_Speed_KM_HR
    FROM
        DeliveryAgents
    ORDER BY On_Time_Percentage DESC
    LIMIT 5) AS top_agents 
UNION ALL SELECT 
    'Bottom 5 Agents' AS Category,
    ROUND(AVG(Avg_Speed_KM_HR), 2) AS Avg_Speed
FROM
    (SELECT 
        Avg_Speed_KM_HR
    FROM
        DeliveryAgents
    ORDER BY On_Time_Percentage ASC
    LIMIT 5) AS bottom_agents;