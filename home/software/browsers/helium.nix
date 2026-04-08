{
  inputs,
  pkgs,
  ...
}: let
  chromiumFlags = import ./chromium-flags.nix {inherit pkgs;};
in {
  home.packages = [
    inputs.mynixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.helium
  ];

  home.sessionVariables = chromiumFlags.sessionVariables;
}
