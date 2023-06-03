{ pkgs, lib, inputs, ... }:

{
  porsmo = pkgs.rustPlatform.buildRustPackage {
    name = "porsmo";
    src = inputs.porsmo;

    cargoSha256 = "sha256-4pTto/BlyFeD55du++zYRD4JSXTR53Jn4vO2Zvmyv10=";

    buildInputs = [ pkgs.alsa-lib ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    meta = with lib; {
      description = "A rust program for pomodoro, timer, stopwatch - all in one.";
      homepage = "https://github.com/ColorCookie-dev/porsmo";
      license = licenses.mit;
    };
  };
}
