hostname: { pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    cura
  ];
}
