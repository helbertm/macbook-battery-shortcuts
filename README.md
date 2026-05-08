# MacBook Battery Shortcuts

![CI](https://github.com/helbertm/macbook-battery-shortcuts/actions/workflows/ci.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform: macOS](https://img.shields.io/badge/platform-macOS-lightgrey)
![Requires: Apple Silicon](https://img.shields.io/badge/requires-Apple%20Silicon-black)
![ShellCheck](https://img.shields.io/badge/lint-ShellCheck-brightgreen)

Terminal shortcuts for sane Apple Silicon MacBook battery charge management using the upstream [`actuallymentor/battery`](https://github.com/actuallymentor/battery) CLI.

## What it does

This project installs a small set of terminal shortcuts:

- `batt-7080`: recommended daily mode, maintain 70–80%.
- `batt-80`: simple daily mode, maintain 80%.
- `batt-away`: prepare for full battery use away from the charger.
- `batt-stat`: show battery status.
- `batt-midyear`: optional calibration routine, useful only occasionally.

It can install the upstream `battery` tool in two ways:

1. CLI only, the default option.
2. Full GUI app + CLI, optional.

## Compatibility

Supported:

- macOS on Apple Silicon

Not supported:

- Intel Macs
- Linux on Apple Silicon / Asahi Linux
- Windows

## Install

### Recommended: inspect before running

![Recommended](https://img.shields.io/badge/recommended-safer%20install-brightgreen)

```bash
curl -fsSLO https://raw.githubusercontent.com/helbertm/macbook-battery-shortcuts/main/scripts/install.sh
less install.sh
bash install.sh
```

### Fast install

```bash
curl -fsSL https://raw.githubusercontent.com/helbertm/macbook-battery-shortcuts/main/scripts/install.sh | bash
```

The installer is interactive. Pressing `ENTER` accepts the default option.

Defaults:

- Language: English
- Install mode: CLI only
- Daily charge mode: 70–80%

## Presets

This project intentionally exposes only two daily charge presets:

- `batt-7080`: recommended default for users who keep the MacBook plugged in most of the day.
- `batt-80`: simpler 80% cap for users who prefer the classic charge-limit behavior.

Other levels such as 50%, 60%, 90%, or custom voltage thresholds are intentionally not exposed as shortcuts. They may be useful in specific cases, but they are not better general-purpose defaults for daily MacBook use.

This choice is based on general lithium-ion battery guidance and Apple’s own battery health behavior. Battery University’s BU-808 article explains that lower charge voltage / lower state of charge can reduce battery stress and prolong lithium-ion battery life. Apple also states that Mac battery health management considers temperature history and charging patterns, and may reduce maximum charge when needed to slow chemical aging.

References:

- Battery University — BU-808: How to Prolong Lithium-based Batteries  
  https://www.batteryuniversity.com/article/bu-808-how-to-prolong-lithium-based-batteries/

- Apple Support — About battery health management in Mac notebooks  
  https://support.apple.com/en-us/102589

## Shortcuts

### `batt-7080`

Recommended daily mode for mostly plugged-in use.

```bash
batt-7080
```

Runs:

```bash
battery maintain 70-80
battery status
```

### `batt-80`

Simple 80% cap mode.

```bash
batt-80
```

Runs:

```bash
battery maintain 80
battery status
```

### `batt-away`

Use before travel, meetings, or any situation where you consciously want full battery.

```bash
batt-away
```

Runs:

```bash
battery maintain stop
battery charging on
battery status
```

After returning to normal plugged-in use:

```bash
batt-7080
```

### `batt-stat`

Shows battery status.

```bash
batt-stat
```

### `batt-midyear`

Optional calibration routine.

```bash
batt-midyear
```

Calibration is mainly about keeping battery percentage estimates accurate. It is not a battery-life ritual. The shortcuts include a soft reminder after 183 days, then every 90 days if calibration is not executed.

## Manual calibration date setup

If you recently calibrated and want to record today manually:

```bash
mkdir -p "$HOME/.battery-shortcuts"
date "+%Y-%m-%d" > "$HOME/.battery-shortcuts/last-midyear-calibration"
rm -f "$HOME/.battery-shortcuts/last-midyear-reminder"
```

## Uninstall this project

```bash
curl -fsSL https://raw.githubusercontent.com/helbertm/macbook-battery-shortcuts/main/scripts/uninstall.sh | bash
```

This removes only this wrapper project: shortcuts and local state. It does not uninstall the upstream `battery` tool.

## Remove upstream battery completely

Before removing upstream `battery`, restore normal charging:

```bash
battery maintain stop || true
battery charging on || true
battery adapter on || true
```

Then remove upstream components depending on how they were installed:

```bash
battery uninstall || true
brew uninstall --cask battery || true
brew uninstall battery || true
```

## Development

Install development tools:

```bash
brew install shellcheck shfmt bats-core
```

Run checks:

```bash
./scripts/test.sh
```

## Project scope

This project is intentionally small. It is a wrapper around the upstream `battery` CLI. It does not replace the upstream project and does not attempt to support every battery-management strategy.

## Credits

Built on top of the excellent [`actuallymentor/battery`](https://github.com/actuallymentor/battery) project.

## License

MIT.
