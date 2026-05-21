{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      libGL
      mesa
      intel-media-driver
      intel-vaapi-driver
      vulkan-loader
      intel-vpl-gpu-rt
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      mesa
      intel-media-driver
      vulkan-loader
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    NIXOS_OZONE_WL = "1";
  };
}
