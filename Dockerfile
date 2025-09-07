# Usa immagine base Node + PNPM
FROM node:20.11.1

WORKDIR /app

COPY . .

# ⚠️ Assicura la giusta versione di pnpm
RUN corepack enable && corepack prepare pnpm@10.12.1 --activate

# 🧹 Installa tutto (senza eseguire postinstall script potenzialmente rotti)
RUN pnpm install --frozen-lockfile --ignore-scripts --no-optional

# 🛠️ Compila TUTTO il monorepo
RUN pnpm build
