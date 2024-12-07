{ pkgs, lib, inputs, ... }:

{
  porsmo = pkgs.rustPlatform.buildRustPackage {
    name = "porsmo";
    src = inputs.porsmo;

    cargoHash = "sha256-k1roPRxILjwfLp5NnkMCP656hN5aXTGBZGJYyPcleBI=";

    buildInputs = [ pkgs.alsa-lib ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    meta = with lib; {
      description = "A rust program for pomodoro, timer, stopwatch - all in one.";
      homepage = "https://github.com/ColorCookie-dev/porsmo";
      license = licenses.mit;
    };
  };
}
