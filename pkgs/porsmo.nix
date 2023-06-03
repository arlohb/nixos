{ pkgs, lib, inputs, ... }:

{
  porsmo = pkgs.rustPlatform.buildRustPackage {
    name = "porsmo";
    src = inputs.porsmo;

    cargoSha256 = "sha256-eMhERDOvKIT06ofZ6a189Ouh5WtJthQQ+6+Ssng7qhw=";

    buildInputs = [ pkgs.alsa-lib ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    meta = with lib; {
      description = "A rust program for pomodoro, timer, stopwatch - all in one.";
      homepage = "https://github.com/ColorCookie-dev/porsmo";
      license = licenses.mit;
    };
  };
}
