# esabird.nvim

Neovim で選択したテキストを [esa.io](https://esa.io/) に送信するためのシンプルなプラグインです。

リポジトリ: [hirokiyoshino/esabird.nvim](https://github.com/hirokiyoshino/esabird.nvim)

## 機能

-   ビジュアルモードで選択したテキストを esa.io の新しい投稿として送信します。
-   投稿は WIP (Work In Progress) として作成されます。

## インストール

お好みのプラグインマネージャーを使用してください。

### lazy.nvim

```lua
{
  'hirokiyoshino/esabird.nvim',
  config = function()
    -- 設定 (下記参照)
    vim.g.esabird_api_token = os.getenv("ESA_API_TOKEN") -- 環境変数から読み込む例
    vim.g.esabird_team_name = "your-team-name"

    -- キーマッピングの例 (Visual モード)
    vim.keymap.set('v', '<leader>es', require('esabird').send_to_esa, { desc = 'Send selection to esa.io' })
  end,
}
```

## 設定

以下のグローバル変数を Neovim の設定ファイル (`init.lua` など) で設定してください。

-   `vim.g.esabird_api_token`: esa.io の API トークン。 [個人用アクセストークン](https://docs.esa.io/posts/102) を生成して設定します。セキュリティのため、環境変数などから読み込むことを推奨します。
-   `vim.g.esabird_team_name`: あなたの esa.io チーム名 (例: `your-team-name.esa.io` の `your-team-name` の部分)。

```lua
-- init.lua の例
vim.g.esabird_api_token = "YOUR_ESA_API_TOKEN" -- または os.getenv("ESA_API_TOKEN")
vim.g.esabird_team_name = "your-team-name"
```

## 使用方法

1.  Neovim でテキストをビジュアルモード (`v`, `V`) で選択します。
2.  設定したキーマッピング（例: `<leader>es`）を押すか、コマンド `:lua require('esabird').send_to_esa()` を実行します。
3.  成功すると、通知が表示され、作成された投稿の URL が表示されます。

## 注意事項

-   ブロック選択 (`<C-v>`) は現在サポートされていません。
-   エラーが発生した場合、Neovim の通知エリアにメッセージが表示されます。

## ライセンス

MIT