#!/usr/bin/env bash
set -euo pipefail

# ─── Agent Harness Setup ─────────────────────────────────────────────────────
# Idempotent install for Will's Claude Code harness. Creates symlinks from the
# standard Claude Code locations into this repository. Backs up any existing
# files/directories before replacing them. Registers MCP servers with the
# `claude` CLI.

HARNESS_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.agent-harness-backup/$(date +%Y%m%d-%H%M%S)"

# ─── Helpers ──────────────────────────────────────────────────────────────────

backup_and_link() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "  [ok]    $target → $source"
    return
  fi

  if [ -L "$target" ]; then
    echo "  [warn]  $target is a symlink to $(readlink "$target"), replacing"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$(basename "$target").symlink"
  elif [ -e "$target" ]; then
    echo "  [back]  $target → $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "  [link]  $target → $source"
}

# ─── Symlinks ─────────────────────────────────────────────────────────────────

echo "Agent harness: $HARNESS_DIR"
echo ""

echo "Setting up symlinks..."
backup_and_link "$HARNESS_DIR/user/CLAUDE.md"      "$HOME/.claude/CLAUDE.md"
backup_and_link "$HARNESS_DIR/user/settings.json"  "$HOME/.claude/settings.json"
backup_and_link "$HARNESS_DIR/skills"              "$HOME/.claude/skills"
backup_and_link "$HARNESS_DIR/agents"              "$HOME/.claude/agents"
backup_and_link "$HARNESS_DIR/hooks"               "$HOME/.claude/hooks"
backup_and_link "$HARNESS_DIR/user/statusline.sh"  "$HOME/.config/claude-code/statusline.sh"

echo ""

# ─── MCP Servers ─────────────────────────────────────────────────────────────

echo "Registering MCP servers..."
if command -v claude >/dev/null 2>&1; then
  claude mcp add-json context7 '{"type":"stdio","command":"npx","args":["-y","@upstash/context7-mcp"],"env":{}}' --scope user 2>/dev/null || true
  echo "  [mcp]   context7"

  claude mcp add-json render '{"type":"http","url":"https://mcp.render.com/mcp","headers":{"Authorization":"Bearer ${RENDER_API_TOKEN}"}}' --scope user 2>/dev/null || true
  echo "  [mcp]   render"

  claude mcp add-json vercel '{"type":"http","url":"https://mcp.vercel.com"}' --scope user 2>/dev/null || true
  echo "  [mcp]   vercel"

  claude mcp add-json figma '{"type":"http","url":"https://mcp.figma.com/mcp"}' --scope user 2>/dev/null || true
  echo "  [mcp]   figma"
else
  echo "  [skip]  claude CLI not found — install Claude Code first"
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo "Backups saved to: $BACKUP_DIR"
else
  echo "No backups needed — all symlinks were already correct."
fi
echo "Done."
