# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # Powers on the adapter at boot

  services.power-profiles-daemon.enable = false; # Disable conflict

  services.tlp = {
    enable = true;
    settings = {
      # Governor choices: powersave, powersave/powersave, conservative, schedutil, etc.
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy performance preference (EPP) for Intel / modern AMD
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Optional: CPU frequency caps on battery
      # CPU_MIN_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT = 50; # Limit max clock speed to 50% on battery
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.useXkbConfig = true;

  programs.neovim.defaultEditor = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
    extraOptions = [ "--unsupported-gpu" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      tms = "tmux-sessionizer";
    };
  };

  environment.variables.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."lucas" = {
    isNormalUser = true;
    description = "lucas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # hardware.graphics.enable = true;
  hardware.graphics = { # Use hardware.opengl se estiver em uma versão do NixOS anterior a 24.05
  enable = true;
  extraPackages = with pkgs; [
    intel-media-driver # Driver principal para VA-API
    intel-vaapi-driver # Driver de fallback
  ];
};

  security.polkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget,
  firefox
  vivaldi
  chromium

  ghostty
  tmux
  bluez
  bluetui
  btop
  pavucontrol
  kdePackages.dolphin
  zathura
  cliphist
  wl-clipboard
  hyprshot
  
  neovim
  vim-full
  fzf
  eza
  wget
  gzip
  curl
  gnutar
  git
  github-cli
  zsh
  oh-my-zsh
  unzip
  quickshell
  fd
  ripgrep
  yazi
  nautilus
  libreoffice-fresh
  codex
  opencode
  
  waybar
  wofi
  swaybg
  swaylock-effects
  spotify
  xournalpp
  sqlite
  
  cargo
  rustc
  rust-analyzer
  rustfmt
  clippy
  stylua
  lua-language-server
  nil
  pyright
  tinymist
  sqls
  shfmt
  gcc
  clang-tools
  gnumake     
  tree-sitter 
  python3
  texliveFull
  nodejs
  typst
  vial
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  # 2. Add udev rules for Vial/QMK hardware access
  services.udev.packages = with pkgs; [
    vial
  ];

  environment.sessionVariables = {
    PATH = [ "/home/lucas/personal/dotfiles-hyprland/bin" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
