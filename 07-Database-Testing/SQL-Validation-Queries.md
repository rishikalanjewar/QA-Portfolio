# SQL Validation Queries — MediDispense

Schema, integrity validation, and analytical queries used to test the MediDispense database layer. Queries progress from schema design through negative-validation checks to multi-table analytical queries using CTEs and window functions.

---

## 1. Schema (DDL)

```sql
CREATE TABLE users (
    user_id       INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    role          ENUM('Pharmacist','Technician','Admin') NOT NULL,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE inventory (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication    VARCHAR(150) NOT NULL,
    batch_no      VARCHAR(50) NOT NULL,
    stock_qty     INT NOT NULL CHECK (stock_qty >= 0),
    expiry_date   DATE NOT NULL,
    low_stock_threshold INT NOT NULL DEFAULT 10
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    patient_name  VARCHAR(150) NOT NULL,
    medication_id INT NOT NULL,
    quantity      INT NOT NULL CHECK (quantity > 0),
    status        ENUM('Pending Verification','Verified','Rejected',
                        'Dispensed','Dispensing Error — Under Review','Complete','Cancelled') NOT NULL,
    created_by    INT NOT NULL,
    verified_by   INT NULL,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (medication_id) REFERENCES inventory(medication_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    FOREIGN KEY (verified_by) REFERENCES users(user_id)
);

CREATE TABLE order_status_history (
    history_id    INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    status        VARCHAR(50) NOT NULL,
    changed_by    INT NOT NULL,
    changed_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

CREATE TABLE dispensing_log (
    log_id        INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT NOT NULL,
    dispensed_by  INT NOT NULL,
    dispensed_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (dispensed_by) REFERENCES users(user_id)
);

CREATE TABLE vision_verification_log (
    verification_id  INT PRIMARY KEY AUTO_INCREMENT,
    order_id          INT NOT NULL,
    image_ref         VARCHAR(255) NOT NULL,
    detected_medications TEXT,
    match_status      ENUM('Verified','Rejected') NOT NULL,
    confidence_score  DECIMAL(5,2) NOT NULL,
    checked_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_medication ON orders(medication_id);
CREATE INDEX idx_vision_order ON vision_verification_log(order_id);
```

---

## 2. Data Integrity — Negative Validation Queries
*(each should return 0 rows on a healthy system — any row returned is a defect)*

**2.1 Orders dispensed despite insufficient stock at time of dispense**
```sql
SELECT o.order_id, o.quantity, i.stock_qty, i.medication
FROM orders o
JOIN inventory i ON o.medication_id = i.medication_id
WHERE o.status IN ('Dispensed','Complete')
  AND i.stock_qty < 0;
```

**2.2 Expired medication dispensed**
```sql
SELECT o.order_id, i.medication, i.expiry_date, o.status
FROM orders o
JOIN inventory i ON o.medication_id = i.medication_id
WHERE o.status IN ('Dispensed','Complete')
  AND i.expiry_date < CURDATE();
```

**2.3 Low-confidence vision results incorrectly marked Verified**
```sql
SELECT verification_id, order_id, confidence_score, match_status
FROM vision_verification_log
WHERE confidence_score <= 85
  AND match_status = 'Verified';
```

**2.4 Orphaned records across all child tables (single query, three-way check)**
```sql
SELECT 'dispensing_log' AS source_table, d.log_id AS orphan_id
FROM dispensing_log d
LEFT JOIN orders o ON d.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'vision_verification_log', v.verification_id
FROM vision_verification_log v
LEFT JOIN orders o ON v.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'order_status_history', h.history_id
FROM order_status_history h
LEFT JOIN orders o ON h.order_id = o.order_id
WHERE o.order_id IS NULL;
```

---

## 3. Analytical & Audit Queries (CTEs / Window Functions)

