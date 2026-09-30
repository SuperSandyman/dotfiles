{
  lib,
  stdenvNoCC,
  fetchurl,
  zstd,
  gnutar,
}:

stdenvNoCC.mkDerivation rec {
  pname = "codex";
  version = "0.159.2";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-x86_64-unknown-linux-musl.tar.zst";
    hash = "sha256-+8otHiPcn4J/5usZy8opQhQPmaSHafYjVdZH9dde6R4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ${zstd}/bin/zstd -dc "$src" | ${gnutar}/bin/tar -xf - -C "$out"
    chmod 0755 "$out/bin/codex" "$out/bin/codex-code-mode-host" "$out/codex-path/rg"
    if [ -f "$out/codex-resources/bwrap" ]; then
      chmod 0755 "$out/codex-resources/bwrap"
    fi
    ln -s bin/codex "$out/codex"

    runHook postInstall
  '';

  meta = {
    description = "OpenAI Codex CLI (prebuilt release package)";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
}
