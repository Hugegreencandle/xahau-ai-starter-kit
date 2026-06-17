---
name: xahau-payment
description: >-
  Build, preview, and track Xahau payments for an AI agent — XAH or issued
  (IOU/RLUSD-style) payments — as UNSIGNED transactions, simulate their full
  effect before signing, then track confirmation. Use when a user/agent wants
  to "send a payment", "pay for an API/compute", "settle an invoice", or
  "check if a payment went through" on Xahau. Read-only / no key custody:
  produces unsigned tx for offline signing. Triggers: "send X XAH to",
  "pay this account", "build a payment", "did my transaction confirm",
  "why did my payment fail".
---

# xahau-payment

Structured Xahau payments for agents, with a step XRPL's stack can't do:
**simulate the real on-ledger effect — including any Hooks that fire — before
a key ever signs.**

## Prerequisites
- `xahau-mcp` connected. Sender account funded (see `xahau-wallet`).

## Procedure
1. **Validate** the destination: `validate_address`. Optionally `scam_check`.
2. **Build (unsigned)**:
   - Native XAH: `build_payment_unsigned` (amount in drops; 1 XAH = 1,000,000).
   - Issued asset (e.g. an RLUSD-style IOU): `build_payment_unsigned` with the
     currency + issuer; cross-asset delivery uses `build_remit_unsigned`.
3. **Simulate before signing** — the differentiator: `simulate_transaction`
   runs the unsigned tx against live ledger state and reports accept/rollback,
   any Hook that fires, and decoded emitted txns. `what_if` replays a historical
   tx with your changes. **If a guardrail Hook would reject it, you see that now
   — not after broadcast.**
4. **Sign offline.** Hand the unsigned blob to Xaman or `xrpl-accountlib`.
   xahau-mcp never signs. (Decode/verify a returned blob with `decode_tx_blob`
   / `decode_sign_request`.)
5. **Submit** the signed blob via the user's submit path.
6. **Track**: `get_transaction <hash>` for deterministic finality
   (confirmed or expired — no ambiguous pending). On failure,
   `diagnose_failed_tx` explains the engine result.

## Why this beats off-chain payment logic
- **Pre-sign flight simulator** — see Hook effects + emitted txns before spend.
- **Deterministic finality** — `get_transaction` resolves confirm/expire; no
  polling/retry guesswork.
- **No custody, no signing** — agent constructs intent; keys stay offline.
- **Provable spend caps** — when the account runs an `xahc-guardrail` Hook, an
  over-limit payment is rejected by Xahau itself, and the prover guarantees the
  cap holds for *every* input.
