#!/usr/bin/env bash
set -euo pipefail

shellcheck scripts/*.sh src/*.sh src/*.zsh tests/*.bats
shfmt -d scripts src tests
bats tests
