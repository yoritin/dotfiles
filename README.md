# Dotfiles

このリポジトリには、私の開発環境の設定ファイル（dotfiles）が含まれています。これらの設定ファイルを使用することで、新しい環境を素早くセットアップし、一貫した開発環境を維持することができます。

## 含まれるファイル

- `.zshrc`: Zshシェルの設定
- `.gitconfig`: Gitの全体設定
- `.vimrc`: Vimエディタの設定

## 前提条件

- Git
- Zsh
- Vim

## インストール

1. このリポジトリをクローンします：

   ```bash
   git clone https://github.com/yoritin/dotfiles.git ~/dotfiles
   ```

2. インストールスクリプトに実行権限を付与します：

   ```bash
   chmod +x ~/dotfiles/install.sh
   ```

3. インストールスクリプトを実行します：

   ```bash
   ~/dotfiles/install.sh
   ```

## カスタマイズ

### .gitconfig

`.gitconfig`ファイルには、ユーザー名とメールアドレスのプレースホルダーが含まれています。これらは環境変数を使用してカスタマイズできます。

1. 以下の環境変数を設定します（例：`~/.zshrc`に追加）：

   ```bash
   export GIT_USER_NAME="Your Name"
   export GIT_USER_EMAIL="your.email@example.com"
   export GITHUB_USER="your_github_username"
   ```

2. 環境変数を読み込みます：

   ```bash
   source ~/.zshrc
   ```

3. インストールスクリプトを再実行します。

## 注意事項

- インストールスクリプトは、既存のdotfilesのバックアップを作成します。
- 複数回実行しても安全です。既存の正しい設定は維持されます。

## 貢献

問題の報告やプルリクエストは大歓迎です。大きな変更を加える前には、まずissueを開いて議論してください。

## ライセンス

[MITライセンス](LICENSE)
