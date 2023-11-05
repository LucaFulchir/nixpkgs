{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "upbge-addons";
  version = "20230804";

  src = fetchFromGitHub {
    owner = "UPBGE";
    repo = "blender-addons";
    rev = "885595ca10e23f92e6af42298fbb1b051a828842";
    sha256 = "sha256-snElLAjwCEskF/AMRS5vmh03BgIieAcj8CbwGabp9f8=";
  };
  installPhase = ''
    mkdir -p $out
    cp -a . $out/
  '';
}

