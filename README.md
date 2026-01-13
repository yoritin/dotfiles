# Dotfiles

このリポジトリには、私の開発環境の設定ファイル（dotfiles）が含まれています。これらの設定ファイルを使用することで、新しい環境を素早くセットアップし、一貫した開発環境を維持することができます。

## 含まれるファイル

- `.zshrc`: Zshシェルの設定
- `.gitconfig`: Gitの全体設定
- `.vimrc`: Vimエディタの設定
- `.config/git/ignore`: グローバルなgitignore設定（XDG Base Directory仕様準拠）
- `setting.json`: VS Codeの設定ファイル

## 前提条件

- Git
- Zsh
- Vim

## インストール

1. このリポジトリをクローンします：

   ```bash
   git clone https://github.com/yoritin/dotfiles.git ~/repositories/dotfiles
   ```

2. インストールスクリプトに実行権限を付与します：

   ```bash
   chmod +x ~/repositories/dotfiles/install_dotfiles.sh
   ```

3. インストールスクリプトを実行します：

   ```bash
   ~/repositories/dotfiles/install_dotfiles.sh
   ```

   スクリプトは自動的に以下を行います：
   - 既存のdotfilesをバックアップ
   - dotfilesのシンボリックリンクを作成
   - VS Code設定のインストールを確認（オプション）

## カスタマイズ

### Git設定

インストールスクリプトを実行する際に、Gitのユーザー名、メールアドレス、GitHubユーザー名を設定できます。スクリプトが対話的にプロンプトを表示しますので、指示に従ってください。

手動で設定する場合は以下のコマンドを使用します：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global github.user "your_github_username"
```

### VS Code設定

インストールスクリプトを実行する際に、VS Codeの設定ファイル（setting.json）をインストールするか選択できます。既存の設定ファイルがある場合は、自動的にバックアップされます。

## 注意事項

- インストールスクリプトは、既存のdotfilesを `~/.dotfiles_backup/日時/` ディレクトリにバックアップします。
- 新しい設定に問題がなければ、バックアップディレクトリは手動で削除できます。
- 複数回実行しても安全です。既存の正しい設定は維持されます。

### バックアップの管理

**確認:**
```bash
ls -la ~/.dotfiles_backup/
```

**削除:**
```bash
# 特定のバックアップを削除
rm -rf ~/.dotfiles_backup/20260114_123456/

# すべてのバックアップを削除
rm -rf ~/.dotfiles_backup/
```

**復元:**

新しい設定に問題があった場合、バックアップから復元できます：

```bash
# 復元スクリプトを実行
~/repositories/dotfiles/restore_dotfiles.sh
```

復元スクリプトは以下を行います：
1. 利用可能なバックアップの一覧を表示
2. 復元するバックアップを選択
3. バックアップの内容を確認
4. 現在の設定ファイルを削除してバックアップから復元

手動で復元する場合：

```bash
# バックアップから直接コピー（例: 20260114_123456 のバックアップを使用）
rm ~/.zshrc ~/.gitconfig ~/.vimrc
rm -rf ~/.config/git

cp ~/.dotfiles_backup/20260114_123456/.zshrc ~/
cp ~/.dotfiles_backup/20260114_123456/.gitconfig ~/
cp ~/.dotfiles_backup/20260114_123456/.vimrc ~/
cp -r ~/.dotfiles_backup/20260114_123456/.config.git ~/.config/git
```

## 貢献

問題の報告やプルリクエストは大歓迎です。大きな変更を加える前には、まずissueを開いて議論してください。

## ライセンス

[MITライセンス](LICENSE)
