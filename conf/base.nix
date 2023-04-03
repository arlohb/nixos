{ config, pkgs, ... }:

{
  # See home.nix for more installed packages
  # I've used codes for packages that are elsewhere
  #  FM = Flake Module
  #  HM = Home Manager
  #  OC = Other Config
  environment.systemPackages = with pkgs; [
    # Absolutely vital
    git
    gh
    wget # Also nvim requirement
    curl
    zip
    unzip

    # Laptop
    brightnessctl

    # Audio
    # OC - wireplumber
    pamixer

    # Window manager stuff
    # FM - Hyprland
    libnotify # For testing configs
    nur.repos.aleksana.swww # For setting backgrounds
    eww-wayland # The top bar and more
    grim # Screen capture for sc
    slurp # Region selection for sc
    polkit_gnome # Polkit agent used by gparted, etcher, etc
    xorg.xhost # Used to disable xorg / xwayland access control

    # Secret management
    # OC - gnupg
    pinentry # Used by gnupg
    git-crypt # Encrypts files in git repos with gpg keys

    # Basic programs
    neofetch # Pretty
    feh # Image viewer
    rofi # App launcher
    gparted # Disk manager

    # Editor
    # HM - neovim
    neovide

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  environment.shellAliases = {
    neonix = ''
      nix develop --command bash -c "WINIT_UNIX_BACKEND=x11 neovide --nofork --multigrid ."'';
  };

  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };
}
