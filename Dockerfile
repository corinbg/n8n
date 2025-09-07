# Usa Node 20 stabile (viene gestito bene da n8n)
FROM node:20 as builder

# Crea directory di lavoro
WORKDIR /app

# Copia tutto il codice
COPY . .

# Abilita corepack e installa direttamente pnpm (senza firme)
RUN corepack enable


# Installa le dipendenze
RUN pnpm install --frozen-lockfile

# 🔨 Compila solo i pacchetti modificati
RUN pnpm --filter @n8n/n8n-nodes-langchain build && \
    pnpm --filter n8n-workflow build && \
    pnpm --filter n8n-core build && \
    pnpm --filter n8n-cli build

# Secondo stage: immagine finale
FROM node:20

WORKDIR /app

# Copia i file compilati
COPY --from=builder /app .

# Abilita corepack e installa pnpm anche nel runtime (per sicurezza)
RUN corepack enable && npm install -g pnpm@10.12.1

# Avvia n8n
CMD ["pnpm", "start"]
