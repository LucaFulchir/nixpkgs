{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
#, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyHik";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyhik";
    rev = "${version}";
    sha256 = "035djnsmccg3zm0hjkxk3kbkh6q2qivhhj08hbpdxqawflfdvz2x";
  };

  # remove broken test (uses localhost:80)
  postPatch = ''
    rm -vf test/test_hikvision.py
  '';

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [ "pyhik.hikvision" ];

  meta = with lib; {
    description = "python module aiming to expose common API events from a Hikvision IP camera or nvr";
    homepage = "https://github.com/mezz64/pyhik";
    license = with licenses; [ mit ];
  };
}
