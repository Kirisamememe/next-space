# 依存関係のインストールステージ
FROM node:24-alpine AS deps
WORKDIR /app

# パッケージマネージャーのファイルをコピー
COPY package.json package-lock.json* ./
RUN npm ci

# ビルドステージ
FROM node:24-alpine AS builder
WORKDIR /app

# 依存関係をコピー
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 環境変数をビルド時に使用
ARG NEXT_PUBLIC_APP_URL
ENV NEXT_PUBLIC_APP_URL=$NEXT_PUBLIC_APP_URL

# Next.jsをビルド
RUN npm run build

# 本番実行ステージ
FROM node:24-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# ヘルスチェック用にwgetをインストール
RUN apk add --no-cache wget

# 必要なファイルのみをコピー
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# 非rootユーザーを作成
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]

