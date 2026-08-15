# BUG-003

**Title:** "Orders Today" dashboard metric shows all-time order count, not today's count
**Reported by:** Rishika Lanjewar
**Date:** 2026-08-02
**Module:** Reporting Dashboard
**Related Test Case(s):** TC-076 (TS-30 daily summary accuracy)
**Related Requirement:** SRS — Reporting Dashboard should show daily dispensing summary

## Severity
Medium — misleading metric could cause a pharmacy manager to misjudge daily workload.

## Priority
P2

## Environment
MediDispense Demo App, Dashboard screen

## Steps to Reproduce
1. Create several orders across what would be different days (or just note the total count of all orders ever created in the session)
2. Check the "Orders Today" metric on the Dashboard

## Expected Result
Should show only orders created today.

## Actual Result
Shows the total count of all orders regardless of creation date — the metric is not actually filtered by date at all.

## Evidence
(screenshot of Dashboard showing Orders Today = total order count)

## Status
New
