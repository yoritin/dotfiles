#!/bin/bash

# ドットファイルのディレクトリを設定（このスクリプトがあるディレクトリを使用）
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# インストールするファイルのリスト
DOTFILES=(".zshrc" ".gitconfig" ".vimrc")
CONFIG_DIRS=(".config/git")

# バックアップディレクトリの設定
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
BACKUP_CREATED=false

# バックアップ作成関数
create_backup() {
    local file=$1
    local filename=$(basename "$file")
    
    # バックアップディレクトリを初回のみ作成
    if [ "$BACKUP_CREATED" = false ]; then
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=true
    fi
    
    local backup_file="$BACKUP_DIR/$filename"
    
    # 同名ファイルがある場合は番号を付ける
    if [ -e "$backup_file" ]; then
        local count=1
        while [ -e "$BACKUP_DIR/${filename}.${count}" ]; do
            count=$((count + 1))
        done
        backup_file="$BACKUP_DIR/${filename}.${count}"
    fi
    
    mv "$file" "$backup_file"
    echo "  → バックアップ: $(basename "$backup_file")"
}

# インストール関数
install_dotfile() {
    local file=$1
    local source_file="$DOTFILES_DIR/$file"
    local target_file="$HOME/$file"

    if [ -f "$source_file" ]; then
        if [ -f "$target_file" ]; then
            if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
                echo "$file は既にシンボリックリンクされています。スキップします。"
            else
                create_backup "$target_file"
                ln -sf "$source_file" "$target_file"
                echo "$file のシンボリックリンクを作成しました"
            fi
        else
            ln -s "$source_file" "$target_file"
            echo "$file のシンボリックリンクを作成しました"
        fi
    else
        echo "警告: $source_file が見つかりません。スキップします。"
    fi
}

# .configディレクトリのインストール関数
install_config_dir() {
    local dir=$1
    local source_dir="$DOTFILES_DIR/$dir"
    local target_dir="$HOME/$dir"

    if [ -d "$source_dir" ]; then
        mkdir -p "$(dirname "$target_dir")"
        
        if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
            create_backup "$target_dir"
        fi
        
        if [ -L "$target_dir" ] && [ "$(readlink "$target_dir")" = "$source_dir" ]; then
            echo "$dir は既にシンボリックリンクされています。スキップします。"
        else
            ln -snf "$source_dir" "$target_dir"
            echo "$dir のシンボリックリンクを作成しました"
        fi
    else
        echo "警告: $source_dir が見つかりません。スキップします。"
    fi
}

# Git設定のカスタマイズ
configure_git() {
    echo ""
    echo "=== Git設定のカスタマイズ ==="
    
    # 既存の設定を確認
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")
    current_github=$(git config --global github.user 2>/dev/null || echo "")
    
    # 名前の設定
    if [ -n "$current_name" ]; then
        echo "現在のGitユーザー名: $current_name"
        echo "変更しますか? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Gitユーザー名を入力してください:"
            read -r git_name
            git config --global user.name "$git_name"
        fi
    else
        echo "Gitユーザー名を入力してください:"
        read -r git_name
        git config --global user.name "$git_name"
    fi
    
    # メールの設定
    if [ -n "$current_email" ]; then
        echo "現在のGitメールアドレス: $current_email"
        echo "変更しますか? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Gitメールアドレスを入力してください:"
            read -r git_email
            git config --global user.email "$git_email"
        fi
    else
        echo "Gitメールアドレスを入力してください:"
        read -r git_email
        git config --global user.email "$git_email"
    fi
    
    # GitHubユーザー名の設定
    if [ -n "$current_github" ]; then
        echo "現在のGitHubユーザー名: $current_github"
        echo "変更しますか? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "GitHubユーザー名を入力してください:"
            read -r github_user
            git config --global github.user "$github_user"
        fi
    else
        echo "GitHubユーザー名を入力してください (スキップする場合は空Enter):"
        read -r github_user
        if [ -n "$github_user" ]; then
            git config --global github.user "$github_user"
        fi
    fi
    
    echo "Git設定が完了しました"
}

# VS Code設定ファイルのインストール
install_vscode_settings() {
    local source_file="$DOTFILES_DIR/setting.json"
    local vscode_settings_dir="$HOME/Library/Application Support/Code/User"
    local target_file="$vscode_settings_dir/settings.json"

    if [ -f "$source_file" ]; then
        if [ ! -d "$vscode_settings_dir" ]; then
            echo "VS Codeの設定ディレクトリが見つかりません。スキップします。"
            return
        fi

        if [ -f "$target_file" ]; then
            create_backup "$target_file"
        fi
        
        cp "$source_file" "$target_file"
        echo "VS Codeの設定ファイルをコピーしました"
    else
        echo "警告: $source_file が見つかりません。スキップします。"
    fi
}

# メイン処理
echo "ドットファイルインストーラーを開始します"
echo "インストール元: $DOTFILES_DIR"

for file in "${DOTFILES[@]}"; do
    install_dotfile "$file"
done

echo ""
for dir in "${CONFIG_DIRS[@]}"; do
    install_config_dir "$dir"
done

echo ""
echo "VS Codeの設定をインストールしますか? (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    install_vscode_settings
fi

echo ""
echo "Git設定をカスタマイズしますか? (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    configure_git
fi

echo ""
echo "========================================"
echo "インストールが完了しました"
echo "========================================"

# バックアップが作成された場合は通知
if [ "$BACKUP_CREATED" = true ]; then
    echo ""
    echo "既存の設定ファイルをバックアップしました:"
    echo "  $BACKUP_DIR"
    echo ""
    echo "新しい設定に問題がなければ、以下のコマンドでバックアップを削除できます:"
    echo "  rm -rf $BACKUP_DIR"
    echo ""
    echo "すべてのバックアップを確認するには:"
    echo "  ls -la ~/.dotfiles_backup/"
fi
