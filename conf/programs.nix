{ pkgs, hostname, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  # Uses nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [
      # Just an example
      # "com.ultimaker.cura"
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  # TODO add some synergy like software

  pkgs = with pkgs; [
    distrobox

    gparted
    firefox
    porsmo
    vlc
    gapless

    gnome-calendar
    gnome-clocks

    obsidian
    presenterm
    aseprite
    teams-for-linux

    vscode

    libreoffice

    zotero
  ];

  programs.fish.shellAliases.to-pdf =
    "libreoffice --headless --invisible --convert-to pdf";

  hm.xdg.mimeApps = {
    enable = true;
    # Desktop files are:
    # Here /run/current-system/sw/share/applications for global packages
    # Here ~/.nix-profile/share/applications for home-manager packages
    # Mime types can be found with:
    # file --mime-type -b $file_name
    defaultApplications."application/pdf" = "firefox.desktop";
  };

  persist.directories = [
    "/var/lib/flatpak"
  ];

  userPersist.directories = [
    ".config/aseprite"
    ".mozilla"
    ".config/teams-for-linux"
    ".local/share/containers"
    ".local/share/flatpak"
    # Flatpak app data
    ".var"
    # Used by a few things, namely gapless
    ".config/dconf"
    ".config/Code"
    ".vscode"
    ".config/libreoffice"
    ".zotero"
  ];

  environment.variables = {
    # Affects kicad and some other GTK programs
    GTK_THEME = "Adwaita:dark";
  };
}
