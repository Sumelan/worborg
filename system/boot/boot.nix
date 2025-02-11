{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  # Bootloader.
  boot = {
    initrd = {
      # enable stage-1 bootloader
      systemd.enable = true;
      # always allow booting from usb
      availableKernelModules = [ "uas" ];
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
      };
      timeout = 3;
    };
  };

  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  # reduce journald logs
  services.journald.extraConfig = ''SystemMaxUse=50M'';
}
