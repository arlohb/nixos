{ ... }:

{
  # Don't sleep when lid is closed
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  networking.firewall.enable = false;
}
