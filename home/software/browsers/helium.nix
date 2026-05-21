{
  inputs,
  pkgs,
  ...
}: let
  chromiumFlags = import ./chromium-flags.nix {inherit pkgs;};
in {
  home.packages = [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = chromiumFlags.sessionVariables;
}
