{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelModules = ["i915" "v4l2loopback" "i2c-dev" "efivarfs" "dell-smbios" "dell-wmi" "dell-laptop" "tcp_bbr"];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernelParams = [
      "intel_pstate=enable"
      "intel_iommu=on"
      "iommu=pt"
      "mitigations=off"
      "intel_idle.max_cstate=4"
      "preempt=voluntary"
      "nowatchdog"
      "psi=1"
      "split_lock_detect=off"
      "elevator=none"

      "randomize_kstack_offset=on"
      "vsyscall=none"
      "slab_nomerge"
      "module.sig_enforce=1"
      "lockdown=confidentiality"
      "page_poison=1"
      "page_alloc.shuffle=1"
      "sysrq_always_enabled=0"
      "rootflags=noatime"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
      "fbcon=nodefer"

      "init_on_alloc=1"
      "init_on_free=1"

      "i915.enable_guc=3"
      "i915.enable_fbc=1"
      "i915.fastboot=1"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 30;
      "vm.vfs_cache_pressure" = 75;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.compaction_proactiveness" = 50;
      "vm.page_lock_unfairness" = 1;
      "vm.max_map_count" = 2147483642;

      "kernel.nmi_watchdog" = 0; # Disable NMI watchdog (slightly improves performance)

      # Network performance optimizations
      "net.core.netdev_budget" = 600;
      "net.core.netdev_max_backlog" = 16384;
      "net.ipv4.tcp_no_metrics_save" = 1;
      "net.ipv4.tcp_moderate_rcvbuf" = 1;

      "kernel.sysrq" = 0; # Disable magic SysRq key (prevents low-level system commands)
      "kernel.kptr_restrict" = 2; # Hide kernel pointers from unprivileged users (security)
      "kernel.ftrace_enabled" = false; # Disable kernel function tracing (security, disables debugging)
      "kernel.dmesg_restrict" = 1; # Restrict access to dmesg for non-root users (security)
      "fs.protected_fifos" = 2; # Fully restrict writing to FIFOs not owned by the writer (security)
      "fs.protected_regular" = 2; # Fully restrict writing to regular files not owned by the writer (security)
      "fs.suid_dumpable" = 0; # Disable core dumps for setuid programs (security)
      "net.core.bpf_jit_harden" = 2; # Harden BPF JIT compiler for all users

      # Additional security hardening
      "kernel.core_uses_pid" = 1; # Append PID to core filenames
      "kernel.randomize_va_space" = 2; # Full ASLR
      "vm.mmap_rnd_bits" = 32; # Increase ASLR entropy for mmap
      "vm.mmap_rnd_compat_bits" = 16; # Increase ASLR entropy for compat mmap
      "dev.tty.ldisc_autoload" = 0; # Disable TTY line discipline autoloading
      "vm.unprivileged_userfaultfd" = 0; # Disable unprivileged userfaultfd
    };

    blacklistedKernelModules = [
      # Obscure network protocols.
      "af_802154" # IEEE 802.15.4
      "appletalk" # Appletalk
      "atm" # ATM
      "ax25" # Amatuer X.25
      "decnet" # DECnet
      "econet" # Econet
      "ipx" # Internetwork Packet Exchange
      "n-hdlc" # High-level Data Link Control
      "netrom" # NetRom
      "p8022" # IEEE 802.3
      "p8023" # Novell raw IEEE 802.3
      "psnap" # SubnetworkAccess Protocol
      "rds" # Reliable Datagram Sockets
      "rose" # ROSE
      "tipc" # Transparent Inter-Process Communication
      "x25" # X.25

      # Old or rare or insufficiently audited filesystems.
      "adfs" # Active Directory Federation Services
      "affs" # Amiga Fast File System
      "befs" # "Be File System"
      "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
      "cramfs" # compressed ROM/RAM file system
      "efs" # Extent File System
      "erofs" # Enhanced Read-Only File System
      "exofs" # EXtended Object File System
      "f2fs" # Flash-Friendly File System
      "freevxfs" # Veritas filesystem driver
      "gfs2" # Global File System 2
      "hfs" # Hierarchical File System (Macintosh)
      "hfsplus" # Same as above, but with extended attributes.
      "hpfs" # High Performance File System (used by OS/2)
      "jffs2" # Journalling Flash File System (v2)
      "jfs" # Journaled File System - only useful for VMWare sessions
      "ksmbd" # SMB3 Kernel Server
      "minix" # minix fs - used by the minix OS
      "nilfs2" # New Implementation of a Log-structured File System
      "omfs" # Optimized MPEG Filesystem
      "qnx4" # Extent-based file system used by the QNX4 OS.
      "qnx6" # Extent-based file system used by the QNX6 OS.
      "squashfs" # compressed read-only file system (used by live CDs)
      "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
      "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
      "vivid" # Virtual Video Test Driver (unnecessary)

      # Disable Thunderbolt and FireWire to prevent DMA attacks
      "firewire-core"
      "thunderbolt"
    ];

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"
      options rtw88_core disable_lps_deep=y
      options rtw88_pci disable_aspm=y
    '';
  };

  networking.hostName = "nixos";

  environment.sessionVariables = {
    EDITOR = "zed";
    VISUAL = "zed";
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      zstd
      openssl
      curl
      libGL
      glib
      freetype
      fontconfig
      alsa-lib
      libxkbcommon
      wayland
      libglvnd
      pipewire
      libpulseaudio
      udev
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  security.tpm2.enable = true;

  # Additional security hardening for HSI compliance
  security = {
    forcePageTableIsolation = true;
    protectKernelImage = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };
  };

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  # Additional systemd hardening
  systemd = {
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
  };



  environment.systemPackages = with pkgs; [
    cryptsetup
    sunshine
    openjdk21
    prismlauncher
    zed-editor
  ];
}
