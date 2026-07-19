# dotfiles

NixOS環境を、更新目的の異なる2つのflakeで管理します。

| グループ | 場所 | 内容 |
| --- | --- | --- |
| システム | リポジトリ直下 | NixOS、KDE、Home Manager、フォント、Ghostty、ユーザー設定 |
| 開発環境 | `profiles/development` | VSCode、Neovim、ランタイム、LSP、CLI、AI agent |

それぞれ独立した`flake.lock`を持つため、OSを固定したまま開発環境だけを更新
できます。

## 構成

```text
flake.nix
flake.lock
home.nix
nixos/
├── hosts/nixos/
│   ├── default.nix
│   └── hardware-configuration.nix
├── modules/
│   ├── base.nix
│   └── desktop.nix
└── nix-storage.nix
profiles/
└── development/
    ├── flake.nix
    ├── flake.lock
    └── packages/
```

開発環境には次のものをまとめています。

- VSCode、Neovim
- Node.js、pnpm、Erlang、Elixir、Rust、Cargo、GCC
- language server、formatter、ripgrepなどの開発CLI
- Herdr、Codex、Copilot CLI、OpenCode、Pi、GitHub CLI

miseとMasonにはランタイム、エディタ、LSPをインストールさせません。

## 新規環境への導入

```sh
git clone git@github.com:SuperSandyman/dotfiles.git ~/develop/dotfiles
cd ~/develop/dotfiles

nix profile add path:$PWD/profiles/development#default

sudo nixos-rebuild test --flake path:$PWD#nixos
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

最初に`test`で一時的に有効化し、デスクトップ、ネットワーク、シェルを確認して
から`switch`します。Home ManagerもNixOS moduleとして統合されているため、
`switch`でホーム設定まで反映されます。

既存の`/etc/nixos`は移行確認用のバックアップとして残して構いません。以後は
このリポジトリを直接rebuild対象にします。

## 旧3 profileからの移行

以前の`fast-cli`、`dev-tools`、`runtimes`を導入済みの場合は、一度だけ統合
profileへ置き換えます。

```sh
cd ~/develop/dotfiles
nix profile remove fast-cli dev-tools runtimes
nix profile add path:$PWD/profiles/development#default
```

## まとめて更新

システムと開発環境の両方を更新し、開発環境profileへ反映します。

```sh
cd ~/develop/dotfiles
nix run path:.#update-all
```

差分とsystem closureを確認してから、NixOSとHome Managerを反映します。

```sh
git diff -- flake.lock profiles/development/flake.lock
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

`update-all`自体はroot権限を要求せず、`nixos-rebuild`も実行しません。

## 個別更新

システム側だけ:

```sh
cd ~/develop/dotfiles
nix flake update
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

開発環境側だけ:

```sh
cd ~/develop/dotfiles
nix flake update --flake ./profiles/development
nix profile upgrade development
```

## `/nix`の容量対策

`nixos/nix-storage.nix`はホスト設定から常に読み込まれます。週次で14日より
古い世代をGCし、storeを自動最適化し、空き容量低下時のGC閾値と
systemd-bootの保持世代数を設定します。

## Codexデータの扱い

Codexの認証、履歴、セッション、キャッシュ、組み込み`.system` skillsは管理対象外
です。Codex設定の雛形は設定が存在しない場合にだけ配置し、Codex Desktopから
更新できる状態を維持します。
