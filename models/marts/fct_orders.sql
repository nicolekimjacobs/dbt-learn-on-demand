select 
    stg_orders.order_id,
    stg_orders.customer_id,
    stg_payments.amount
from {{ ref('stg_orders')}} stg_orders
left
join {{ ref('stg_payments')}} stg_payments
on   stg_orders.order_id = stg_payments.order_id