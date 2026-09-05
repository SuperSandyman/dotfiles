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
