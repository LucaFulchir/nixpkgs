{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "upbge-logicnodes";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "UPBGE";
    repo = "UPBGE-logicnodes";
    rev = "v${version}";
    sha256 = "sha256-tDN5G/q12npyPz5mPw8cuoYfCQCIT9OHhAx+N2kB7tQ=";
  };
  installPhase = ''
    mkdir -p $out
    cp -a . $out/
  '';
}

