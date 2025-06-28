{ ... }:

{
  # Don't sleep when lid is closed
  services.logind.lidSwitch = "ignore";

  networking.firewall.enable = false;
}
