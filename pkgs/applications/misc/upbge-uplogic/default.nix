{ buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "upbge-uplogic";
  version = "20230711";
  src = fetchFromGitHub {
    owner = "UPBGE";
    repo = "uplogic";
    rev = "e7937a632c395c90fe8adf98ffc1b0d29d332d07";
    sha256 = "sha256-61f76qxnx0IDJuLTWkAgNj/d4hm4mF7yLS+4oOZgYLE=";
  };
  doCheck = false;

}

