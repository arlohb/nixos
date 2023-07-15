#!/usr/bin/env bash

echo "Updating flake..."
nix flake update
echo "Building system..."
nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel"
echo "Showing pkg updates..."
nvd diff /run/current-system ./result
echo "Switching to new system..."
sudo nixos-rebuild switch

