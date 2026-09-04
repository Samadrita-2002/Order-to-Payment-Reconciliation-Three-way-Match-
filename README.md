# Order-to-Payment Reconciliation (Three-Way Match)

## What this is
A reconciliation between order items (what was charged) and payments (what
was actually paid) across ~100,000 real e-commerce orders, flagging orders
where the two sides don't agree — a simplified version of a standard audit
reconciliation procedure.

## Data source
"Brazilian E-Commerce Public Dataset by Olist" — Kaggle 

## Tools
Excel (Inspection, pivot table) → Python/pandas (data cleaning, order-level aggregation) → MySQL (reconciliation joins) → Power BI (dashboard)

## Key findings
- Overall reconciliation match rate was 99.00%, indicating that the vast majority of transactions were successfully reconciled between order charges and recorded payments.
- Only 1 order out of approximately 99K orders had no matching payment, suggesting that missing payments on the order side were relatively rare. However, 775 payment records had no corresponding order items, highlighting a significantly larger number of payment-side exceptions that warrant investigation.
- The largest individual amount mismatch was $182.81, where the recorded payment of $1,586.47 exceeded the order charge of $1,403.66.
- Transactions with an absolute difference greater than $0.01 accounted for a cumulative absolute variance of approximately $3,270, indicating that even though mismatched transactions represent a small proportion of the overall volume, their financial impact is not negligible.

## Recommendations / Business Implications
- Investigate the drivers of amount mismatches: The largest priority should be understanding why recorded payments differ from the amount charged at the order level. Break mismatches down by factors such as— payment method, order value, freight/shipping charges, product category, number of items per order, installment numbers(sequences). Particular attention should be given to cases where amount paid exceeds the expected order charge, as these may indicate duplicate payments, additional charges not captured in the order-item data, payment processing issues, or data inconsistencies. Indentifying the root cause can reduce revenue leakage, prevent over/under-collection, and improve the reliability of financial reporting
- The 775 payments with no corresponding order items represent the largest reconciliation exception category and should be investigated individually or through pattern analysis. These records should be checked for: duplicate payments, cancelled or failed orders, refunds/reversals, data integration failures, incorrect/missing order IDs. Rather than assuming these payments were made "by mistake," first determine whether they represent genuine orphaned transactions or missing/incomplete data. Resolving these exceptions can prevent incorrect revenue recognition and ensure that every payment can be traced back to a valid business transaction.
- Prioritize exceptions based on financial impact. Not every mismatch needs the same level of attention. We can create an exception-priority system based on the absolute variance amount.

For example: 'Low'→ |variance| ≤ $10
'Medium' → $10 < |variance| ≤ $50
'High' → |variance| > $50

The business/finance team can then investigate the highest-value discrepancies first. This makes the reconciliation process more efficient by focusing resources on exceptions with the greatest potential financial impact.

## Screenshots
[Dashboard](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/Dashboard.png)

## Files
- The cleaned dataset could not be uploaded due to its large file size
- [Python: data cleaning, order-level aggregation](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/Order_aggregation.py)
- [Items by order](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/items_by_order.csv)
- [Payments by order](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/payments_by_order.csv)
- [SQL: analysis queries](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/order_reconciliation_analysis.sql)
- [Queries outputs and pivot table](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/SQL%20results%20and%20pivot%20tables.xlsx)
- [Power BI file](https://github.com/Samadrita-2002/Order-to-Payment-Reconciliation-Three-way-Match-/blob/main/Order%20Reconciliation%20Analysis%20Dashboard.pdf)
