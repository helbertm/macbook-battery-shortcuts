#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_URL="${REPO_RAW_URL:-https://raw.githubusercontent.com/helbertm/macbook-battery-shortcuts/main}"
SHORTCUTS_STATE_DIR="$HOME/.battery-shortcuts"
SHORTCUTS_FILE="$HOME/.battery-shortcuts.zsh"
I18N_STATE_FILE="$SHORTCUTS_STATE_DIR/i18n.sh"
LANG_FILE="$SHORTCUTS_STATE_DIR/lang"
INSTALL_DATE_FILE="$SHORTCUTS_STATE_DIR/install-date"
ZSHRC="$HOME/.zshrc"
LANG_CHOICE="en"
INSTALL_MODE="cli"

load_i18n() {
  mkdir -p "$SHORTCUTS_STATE_DIR"

  local local_i18n
  local_i18n="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)/src/i18n.sh"

  if [[ -f "$local_i18n" ]]; then
    cp "$local_i18n" "$I18N_STATE_FILE"
  else
    curl -fsSL "$REPO_RAW_URL/src/i18n.sh" -o "$I18N_STATE_FILE"
  fi

  # shellcheck source=/dev/null
  source "$I18N_STATE_FILE"
}

ask_language() {
  t "language_prompt"
  echo ""
  t language_en
  t language_pt
  t language_es
  echo ""

  local choice
  read -r -p "$(t choice_prompt)" choice

  case "${choice:-1}" in
    1) LANG_CHOICE="en" ;;
    2) LANG_CHOICE="pt" ;;
    3) LANG_CHOICE="es" ;;
    *) LANG_CHOICE="en" ;;
  esac

  echo "$LANG_CHOICE" >"$LANG_FILE"
}

check_compatibility() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    t incompatible_os
    t aborted
    exit 1
  fi

  if [[ "$(uname -m)" != "arm64" ]]; then
    t incompatible_arch
    echo "$(t current_arch) $(uname -m)"
    t aborted
    exit 1
  fi
}

show_intro() {
  echo ""
  t intro_title
  echo ""
  t intro_body
  echo ""
  t shortcuts_intro
  echo ""
}

ask_install_mode() {
  t install_mode_title
  echo ""
  t install_mode_cli
  echo ""
  t install_mode_gui
  echo ""

  local mode
  read -r -p "$(t install_mode_prompt)" mode

  case "${mode:-1}" in
    1) INSTALL_MODE="cli" ;;
    2) INSTALL_MODE="gui" ;;
    *) INSTALL_MODE="cli" ;;
  esac
}

install_battery_cli_only() {
  echo ""
  t installing_cli
  curl -fsSL https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash
}

install_battery_gui() {
  echo ""
  t installing_gui

  if ! command -v brew >/dev/null 2>&1; then
    t homebrew_required
    exit 1
  fi

  if brew list --cask battery >/dev/null 2>&1; then
    brew upgrade --cask battery || true
  else
    brew install --cask battery
  fi

  local open_app
  read -r -p "$(t open_app_now)" open_app
  if [[ -z "${open_app:-}" || "$open_app" =~ ^[YySs]$ ]]; then
    open -a Battery
  fi
}

install_shortcuts() {
  echo ""
  t installing_shortcuts

  local local_shortcuts
  local_shortcuts="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)/src/battery-shortcuts.zsh"

  if [[ -f "$local_shortcuts" ]]; then
    cp "$local_shortcuts" "$SHORTCUTS_FILE"
  else
    curl -fsSL "$REPO_RAW_URL/src/battery-shortcuts.zsh" -o "$SHORTCUTS_FILE"
  fi

  touch "$ZSHRC"

  if ! grep -q 'source \$HOME/.battery-shortcuts.zsh' "$ZSHRC"; then
    {
      echo ""
      echo "# MacBook battery shortcuts"
      echo "source \$HOME/.battery-shortcuts.zsh"
    } >>"$ZSHRC"
  fi

  if [[ ! -f "$INSTALL_DATE_FILE" ]]; then
    date "+%Y-%m-%d" >"$INSTALL_DATE_FILE"
  fi
}

ask_activate_now() {
  echo ""

  local activate
  read -r -p "$(t activate_now)" activate

  if [[ -z "${activate:-}" || "$activate" =~ ^[YySs]$ ]]; then
    if command -v battery >/dev/null 2>&1; then
      battery maintain 70-80
      battery status || true
    else
      t command_not_found
    fi
  fi
}

finish_message() {
  echo ""
  t "done"
  echo ""
  t activate_shortcuts
  echo "  source ~/.zshrc"
  echo ""
  t available_shortcuts
  echo "  batt-7080"
  echo "  batt-80"
  echo "  batt-away"
  echo "  batt-stat"
  echo "  batt-midyear"
}

main() {
  load_i18n
  ask_language
  check_compatibility
  show_intro
  ask_install_mode

  if [[ "$INSTALL_MODE" == "cli" ]]; then
    install_battery_cli_only
  else
    install_battery_gui
  fi

  install_shortcuts
  ask_activate_now
  finish_message
}

main "$@"
