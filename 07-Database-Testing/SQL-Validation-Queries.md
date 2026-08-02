# SQL Validation Queries — MediDispense

Queries used to validate backend data integrity against the schema defined in the SRS (`orders`, `inventory`, `dispensing_log`, `vision_verification_log`, `users`). Each query maps to specific test cases from `04-Test-Scenarios-Cases`.

## 1. Stock deduction accuracy (TC-013)
Verify inventory stock reflects correct deduction after dispensing.
```sql
SELECT i.medication_id, i.stock_qty,
       (SELECT COALESCE(SUM(o.quantity), 0)
        FROM orders o
        WHERE o.medication_id = i.medication_id AND o.status IN ('Dispensed','Complete')) AS total_dispensed
FROM inventory i
WHERE i.medication_id = :medication_id;
```

## 2. Orders dispensed despite insufficient stock (TC-014, TC-015) — should return 0 rows
```sql
SELECT o.order_id, o.quantity, i.stock_qty
FROM orders o
JOIN inventory i ON o.medication_id = i.medication_id
WHERE o.status IN ('Dispensed','Complete')
  AND i.stock_qty < 0;
```

## 3. Expired medication dispensed (TC-017) — should return 0 rows
```sql
SELECT o.order_id, i.medication_id, i.expiry_date, o.status
FROM orders o
JOIN inventory i ON o.medication_id = i.medication_id
WHERE o.status IN ('Dispensed','Complete')
  AND i.expiry_date < CURDATE();
```

## 4. Orders dispensed without prior verification (TC-019) — should return 0 rows
```sql
SELECT order_id, status
FROM orders
WHERE status IN ('Dispensed','Complete')
  AND order_id NOT IN (
    SELECT order_id FROM order_status_history WHERE status = 'Verified'
  );
```

## 5. Vision verification log completeness (TC-029)
Every dispensed order should have a corresponding vision check.
```sql
SELECT o.order_id, o.status
FROM orders o
LEFT JOIN vision_verification_log v ON o.order_id = v.order_id
WHERE o.status IN ('Complete','Dispensing Error — Under Review')
  AND v.verification_id IS NULL;
```

## 6. Low-confidence vision results incorrectly marked Verified (TC-026) — should return 0 rows
```sql
SELECT verification_id, order_id, confidence_score, match_status
FROM vision_verification_log
WHERE confidence_score <= 85
  AND match_status = 'Verified';
```

## 7. Referential integrity — orphaned dispensing log rows (TC-038)
```sql
SELECT d.log_id, d.order_id
FROM dispensing_log d
LEFT JOIN orders o ON d.order_id = o.order_id
WHERE o.order_id IS NULL;
```

## 8. Referential integrity — orphaned vision log rows (TC-038)
```sql
SELECT v.verification_id, v.order_id
FROM vision_verification_log v
LEFT JOIN orders o ON v.order_id = o.order_id
WHERE o.order_id IS NULL;
```

## 9. Duplicate order_id check (TC-038) — should return 0 rows
```sql
SELECT order_id, COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
```

## 10. Orders that skipped a required status transition (TC-039)
Flags orders marked Complete without ever being Verified or Dispensed.
```sql
SELECT order_id, status
FROM orders o
WHERE status = 'Complete'
  AND NOT EXISTS (
    SELECT 1 FROM order_status_history h
    WHERE h.order_id = o.order_id AND h.status = 'Verified'
  );
```

## 11. Orphaned records after order cancellation (TC-040) — should return 0 rows
```sql
SELECT d.log_id
FROM dispensing_log d
JOIN orders o ON d.order_id = o.order_id
WHERE o.status = 'Cancelled';
```

## 12. Daily dispensing summary cross-check (TC-030)
Used to validate the dashboard's "Orders Today" metric against actual data.
```sql
SELECT COUNT(*) AS dispensed_today
FROM orders
WHERE status IN ('Dispensed','Complete')
  AND DATE(created_at) = CURDATE();
```

## 13. Low-stock threshold cross-check (TC-016, TC-032)
```sql
SELECT medication_id, stock_qty
FROM inventory
WHERE stock_qty < 10
ORDER BY stock_qty ASC;
```

## Notes
- `order_status_history` is assumed as a supporting audit table (order_id, status, changed_at, changed_by) implied by the SRS's status-transition business rules, used here to validate transition order.
- All "should return 0 rows" queries are negative-validation queries — any returned row indicates a defect.
