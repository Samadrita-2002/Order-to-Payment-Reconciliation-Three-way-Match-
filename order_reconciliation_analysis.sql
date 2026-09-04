CREATE DATABASE order_reconciliations;
USE order_reconciliations;

CREATE VIEW reconciliation_view AS
SELECT coalesce(i.order_id, p.order_id) AS order_id,
i.total_charged, p.total_paid,
ROUND((p.total_paid - i.total_charged), 2) AS variance,
CASE 
WHEN i.order_id IS NULL THEN 'Payment with no matching order'
WHEN p.order_id IS NULL THEN 'Order with no matching payment'
WHEN ABS(p.total_paid - i.total_charged)<0.01 THEN 'Matched'
ELSE 'Amount Mismatch'
END AS reconciliation_status
FROM items_by_order i
LEFT JOIN payments_by_order p ON i.order_id = p.order_id

UNION

SELECT coalesce(i.order_id, p.order_id) AS order_id,
i.total_charged, p.total_paid,
ROUND((p.total_paid - i.total_charged), 2) AS variance,
CASE 
WHEN i.order_id IS NULL THEN 'Payment with no matching order'
WHEN p.order_id IS NULL THEN 'Order with no matching payment'
WHEN ABS(p.total_paid - i.total_charged)<0.01 THEN 'Matched'
ELSE 'Amount Mismatch'
END AS reconciliation_status
FROM items_by_order i
RIGHT JOIN payments_by_order p ON i.order_id = p.order_id;

SELECT reconciliation_status,
COUNT(*) AS num_orders,
ROUND((COUNT(*)/SUM(COUNT(*)) OVER())*100.0, 2) AS pct_of_orders
FROM (SELECT * FROM reconciliation_view) t
GROUP BY reconciliation_status;

SELECT order_id, total_charged, total_paid, variance
FROM reconciliation_view
WHERE reconciliation_status = 'Amount Mismatch'
ORDER BY ABS(variance) DESC
LIMIT 20;