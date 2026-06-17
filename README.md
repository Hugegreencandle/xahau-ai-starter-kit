# Xahau AI Starter Kit

**Agentic payments you can prove.**

A curated set of tools, skills, and docs for building AI-agent applications on
[Xahau](https://xahau.network) — the XRPL fork with **Hooks** (layer-1 WASM
smart contracts) and **Evernode** decentralized compute.

> This is a **hub**, not a monorepo. Each component lives in its own repo and is
> independently useful; this kit assembles them into one starting point and
> bundles the Claude skills + tutorial you need to go from zero to a confirmed,
> policy-enforced agent payment.

---

## Why Xahau for agentic payments

AI agents are starting to pay for APIs, compute, and services without a human in
the loop. Most rails just move value. Xahau can also **enforce the rules an
agent must obey — on-chain — and let you prove those rules can't be broken.**

| | XRPL agent payments | **Xahau agent payments** |
|---|---|---|
| Settlement | fast, deterministic | fast, deterministic |
| Agent spending policy | off-chain, in app code | **on-chain Hook** (`xahc`) |
| Policy correctness | "trust the code" | **mathematically proven** (`xahc-prover`) — agent *provably cannot overspend* |
| Where the agent runs | your servers | **Evernode** (`evernode-mcp`) |
| Smart-contract risk | avoided by having no programmability | programmability **with** the risk removed by proof |

The usual objection to on-chain logic — "smart-contract risk" — is exactly what
the prover kills: a policy-enforcing payment Hook, proven safe over *every*
input. Don't compete on throughput; compose with a channel facilitator (e.g.
[Dhali](https://dhali.io)) that settles micropayments *within* the proven cap.

---

## The components (spokes)

| Stage | Component | What it does |
|---|---|---|
| **Docs + ledger MCP** | [xahau-mcp](https://github.com/Hugegreencandle/xahau-mcp) | First MCP for Xahau: read-only ledger access, Xahau-aware codec, **runs real Hook bytecode in a local VM**, static security analysis, unsigned-tx builders. No key custody. |
| **Write safe Hooks** | [xahc](https://github.com/Hugegreencandle/xahc) | Author + compile C Hooks to clean, lint-passed WASM — guarantees in the type system, not in your head. |
| **Prove them** | [xahc-prover](https://github.com/Hugegreencandle/xahc-prover) | Symbolic-execution engine: proves an invariant holds for *every* input in scope — or returns the counterexample. Fails closed. |
| **Watch live** | [xahc-watch](https://github.com/Hugegreencandle/xahc-prover/tree/main/src/watch) | Binds a proof to a *deployed* hook and continuously attests it: alerts if a `SetHook` swaps the proven bytecode or a live tx breaks the proven verdict. |
| **Pay (X402)** | [x402-xahau](https://github.com/Hugegreencandle/x402-xahau) | Provable spending-authority layer for X402 on Xahau: an agent's budget becomes an on-chain rule, readable live at `GET /policy/:account`. |
| **Compute** | [evernode-mcp](https://github.com/Hugegreencandle/evernode-mcp) | Build/check/deploy deterministic HotPocket dApps on Evernode — catches the non-determinism that breaks consensus. |

---

## What's in this repo

```
skills/
  xahau-wallet/SKILL.md     # inspect accounts, balances, trustlines (read-only)
  xahau-payment/SKILL.md     # build → simulate → sign offline → track payments
  xahc-guardrail/SKILL.md    # install a proven on-chain spending cap
docs/
  getting-started-agentic-xahau.md   # 0 → confirmed → provably-capped, < 30 min
```

The skills are [Claude skills](https://docs.anthropic.com/en/docs/claude-code/skills) —
drop the `skills/` folders into your Claude Code / Desktop skills directory and
point Claude at `xahau-mcp`.

---

## Quickstart (testnet, < 30 min)

1. **Connect** `xahau-mcp` as an MCP server. Ask Claude to call
   `xahau_server_info` — confirms testnet (`wss://xahau-test.net`, net id 21338).
2. **Fund a wallet**: the [Xahau Testnet faucet](https://xahau-test.net) returns
   a pre-funded account (address + secret).
3. **Pay**: "build an unsigned XAH payment, simulate it" → sign offline → submit
   → `get_transaction` to confirm.
4. **Cap it**: build + **prove** an `xahc-guardrail` Hook, install it, then watch
   Xahau reject an over-limit payment at layer 1.

Full walkthrough: [docs/getting-started-agentic-xahau.md](docs/getting-started-agentic-xahau.md).

---

## Status

Early and honest about maturity. `xahau-mcp` and `x402-xahau` are shipped; the
skills and tutorial in this repo are the connective tissue. Treat as a starting
point, not production-certified infrastructure — verify each component's own repo
for current status.

## License

MIT. See [LICENSE](LICENSE).
