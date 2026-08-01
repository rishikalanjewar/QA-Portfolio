# Software Requirements Specification (SRS)
## MediDispense — Pharmacy Order & Automated Dispensing Management System

**Version:** 1.1
**Status:** Fictional project for QA portfolio purposes — not a real product

---

## 1. Overview
MediDispense is a web-based pharmacy order and automated dispensing management system used by pharmacy staff to manage prescription orders from intake through dispensing.

## 2. User Roles
- **Pharmacist** — reviews and approves orders, verifies dispensing accuracy
- **Pharmacy Technician** — creates orders, manages inventory
- **Admin** — manages users, views reports

## 3. Core Modules

| Module | Description |
|---|---|
| Order Intake | Create/edit prescription orders (patient info, medication, dosage, quantity) |
| Order Verification | Pharmacist reviews and approves/rejects orders before dispensing |
| Inventory Management | Track medication stock, batch numbers, expiry dates, low-stock alerts |
| Dispensing | Marks order as dispensed, deducts from inventory, logs dispensing timestamp |
| AI Vision Verification | After dispensing, captures an image of the dispensed pack; AI model checks the image against the prescribed medication list; returns Verified (match) or Rejected (mismatch) |
| Reporting Dashboard | Daily dispensing summary, pending orders, low-stock report, vision verification pass/fail rate |
| User Authentication | Login, role-based access control |

## 4. Sample API Endpoints

- `POST /api/orders` — create order
- `GET /api/orders/{id}` — fetch order
- `PUT /api/orders/{id}/verify` — pharmacist approves order
- `PUT /api/orders/{id}/dispense` — mark dispensed
- `POST /api/orders/{id}/vision-check` — submit pack image, get AI verification result
- `GET /api/orders/{id}/vision-result` — fetch verification result (verified/rejected + confidence score)
- `GET /api/inventory` — list stock
- `PUT /api/inventory/{id}` — update stock

## 5. Sample Database Tables

- `orders` (order_id, patient_id, medication_id, quantity, status, created_at)
- `inventory` (medication_id, batch_no, stock_qty, expiry_date)
- `dispensing_log` (log_id, order_id, dispensed_by, dispensed_at)
- `vision_verification_log` (verification_id, order_id, image_ref, detected_medications, match_status, confidence_score, checked_at)
- `users` (user_id, name, role)

## 6. Key Business Rules

- An order cannot be dispensed if not first verified by a pharmacist
- An order cannot be dispensed if inventory stock is insufficient
- Medication past expiry date cannot be dispensed
- After dispensing, the system must capture a pack image and run AI vision verification before the order can be marked "Complete"
- If vision verification returns Rejected (mismatch), the order status changes to "Dispensing Error — Under Review" and cannot proceed to Complete until manually resolved
- If vision verification confidence score is below a defined threshold, treat as Rejected (no silent low-confidence pass)
- Only Admin can create/deactivate user accounts
