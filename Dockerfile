# Usa Node 22 (necessario per n8n >= 1.110.0)
FROM node:22.2.0 as builder

WORKDIR /app
COPY . .

# Installa pnpm senza usare corepack
RUN npm install -g pnpm@8.15.6

# Installa le dipendenze
RUN pnpm install

# Compila solo i pacchetti modificati
RUN pnpm --filter @n8n/n8n-nodes-langchain build && \
    pnpm --filter n8n-workflow build && \
    pnpm --filter n8n-core build && \
    pnpm --filter n8n-cli build

# Immagine finale, anche qui con Node 22
FROM node:22.2.0
WORKDIR /app
COPY --from=builder /app .

# Installa pnpm anche qui
RUN npm install -g pnpm@8.15.6

CMD ["pnpm", "start"]
