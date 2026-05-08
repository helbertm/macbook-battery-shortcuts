# Troubleshooting

## `battery` command not found

Restart your terminal or run:

```bash
source ~/.zshrc
```

If the CLI is still missing, reinstall using the project installer.

## Shortcuts not available

Check that this line exists in `~/.zshrc`:

```bash
source $HOME/.battery-shortcuts.zsh
```

Then run:

```bash
source ~/.zshrc
```

## GUI app install does not expose CLI

If you selected full app + CLI, open the Battery app once to complete setup and permissions.

```bash
open -a Battery
```

## Restore daily mode

```bash
batt-7080
```

## Prepare for full battery

```bash
batt-away
```
