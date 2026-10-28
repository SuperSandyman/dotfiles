# dotfiles

NixOS と Home Manager の設定です。

開発用ツールは `profiles/development` の独立した flake で管理しています。

## ホスト

| 機種 | Flakeの指定 | OS / ユーザー設定 |
| --- | --- | --- |
| ThinkPad T14 Gen6 | `#t14g6`（互換名: `#nixos`、`#t14`） | `nixos/hosts/t14g6/`、`home/t14g6.nix`。unstable / Plasma |
| ThinkPad X270 | `#x270` | `nixos/hosts/x270/`、`home/x270.nix`。26.05 Stable / Hyprland |

両方とも `sandyman` を使い、ホスト設定とHome Manager設定は独立しています。
X270の導入、Satelliteの初期化、更新・復旧方法は **[docs/x270.md](docs/x270.md)** を参照してください。
T14の単独Home Manager設定は `homeConfigurations."sandyman@t14g6"`（互換名: `sandyman`）です。
以下の既存セットアップ手順と `profiles/development#default` はT14用です。

## セットアップ

```sh
git clone git@github.com:SuperSandyman/dotfiles.git ~/develop/dotfiles
cd ~/develop/dotfiles

# 先にNixOSのキャッシュ設定を有効化
sudo nixos-rebuild test --flake path:$PWD#t14g6

# 開発ツールはNumtideのバイナリキャッシュを使って導入
nix --accept-flake-config profile add path:$PWD/profiles/development#default

# 適用
sudo nixos-rebuild switch --flake path:$PWD#t14g6
```

## 更新

```sh
cd ~/develop/dotfiles

# システムと開発環境
nix run path:.#update-all
sudo nixos-rebuild switch --flake path:$PWD#t14g6

# システムのみ
nix flake update
sudo nixos-rebuild switch --flake path:$PWD#t14g6

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

Codex は `llm-agents.nix` から導入し、`dev-update` で同リポジトリが提供する最新版に更新します。

## このPCだけの設定

Git管理に含めない追加設定は `local/` に置きます。このディレクトリ全体を `.gitignore` で除外しています。
T14では、存在する場合だけ次のモジュールを読み込みます。

- `local/t14g6-home.nix`: Home Managerの追加設定
- `local/t14g6-system.nix`: NixOSの追加設定

ローカル設定も読み込んで適用する場合は、上記手順のように `--flake path:$PWD#t14g6` を使います。
GitをソースにするFlakeではGit対象外のファイルは含まれません。
新しくcloneした環境ではローカル設定なしでも評価でき、X270はこれらを読み込みません。
`local/` はGitから復元できないため、別途バックアップします。
