{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "blender-addons-contrib";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "blender";
    repo = "blender-addons-contrib";
    rev = "v${version}";
    sha256 = "sha256-wT4XN7QCP8/M+Av/PnFHr22w1DRu35+sXWifkP/lvsc=";
  };
  installPhase = ''
    mkdir -p $out
    cp -a . $out/
  '';
}

