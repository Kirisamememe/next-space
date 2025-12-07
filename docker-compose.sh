#!/bin/bash

# Docker Composeヘルパースクリプト
# .env.developmentまたは.env.productionから環境変数を読み込んでdocker composeを実行

set -e

ENV=${ENV:-development}
ENV_FILE=".env.${ENV}"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: ${ENV_FILE} not found"
  exit 1
fi

# .envファイルから環境変数をエクスポート（コメントと空行を除外）
# 行頭の#と、行内の#以降のコメントを除外し、空行も除外
while IFS= read -r line; do
  # 空行をスキップ
  [[ -z "$line" ]] && continue
  # 行頭が#の行をスキップ
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  # 行内の#以降を削除（ただし、値の中の#は保持）
  # シンプルに、=の後の#以降を削除する
  line=$(echo "$line" | sed 's/\([^=]*=.*\)#.*/\1/' | sed 's/[[:space:]]*$//')
  # 空になった行をスキップ
  [[ -z "$line" ]] && continue
  export "$line"
done < "$ENV_FILE"

# docker composeコマンドを実行
docker compose "$@"

