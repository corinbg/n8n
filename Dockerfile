# Sintesi problema
# Render sta fallendo su `pnpm install` con errori legati a script di lifecycle falliti, non a dipendenze mancanti.
# Anche senza `--frozen-lockfile` fallisce, quindi va fatto un workaround più avanzato.

# 🔧 Soluzione stabile e definitiva
# 1. Usa Node 20.x nel Dockerfile
# 2. Disabilita script "postinstall" o fallback temporanei
# 3. Costruisci solo i pacchetti modificati per evitare errori su benchmark/dev

# --- Dockerfile ---

FROM node:20.11.1 AS builder

# Imposta la directory di lavoro
WORKDIR /app

# Copia tutto
COPY . .

# Abilita Corepack e PNPM
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# Installa solo le dipendenze necessarie
RUN pnpm install --no-optional --ignore-scripts

# 🔨 Compila solo i pacchetti essenziali
RUN pnpm --filter @n8n/n8n-nodes-langchain build && \
    pnpm --filter n8n-nodes-base build && \
    pnpm --filter n8n-workflow build && \
    pnpm --filter n8n-core build

# --- STAGE finale ---
FROM node:20.11.1

WORKDIR /app
COPY --from=builder /app .

# Abilita pnpm
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# Avvia n8n
CMD ["pnpm", "start"]
