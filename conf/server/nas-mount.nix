{ ... }:

{
  fileSystems."/nas" = {
    device = "datasphere:/Root";
    fsType = "nfs";
    options = [
      "defaults"
      "nofail"                        # Don't fail to boot if not present
      "x-system.device-timeout=10"    # Give up faster if not present
    ];
  };
}
