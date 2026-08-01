# Test Plan — MediDispense v1.0

## 1. Introduction
This Test Plan defines the scope, approach, resources, and schedule for testing the MediDispense pharmacy order and dispensing system, including the AI Vision Verification module.

## 2. Features to be Tested
- User login and role-based access (Pharmacist, Technician, Admin)
- Order creation and editing
- Order verification workflow
- Inventory stock tracking and low-stock alerts
- Dispensing workflow and inventory deduction
- AI Vision Verification (pack image submission, match/mismatch handling, confidence threshold logic)
- Reporting dashboard accuracy
- API endpoints (all 8 listed in SRS)
- Database consistency across all modules

## 3. Features Not to be Tested
- AI model training/accuracy (model treated as black box)
- Physical dispensing hardware
- Performance/load testing (future scope)

## 4. Test Approach
- Manual functional testing against SRS requirements
- API testing via Postman for all endpoints (positive + negative cases)
- SQL queries to validate backend data after each workflow action
- Exploratory testing for edge cases not explicitly covered in test cases

## 5. Test Environment
- Simulated REST API (Postman mock server / collection)
- Simulated MySQL database schema (per SRS section 5)
- Test data: fictional patient records, medication list, sample pack images (for vision check scenarios)

## 6. Roles & Responsibilities
| Role | Responsibility |
|---|---|
| QA Engineer (Rishika) | Test case design, execution, defect logging, reporting |

## 7. Test Deliverables
- Test Scenarios & Test Cases document
- Postman Collection (API tests)
- SQL Validation Queries
- Bug Reports
- Test Execution Report
- Test Summary Report
- Bug Metrics Dashboard

## 8. Schedule (Simulated Sprint)
| Phase | Duration |
|---|---|
| Requirement Analysis & Test Planning | Day 1–2 |
| Test Case Design | Day 3–5 |
| Test Execution — Cycle 1 | Day 6–8 |
| Defect Retest / Regression | Day 9 |
| Test Summary & Reporting | Day 10 |

## 9. Risk & Contingency
See `03-Risk-Analysis/Risk-Analysis.md` for detailed risk assessment.

## 10. Suspension & Resumption Criteria
- **Suspend testing if:** a Critical defect blocks more than 40% of planned test cases from executing
- **Resume when:** blocking defect is fixed and verified in a new build
