This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

## 開発方法の選択

このプロジェクトでは、2つの開発方法を選択できます：

### 方法1: ローカル開発（`npm run dev`） - **推奨**

**メリット：**

- ✅ **ホットリロードが速い** - ファイル変更が即座に反映される
- ✅ **デバッグが簡単** - ローカルの開発ツールがそのまま使える
- ✅ **起動が速い** - Dockerイメージのビルドが不要
- ✅ **開発体験が良い** - Next.jsの開発サーバーの機能をフル活用

**デメリット：**

- ❌ ローカルにNode.jsが必要
- ❌ 環境の違いによる問題が発生する可能性

**推奨する人：**

- 日常的な開発作業を行う人
- 高速な開発サイクルを重視する人
- Dockerに慣れていない人

### 方法2: Docker Composeで開発

**メリット：**

- ✅ **本番環境に近い** - デプロイ環境と同じ環境で開発できる
- ✅ **環境の一貫性** - チーム全員が同じ環境で開発できる
- ✅ **セットアップが簡単** - Node.jsをローカルにインストールする必要がない

**デメリット：**

- ❌ **ホットリロードが遅い** - ファイル変更の反映に時間がかかる
- ❌ **ビルド時間** - 初回起動やコード変更時にビルドが必要
- ❌ **デバッグが複雑** - コンテナ内でのデバッグが必要

**推奨する人：**

- 本番環境との整合性を重視する人
- Dockerに慣れている人
- CI/CDパイプラインのテストを行う人

### 推奨される開発フロー

**日常的な開発：**

```bash
# 1. データベースのみDockerで起動
ENV=development ./docker-compose.sh up -d db

# 2. Next.jsはローカルで起動（npm run dev）
npm run dev
```

**本番環境のテストやデプロイ前の確認：**

```bash
# Docker Composeで全体を起動
ENV=development ./docker-compose.sh up
```

---

### Dockerでの実行

このアプリケーションはDocker Composeを使用して完全にDocker化されています。

#### 1. 環境変数の設定

環境に応じて適切な`.env`ファイルを作成してください：

**開発環境の場合：**

```bash
cp .env.development.example .env.development
```

**本番環境の場合：**

```bash
cp .env.production.example .env.production
```

その後、作成した`.env`ファイル内の値を必要に応じて変更してください。

#### 2. Docker Composeでアプリケーションを起動

**重要**: `compose.yaml`では環境変数ファイル（`.env.development`など）から値を読み込むため、`docker compose`コマンドを実行する前に環境変数をエクスポートする必要があります。

**方法1: ヘルパースクリプトを使用（推奨）**

```bash
# 開発環境で起動
ENV=development ./docker-compose.sh up -d

# 本番環境で起動
ENV=production ./docker-compose.sh up -d

# その他のdocker composeコマンドも使用可能
ENV=development ./docker-compose.sh logs -f
ENV=development ./docker-compose.sh down
```

**方法2: 環境変数を手動でエクスポート**

```bash
# 開発環境で起動
export $(cat .env.development | grep -v '^#' | xargs) && docker compose up -d

# 本番環境で起動
export $(cat .env.production | grep -v '^#' | xargs) && docker compose up -d
```

**ログを確認：**

```bash
docker compose logs -f app
```

**停止：**

```bash
docker compose down
```

**データベースのボリュームも含めて完全に削除：**

```bash
docker compose down -v
```

#### 3. アプリケーションにアクセス

- アプリケーション: http://localhost:3456（デフォルト、`APP_PORT`環境変数で変更可能）
- データベース: localhost:5433（ローカルのPostgreSQLと競合しないように）

### ローカル開発（推奨）

#### 1. 環境変数の設定

`.env.local.example`をコピーして`.env.local`を作成してください：

```bash
cp .env.local.example .env.local
```

`.env.local`ファイル内の`DATABASE_URL`は、Docker Compose内のサービス名ではなく`localhost`を使用するように設定されています：

```
DATABASE_URL=postgresql://root:mysecretpassword@localhost:5433/local
```

#### 2. Dockerでデータベースのみ起動

```bash
ENV=development ./docker-compose.sh up -d db
```

データベースはポート5433で起動します（ローカルのPostgreSQLと競合しないように）。

#### 3. 開発サーバーの起動

別のターミナルで：

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

ブラウザで [http://localhost:3456](http://localhost:3456) を開いてください。

ファイルを編集すると、ページが自動的に更新されます（Fast Refresh）。

## 環境変数の管理

このプロジェクトでは、環境別に環境変数ファイルを管理します：

### 環境変数ファイルの優先順位

Docker Composeでは、以下の順序で環境変数ファイルが読み込まれます（後のファイルが前のファイルの値を上書きします）：

1. `.env.local` - ローカル開発用（gitignoreに含まれる、**最優先**）
2. `.env.development` / `.env.production` - 環境別設定（gitignoreに含まれる）

### ファイルの説明

- `.env.local` - ローカル開発用の個人設定（gitignoreに含まれる、コミットされない）
- `.env.development` - 開発環境用（gitignoreに含まれる）
- `.env.production` - 本番環境用（gitignoreに含まれる）
- `.env.local.example` - ローカル開発用のテンプレート（コミット可能）
- `.env.development.example` - 開発環境用のテンプレート（コミット可能）
- `.env.production.example` - 本番環境用のテンプレート（コミット可能）

### 使用方法

**ローカル開発の場合：**

```bash
cp .env.local.example .env.local
# .env.localを編集して個人の設定を追加
```

**Docker Composeでの起動：**

```bash
ENV=development docker compose up -d  # 開発環境（.env.local → .env.development の順で読み込み）
ENV=production docker compose up -d  # 本番環境（.env.local → .env.production の順で読み込み）
```

### ポートについて

- **ローカル開発時（`npm run dev`）**: ポート3456で起動（`package.json`で指定）
- **Docker実行時**: デフォルトでポート3456で起動（`APP_PORT`環境変数で変更可能）
  - コンテナ内では3000で動作し、ホスト側の3456にマッピングされます

## Learn More

To learn more about Next.js, look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
