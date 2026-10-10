# Business Rules Register

Source of truth for confirmed system behavior and decisions. Do NOT change any `Locked: yes` rule unless the user explicitly asks. Never store secrets or personal data here.

Statuses: `confirmed` (approved by the user or owner) | `inferred` (seen in code, not yet confirmed) | `superseded` (replaced, kept for history)

Index by area:
- (none yet)

---

## EXAMPLE-001: Example (delete after adding real rules)
- Area: Orders / Discounts
- Rule: A discount code can be applied once per order. If the order total after discount is below 0, the total is set to 0.
- Status: confirmed
- Source: 2026-01-01, client (via chat), ticket #123
- Evidence: src/orders/discount.ts:42, tests/discount.spec.ts, caps total at zero
- Decided by: Product owner
- Locked: yes
- Affects: Checkout screen, invoice PDF, sales report
- Tests: discount.spec.ts
- History: 2026-01-01: logged as confirmed
- Related: -
