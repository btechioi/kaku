{pkgs, ...}: {
  users.users.root.initialPassword = "root";

  users.users.banumath = {
    isNormalUser = true;
    description = "Banumath Hettiarachchi";
    shell = pkgs.fish;
    initialPassword = "banumath";
    extraGroups = [
      "adbusers"
      "input"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
      "kvm"
      "docker"
    ];
  };
}
