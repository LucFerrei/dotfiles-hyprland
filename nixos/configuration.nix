{ config, pkgs, pkgs-unstable, ... }:

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
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable AppImage support and register it as a binary type
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # Powers on the adapter at boot

  services.power-profiles-daemon.enable = false; # Disable conflict

  services.tlp = {
    enable = true;
    settings = {
      # Governor choices: powersave, powersave/powersave, conservative, schedutil, etc.
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";

      # Energy performance preference (EPP) for Intel / modern AMD
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
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

  ## printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # 2. Habilitar o Avahi (necessário para detetar a impressora na rede/Wi-Fi)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.xserver.enable = true; # Mantém o xserver base ativo

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
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "docker" ]; ##remove lp and scanner
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
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  # programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
  firefox
  chromium
  distrobox
  podman
  docker
  docker-compose
  cloudflared

  ghostty
  tmux
  bluez
  bluetui
  btop
  pavucontrol
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
  pnpm
  quickshell
  fd
  jq
  ripgrep
  yazi
  nautilus
  libreoffice-fresh
  codex
  pkgs-unstable.opencode
  pkgs-unstable.claude-code
  
  waybar
  wofi
  swaybg
  swaylock-effects
  xournalpp
  sqlite
  slack
  brightnessctl
  
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
    PATH = [ "/home/lucas/personal/dotfiles-hyprland/bin" "/home/lucas/.cargo/bin" "/home/lucas/.local/bin" ];
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # --- Otimizacoes de recursos (CPU / RAM / IO) ---
  # zram: swap comprimida na RAM (voce tem 11 GiB e a swap em disco nunca e usada)
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;          # recomendado para zram
    "vm.vfs_cache_pressure" = 50;   # preserva caches de inode/dentry
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
