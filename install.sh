#!/usr/bin/env bash
# Xahau AI Starter Kit — installer
# Copies the bundled Claude skills into your Claude skills dir and prints the
# xahau-mcp MCP server config. Safe + idempotent: never overwrites without -f.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
FORCE="${1:-}"

echo "Xahau AI Starter Kit installer"
echo "  source: $SKILLS_SRC"
echo "  dest:   $SKILLS_DEST"
echo

mkdir -p "$SKILLS_DEST"
for skill in "$SKILLS_SRC"/*/; do
  name="$(basename "$skill")"
  target="$SKILLS_DEST/$name"
  if [ -e "$target" ] && [ "$FORCE" != "-f" ]; then
    echo "  skip   $name (exists — re-run with -f to overwrite)"
  else
    rm -rf "$target"
    cp -R "$skill" "$target"
    echo "  install $name"
  fi
done

cat <<'EOF'

Skills installed. Next:

1. Add xahau-mcp as an MCP server. Example (Claude Code ~/.claude.json or
   project .mcp.json):

   {
     "mcpServers": {
       "xahau": {
         "command": "npx",
         "args": ["-y", "xahau-mcp"]
       }
     }
   }

   (Or run from a local clone of https://github.com/Hugegreencandle/xahau-mcp .)

2. Restart Claude, then verify:  ask it to call  xahau_server_info
3. Follow docs/getting-started-agentic-xahau.md  (0 -> confirmed -> proven cap).

Faucet (testnet): https://xahau-test.net   Endpoint: wss://xahau-test.net
EOF
