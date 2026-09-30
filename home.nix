{
  config,
  lib,
  localPackages,
  pkgs,
  ...
}:

let
  dotfilesDir = "${config.home.homeDirectory}/develop/dotfiles";
  # Keep model names and tuning profiles in the user-local llama.cpp config;
  # this Home Manager file only installs the generic launchers.
  llamaCppVulkan = pkgs.llama-cpp-vulkan;
  gemma4Server = pkgs.writeShellApplication {
    name = "gemma4-26b-server";
    runtimeInputs = [
      pkgs.coreutils
      llamaCppVulkan
    ];
    text = ''
      set -euo pipefail

      cache_root="''${XDG_CACHE_HOME:-$HOME/.cache}"
      export LLAMA_CACHE="''${LLAMA_CACHE:-$cache_root/llama.cpp}"
      mkdir -p "$LLAMA_CACHE"

      config_file="''${GEMMA4_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/llama.cpp/gemma4.env}"
      if [[ -r "$config_file" ]]; then
        # shellcheck disable=SC1090
        source "$config_file"
      fi

      model="''${GEMMA4_MODEL:-''${GEMMA4_DEFAULT_MODEL:-}}"
      if [[ -z "$model" ]]; then
        printf '%s\n' "Set GEMMA4_DEFAULT_MODEL in $config_file (or GEMMA4_MODEL in the environment)." >&2
        exit 2
      fi
      device="''${GEMMA4_DEVICE:-''${GEMMA4_DEFAULT_DEVICE:-}}"
      gpu_layers="''${GEMMA4_GPU_LAYERS:-''${GEMMA4_DEFAULT_GPU_LAYERS:-}}"
      threads="''${GEMMA4_THREADS:-''${GEMMA4_DEFAULT_THREADS:-8}}"
      threads_batch="''${GEMMA4_THREADS_BATCH:-''${GEMMA4_DEFAULT_THREADS_BATCH:-$threads}}"
      context="''${GEMMA4_CTX_SIZE:-''${GEMMA4_DEFAULT_CTX_SIZE:-}}"
      batch="''${GEMMA4_BATCH_SIZE:-''${GEMMA4_DEFAULT_BATCH_SIZE:-}}"
      ubatch="''${GEMMA4_UBATCH_SIZE:-''${GEMMA4_DEFAULT_UBATCH_SIZE:-}}"
      flash_attention="''${GEMMA4_FLASH_ATTN:-''${GEMMA4_DEFAULT_FLASH_ATTN:-on}}"
      cache_type="''${GEMMA4_CACHE_TYPE:-''${GEMMA4_DEFAULT_CACHE_TYPE:-q8_0}}"
      reasoning="''${GEMMA4_REASONING:-''${GEMMA4_DEFAULT_REASONING:-off}}"
      reasoning_budget="''${GEMMA4_REASONING_BUDGET:-''${GEMMA4_DEFAULT_REASONING_BUDGET:-0}}"
      host="''${GEMMA4_HOST:-127.0.0.1}"
      port="''${GEMMA4_PORT:-8080}"
      temperature="''${GEMMA4_TEMP:-''${GEMMA4_DEFAULT_TEMP:-0.8}}"
      top_p="''${GEMMA4_TOP_P:-''${GEMMA4_DEFAULT_TOP_P:-0.95}}"
      top_k="''${GEMMA4_TOP_K:-''${GEMMA4_DEFAULT_TOP_K:-64}}"
      alias="''${GEMMA4_ALIAS:-''${GEMMA4_DEFAULT_ALIAS:-local-model}}"

      if [[ -z "$device" || -z "$gpu_layers" || -z "$context" || -z "$batch" || -z "$ubatch" ]]; then
        printf '%s\n' "Complete the default profile in $config_file (GPU layers, context, batch, and device are required)." >&2
        exit 2
      fi

      exec llama-server \
        --hf-repo "$model" \
        --no-mmproj \
        --jinja \
        --device "$device" \
        --n-gpu-layers "$gpu_layers" \
        --fit off \
        --split-mode none \
        --n-cpu-moe 0 \
        --threads "$threads" \
        --threads-batch "$threads_batch" \
        --ctx-size "$context" \
        --batch-size "$batch" \
        --ubatch-size "$ubatch" \
        --flash-attn "$flash_attention" \
        --cache-type-k "$cache_type" \
        --cache-type-v "$cache_type" \
        --cache-ram 0 \
        --no-cache-idle-slots \
        --parallel 1 \
        --reasoning "$reasoning" \
        --reasoning-budget "$reasoning_budget" \
        --temp "$temperature" \
        --top-p "$top_p" \
        --top-k "$top_k" \
        --alias "$alias" \
        --host "$host" \
        --port "$port" \
        "$@"
    '';
  };
  gemma4Chat = pkgs.writeShellApplication {
    name = "gemma4-26b";
    runtimeInputs = [
      pkgs.coreutils
      llamaCppVulkan
    ];
    text = ''
      set -euo pipefail

      cache_root="''${XDG_CACHE_HOME:-$HOME/.cache}"
      export LLAMA_CACHE="''${LLAMA_CACHE:-$cache_root/llama.cpp}"
      mkdir -p "$LLAMA_CACHE"

      config_file="''${GEMMA4_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/llama.cpp/gemma4.env}"
      if [[ -r "$config_file" ]]; then
        # shellcheck disable=SC1090
        source "$config_file"
      fi

      model="''${GEMMA4_MODEL:-''${GEMMA4_DEFAULT_MODEL:-}}"
      if [[ -z "$model" ]]; then
        printf '%s\n' "Set GEMMA4_DEFAULT_MODEL in $config_file (or GEMMA4_MODEL in the environment)." >&2
        exit 2
      fi
      device="''${GEMMA4_DEVICE:-''${GEMMA4_DEFAULT_DEVICE:-}}"
      gpu_layers="''${GEMMA4_GPU_LAYERS:-''${GEMMA4_DEFAULT_GPU_LAYERS:-}}"
      threads="''${GEMMA4_THREADS:-''${GEMMA4_DEFAULT_THREADS:-8}}"
      threads_batch="''${GEMMA4_THREADS_BATCH:-''${GEMMA4_DEFAULT_THREADS_BATCH:-$threads}}"
      context="''${GEMMA4_CTX_SIZE:-''${GEMMA4_DEFAULT_CTX_SIZE:-}}"
      batch="''${GEMMA4_BATCH_SIZE:-''${GEMMA4_DEFAULT_BATCH_SIZE:-}}"
      ubatch="''${GEMMA4_UBATCH_SIZE:-''${GEMMA4_DEFAULT_UBATCH_SIZE:-}}"
      flash_attention="''${GEMMA4_FLASH_ATTN:-''${GEMMA4_DEFAULT_FLASH_ATTN:-on}}"
      cache_type="''${GEMMA4_CACHE_TYPE:-''${GEMMA4_DEFAULT_CACHE_TYPE:-q8_0}}"
      reasoning="''${GEMMA4_REASONING:-''${GEMMA4_DEFAULT_REASONING:-off}}"
      reasoning_budget="''${GEMMA4_REASONING_BUDGET:-''${GEMMA4_DEFAULT_REASONING_BUDGET:-0}}"
      temperature="''${GEMMA4_TEMP:-''${GEMMA4_DEFAULT_TEMP:-0.8}}"
      top_p="''${GEMMA4_TOP_P:-''${GEMMA4_DEFAULT_TOP_P:-0.95}}"
      top_k="''${GEMMA4_TOP_K:-''${GEMMA4_DEFAULT_TOP_K:-64}}"

      if [[ -z "$device" || -z "$gpu_layers" || -z "$context" || -z "$batch" || -z "$ubatch" ]]; then
        printf '%s\n' "Complete the default profile in $config_file (GPU layers, context, batch, and device are required)." >&2
        exit 2
      fi

      exec llama-cli \
        --hf-repo "$model" \
        --no-mmproj \
        --jinja \
        --conversation \
        --device "$device" \
        --n-gpu-layers "$gpu_layers" \
        --fit off \
        --split-mode none \
        --n-cpu-moe 0 \
        --threads "$threads" \
        --threads-batch "$threads_batch" \
        --ctx-size "$context" \
        --batch-size "$batch" \
        --ubatch-size "$ubatch" \
        --flash-attn "$flash_attention" \
        --cache-type-k "$cache_type" \
        --cache-type-v "$cache_type" \
        --cache-ram 0 \
        --reasoning "$reasoning" \
        --reasoning-budget "$reasoning_budget" \
        --temp "$temperature" \
        --top-p "$top_p" \
        --top-k "$top_k" \
        "$@"
    '';
  };
  gemma4Server4Bit = pkgs.writeShellApplication {
    name = "gemma4-26b-4bit-server";
    runtimeInputs = [ gemma4Server ];
    text = ''
      set -euo pipefail

      config_file="''${GEMMA4_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/llama.cpp/gemma4.env}"
      if [[ -r "$config_file" ]]; then
        # shellcheck disable=SC1090
        source "$config_file"
      fi

      export GEMMA4_MODEL="''${GEMMA4_MODEL:-''${GEMMA4_4BIT_MODEL:-}}"
      export GEMMA4_DEVICE="''${GEMMA4_DEVICE:-''${GEMMA4_4BIT_DEVICE:-}}"
      export GEMMA4_GPU_LAYERS="''${GEMMA4_GPU_LAYERS:-''${GEMMA4_4BIT_GPU_LAYERS:-}}"
      export GEMMA4_THREADS="''${GEMMA4_THREADS:-''${GEMMA4_4BIT_THREADS:-}}"
      export GEMMA4_THREADS_BATCH="''${GEMMA4_THREADS_BATCH:-''${GEMMA4_4BIT_THREADS_BATCH:-}}"
      export GEMMA4_CTX_SIZE="''${GEMMA4_CTX_SIZE:-''${GEMMA4_4BIT_CTX_SIZE:-}}"
      export GEMMA4_BATCH_SIZE="''${GEMMA4_BATCH_SIZE:-''${GEMMA4_4BIT_BATCH_SIZE:-}}"
      export GEMMA4_UBATCH_SIZE="''${GEMMA4_UBATCH_SIZE:-''${GEMMA4_4BIT_UBATCH_SIZE:-}}"
      export GEMMA4_FLASH_ATTN="''${GEMMA4_FLASH_ATTN:-''${GEMMA4_4BIT_FLASH_ATTN:-}}"
      export GEMMA4_CACHE_TYPE="''${GEMMA4_CACHE_TYPE:-''${GEMMA4_4BIT_CACHE_TYPE:-}}"
      export GEMMA4_REASONING="''${GEMMA4_REASONING:-''${GEMMA4_4BIT_REASONING:-}}"
      export GEMMA4_REASONING_BUDGET="''${GEMMA4_REASONING_BUDGET:-''${GEMMA4_4BIT_REASONING_BUDGET:-}}"
      export GEMMA4_TEMP="''${GEMMA4_TEMP:-''${GEMMA4_4BIT_TEMP:-}}"
      export GEMMA4_TOP_P="''${GEMMA4_TOP_P:-''${GEMMA4_4BIT_TOP_P:-}}"
      export GEMMA4_TOP_K="''${GEMMA4_TOP_K:-''${GEMMA4_4BIT_TOP_K:-}}"
      export GEMMA4_ALIAS="''${GEMMA4_ALIAS:-''${GEMMA4_4BIT_ALIAS:-local-model}}"

      exec gemma4-26b-server "$@"
    '';
  };
  gemma4Chat4Bit = pkgs.writeShellApplication {
    name = "gemma4-26b-4bit";
    runtimeInputs = [ gemma4Chat ];
    text = ''
      set -euo pipefail

      config_file="''${GEMMA4_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/llama.cpp/gemma4.env}"
      if [[ -r "$config_file" ]]; then
        # shellcheck disable=SC1090
        source "$config_file"
      fi

      export GEMMA4_MODEL="''${GEMMA4_MODEL:-''${GEMMA4_4BIT_MODEL:-}}"
      export GEMMA4_DEVICE="''${GEMMA4_DEVICE:-''${GEMMA4_4BIT_DEVICE:-}}"
      export GEMMA4_GPU_LAYERS="''${GEMMA4_GPU_LAYERS:-''${GEMMA4_4BIT_GPU_LAYERS:-}}"
      export GEMMA4_THREADS="''${GEMMA4_THREADS:-''${GEMMA4_4BIT_THREADS:-}}"
      export GEMMA4_THREADS_BATCH="''${GEMMA4_THREADS_BATCH:-''${GEMMA4_4BIT_THREADS_BATCH:-}}"
      export GEMMA4_CTX_SIZE="''${GEMMA4_CTX_SIZE:-''${GEMMA4_4BIT_CTX_SIZE:-}}"
      export GEMMA4_BATCH_SIZE="''${GEMMA4_BATCH_SIZE:-''${GEMMA4_4BIT_BATCH_SIZE:-}}"
      export GEMMA4_UBATCH_SIZE="''${GEMMA4_UBATCH_SIZE:-''${GEMMA4_4BIT_UBATCH_SIZE:-}}"
      export GEMMA4_FLASH_ATTN="''${GEMMA4_FLASH_ATTN:-''${GEMMA4_4BIT_FLASH_ATTN:-}}"
      export GEMMA4_CACHE_TYPE="''${GEMMA4_CACHE_TYPE:-''${GEMMA4_4BIT_CACHE_TYPE:-}}"
      export GEMMA4_REASONING="''${GEMMA4_REASONING:-''${GEMMA4_4BIT_REASONING:-}}"
      export GEMMA4_REASONING_BUDGET="''${GEMMA4_REASONING_BUDGET:-''${GEMMA4_4BIT_REASONING_BUDGET:-}}"
      export GEMMA4_TEMP="''${GEMMA4_TEMP:-''${GEMMA4_4BIT_TEMP:-}}"
      export GEMMA4_TOP_P="''${GEMMA4_TOP_P:-''${GEMMA4_4BIT_TOP_P:-}}"
      export GEMMA4_TOP_K="''${GEMMA4_TOP_K:-''${GEMMA4_4BIT_TOP_K:-}}"
      export GEMMA4_ALIAS="''${GEMMA4_ALIAS:-''${GEMMA4_4BIT_ALIAS:-local-model}}"

      exec gemma4-26b "$@"
    '';
  };
  gemma4Devices = pkgs.writeShellApplication {
    name = "gemma4-26b-devices";
    runtimeInputs = [ llamaCppVulkan ];
    text = ''
      exec llama-server --list-devices "$@"
    '';
  };
  shellAliases = {
    ls = "eza --icons --group-directories-first";
    ll = "eza --icons -la --group-directories-first";
    la = "eza --icons -a --group-directories-first";
    grep = "rg";
    cat = "bat --paging=never";
    vi = "nvim";
    vim = "nvim";
    lmstudio = "lm-studio";
    lmstudio-chat = "lms runtime select llama.cpp-linux-x86_64-vulkan-avx2@2.24.0 && lms chat";
    lmstudio-runtime = "lms runtime select llama.cpp-linux-x86_64-vulkan-avx2@2.24.0";
    lmstudio-load = "lms runtime select llama.cpp-linux-x86_64-vulkan-avx2@2.24.0 && lms load";
    lmstudio-models = "lms ls";
    lmstudio-loaded = "lms ps";
    lmstudio-server = "lms server start --port 1234";
    lmstudio-server-status = "lms server status";
    lmstudio-server-stop = "lms server stop";
    gemma4-chat = "gemma4-26b";
    gemma4-server = "gemma4-26b-server";
    gemma4-4bit-chat = "gemma4-26b-4bit";
    gemma4-4bit-server = "gemma4-26b-4bit-server";
    gemma4-devices = "gemma4-26b-devices";
    codex-lmstudio = "codex --oss";
    dotfiles-update = "cd ${dotfilesDir} && nix run path:.#update-all";
    nixos-update = "cd ${dotfilesDir} && nix flake update";
    dev-update = "cd ${dotfilesDir} && nix --accept-flake-config flake update --flake ./profiles/development && nix --accept-flake-config profile upgrade development";
    nixos-switch = "sudo nixos-rebuild switch --flake path:${dotfilesDir}#nixos";
  };
