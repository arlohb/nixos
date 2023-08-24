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

