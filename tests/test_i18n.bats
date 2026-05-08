#!/usr/bin/env bats

setup() {
  source "${BATS_TEST_DIRNAME}/../src/i18n.sh"
}

@test "English default translation works" {
  LANG_CHOICE="en"
  run t incompatible_arch
  [ "$status" -eq 0 ]
  [ "$output" = "This requires an Apple Silicon." ]
}

@test "Portuguese translation works" {
  LANG_CHOICE="pt"
  run t incompatible_os
  [ "$status" -eq 0 ]
  [ "$output" = "Isso requer macOS." ]
}

@test "Spanish parameterized calibration message works" {
  LANG_CHOICE="es"
  run t calibration_reminder_last 200
  [ "$status" -eq 0 ]
  [ "$output" = "Recordatorio: tu última calibración fue hace 200 días." ]
}
