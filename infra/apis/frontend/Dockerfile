# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copia package.json
COPY frontend/package*.json ./

# Instala dependências
RUN npm install

# Copia código fonte
COPY frontend/ ./

# Build da aplicação
RUN npm run build

# Stage 2: Production com nginx
FROM nginx:alpine

# Copia build do stage anterior
COPY --from=builder /app/dist /usr/share/nginx/html

# Copia configuração customizada do nginx
COPY infra/apis/frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Expõe porta 80
EXPOSE 80

# Comando padrão do nginx
CMD ["nginx", "-g", "daemon off;"]
