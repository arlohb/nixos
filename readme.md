# My Perfect System

# The Core

## Systemd-boot

This can't be uninstalled, so why not use it?

## Kernel

I'm using the Zen kernel.
This seems to be the best but there's no particular reason for this.

## Nixos Unstable

For the latest packages possible.
If something does break, I can just use a pinned version until it's fixed.

## Flakes

My system is a nix flake, instead of the 'legacy' system.
This seems to be nix's future, and makes things more reproducible.

## NUR (Nix User Repository)

For packages not (yet) in nixpkgs.

## Home Manager

For declarative configuration for more programs.

## Impermanence

Allows the root file system to be a tmp-fs,
meaning only I can choose exactly what is persisted,
and the system is rebuilt on every boot,
so it cannot be corrupted.

# Modules

| Module        | Description                                |
| ------------- |:------------------------------------------ |
| 3d            | 3d modelling and slicing software          |
| Audio         | Pipewire and Wireplumber                   |
| Gaming        | Launchers and runners                      |
| Git           | Git and secret management                  |
| Printing      | Enable cups etc                            |
| Programs      | Browsers, image viewers etc                |
| Terminal      | Fish, Kitty, direnv etc                    |
| User          | User file persistence, symlink config file |
| Neovim        | Configure and install plugins              |

## WM Modules

| Module        | Description                                |
| ------------- |:------------------------------------------ |
| Core          | Stuff I wouldn't need if I had a DE        |
| Cursor        | Cursor themes for x11 and gtk              |
| Lockscreen    | Swaylock                                   |
| Notifications | Dunst and earlyoom notifications           |
| Polkit        | Polkit gnome                               |

