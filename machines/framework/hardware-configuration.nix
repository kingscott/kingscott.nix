# PLACEHOLDER — regenerate this file on the Framework 13 during install.
#
# From the NixOS installer, after partitioning and mounting the target at /mnt:
#     sudo nixos-generate-config --root /mnt --dir /mnt/etc/nixos/machines/framework
# or, once the system is running:
#     sudo nixos-generate-config --dir /etc/nixos/machines/framework
#
# The fileSystems entries below are placeholders (matched by partition LABEL)
# and exist only so the flake evaluates. They will NOT boot until this file is
# regenerated with the machine's real UUIDs / LUKS mapping.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Placeholder — replace via nixos-generate-config on the target machine.
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
