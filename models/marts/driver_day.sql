select d.driver_sk, d.driver_id, d.full_name AS driver_name,
    count_if(t.status = 'completed') AS completed_rides,
    round(sum(iff(t.status = 'completed', total_fare, 0)),2) AS revenue
from {{ ref('fct_trips') }} t 
join {{ ref('dim_driver') }} d 
group by 1,2,3
order by driver_name
