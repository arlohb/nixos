{ pkgs, ...}:

{
  hardware.bluetooth = {
    enable = true;
    settings = {
      # Needed to get battery from dbus in bl_status.sh
      General.Experimental = true;
    };
  };

  pkgs = with pkgs; [
    blueberry
  ];

  persist.directories = [
    "/var/lib/bluetooth"
  ];
}
