{ pkgs }:
# Add/remove agent development tools here. No services or local LLM runtimes.
with pkgs;
[
  nodejs_24
  pnpm
  bun
  python3
  uv
  pipx
  rustc
  cargo
  go
  gcc
  # Both compiler wrappers otherwise export cc/c++ at priority 10.
  (lib.setPrio 20 clang)
  cmake
  gnumake
  pkg-config
  sqlite
  postgresql
  nixd
  nil
  nixfmt
  rust-analyzer
  typescript-language-server
  bash-language-server
  lua-language-server
  yaml-language-server
  prettier
  stylua
  tree-sitter
]
