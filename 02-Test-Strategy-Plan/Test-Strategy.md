# Test Strategy — MediDispense

## 1. Objective
Define the overall approach for testing MediDispense to ensure functional correctness, data integrity, and reliability of the AI vision verification step before release.

## 2. Scope

**In Scope:**
- Order intake, verification, and dispensing workflows
- Inventory management and stock deduction logic
- AI Vision Verification module (functional + edge case behavior)
- API layer (all endpoints listed in SRS)
- Database validation (data consistency across orders, inventory, dispensing, vision logs)
- Role-based access control (Pharmacist, Technician, Admin)

**Out of Scope:**
- Actual AI/ML model training or accuracy tuning (treated as a black box — we test its integration and system behavior, not the model internals)
- Hardware-level dispensing mechanics
- Load/performance testing (noted as a future enhancement)

## 3. Testing Types Covered

| Type | Purpose |
|---|---|
| Functional Testing | Verify each feature works per SRS requirements |
| Regression Testing | Ensure new changes don't break existing verified functionality |
| Smoke Testing | Quick check that critical flows (order → dispense → vision check) work after a build |
| Sanity Testing | Focused check after a specific bug fix or minor change |
| API Testing | Validate request/response correctness, status codes, error handling |
| Database Testing | Validate data consistency, referential integrity, correct status transitions |
| Negative Testing | Invalid inputs, unauthorized access, edge cases (e.g., zero stock, expired medication, low-confidence vision result) |

## 4. Test Levels
- **System Testing** — primary focus, end-to-end workflows across modules
- **Integration Testing** — Order module ↔ Inventory module ↔ Vision module interactions

## 5. Entry Criteria
- SRS finalized and reviewed
- Test environment (API endpoints/mock data) available
- Test cases written and reviewed

## 6. Exit Criteria
- All Priority 1 (Critical) and Priority 2 (High) test cases executed
- No open Critical or High severity defects
- Test summary report completed and reviewed

## 7. Defect Management Approach
- All defects logged with severity (Critical/High/Medium/Low) and priority (P1–P4)
- Severity = impact on the system; Priority = urgency to fix
- Defects tracked through lifecycle: New → Open → In Progress → Fixed → Retest → Closed / Reopened

## 8. Tools Used
- **Postman** — API testing
- **MySQL / SQL** — database validation
- **Excel** — test case management, execution tracking, bug metrics dashboard
- **Jira (simulated)** — defect tracking and sample tickets
- **GitHub** — documentation and version control
