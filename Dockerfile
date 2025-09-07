FROM node:20.16

WORKDIR /app

COPY . .

# Abilita corepack e installa pnpm 10.12.1 manualmente (evita bug)
RUN corepack enable
RUN npm install -g pnpm@10.12.1


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
