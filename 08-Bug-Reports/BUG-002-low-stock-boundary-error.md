# BUG-002

**Title:** Low-stock alert does not trigger when stock exactly equals threshold
**Reported by:** Rishika Lanjewar
**Date:** 2026-08-02
**Module:** Inventory Management
**Related Test Case(s):** TC-016 (low-stock boundary), TC-057 (H2 execution checklist)
**Related Requirement:** SRS Business Rules — low-stock alert should trigger when stock reaches threshold

## Severity
Medium — doesn't block core dispensing, but causes pharmacy staff to miss a restock signal at the exact boundary.

## Priority
P2

## Environment
MediDispense Demo App, Inventory screen

## Steps to Reproduce
1. Log in as Technician or Admin
2. Go to Inventory
3. Find "Cetirizine 10mg" — stock is exactly 10, and the low-stock threshold is also 10

## Expected Result
Status pill should show "Low stock" since stock has reached the threshold.

## Actual Result
Status pill shows "In stock" — the check only fires when stock is strictly less than the threshold (`stock < threshold`), not less-than-or-equal.

## Evidence
(screenshot of Inventory screen showing Cetirizine 10mg marked "In stock" with stock = 10)

## Status
New
