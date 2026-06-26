# Backend Docker

Dockerfile multi-stage para a API Backend do Conduit.

## Estrutura

- **Stage 1 (builder)**: Instala dependências
- **Stage 2 (production)**: Imagem final otimizada

## Build local

```bash
docker build -t conduit-backend:latest -f infra/apis/backend/Dockerfile .
```

## Rodar local

```bash
docker run -p 3001:3001 \
  -e DEV_DB_USERNAME=postgres \
  -e DEV_DB_PASSWORD=postgres \
  -e DEV_DB_NAME=conduit_development \
  -e DEV_DB_HOSTNAME=host.docker.internal \
  -e DEV_DB_DIALECT=postgres \
  -e JWT_KEY=supersecretkey \
  conduit-backend:latest
```

## Publicar no Docker Hub

```bash
# Login
docker login

# Tag
docker tag conduit-backend:latest SEU_USUARIO/conduit-backend:latest

# Push
docker push SEU_USUARIO/conduit-backend:latest
```

## Variáveis de ambiente necessárias

- `PORT` - Porta da aplicação (padrão: 3001)
- `JWT_KEY` - Chave secreta para JWT
- `DEV_DB_USERNAME` - Usuário do banco
- `DEV_DB_PASSWORD` - Senha do banco
- `DEV_DB_NAME` - Nome do banco
- `DEV_DB_HOSTNAME` - Host do banco
- `DEV_DB_DIALECT` - Tipo do banco (postgres)
