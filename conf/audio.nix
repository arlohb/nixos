hostname: { pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
