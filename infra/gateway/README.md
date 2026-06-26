# API Gateway - Nginx

Gateway de API usando Nginx para rotear requisições entre frontend e backend.

## Arquitetura

```
Cliente
   ↓
Gateway (Nginx:80)
   ├── /api/*  → Backend (Express:3001)
   └── /*      → Frontend (React:80)
```

## Rotas

- **`/api/*`** → Roteado para o Backend (Express.js na porta 3001)
- **`/*`** → Roteado para o Frontend (React na porta 80)
- **`/health`** → Health check do gateway

## Executar localmente com Docker Compose

### 1. Build e iniciar todos os serviços

```bash
cd infra/gateway
docker-compose up --build
```

### 2. Acessar a aplicação

- **Gateway**: http://localhost
- **Frontend**: http://localhost (através do gateway)
- **Backend API**: http://localhost/api (através do gateway)
- **Health check**: http://localhost/health

### 3. Testar rotas

```bash
# Health check do gateway
curl http://localhost/health

# Listar artigos (via gateway)
curl http://localhost/api/articles

# Frontend (via gateway)
curl http://localhost/
```

### 4. Parar serviços

```bash
docker-compose down
```

## Build apenas do gateway

```bash
# Na raiz do projeto
docker build -t conduit-gateway -f infra/gateway/Dockerfile .
```

## Configuração

A configuração do Nginx está em `nginx.conf` e define:

- Upstream do backend (porta 3001)
- Upstream do frontend (porta 80)
- Proxy pass para rotas `/api/*`
- Proxy pass para demais rotas
- Headers de proxy (X-Real-IP, X-Forwarded-For, etc.)
- Timeouts configurados

## Logs

Os logs do Nginx ficam em:
- Access log: `/var/log/nginx/access.log`
- Error log: `/var/log/nginx/error.log`

Para ver os logs:

```bash
docker-compose logs -f gateway
```

## Variáveis de ambiente

O docker-compose configura as seguintes variáveis:

### Backend
- `PORT=3001`
- `JWT_KEY=supersecretkey`
- `DEV_DB_*` - Configurações do banco

### PostgreSQL
- `POSTGRES_DB=conduit_development`
- `POSTGRES_USER=postgres`
- `POSTGRES_PASSWORD=postgres`

## Volumes

- `postgres-data` - Dados persistentes do PostgreSQL

## Rede

Todos os serviços estão na mesma rede `conduit-network` para comunicação interna.
