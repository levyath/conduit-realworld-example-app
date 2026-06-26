# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copia apenas os arquivos de dependências primeiro
COPY backend/package*.json ./

# Instala dependências
RUN npm install --omit=dev

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app

# Cria usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copia dependências do stage anterior
COPY --from=builder /app/node_modules ./node_modules

# Copia código da aplicação
COPY backend/ ./

# Define variáveis de ambiente padrão
ENV NODE_ENV=production
ENV PORT=3001

# Muda para usuário não-root
USER nodejs

# Expõe a porta da aplicação
EXPOSE 3001

# Comando para iniciar a aplicação
CMD ["node", "index.js"]
