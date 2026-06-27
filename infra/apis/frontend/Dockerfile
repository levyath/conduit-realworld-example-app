# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Build arg para API URL (não usado mais, proxy no nginx)
ARG VITE_API_URL=http://localhost:3001/api
ENV VITE_API_URL=$VITE_API_URL

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

# Expõe porta 3000
EXPOSE 3000

# Comando padrão do nginx
CMD ["nginx", "-g", "daemon off;"]
