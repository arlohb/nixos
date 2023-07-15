{ ... }@inputs:

{
  nixpkgs.config.packageOverrides = pkgs: {
    porsmo = ((import ../pkgs/porsmo.nix) inputs).porsmo;
  };
}
