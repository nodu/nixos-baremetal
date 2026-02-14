# AGENTS.md

Instructions for AI coding agents working in this NixOS configuration repository.

## Repository Overview

Personal NixOS configuration for a Framework 13 AMD laptop. Uses Nix flakes, home-manager, GNOME + i3 (X11 primary), and Sway (Wayland secondary). Single host: `baremetal`.

## Build / Test / Apply Commands

```bash
make test             # Test configuration without switching (catches eval errors)
make switch           # Apply configuration changes (requires sudo)
make switch-logs      # Apply with detailed build logs
make list             # List system generations (for rollback)
make clean-generations # Delete generations older than 10 days
make optimise         # Optimize/deduplicate nix store
```

### NixOS Helper Functions (source home/nixos-functions.sh)

```bash
nx-update()                    # Update and switch system configuration
nx-update-flakes()            # Update all flake inputs
nx-update-input <input>       # Update specific flake input
nx-search <query>             # Search for packages
nx-info-size <package>        # Show package size information
nx-shell <packages>           # Create temporary shell with packages
```

### VM/Remote Deployment

```bash
make vm/bootstrap0    # Bootstrap new VM from ISO
make vm/bootstrap     # Complete VM setup with configuration
make vm/copy         # Copy configuration to VM
make vm/switch       # Apply configuration on VM
```

There is no unit test suite, linter, or CI pipeline. The primary validation method is `make test`, which evaluates the full NixOS configuration and reports any Nix evaluation errors. **Always run `make test` after making changes.**

## File Organization

| Path | Purpose |
|------|---------|
| `flake.nix` | Flake definition: inputs, outputs, nixpkgs/unstable channels, overlays |
| `configuration.nix` | System-level config: boot, networking, services, system packages |
| `hardware-configuration.nix` | Auto-generated hardware config (**do not edit**) |
| `home/home-manager.nix` | User-level config: user packages, dotfiles, programs, shell |
| `home/i3/`, `home/sway/` | Window manager configs (nix modules + external config files) |
| `modules/` | Custom NixOS modules (`vpns.nix`, `fhs-compat.nix`) and package derivations (`vpn.nix`, `handy.nix`) |
| `Makefile` | Build/deploy commands |

### Where to Add Things

- **System packages**: `configuration.nix` in `environment.systemPackages`
- **User packages**: `home/home-manager.nix` in `home.packages`
- **NixOS services/modules**: `modules/` directory, imported in `configuration.nix`
- **WM-specific packages/config**: `home/i3/i3.nix` or `home/sway/sway.nix`

## Desktop & Development Environment

- **Primary WM**: GNOME + i3 (X11)
- **Secondary WM**: Sway (Wayland)
- **Terminal**: Alacritty with Catppuccin Mocha theme
- **Shell**: Zsh with oh-my-zsh, extensive aliases in `home/nixos-functions.sh`
- **Editor**: Neovim nightly with external configuration
- **Languages**: Go, Python, Node.js with corresponding LSPs
- **Tools**: Modern CLI utilities (bat, fd, ripgrep, fzf, jq)
- **Git**: Configured for multiple identities, SSH key management via secrets
- **Docker**: Enabled for containerized development

## Nix Code Style

### Formatting

- **2-space indentation**, no tabs
- No enforced line length limit (pragmatic)
- Formatter: `nixpkgs-fmt` (installed for editor use, no project config)
- Use `#` for all comments (never `/* */`)
- Section banners in large files: `#----- Section Name -----`
- TODO format: `# TODO: description`

### Module Function Signatures

```nix
# Standard NixOS module
{ config, pkgs, lib, ... }:
{ }

# Home-manager (curried to pass flake inputs)
{ inputs, ... }:
{ config, lib, pkgs, unstable, ... }:

# Package derivations (enumerate dependencies explicitly)
{ autoPatchelfHook, dpkg, fetchurl, lib, stdenv, ... }:
```

### Naming Conventions

