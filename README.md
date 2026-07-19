# dotfiles

NixOSとHome ManagerをNix flakesで管理する個人環境です。OSからユーザー設定
までroot flakeで構成し、更新周期が異なるCLIとランタイムは別flake・別
`flake.lock`に分離しています。

| 管理単位 | 場所 | 内容 |
| --- | --- | --- |
| NixOS + Home Manager | リポジトリ直下 | OS、KDE、シェル、エディタ、フォント、GUI設定 |
| 高速更新CLI | `profiles/fast-cli` | Herdr、Codex、Copilot CLI、OpenCode、Pi、ghなど |
| 開発ツール | `profiles/dev-tools` | LSP、formatter、ripgrepなど |
| ランタイム | `profiles/runtimes` | Node.js、pnpm、Erlang、Elixir、Rust、GCC |

各サブflakeは独立したlock fileを持ちます。たとえば高速更新CLIを更新しても、
Home Manager、開発ツール、ランタイムのlock fileは変わりません。

## 構成

```text
flake.nix
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
├── fast-cli/
├── dev-tools/
└── runtimes/
```

`nixos/hosts/nixos`はこのマシン固有のhostname、filesystem UUID、
hardware設定を持ちます。再利用可能なOS設定は`nixos/modules`に分離しています。

## 新規環境への初回導入

```sh
git clone https://github.com/SuperSandyman/dotfiles.git ~/develop/dotfiles
cd ~/develop/dotfiles

nix profile add path:$PWD/profiles/fast-cli#default
nix profile add path:$PWD/profiles/dev-tools#default
nix profile add path:$PWD/profiles/runtimes#default

sudo nixos-rebuild test --flake path:$PWD#nixos
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

最初に`test`で一時的に有効化し、デスクトップ・ネットワーク・シェルを確認して
から`switch`します。Home ManagerもNixOS moduleとして統合されているため、
`switch`でホーム設定まで反映されます。

既存の`/etc/nixos`は移行確認用のバックアップとして残して構いません。以後は
このリポジトリを直接rebuild対象にするため、`/etc/nixos`の設定は更新しません。

miseとMasonにはランタイムやLSPをインストールさせません。これらは独立した
Nix profileから提供します。

## まとめて更新

root、fast-cli、dev-tools、runtimesの4つのlock fileと、3つのユーザーprofileを
まとめて更新します。

```sh
cd ~/develop/dotfiles
nix run path:.#update-all
```

更新差分とbuildを確認してから、NixOSとHome Managerを同時に反映します。

```sh
git diff -- flake.lock profiles/*/flake.lock
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake path:$PWD#nixos
```

`update-all`自体はroot権限を要求せず、`nixos-rebuild`も実行しません。

## グループごとの独立更新

高速更新CLIだけ:

```sh
cd ~/develop/dotfiles
nix flake update --flake ./profiles/fast-cli
nix profile upgrade fast-cli
```

開発ツールだけ:

```sh
cd ~/develop/dotfiles
nix flake update --flake ./profiles/dev-tools
nix profile upgrade dev-tools
```

ランタイムだけ:

```sh
cd ~/develop/dotfiles
nix flake update --flake ./profiles/runtimes
nix profile upgrade runtimes
```

更新前にビルドだけ確認したい場合は、対象に対して
`nix build ./profiles/fast-cli`のように実行します。

rootのnixpkgsとHome Managerだけを更新する場合は、rootで
`nix flake update`してからrebuildします。

## `/nix`の容量対策

`nixos/nix-storage.nix`はホスト設定から常に読み込まれます。週次で14日より
古い世代をGCし、storeを自動最適化し、空き容量低下時のGC閾値と
systemd-bootの保持世代数を設定します。

## Codexデータの扱い

Codexの認証、履歴、セッション、キャッシュ、組み込み`.system` skillsは管理対象外
です。Codex設定の雛形は設定が存在しない場合にだけ配置し、Codex Desktopから
更新できる状態を維持します。
