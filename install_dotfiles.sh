#!/bin/bash

# ドットファイルのディレクトリを設定
DOTFILES_DIR="$HOME/dotfiles"

# インストールするファイルのリスト
DOTFILES=(".zshrc" ".gitconfig" ".vimrc")

# バックアップ作成関数
create_backup() {
    local file=$1
    local backup_file="${file}.backup"
    local count=1

    # 既存のバックアップファイルがある場合、番号を付けて新しいバックアップを作成
    while [ -e "$backup_file" ]; do
        backup_file="${file}.backup.${count}"
        count=$((count + 1))
    done

    mv "$file" "$backup_file"
    echo "既存の $file をバックアップしました: $backup_file"
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

# メイン処理
echo "ドットファイルインストーラーを開始します"

for file in "${DOTFILES[@]}"; do
    install_dotfile "$file"
done

echo "インストールが完了しました"
