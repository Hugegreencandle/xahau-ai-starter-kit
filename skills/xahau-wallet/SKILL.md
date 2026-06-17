---
name: xahau-wallet
description: >-
  Inspect and manage a Xahau account for an AI agent — validate addresses,
  check XAH balances, read trustlines/IOU balances, list account objects, and
  guide safe (no-custody) wallet creation. Use when a user or agent needs to
  know "what's in this account", "is this address valid", "what can this agent
  hold/spend", or wants to create a Xahau wallet. Read-only: never holds or
  asks for keys. Triggers: "check my balance", "validate this address",
  "create a Xahau wallet", "what trustlines does this account have",
  "agent account state".
---

# xahau-wallet

Give Claude structured, read-only access to a Xahau account. Pairs with
[xahau-mcp]. The agent can see everything it needs to decide a payment — and
nothing here ever touches a private key.

## Prerequisites
- `xahau-mcp` connected as an MCP server (Claude Code / Desktop / Cursor).
- Network: mainnet `wss://xahau.network` (network id 21337) or testnet
  `wss://xahau-test.net` (network id 21338).

## Capabilities → tools
| Task | xahau-mcp tool |
|---|---|
| Validate an r-address / x-address | `validate_address`, `xaddress` |
| XAH balance + account flags/sequence | `get_account_info` |
| IOU / trustline balances | `get_account_lines` |
| Escrows, hooks, offers, URITokens on the account | `get_account_objects`, `get_account_hooks`, `get_account_uritokens` |
| Network/fee state before acting | `xahau_server_info`, `get_fee` |
| Human-readable amount conversion | `xah_amount`, `decode_amount` |
| Safety screen a counterparty | `scam_check`, `explain_account` |

## Creating a wallet (no custody)
xahau-mcp **does not generate or store keys** — that is the safety property.

- **Testnet:** the Xahau Testnet faucet at `https://xahau-test.net` ("Get
  Testnet Funds") generates a new, already-funded account and returns its
  address + secret. Store the secret; never paste it into chat.
- **Mainnet / production:** generate a keypair **offline** with
  `xrpl-accountlib` (npm) or the Xaman app, then fund it from an existing
  account (Xahau needs a base reserve to activate).

Verify activation either way: `get_account_info <rAddress>` → expect a reserve
balance. Hand the seed to the user/operator to store. Never paste a seed into
chat.

## Notes
- Account not found = unfunded (Xahau needs a base reserve to activate).
- For agent budgets, pair with `xahc-guardrail` to make a spend cap an
  on-chain rule, then read it live via the x402-xahau `GET /policy/:account`.
