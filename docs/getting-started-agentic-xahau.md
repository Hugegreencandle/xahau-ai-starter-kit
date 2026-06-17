# Getting Started With Agentic Transactions on Xahau

Go from zero to a confirmed agent payment on Xahau testnet in under 30 minutes —
then add the thing XRPL can't: a **provable, on-chain spending cap.**

## What you'll need
- Claude Code / Desktop / Cursor with **xahau-mcp** connected.
- ~20 minutes. (No offline keygen needed for testnet — the faucet provides a
  funded account.)

## 1. Connect xahau-mcp (2 min)
Add xahau-mcp as an MCP server, then ask Claude: *"call `xahau_server_info`."*
A reply confirms you're connected to testnet (`wss://xahau-test.net`,
network id 21338).

## 2. Get a funded testnet wallet (3 min)
1. Open the **Xahau Testnet faucet**: <https://xahau-test.net> → "Get Testnet
   Funds". It generates a new, already-funded account and returns its
   **address + secret**. Store the secret somewhere safe; never paste it into
   chat.
2. Ask Claude: *"`get_account_info` for `<address>`."* → you'll see a reserve
   balance confirming it's activated. (Skill: `xahau-wallet`.)

> Mainnet/production differs: generate keys offline (`xrpl-accountlib` / Xaman)
> and fund from an existing account. The faucet is testnet-only.

## 3. Send your first payment (5 min)
Ask Claude: *"Build an unsigned 5 XAH payment from `<me>` to `<dest>`, then
simulate it."*
- It calls `build_payment_unsigned` then `simulate_transaction` — you see the
  exact ledger effect **before signing**.
- Sign the unsigned blob offline (xrpl-accountlib / Xaman), submit, then
  *"`get_transaction <hash>`"* to confirm. Deterministic finality — confirmed or
  expired, no limbo. (Skill: `xahau-payment`.)

## 4. The part XRPL can't do — a provable spending cap (10 min)
Make the agent's budget an **on-chain rule** it cannot break.
1. Scaffold + build the guardrail (Skill: `xahc-guardrail`):
   ```sh
   xahc new agentguard --archetype agent_guardrail
   xahc build agentguard.c -o agentguard.wasm && xahc test agentguard.test.toml
   ```
   (Prefer the browser? The Xahau Hooks Builder at <https://builder.xahau.network>
   compiles and deploys Hooks on testnet directly.)
2. **Prove it** — `xahc-prover` certifies the Hook can never accept an
   over-limit payment, for *every* input (or returns the counterexample).
3. Install it: `xahc install-tx agentguard.wasm --account <me> --on Payment
   --param 4C494D=<LIM-in-drops-hex>` → sign + submit the unsigned `SetHook`.
4. **Watch it work:** build a payment *above* the cap and
   `simulate_transaction`. Xahau rejects it at layer 1 — even though the agent
   "wanted" to send it. The budget is now enforced by the protocol, not by
   trust in the agent's code.

## Where to go next
- `x402-xahau` — expose the live policy at `GET /policy/:account` and let agents
  pay for APIs/compute within their proven cap.
- Compose with a channel facilitator (e.g. Dhali) for high-throughput
  micropayments *inside* the guardrail.
