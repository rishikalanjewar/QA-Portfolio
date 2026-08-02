# BUG-001

**Title:** Role-based access control not enforced — all roles have identical access
**Reported by:** Rishika Lanjewar
**Date:** 2026-08-02
**Module:** Authentication / Role-Based Access Control
**Related Test Case(s):** TC-003, TC-011 (Technician cannot approve own order), TC-004 (Admin-only inventory access)
**Related Requirement:** SRS section 2 (User Roles) and Business Rules — Pharmacist, Technician, and Admin are defined as distinct roles with different permitted actions

## Severity
**High** — this is a security/data-integrity control, not a cosmetic issue. In a real pharmacy system, unrestricted role access could allow unqualified staff to approve or dispense medication.

## Priority
**P1** — blocks reliable testing of all role-restriction test cases; should be fixed before further RBAC-related testing.

## Environment
MediDispense Demo App (05-Demo-App/index.html), tested in Chrome browser, all three roles

## Steps to Reproduce
1. Open the app, log in as "Technician"
2. Navigate to "Verification queue"
3. Observe that Approve/Reject actions are available (per SRS, only Pharmacist should have this)
4. Log out, log in as "Technician" again, navigate to "Inventory"
5. Observe inventory is visible and unrestricted (per SRS, inventory edits should be Admin-only)
6. Repeat for Pharmacist and Admin roles — all three see identical sidebar navigation and identical screen access

## Expected Result
- Technician should not see Approve/Reject actions on the Verification queue
- Only Pharmacist should be able to verify/reject orders
- Only Admin should be able to edit Inventory
- Each role's sidebar navigation should reflect only the actions permitted to that role

## Actual Result
All three roles (Pharmacist, Technician, Admin) have identical access to every screen and every action, with no restrictions applied anywhere in the app.

## Evidence
(Add screenshots: sidebar/navigation looks identical when logged in as each of the 3 roles)

## Status
New
