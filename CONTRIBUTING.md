# Contributing

Thanks for considering a contribution.

## Development setup

```bash
brew install shellcheck shfmt bats-core
```

Run checks:

```bash
./scripts/test.sh
```

## Translations

All user-facing text should live in `src/i18n.sh`.

When adding or changing a message:

1. Add/update the key for English (`en`).
2. Add/update the same key for Portuguese Brazil (`pt`).
3. Add/update the same key for Spanish (`es`).
4. Keep installer and shortcut logic free of hardcoded user-facing text when practical.

## Scope

This project supports macOS on Apple Silicon only.

Not supported:

- Intel Macs
- Linux on Apple Silicon / Asahi Linux
- Windows
