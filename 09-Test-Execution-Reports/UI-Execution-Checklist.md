# UI Execution Checklist — MediDispense Demo App

Follow every step in order. Mark ✅ Pass or ❌ Fail after each action. If ❌, note what actually happened.

## A. Login Screen
| # | Action | Expected Result | Actual |
|---|---|---|---|
| A1 | Open `index.html` | Login screen appears with 3 role buttons | |
| A2 | Click "Continue as Technician" | App loads, Dashboard screen shown, sidebar says "Technician" | |
| A3 | Click "Switch role" (bottom of sidebar) | Returns to login screen | |
| A4 | Click "Continue as Pharmacist" | Dashboard loads, sidebar says "Pharmacist" | |
| A5 | Switch role, click "Continue as Admin" | Dashboard loads, sidebar says "Admin" | |

## B. Navigation (as any role)
| # | Action | Expected Result | Actual |
|---|---|---|---|
| B1 | Click "Dashboard" in sidebar | Dashboard screen shown, nav item highlighted | |
| B2 | Click "New order" | New order form shown | |
| B3 | Click "Verification queue" | Verification queue table shown | |
| B4 | Click "Dispensing" | Dispensing table shown | |
| B5 | Click "Vision verification" | Vision verification screen shown | |
| B6 | Click "Inventory" | Inventory table shown | |
| B7 | Click "Reports" | Reports screen shown | |

## C. New Order Form — Valid Submission
| # | Action | Expected Result | Actual |
|---|---|---|---|
| C1 | Go to New order. Leave all fields empty. Click "Create order" | Error message: "Patient name is required." | |
| C2 | Type "Test Patient" in Patient name. Leave quantity at 1. Click "Create order" | Order created successfully, confirmation message shown | |
| C3 | Go to Dashboard | New order appears in "Recent orders" table with status "Pending Verification" | |

## D. New Order Form — Negative Cases
| # | Action | Expected Result | Actual |
|---|---|---|---|
| D1 | New order. Enter patient name. Set Quantity field to 0. Click "Create order" | Error: "Enter a valid quantity." | |
| D2 | Set Quantity to a negative number (e.g. -5) if the field allows typing it. Click "Create order" | Should be rejected with validation error | |
| D3 | Enter patient name with only spaces (e.g. "   "). Click "Create order" | Should be rejected — spaces-only is not a valid name (note if it isn't) | |

## E. Verification Queue
| # | Action | Expected Result | Actual |
|---|---|---|---|
| E1 | Go to Verification queue | All Pending Verification orders listed with Approve/Reject buttons | |
| E2 | Click "Approve" on one order | Order disappears from queue; status becomes "Verified" | |
| E3 | Go to Dashboard, check that order's status | Should show "Verified" in Recent orders | |
| E4 | Go back to Verification queue, click "Reject" on a different order | Order disappears from queue; check its status elsewhere shows "Rejected" | |

## F. Dispensing
| # | Action | Expected Result | Actual |
|---|---|---|---|
| F1 | Go to Dispensing | Verified orders listed with their medication's current stock number shown | |
| F2 | Note the stock number shown for an order's medication | Write it down: ______ | |
| F3 | Click "Dispense" on that order | Order disappears from Dispensing list, toast message appears | |
| F4 | Go to Inventory, find that same medication | Stock should be exactly (noted value − order quantity) | |
| F5 | Repeat F1–F4 for a medication where stock is very low (e.g. Metformin, stock = 2) — try dispensing an order requiring more than 2 | Should be blocked with an insufficient-stock message — **check carefully whether it actually blocks it** | |

## G. AI Vision Verification
| # | Action | Expected Result | Actual |
|---|---|---|---|
| G1 | Go to Vision verification | Dropdown shows orders with status "Awaiting Verification" (orders you just dispensed) | |
| G2 | Select an order from the dropdown | Scan frame and "Run vision check" button appear | |
| G3 | Click "Run vision check" | Scanning animation plays (~1 second), then a confidence % and result pill appear | |
| G4 | **Note the exact confidence % shown** | Write it down: ______% | |
| G5 | **Note the result pill color/text (Complete = green/purple, or "Dispensing Error — Under Review" = amber)** | Write it down: ______ | |
| G6 | Compare G4 and G5 against the SRS rule (section 6): "confidence score below threshold (85%) is treated as Rejected" | Does the result in G5 match what the SRS says should happen for that confidence score? Circle: MATCHES / DOES NOT MATCH | |
| G7 | Repeat G1–G6 for at least 4 more orders (dispense more test orders first if needed) to get a range of confidence scores, including at least one in the 80–90% range if you can | Record each one the same way | |

## H. Inventory
| # | Action | Expected Result | Actual |
|---|---|---|---|
| H1 | Go to Inventory, find "Amoxicillin 250mg" (stock starts at 6, threshold 10) | Status pill should show "Low stock" (since 6 < 10) | |
| H2 | Find "Cetirizine 10mg" (stock starts exactly at 10, threshold 10) | Since stock equals the threshold exactly, check what the pill shows — **this exact boundary is worth double-checking against the rule "stock < threshold"** | |
| H3 | Find "Azithromycin 250mg" | Status pill should show "Out of stock" (stock = 0) | |

## I. Reports
| # | Action | Expected Result | Actual |
|---|---|---|---|
| I1 | Go to Reports after completing several vision checks | "Vision checks run" count matches how many you actually ran | |
| I2 | Compare "Vision pass rate" shown here to what you calculate manually from your own notes in G4/G5 | Should match — note if it doesn't | |
| I3 | Check "Under review" count matches how many orders got a Rejected vision result | Should match | |

## Summary
- Total checks: 32
- Passed: ____
- Failed: ____
- Bugs found (list TC/checklist IDs): ____
