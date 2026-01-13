#!/bin/bash

# バックアップディレクトリの確認
BACKUP_BASE="$HOME/.dotfiles_backup"

if [ ! -d "$BACKUP_BASE" ]; then
    echo "エラー: バックアップディレクトリが見つかりません: $BACKUP_BASE"
    exit 1
fi

# バックアップの一覧を表示
echo "=== 利用可能なバックアップ ==="
backups=($(ls -1t "$BACKUP_BASE" 2>/dev/null))

if [ ${#backups[@]} -eq 0 ]; then
    echo "バックアップが見つかりません。"
    exit 1
fi

for i in "${!backups[@]}"; do
    echo "[$i] ${backups[$i]}"
done

# バックアップを選択
echo ""
echo -n "復元するバックアップの番号を入力してください: "
read -r selection

if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -ge ${#backups[@]} ]; then
    echo "エラー: 無効な番号です。"
    exit 1
fi

SELECTED_BACKUP="${backups[$selection]}"
BACKUP_DIR="$BACKUP_BASE/$SELECTED_BACKUP"

echo ""
echo "選択されたバックアップ: $SELECTED_BACKUP"
echo "バックアップディレクトリ: $BACKUP_DIR"
echo ""

# バックアップの内容を表示
echo "=== バックアップの内容 ==="
ls -lh "$BACKUP_DIR"
echo ""

# 確認
echo "このバックアップから復元しますか? (yes/N)"
read -r confirm

if [[ ! "$confirm" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "復元をキャンセルしました。"
    exit 0
fi

echo ""
echo "=== 復元を開始します ==="

# 復元関数
restore_file() {
    local backup_file="$1"
    local filename=$(basename "$backup_file")
    local target_file="$HOME/$filename"
    
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        rm -f "$target_file"
        echo "既存の $filename を削除しました"
    fi
    
    cp "$backup_file" "$target_file"
    echo "✓ $filename を復元しました"
}

# 復元関数（ディレクトリ用）
restore_dir() {
    local backup_dir="$1"
    local dirname=$(basename "$backup_dir")
    local target_dir="$HOME/$dirname"
    
    if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
        rm -rf "$target_dir"
        echo "既存の $dirname を削除しました"
    fi
    
    cp -r "$backup_dir" "$target_dir"
    echo "✓ $dirname を復元しました"
}

# dotfilesの復元
for file in "$BACKUP_DIR"/.zshrc "$BACKUP_DIR"/.gitconfig "$BACKUP_DIR"/.vimrc; do
    if [ -f "$file" ]; then
        restore_file "$file"
    fi
done

# .configディレクトリの復元
if [ -d "$BACKUP_DIR/.config.git" ]; then
    mkdir -p "$HOME/.config"
    if [ -e "$HOME/.config/git" ] || [ -L "$HOME/.config/git" ]; then
        rm -rf "$HOME/.config/git"
        echo "既存の .config/git を削除しました"
    fi
    cp -r "$BACKUP_DIR/.config.git" "$HOME/.config/git"
    echo "✓ .config/git を復元しました"
fi

# VS Code設定の復元
vscode_backup="$BACKUP_DIR/settings.json"
vscode_target="$HOME/Library/Application Support/Code/User/settings.json"

if [ -f "$vscode_backup" ]; then
    echo ""
    echo "VS Code設定のバックアップが見つかりました。"
    echo "復元しますか? (y/N)"
    read -r vscode_confirm
    
    if [[ "$vscode_confirm" =~ ^[Yy]$ ]]; then
        if [ -f "$vscode_target" ]; then
            rm "$vscode_target"
            echo "既存の VS Code設定を削除しました"
        fi
        cp "$vscode_backup" "$vscode_target"
        echo "✓ VS Code設定を復元しました"
    fi
fi

echo ""
echo "========================================"
echo "復元が完了しました"
echo "========================================"
echo ""
echo "シェルを再起動するか、以下のコマンドを実行して設定を反映してください:"
echo "  source ~/.zshrc"