- **Files**: lowercase kebab-case (`home-manager.nix`, `fhs-compat.nix`)
- **Local variables** in `let` blocks: camelCase (`nordVPNBase`, `handyFHS`)
- **Package names** (`pname`): lowercase with hyphens (`"nordvpn"`)
- **Module options**: standard NixOS dot paths (`services.nordvpn.enable`)

### Attribute Paths

Use **dotted paths** for single settings, **nested sets** for grouped settings:

```nix
boot.loader.systemd-boot.enable = true;       # Dotted for one-off
services.avahi = { enable = true; nssmdns4 = true; };  # Nested for groups
```

### Package References

- Prefer explicit `pkgs.` prefix: `pkgs.google-chrome`
- `unstable.` for unstable channel packages: `unstable.alacritty`
- `with pkgs; [ ... ]` acceptable for library lists (e.g., `fhs-compat.nix`)
- Do not mix `with pkgs;` and `pkgs.` prefix in the same list

### Imports and Dependencies

- Relative paths with `./` prefix: `imports = [ ./hardware-configuration.nix ];`
- Use `inherit` for concise binding: `inherit (pkgs) fetchFromGitHub;`
- External config files via `builtins.readFile`: `"i3/config".text = builtins.readFile ./i3.config;`

### Strings

- Single-line: double quotes (`"value"`)
- Multi-line scripts/config: `'' ... ''`
- Interpolation: `"${pkgs.foo}/bin/foo"` -- escape `$` inside `'' ''` with `''$`

### Conditionals and Options

- `lib.mkIf` for conditional config (not bare `if-then-else`)
- `lib.mkDefault` for overridable defaults
- `lib.mkForce` to override upstream values
- `lib.optionals` for conditional list elements
- `lib.mkOption` with `types.*` for custom module options

### Module Patterns

**Config-only module** (most files): directly set config attributes. **Full option module** (only `modules/vpns.nix`): defines `options` + uses `config = mkIf ...`.

### Let-In Usage

Top-level only. Used for intermediate derivations, pinned packages, and helper scripts:

```nix
let
  helperPkg = pkgs.writeShellApplication { ... };
in
{ home.packages = [ helperPkg ]; }
```

### Error Handling

- No `builtins.assert` or `throw` -- rely on NixOS type checking and eval errors
- `mdDoc` descriptions to document correct usage of custom options
- Shell scripts use `|| true` for non-fatal operations, `|| exit` for critical ones

## Stable vs Unstable Packages

- Default: `pkgs` (nixpkgs 25.05, stable)
- Unstable: `unstable` (nixpkgs-unstable), passed via `specialArgs`
- Use `unstable.` only when a newer version is specifically needed
- Version pinning: specific nixpkgs commit via `builtins.fetchTarball` with SHA256

## Secrets

- SSH keys and GPG keyrings managed outside Nix (`make secrets/backup`, `make secrets/restore`)
- Never commit `.ssh/`, `.gnupg/`, or `backup.tar.gz`

## Important Notes

- System uses experimental Nix features (flakes, nix-command)
- Home-manager manages user environment separately from system
- Framework 13 hardware optimizations are applied via nixos-hardware
- Auto garbage collection runs every 30 days, store optimization enabled

## Key Workflows

### Making Configuration Changes

1. Edit relevant `.nix` files
2. Test with `make test` to catch errors
3. Apply with `make switch`
4. Use `make list` to see generations for rollback if needed

### Managing System State

- Use `make clean-generations` periodically to free space
- Run `make optimise` to deduplicate store
- Check `make clean-boot-partition` if boot partition fills up

### Flake Updates

- Use `nx-update-flakes()` to update all inputs
- Use `nx-update-input <input>` for targeted updates
- Check nixpkgs versions in flake.nix - system uses 25.05, some packages from unstable

### Package Discovery

- Use `nx-search <query>` to find packages
- Use `nx-info-size <package>` to check size before installing
- Browse https://search.nixos.org for comprehensive package search
