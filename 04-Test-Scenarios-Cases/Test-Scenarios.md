# Test Scenarios — MediDispense

Scenarios are grouped by module, referencing SRS v1.1 and Risk Analysis priorities (High-risk areas covered first).

## Module: User Authentication & Role-Based Access
| Scenario ID | Scenario |
|---|---|
| TS-01 | Verify login works for all valid roles (Pharmacist, Technician, Admin) |
| TS-02 | Verify login fails with invalid credentials |
| TS-03 | Verify each role can only access actions permitted to it |
| TS-04 | Verify only Admin can create/deactivate user accounts |

## Module: Order Intake
| Scenario ID | Scenario |
|---|---|
| TS-05 | Verify a new order can be created with valid patient and medication details |
| TS-06 | Verify order creation fails with missing mandatory fields |
| TS-07 | Verify order creation handles duplicate/double submission correctly |
| TS-08 | Verify order can be edited before verification |

## Module: Order Verification
| Scenario ID | Scenario |
|---|---|
| TS-09 | Verify Pharmacist can approve a valid order |
| TS-10 | Verify Pharmacist can reject an order with reason |
| TS-11 | Verify Technician cannot approve their own order |
| TS-12 | Verify order status updates correctly after verification |

## Module: Inventory Management
| Scenario ID | Scenario |
|---|---|
| TS-13 | Verify stock decreases correctly after dispensing |
| TS-14 | Verify order cannot be dispensed when stock is insufficient |
| TS-15 | Verify order cannot be dispensed when stock is exactly zero |
| TS-16 | Verify low-stock alert triggers at defined threshold |
| TS-17 | Verify medication past expiry date cannot be dispensed |
| TS-18 | Verify medication expiring exactly "today" is handled per business rule |

## Module: Dispensing
| Scenario ID | Scenario |
|---|---|
| TS-19 | Verify order cannot be dispensed without prior pharmacist verification |
| TS-20 | Verify dispensing action logs correct timestamp and user |
| TS-21 | Verify inventory deduction happens atomically with dispensing action |

## Module: AI Vision Verification
| Scenario ID | Scenario |
|---|---|
| TS-22 | Verify system captures pack image after dispensing |
| TS-23 | Verify order marked "Verified" when image matches prescribed medication |
| TS-24 | Verify order marked "Rejected" when image shows wrong/missing medication |
| TS-25 | Verify order flagged "Dispensing Error — Under Review" on Rejected result |
| TS-26 | Verify low-confidence score below threshold is treated as Rejected (no silent pass) |
| TS-27 | Verify order cannot be marked "Complete" until vision verification finishes |
| TS-28 | Verify system behavior when vision-check API times out or fails |
| TS-29 | Verify vision verification result and confidence score are logged in database |

## Module: Reporting Dashboard
| Scenario ID | Scenario |
|---|---|
| TS-30 | Verify daily dispensing summary count matches database records |
| TS-31 | Verify pending orders count is accurate |
| TS-32 | Verify low-stock report reflects current inventory |
| TS-33 | Verify vision verification pass/fail rate is calculated correctly |

## Module: API Testing
| Scenario ID | Scenario |
|---|---|
| TS-34 | Verify all endpoints return correct status codes for valid requests |
| TS-35 | Verify all endpoints return correct error codes/messages for invalid requests |
| TS-36 | Verify unauthorized API access is rejected (401/403) |
| TS-37 | Verify API response schema matches expected structure |

## Module: Database Validation
| Scenario ID | Scenario |
|---|---|
| TS-38 | Verify referential integrity between orders, inventory, and vision logs |
| TS-39 | Verify order status transitions are recorded accurately |
| TS-40 | Verify no orphaned records exist after order cancellation |
