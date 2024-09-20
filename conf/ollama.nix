{ pkgs, ... }:

{
  hardware.amdgpu.opencl.enable = true;

  services.ollama = {
    enable = true;

    host = "0.0.0.0";
    openFirewall = true;

    acceleration = "rocm";
    rocmOverrideGfx = "10.3.1";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1031";
      OLLAMA_ORIGINS = "http://*";
    };
  };

  persist.directories = [
    "/var/lib/private/ollama"
  ];
}
