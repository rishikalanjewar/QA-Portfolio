# SQL Validation — Execution Log

Every query below was executed against the real `MediDispense.db` SQLite database (seeded with 12 orders, 4 users, 5 inventory items, and realistic order history). Results shown are actual query output, not illustrative examples.

**Executed on:** database build with intentional seeded defects, for demonstration purposes.

---

## 2.1 Orders dispensed despite insufficient stock

**Result:** 0 rows returned — no defect detected.

---

## 2.2 Expired medication dispensed

**Result:** 1 row(s) returned.

**⚠ DEFECT DETECTED** — see Bug Report reference below.


| order_id | medication | expiry_date | status |
|---|---|---|---|
| 6 | Azithromycin 250mg | 2025-12-01 | Complete |

---

## 2.3 Low-confidence vision results incorrectly marked Verified

**Result:** 1 row(s) returned.

**⚠ DEFECT DETECTED** — see Bug Report reference below.


| verification_id | order_id | confidence_score | match_status |
|---|---|---|---|
| 6 | 10 | 70.0 | Verified |

---

## 2.4 Orphaned records across child tables

**Result:** 1 row(s) returned.

**⚠ DEFECT DETECTED** — see Bug Report reference below.


| source_table | orphan_id |
|---|---|
| dispensing_log | 999 |

---

## 3.1 Out-of-order status transitions (Dispensed before Verified)

**Result:** 1 row(s) returned.


| order_id | previous_status | status | previous_changed_at | changed_at |
|---|---|---|---|---|
| 10 | Pending Verification | Dispensed | 2026-07-23 11:00:00 | 2026-07-23 11:05:00 |

---

## 3.2 Running stock balance vs recorded stock (drift detection)

**Result:** 5 row(s) returned.


| medication_id | medication | recorded_stock | calculated_starting_stock |
|---|---|---|---|
| 1 | Paracetamol 500mg | 48 | 53 |
| 2 | Amoxicillin 250mg | 6 | 8 |
| 3 | Cetirizine 10mg | 10 | 12 |
| 4 | Metformin 500mg | 2 | 3 |
| 5 | Azithromycin 250mg | 15 | 17 |

---

## 3.3 Vision verification pass rate by medication

**Result:** 5 row(s) returned.


| medication | total_checks | passed | pass_rate_pct |
|---|---|---|---|
| Amoxicillin 250mg | 3 | 2 | 66.7 |
| Azithromycin 250mg | 1 | 1 | 100.0 |
| Cetirizine 10mg | 1 | 1 | 100.0 |
| Metformin 500mg | 1 | 1 | 100.0 |
| Paracetamol 500mg | 2 | 2 | 100.0 |

---

## 3.4 Full order lifecycle audit (sample of 5)

**Result:** 5 row(s) returned.


| order_id | patient_name | medication | status | dispensed_at | match_status | confidence_score |
|---|---|---|---|---|---|---|
| 12 | Divya Kapoor | Amoxicillin 250mg | Complete | 2026-07-24 10:40:00 | Verified | 89.9 |
| 11 | Alok Verma | Metformin 500mg | Complete | 2026-07-24 09:35:00 | Verified | 97.3 |
| 10 | Vikram Shah | Paracetamol 500mg | Complete | 2026-07-23 11:05:00 | Verified | 70.0 |
| 9 | Meena Iyer | Cetirizine 10mg | Complete | 2026-07-23 10:30:00 | Verified | 94.2 |
| 8 | Farhan Sheikh | Paracetamol 500mg | Cancelled | None | None | None |

---

## Summary

- **8 queries executed** against the live database

- **3 defect(s)** surfaced by negative-validation queries (Section 2)

- Defects found here correspond to bug reports in `08-Bug-Reports/` (BUG-DB-01: low-confidence vision result marked Verified; BUG-DB-02: expired medication dispensed; BUG-DB-03: orphaned dispensing_log record)