in
{
  imports = [ ./plasma.nix ];

  home.username = "sandyman";
  home.homeDirectory = "/home/sandyman";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Editors, CLI tools, and runtimes live in the development Nix profile.
    ghostty
    inconsolata
    llamaCppVulkan
    gemma4Chat
    gemma4Server
    gemma4Chat4Bit
    gemma4Server4Bit
    gemma4Devices
    # Includes the GUI and a NixOS-compatible `lms` CLI.
    lmstudio
    nerd-fonts.hack
    noto-fonts-cjk-sans
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    inherit shellAliases;
    initExtra = ''
      if command -v herdr >/dev/null 2>&1; then
        source <(herdr completion bash)
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    inherit shellAliases;
    initContent = lib.mkOrder 1200 ''
      if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
        source "$HOME/google-cloud-sdk/path.zsh.inc"
      fi
      if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
        source "$HOME/google-cloud-sdk/completion.zsh.inc"
      fi
      if command -v herdr >/dev/null 2>&1; then
        source <(herdr completion zsh)
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./private_dot_config/starship.toml);
  };

  programs.bat.enable = true;
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  xdg.configFile = {
    "nvim/init.lua".source = ./private_dot_config/nvim/init.lua;
    "nvim/README.md".source = ./private_dot_config/nvim/README.md;
    "nvim/after".source = ./private_dot_config/nvim/after;
    "nvim/lua".source = ./private_dot_config/nvim/lua;
    "ghostty/config".source = ./private_dot_config/ghostty/config;
    "ghostty/empty_config.ghostty".source = ./private_dot_config/ghostty/empty_config.ghostty;
    "eza/theme.yml".source = ./private_dot_config/eza/theme.yml;
  };

  # Only custom skills are managed. Codex auth, history, sessions, caches,
  # bundled skills, plugin state, and the mutable config.toml remain untouched.
  home.file = {
    ".gitconfig".text = lib.generators.toGitINI {
      user = {
        name = "SuperSandyman";
        email = "66544945+SuperSandyman@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
    ".codex/skills/opensrc".source = ./dot_codex/skills/opensrc;
    ".codex/skills/notion-memory".source = ./dot_codex/skills/notion-memory;
    ".codex/skills/planning".source = ./dot_codex/skills/planning;
    ".codex/skills/worktree".source = ./dot_codex/skills/worktree;
  };

  # The tracked Codex config is a bootstrap template. Codex Desktop mutates
  # config.toml, so an existing installation must never be replaced by a
  # read-only Home Manager symlink.
  home.activation.bootstrapCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.codex/config.toml" ]]; then
      run mkdir -p "$HOME/.codex"
      run install -m 0600 \
        ${./dot_codex/private_config.toml} \
        "$HOME/.codex/config.toml"
    fi
  '';

  # lazy.nvim updates this file as plugins change, so it must remain writable.
  home.activation.bootstrapNeovimLock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.config/nvim/lazy-lock.json" ]]; then
      run install -m 0644 \
        ${./private_dot_config/nvim/lazy-lock.json} \
        "$HOME/.config/nvim/lazy-lock.json"
    fi
  '';
}
