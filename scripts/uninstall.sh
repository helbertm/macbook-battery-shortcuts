#!/usr/bin/env bash
set -euo pipefail

SHORTCUTS_STATE_DIR="$HOME/.battery-shortcuts"
SHORTCUTS_FILE="$HOME/.battery-shortcuts.zsh"
ZSHRC="$HOME/.zshrc"

remove_shortcuts_from_zshrc() {
  # shellcheck disable=SC2016
  if [[ -f "$ZSHRC" ]] && grep -q 'source \$HOME/.battery-shortcuts.zsh' "$ZSHRC"; then
    local tmp_file
    tmp_file="$(mktemp)"
    # shellcheck disable=SC2016
    grep -v 'source \$HOME/.battery-shortcuts.zsh' "$ZSHRC" >"$tmp_file"
    mv "$tmp_file" "$ZSHRC"
  fi
}

echo "Removing macbook-battery-shortcuts files..."
rm -f "$SHORTCUTS_FILE"
rm -rf "$SHORTCUTS_STATE_DIR"
remove_shortcuts_from_zshrc

echo ""
echo "Shortcuts removed."
echo ""
echo "This did not uninstall the upstream battery CLI/app."
echo "To remove upstream battery too, run:"
echo "  battery maintain stop || true"
echo "  battery charging on || true"
echo "  battery uninstall || true"
echo "  brew uninstall --cask battery || true"
