# dotfiles

NixOS と Home Manager の設定です。

開発用ツールは `profiles/development` の独立した flake で管理しています。

## セットアップ

```sh
git clone git@github.com:SuperSandyman/dotfiles.git ~/develop/dotfiles
cd ~/develop/dotfiles

nix profile add path:$PWD/profiles/development#default

# 確認
sudo nixos-rebuild test --flake path:$PWD#nixos

# 適用
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

## 更新

```sh
cd ~/develop/dotfiles

# システムと開発環境
nix run path:.#update-all
sudo nixos-rebuild switch --flake path:$PWD#nixos

# システムのみ
nix flake update
sudo nixos-rebuild switch --flake path:$PWD#nixos

# 開発環境のみ
nix flake update --flake ./profiles/development
nix profile upgrade development
```

## エイリアス

```sh
dotfiles-update  # システムと開発環境を更新
nixos-update     # システムだけ更新
dev-update       # 開発環境だけ更新
nixos-switch     # NixOSを適用
```

## ローカルLLM（llama.cpp / Arc 140V）

モデル名・量子化・コンテキスト長などはOS設定やこのリポジトリに埋め込まず、
ローカル専用の `~/.config/llama.cpp/gemma4.env` から読み込みます。
必要なら `GEMMA4_CONFIG=/path/to/profile.env` で別プロファイルに切り替えられます。
初回起動時に指定モデルが `~/.cache/llama.cpp` へダウンロードされます。

```sh
# Vulkan デバイスの確認
gemma4-devices

# OpenAI 互換サーバー（http://127.0.0.1:8080）
gemma4-server

# ターミナル対話
gemma4-chat
```

```sh
# 4bitプロファイル
gemma4-4bit-server
gemma4-4bit-chat

# 空きメモリが多い場合はプロファイルを一時的に上書き
GEMMA4_GPU_LAYERS=20 gemma4-4bit-server

# 推論を一時的に有効化
GEMMA4_REASONING=auto GEMMA4_REASONING_BUDGET=-1 gemma4-server
```

変更後はログアウト／ログインして `render`・`video` グループを反映します。
