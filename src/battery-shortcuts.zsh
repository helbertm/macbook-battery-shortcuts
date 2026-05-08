# shellcheck shell=bash
# macbook-battery-shortcuts
# Requires: actuallymentor/battery

_BATT_SHORTCUTS_DIR="${BATT_SHORTCUTS_DIR:-$HOME/.battery-shortcuts}"
_BATT_INSTALL_DATE_FILE="$_BATT_SHORTCUTS_DIR/install-date"
_BATT_LAST_MIDYEAR_FILE="$_BATT_SHORTCUTS_DIR/last-midyear-calibration"
_BATT_LAST_MIDYEAR_REMINDER_FILE="$_BATT_SHORTCUTS_DIR/last-midyear-reminder"
_BATT_LANG_FILE="$_BATT_SHORTCUTS_DIR/lang"
_BATT_I18N_FILE="$_BATT_SHORTCUTS_DIR/i18n.sh"

_BATT_FIRST_MIDYEAR_REMINDER_DAYS=183
_BATT_REPEAT_MIDYEAR_REMINDER_DAYS=90

if [[ -f "$_BATT_LANG_FILE" ]]; then
  LANG_CHOICE="$(cat "$_BATT_LANG_FILE" 2>/dev/null || echo en)"
else
  LANG_CHOICE="${LANG_CHOICE:-en}"
fi

if [[ -f "$_BATT_I18N_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$_BATT_I18N_FILE"
elif ! command -v t >/dev/null 2>&1; then
  t() { echo "$1"; }
fi

_batt_require_cli() {
  if ! command -v battery >/dev/null 2>&1; then
    t cli_missing
    return 1
  fi
}

_batt_today_iso() {
  date "+%Y-%m-%d"
}

_batt_today_epoch() {
  date +%s
}

_batt_date_to_epoch() {
  local date_value="$1"
  date -j -f "%Y-%m-%d" "$date_value" "+%s" 2>/dev/null
}

_batt_days_since() {
  local date_value="$1"
  local last_epoch
  local today_epoch

  last_epoch="$(_batt_date_to_epoch "$date_value")" || return 1
  today_epoch="$(_batt_today_epoch)"

  echo $(((today_epoch - last_epoch) / 86400))
}

_batt_record_midyear_calibration() {
  mkdir -p "$_BATT_SHORTCUTS_DIR"
  _batt_today_iso >"$_BATT_LAST_MIDYEAR_FILE"
  rm -f "$_BATT_LAST_MIDYEAR_REMINDER_FILE"
}

_batt_record_midyear_reminder() {
  mkdir -p "$_BATT_SHORTCUTS_DIR"
  _batt_today_iso >"$_BATT_LAST_MIDYEAR_REMINDER_FILE"
}

_batt_show_midyear_reminder() {
  local days_since_baseline="$1"

  if [[ -f "$_BATT_LAST_MIDYEAR_FILE" ]]; then
    t calibration_reminder_last "$days_since_baseline"
  else
    t calibration_reminder_none "$days_since_baseline"
  fi

  t calibration_reminder_reason
  t calibration_reminder_action
  echo ""
}

_batt_check_midyear_reminder() {
  local baseline_date
  local last_reminder
  local days_since_baseline
  local days_since_reminder

  mkdir -p "$_BATT_SHORTCUTS_DIR"

  if [[ -f "$_BATT_LAST_MIDYEAR_FILE" ]]; then
    baseline_date="$(cat "$_BATT_LAST_MIDYEAR_FILE" 2>/dev/null || true)"
  elif [[ -f "$_BATT_INSTALL_DATE_FILE" ]]; then
    baseline_date="$(cat "$_BATT_INSTALL_DATE_FILE" 2>/dev/null || true)"
  else
    _batt_today_iso >"$_BATT_INSTALL_DATE_FILE"
    baseline_date="$(cat "$_BATT_INSTALL_DATE_FILE")"
  fi

  days_since_baseline="$(_batt_days_since "$baseline_date")" || return 0

  if ((days_since_baseline < _BATT_FIRST_MIDYEAR_REMINDER_DAYS)); then
    return 0
  fi

  if [[ ! -f "$_BATT_LAST_MIDYEAR_REMINDER_FILE" ]]; then
    _batt_show_midyear_reminder "$days_since_baseline"
    _batt_record_midyear_reminder
    return 0
  fi

  last_reminder="$(cat "$_BATT_LAST_MIDYEAR_REMINDER_FILE" 2>/dev/null || true)"
  days_since_reminder="$(_batt_days_since "$last_reminder")" || return 0

  if ((days_since_reminder >= _BATT_REPEAT_MIDYEAR_REMINDER_DAYS)); then
    _batt_show_midyear_reminder "$days_since_baseline"
    _batt_record_midyear_reminder
  fi
}

batt-stat() {
  _batt_require_cli || return 1
  _batt_check_midyear_reminder
  battery status
}

batt-7080() {
  _batt_require_cli || return 1
  _batt_check_midyear_reminder

  t setting_7080
  battery maintain 70-80
  battery status
}

batt-80() {
  _batt_require_cli || return 1
  _batt_check_midyear_reminder

  t setting_80
  battery maintain 80
  battery status
}

batt-away() {
  _batt_require_cli || return 1
  _batt_check_midyear_reminder

  t away_mode
  battery maintain stop
  battery charging on
  battery status

  echo ""
  t away_restore
  echo "  batt-7080"
}

batt-midyear() {
  _batt_require_cli || return 1

  t calibration_title
  echo ""
  t calibration_hint
  echo ""

  local confirm
  read -r -p "$(t calibration_confirm)" confirm

  if [[ "$confirm" != "YES" ]]; then
    t calibration_cancelled
    return 0
  fi

  battery calibrate
  _batt_record_midyear_calibration

  echo ""
  echo "$(t calibration_recorded) $(cat "$_BATT_LAST_MIDYEAR_FILE")"
  echo ""
  t calibration_after
  echo "  batt-7080"
}
