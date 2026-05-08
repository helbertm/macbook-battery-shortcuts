#!/usr/bin/env bats

setup() {
  export BATT_SHORTCUTS_DIR="$(mktemp -d)"
  mkdir -p "$BATT_SHORTCUTS_DIR"
  cat >"$BATT_SHORTCUTS_DIR/i18n.sh" <<'EOS'
t() {
  local key="$1"
  shift || true
  case "$key" in
    calibration_reminder_last) echo "Reminder: your last calibration was $1 days ago." ;;
    calibration_reminder_none) echo "Reminder: no calibration has been recorded since setup $1 days ago." ;;
    calibration_reminder_reason) echo "Consider at least one calibration per year to keep battery percentage estimates accurate." ;;
    calibration_reminder_action) echo "Use batt-midyear when convenient." ;;
    *) echo "$key" ;;
  esac
}
EOS
  # shellcheck source=/dev/null
  source "${BATS_TEST_DIRNAME}/../src/battery-shortcuts.zsh"
}

teardown() {
  rm -rf "$BATT_SHORTCUTS_DIR"
}

@test "does not remind before 183 days from install date" {
  date -v-100d "+%Y-%m-%d" >"$BATT_INSTALL_DATE_FILE"
  run _batt_check_midyear_reminder
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "reminds after 183 days from install date when no calibration exists" {
  date -v-184d "+%Y-%m-%d" >"$BATT_INSTALL_DATE_FILE"
  run _batt_check_midyear_reminder
  [ "$status" -eq 0 ]
  [[ "$output" == *"no calibration has been recorded"* ]]
  [[ "$output" == *"Use batt-midyear when convenient."* ]]
}

@test "does not repeat reminder before 90 days" {
  date -v-184d "+%Y-%m-%d" >"$BATT_INSTALL_DATE_FILE"
  date -v-10d "+%Y-%m-%d" >"$BATT_LAST_MIDYEAR_REMINDER_FILE"
  run _batt_check_midyear_reminder
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "repeats reminder after 90 days" {
  date -v-300d "+%Y-%m-%d" >"$BATT_INSTALL_DATE_FILE"
  date -v-91d "+%Y-%m-%d" >"$BATT_LAST_MIDYEAR_REMINDER_FILE"
  run _batt_check_midyear_reminder
  [ "$status" -eq 0 ]
  [[ "$output" == *"Use batt-midyear when convenient."* ]]
}
