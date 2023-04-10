hostname: { config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users = {
    mutableUsers = false;

    groups = {
      # A user that can modify /etc/nixos
      # The git repo can be changed to this with these commands:
      # cd /etc/nixos
      # sudo chgrp -R nixconfig .
      # sudo chmod  -R g+rw .
      # sudo chmod g+s `find . -type d` # (change `` to () for fish)
      # git init --bare --shared=all .
      nixconfig = {};
    };

    users.arlo = {
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "nixconfig" ];
      initialHashedPassword = (import ../secrets.nix).initialHashedPassword;
    };
  };

  # See home.nix for more installed packages
  # I've used codes for packages that are elsewhere
  #  FM = Flake Module
  #  HM = Home Manager
  #  OC = Other Config
  environment.systemPackages = with pkgs; [
    # Absolutely vital
    # HM - git
    wget # Also nvim requirement
    curl
    zip
    unzip

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
    dwt1-shell-color-scripts # Ran on shell start
    playerctl # Control media with media keys

    # Secret management
    git-crypt # Automatically encrypts secret files in git repos
              # I use this in nixos config for secrets.nix
    scrypt # Encrypts files with passwords
           # I use this so I can store the git-crypt key file
           # in a secure-ish place, that's not acc. that secure

    # Basic programs
    neofetch # Pretty
    feh # Image viewer
    rofi # App launcher
    gparted # Disk manager

    # Editor
    # HM - neovim
    neovide

    # Gaming
    # OC - steam
    # OC - gamemode
    gamescope

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian
  ] ++ (if hostname == "arlo-laptop2" then [
    # Laptop
    brightnessctl
  ] else []);

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
      colorscript -r
    '';
  };

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
}
