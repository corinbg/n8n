# 🔧 FASE 1: build selettivo
FROM node:22.16 as builder

WORKDIR /app
COPY . .

# Abilita pnpm
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# Installa dipendenze
RUN pnpm install --frozen-lockfile

# 🔨 Compila solo i pacchetti modificati
RUN pnpm --filter @n8n/n8n-nodes-langchain build && \
    pnpm --filter n8n-workflow build && \
    pnpm --filter n8n-core build && \
    pnpm --filter n8n-cli build

# ✅ FASE 2: immagine finale
FROM node:18

# Copia tutto da builder
WORKDIR /app
COPY --from=builder /app /app

# Reimposta pnpm
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

EXPOSE 5678

# Avvia n8n CLI
CMD ["pnpm", "start"]

