# kingscott.nix 

My personal NixOS setup.

## Layout

```
machines/       per-machine config and hardware
  dbook/        2015 MacBook Air (current machine)
  framework/    Framework 13 (future)
modules/
  common.nix    shared packages, desktop, and user settings
flake.nix       defines nixosConfigurations for each machine
```

## Secrets

WiFi PSKs and other secrets live in `/etc/nixos/secrets.nix` (gitignored, not committed).

## Rebuilding

```bash
sudo nixos-rebuild switch --flake .#dbook --impure
```
