{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, meson
, ninja
, binutils
, cairo
, git
, hyprland-protocols
, jq
, libdrm
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, pciutils
, systemd
, udis86
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, xcbutilwm
, xwayland
, debug ? false
, enableNvidiaPatches ? false
, enableXWayland ? true
, legacyRenderer ? false
, withSystemd ? true
, wrapRuntimeDeps ? true
  # deprecated flags
, nvidiaPatches ? false
, hidpiXWayland ? false
}:
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been renamed `enableNvidiaPatches`";
assert lib.assertMsg (!hidpiXWayland) "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "8e04a80e60983f5def26bdcaea701040fea9a7ae";
    hash = "sha256-5/vEdU3SzAdeIyPykjks/Zxkvh9luPTIei6oa77OY2Q=";
  };

  patches = [
    # make meson use the provided dependencies instead of the git submodules
    "${finalAttrs.src}/nix/patches/meson-build.patch"
    # look into $XDG_DESKTOP_PORTAL_DIR instead of /usr; runtime checks for conflicting portals
    "${finalAttrs.src}/nix/patches/portals.patch"
  ];

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp
    substituteInPlace meson.build \
      --replace "@GIT_COMMIT_HASH@" '${finalAttrs.src.rev}' \
      --replace "@GIT_DIRTY@" ""
  '';

  nativeBuildInputs = [
    jq
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs =
    [
      cairo
      git
      hyprland-protocols
      libdrm
      libinput
      libxkbcommon
      mesa
      udis86
      wayland
      wayland-protocols
      pango
      pciutils
      (wlroots.override { inherit enableNvidiaPatches; })
    ]
    ++ lib.optionals enableXWayland [ libxcb xcbutilwm xwayland ]
    ++ lib.optionals withSystemd [ systemd ];

  mesonBuildType =
    if debug
    then "debug"
    else "release";

  mesonFlags = builtins.concatLists [
    (lib.optional (!enableXWayland) "-Dxwayland=disabled")
    (lib.optional legacyRenderer "-DLEGACY_RENDERER:STRING=true")
    (lib.optional withSystemd "-Dsystemd=enabled")
  ];

  postInstall = ''
    ln -s ${wlroots}/include/wlr $dev/include/hyprland/wlroots
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils]}
    ''}
  '';

  passthru.providedSessions = [ "hyprland" ];

  meta = with lib; {
    homepage = "https://github.com/vaxerski/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    mainProgram = "Hyprland";
    platforms = wlroots.meta.platforms;
  };
})
