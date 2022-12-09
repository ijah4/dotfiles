{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [];
    extraModulePackages = [];
    kernelModules = [ "kvm-amd" ];
  };

  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    ergodox.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = true;
    sensors.enable = true;
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 12;
  hardware.cpu.amd.updateMicrocode = true;

  # Networking
  networking.interfaces = {
    enp42s0.useDHCP = true;
    wlo1.useDHCP = true;
  };

  # Displays
  services.xserver = {
    # This must be done manually to ensure my screen spaces are arranged exactly
    # as I need them to be *and* the correct monitor is "primary". Using
    # xrandrHeads does not work.
    monitorSection = ''
      VendorName     "Unknown"
      ModelName      "Samsung S27E391"
      HorizSync       30.0 - 81.0
      VertRefresh     50.0 - 75.0
      Option         "DPMS"
    '';
    screenSection = ''
      Option "metamodes" "HDMI-0: nvidia-auto-select +1920+0, DP-1: 1920x1080_75 +0+0"
      Option "SLI" "Off"
      Option "MultiGPU" "Off"
      Option "BaseMosaic" "off"
      Option "Stereo" "0"
      Option "nvidiaXineramaInfoOrder" "DFP-1"
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media/games" = {
      device = "/dev/disk/by-uuid/8C1EE27F1EE261A6";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=100" "rw" "user" "exec" "umask=000" "nofail" "lowntfs-3g" ];
    };
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];
}
