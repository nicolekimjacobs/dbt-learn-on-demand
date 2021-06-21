select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date,
    coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
    coalesce(fct_orders.lifetime_value, 0) as lifetime_value
from {{ ref('stg_customers')}} customers
left 
join (select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from {{ ref('stg_orders') }}
    group by customer_id) customer_orders
on customers.customer_id = customer_orders.customer_id
left
join (select customer_id, sum(amount) lifetime_value
      from   {{ ref('fct_orders')}} 
      group by customer_id) fct_orders
on  customers.customer_id = fct_orders.customer_id