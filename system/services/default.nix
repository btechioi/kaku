{
  lib,
  pkgs,
  ...
}: {
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };

    dbus.implementation = "broker";

    irqbalance.enable = true;
    thermald.enable = true;
    speechd.enable = lib.mkForce false;

    journald.extraConfig = ''
      Storage=volatile
      Compress=yes
      SystemMaxUse=50M
      MaxRetentionSec=7day
    '';
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=10s
    '';
    services = {
      systemd-udev-settle.enable = false;
      systemd-udevd.serviceConfig.ExecStart = [
        ""
        "${pkgs.systemd}/lib/systemd/systemd-udevd --resolve-names=never"
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
    powerDownCommands = ''
      loginctl lock-sessions
      sleep 1
    '';
  };
}
