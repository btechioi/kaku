_: {
  environment.variables.NH_FLAKE = "/home/banumath/kaku";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
  };
}
