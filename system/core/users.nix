{pkgs, ...}: {
  users.users.root.initialPassword = "root";

  users.users.banumath = {
    isNormalUser = true;
    description = "Banumath Hettiarachchi";
    shell = pkgs.fish;
    initialPassword = "banumath";
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "gamemode"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "podman"
      "plugdev"
      "realtime"
      "video"
      "wheel"
    ];
  };
}
