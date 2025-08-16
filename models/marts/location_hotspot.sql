select
  zip_code,
  count(*) AS trips,                                           
  round(sum(iff(t.status='completed', t.total_fare, 0)),2) as revenue,
  round(avg(t.pickup_wait_min),2) as avg_pickup_wait_min
from {{ ref('fct_trips') }} t
join {{ ref('dim_location') }} l
  on t.location_id = l.location_id
group by 1
order by trips desc
