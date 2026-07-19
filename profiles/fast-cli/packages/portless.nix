{
  fetchurl,
  lib,
  makeWrapper,
  nodejs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "portless";
  version = "0.15.4";

  src = fetchurl {
    url = "https://registry.npmjs.org/portless/-/portless-${finalAttrs.version}.tgz";
    hash = "sha256-Wv1T7rezsuUYVBmp9sgan8y1CXQIMT0nRe/ZJeOABlU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = "package";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/portless" "$out/bin"
    cp -r dist package.json "$out/lib/portless/"
    makeWrapper ${nodejs}/bin/node "$out/bin/portless" \
      --add-flags "$out/lib/portless/dist/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Stable named localhost URLs for local development";
    homepage = "https://github.com/vercel-labs/portless";
    license = lib.licenses.asl20;
    mainProgram = "portless";
    platforms = lib.platforms.unix;
  };
})
