FROM node:20.16

WORKDIR /app

COPY . .

# Abilita corepack e pnpm 10.12.1 (coerente col lockfile)
RUN corepack enable && corepack prepare pnpm@10.12.1 --activate

# Installa dipendenze
RUN pnpm install --frozen-lockfile

# 🔧 Fixa l'errore di rollup aggiungendo manualmente i moduli opzionali
RUN pnpm add -w \
  @rollup/rollup-linux-x64-gnu \
  @rollup/rollup-linux-x64-musl \
  @rollup/rollup-linux-arm64-gnu \
  @rollup/rollup-linux-arm64-musl

# Compila tutto il progetto
RUN pnpm build
