#!/usr/bin/env bats

@test "install script references helbertm repo by default" {
  run grep -F "https://raw.githubusercontent.com/helbertm/macbook-battery-shortcuts/main" "${BATS_TEST_DIRNAME}/../scripts/install.sh"
  [ "$status" -eq 0 ]
}

@test "README mentions recommended safer install" {
  run grep -F "Recommended: inspect before running" "${BATS_TEST_DIRNAME}/../README.md"
  [ "$status" -eq 0 ]
}
