{inputs, pkgs, ...}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
        desiredgov = "performance";
        inogov = "powersave";
        igpu_desiredgov = "performance";
        igpu_inogov = "powersave";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
        nv_powermizer_mode = 1;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'Gamemode Active' 'Optimizations applied'";
        end = "${pkgs.libnotify}/bin/notify-send 'Gamemode Inactive' 'Optimizations reverted'";
      };
    };
  };

  services.pipewire.lowLatency.enable = true;
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}
