# Reader Nvim

A Neovim setup tuned for reading documents and code.

## まず使うキー

- `<Space>`: キーグループを表示
- `<Space>?`: チートシートを開く
- `<Space>f`: ファイルを探す
- `<Space>g`: 文字列を検索
- `<Space>e`: エクスプローラーを表示
- `<Space>o`: ドキュメントアウトライン
- `<Space>z`: 集中モード
- `<Space>mr`: Markdown 表示を切り替え
- `<Space>w`: 折り返しを切り替え

## GitHub PR レビュー

事前に `gh auth login` で GitHub CLI にログインしておく。

- `<Space>pP`: 自分にレビュー依頼が来ている PR を開く
- `<Space>pp`: 現在のリポジトリの PR 一覧
- `<Space>po`: 現在のブランチに対応する PR を開く
- `<Space>px`: PR を checkout
- `<Space>pr`: PR レビューを開始
- `<Space>pc`: 保留中のレビューコメント一覧
- `<Space>ps`: レビューを送信
- `<Space>pb`: PR のチェック結果を表示
- `<Space>pu`: PR をブラウザで開く

レビュー画面では `<Space>c` でコメント、Visual 選択して `<Space>s` で suggestion、`]t` / `[t` でスレッド移動、`<Space>rs` でレビュー送信。

## LSP / 補完

- `gd`: 定義へ移動
- `gr`: 参照を表示
- `K`: ホバー情報
- `<Space>ca`: コードアクション
- `<Space>cf`: コード整形
- `<Space>rn`: 名前を変更
- `<C-Space>`: 補完を表示
- `<C-y>`: 補完候補を確定

## Explorer

- `Up` / `Down`: ファイル間を移動
- `Enter` / `Right`: ファイルまたはディレクトリを開く
- `Left`: ディレクトリを閉じる
- `Backspace`: 親ディレクトリへ移動
- `q`: エクスプローラーを閉じる
- `I`: gitignore 対象の表示を切り替え
- `H`: dotfile の表示を切り替え

The previous configuration was moved to a timestamped `~/.config/nvim.bak-*` directory.
