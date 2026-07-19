{
  bun,
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hunkdiff";
  version = "0.17.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/hunkdiff/-/hunkdiff-${finalAttrs.version}.tgz";
    hash = "sha256-skCmwbN5wY9ZBUueBlwj1uX8WaPk+B+WEj6JyoI2k6o=";
  };

  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = "package";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/hunkdiff" "$out/share/hunkdiff/skills" "$out/bin"
    cp -r dist package.json "$out/lib/hunkdiff/"
    cp -r skills/* "$out/share/hunkdiff/skills/"
    ln -s "$out/share/hunkdiff/skills" "$out/lib/hunkdiff/skills"
    makeWrapper ${bun}/bin/bun "$out/bin/hunk" \
      --add-flags "$out/lib/hunkdiff/dist/npm/main.js"
    ln -s hunk "$out/bin/hunkdiff"

    runHook postInstall
  '';

  meta = {
    description = "Terminal diff viewer for agent-authored changesets";
    homepage = "https://github.com/modem-dev/hunk";
    license = lib.licenses.mit;
    mainProgram = "hunkdiff";
    platforms = lib.platforms.unix;
  };
})
