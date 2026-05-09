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

Secrets live in `/etc/nixos/secrets.nix` (gitignored, not committed). WiFi is now managed by NetworkManager, so PSKs are stored under `/etc/NetworkManager/system-connections/` rather than in nix.

## Notes

- **dbook (2015 MacBook Air) wifi:** the Broadcom card won't associate with 802.11w (PMF) enabled. After adding the connection, disable PMF: `nmcli connection modify <name> wifi-sec.pmf 1` (1 = disable in NetworkManager).

## Rebuilding

```bash
sudo nixos-rebuild switch --flake .#dbook --impure
```
