# dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/).

## Bootstrap on NixOS

Install Git and chezmoi, then initialize and apply this repository:

```sh
nix-shell -p git chezmoi --run \
  'chezmoi init --apply git@github.com:SuperSandyman/dotfiles.git'
```

If GitHub SSH keys are not available yet, use HTTPS for the first checkout:

```sh
nix-shell -p git chezmoi --run \
  'chezmoi init --apply https://github.com/SuperSandyman/dotfiles.git'
```

Preview later updates before applying them:

```sh
chezmoi update --dry-run --verbose
chezmoi update
```

## Managed configuration

- Codex preferences, enabled plugins, and custom agent skills
- Neovim configuration and its plugin lockfile
- Zsh and Starship
- Git identity and defaults
- Ghostty, mise, and eza

Codex authentication, conversation history, caches, bundled `.system` skills,
generated marketplace paths, and installation-specific desktop MCP paths are
intentionally not tracked. They are credentials, runtime state, or tied to a
particular Codex installation and should be recreated on the destination host.
