{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wayland,
  libxkbcommon,
  grim,
  slurp,
  ydotool,
  wtype,
  wl-clipboard,
  hyprland,
  glib,
  gsettings-desktop-schemas,
  xdotool,
  wmctrl,
}:
let
  version = "0.7.31";
  binaries = {
    computer-use-linux = "sha256-SA/U8DFmx5gx+HYqK7JktHlMdoZdcbfqLnMsXOLfmew=";
    computer-use-linux-indicator = "sha256-fIhSyEIJE2l/gWtB99KjUwi1q0Dbq+ygeS0CRohSphQ=";
  };
  # Release binaries avoid a lengthy Rust build on the 8 GB X270.
  sources = lib.mapAttrs (
    name: hash:
    fetchurl {
      url = "https://github.com/agent-sh/computer-use-linux/releases/download/v${version}/${name}-x86_64-unknown-linux-gnu";
      inherit hash;
    }
  ) binaries;
in
stdenv.mkDerivation {
  pname = "computer-use-linux";
  inherit version;
  dontUnpack = true;
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    wayland
    libxkbcommon
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    ${lib.concatMapStringsSep "\n" (name: ''
      install -m755 ${sources.${name}} "$out/bin/${name}"
    '') (builtins.attrNames binaries)}
    wrapProgram "$out/bin/computer-use-linux" \
      --prefix PATH : ${
        lib.makeBinPath [
          grim
          slurp
          ydotool
          wtype
          wl-clipboard
          hyprland
          glib
          xdotool
          wmctrl
        ]
      } \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
        ]
      } \
      --set COMPUTER_USE_LINUX_INDICATOR_BIN "$out/bin/computer-use-linux-indicator"
    runHook postInstall
  '';
  meta = {
    description = "Linux desktop control for AI agents via CLI, MCP and Pi";
    homepage = "https://github.com/agent-sh/computer-use-linux";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "computer-use-linux";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
