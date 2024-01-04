{ lib
, stdenv
, fetchFromGitLab
, git
, makeWrapper
, python3
, rcs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "src";
  version = "1.32";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "src";
    rev = finalAttrs.version;
    hash = "sha256-gVB0BdnrJ1ew49t9j5zlLpBC4WP9xxYlU26ilOWtq08=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    git
    python3
    rcs
  ];

  preConfigure = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/src \
      --suffix PATH ":" "${rcs}/bin"
  '';

  meta = with lib; {
    homepage = "http://www.catb.org/esr/src/";
    description = "Simple single-file revision control";
    longDescription = ''
      SRC, acronym of Simple Revision Control, is RCS/SCCS reloaded with a
      modern UI, designed to manage single-file solo projects kept more than one
      to a directory. Use it for FAQs, ~/bin directories, config files, and the
      like. Features integer sequential revision numbers, a command set that
      will seem familiar to Subversion/Git/hg users, and no binary blobs
      anywhere.
    '';
    changelog = "https://gitlab.com/esr/src/-/raw/${finalAttrs.version}/NEWS.adoc";
    license = licenses.bsd2;
    mainProgram = "src";
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (python3.meta) platforms;
  };
})