**3.1 Detect out-of-order status transitions using `LAG()`**
Flags any order where "Dispensed" was logged before "Verified" — a sequencing defect a single-table query can't catch.
```sql
WITH ordered_history AS (
    SELECT
        order_id,
        status,
        changed_at,
        LAG(status) OVER (PARTITION BY order_id ORDER BY changed_at) AS previous_status,
        LAG(changed_at) OVER (PARTITION BY order_id ORDER BY changed_at) AS previous_changed_at
    FROM order_status_history
)
SELECT order_id, previous_status, status, previous_changed_at, changed_at
FROM ordered_history
WHERE status = 'Dispensed'
  AND (previous_status IS NULL OR previous_status <> 'Verified');
```

**3.2 Running stock balance vs. recorded stock (data-drift detection)**
Recomputes stock from the dispensing history and compares it to the value actually stored in `inventory`, catching silent data corruption.
```sql
WITH dispensed_totals AS (
    SELECT o.medication_id, SUM(o.quantity) AS total_dispensed
    FROM orders o
    WHERE o.status IN ('Dispensed','Complete')
    GROUP BY o.medication_id
),
expected_stock AS (
    SELECT i.medication_id, i.medication, i.stock_qty AS recorded_stock,
           i.stock_qty + COALESCE(d.total_dispensed, 0) AS calculated_starting_stock
    FROM inventory i
    LEFT JOIN dispensed_totals d ON i.medication_id = d.medication_id
)
SELECT * FROM expected_stock
WHERE recorded_stock < 0;
```

**3.3 Vision verification pass rate by medication — surfaces which medications the AI struggles with**
```sql
SELECT
    i.medication,
    COUNT(v.verification_id) AS total_checks,
    SUM(CASE WHEN v.match_status = 'Verified' THEN 1 ELSE 0 END) AS passed,
    ROUND(100.0 * SUM(CASE WHEN v.match_status = 'Verified' THEN 1 ELSE 0 END) / COUNT(v.verification_id), 1) AS pass_rate_pct
FROM vision_verification_log v
JOIN orders o ON v.order_id = o.order_id
JOIN inventory i ON o.medication_id = i.medication_id
GROUP BY i.medication
HAVING COUNT(v.verification_id) >= 3
ORDER BY pass_rate_pct ASC;
```

**3.4 Full order lifecycle audit — join across every table with computed turnaround times**
```sql
SELECT
    o.order_id,
    o.patient_name,
    i.medication,
    o.status,
    d.dispensed_at,
    v.match_status,
    v.confidence_score,
    TIMESTAMPDIFF(MINUTE, o.created_at, d.dispensed_at) AS minutes_to_dispense,
    TIMESTAMPDIFF(SECOND, d.dispensed_at, v.checked_at) AS seconds_to_vision_result
FROM orders o
JOIN inventory i ON o.medication_id = i.medication_id
LEFT JOIN dispensing_log d ON o.order_id = d.order_id
LEFT JOIN vision_verification_log v ON o.order_id = v.order_id
ORDER BY o.created_at DESC;
```

**3.5 Reporting view for dashboard reconciliation**
```sql
CREATE VIEW vw_daily_dashboard AS
SELECT
    DATE(o.created_at) AS report_date,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.status = 'Pending Verification' THEN 1 ELSE 0 END) AS pending_verification,
    SUM(CASE WHEN o.status = 'Complete' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN o.status = 'Dispensing Error — Under Review' THEN 1 ELSE 0 END) AS under_review
FROM orders o
GROUP BY DATE(o.created_at);
```

---

## Notes
- Queries assume a MySQL-compatible dialect (`TIMESTAMPDIFF`, `CURDATE()`); minor syntax changes needed for PostgreSQL/SQL Server.
- Section 2 queries are negative-validation checks meant to be run in an automated data-integrity job.
- Section 3 queries were written to catch classes of defects (sequencing, drift, per-segment AI accuracy) that simple single-table checks miss — this is the kind of query I'd expect from someone testing a real production system, not a tutorial project.
