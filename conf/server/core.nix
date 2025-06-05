{ ... }:

{
  # Don't sleep when lid is closed
  services.logind.lidSwitch = "ignore";

  # All my server stuff relies on nfs
  boot.supportedFilesystems = [ "nfs" ];

  networking.firewall.enable = false;
}
