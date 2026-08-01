# Risk Analysis — MediDispense

## 1. Purpose
Identify product and project risks to prioritize testing effort on the areas of highest impact and likelihood.

## 2. Risk Assessment Matrix

| Risk ID | Risk Description | Likelihood | Impact | Risk Level | Mitigation / Testing Focus |
|---|---|---|---|---|---|
| R-01 | Wrong medication dispensed due to AI vision false negative (accepts a mismatch) | Medium | Critical | **High** | Extensive negative testing on Vision Verification module; test with occluded/partial pack images, similar-looking medications, low-confidence scores |
| R-02 | Order dispensed despite insufficient stock (inventory not deducted in real time) | Medium | High | **High** | Concurrency/race-condition scenarios, stock boundary testing (exact stock = order qty, stock = 0) |
| R-03 | Expired medication dispensed | Low | Critical | **High** | Explicit test cases for expiry date boundary (expiry = today, expiry = yesterday) |
| R-04 | Unauthorized role performs restricted action (e.g., Technician approves own order) | Medium | High | **High** | Role-based access control test cases for every endpoint and UI action |
| R-05 | Vision verification API timeout/failure not handled gracefully | Medium | Medium | **Medium** | Simulate API failure/timeout, verify system doesn't silently mark order as Complete |
| R-06 | Dashboard reporting shows incorrect counts (stale or miscalculated data) | Low | Medium | **Medium** | Cross-check dashboard numbers against database query results |
| R-07 | Duplicate order submission (double-click / network retry) | Medium | Medium | **Medium** | Duplicate submission test cases at API and UI level |
| R-08 | Data loss on partial order creation (browser refresh mid-form) | Low | Low | **Low** | Basic recovery/session test, lower priority |

## 3. Risk Level Definition
- **High** — Must be covered by test cases before release; blocks release if unresolved
- **Medium** — Should be covered; may be deferred with documented justification
- **Low** — Covered opportunistically or in later test cycles

## 4. Testing Priority Derived from Risk
Test case design (folder 04) prioritizes High-risk areas first: AI Vision Verification, Inventory/Stock logic, Expiry handling, and Role-based access control.
