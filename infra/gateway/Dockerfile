FROM nginx:alpine

# Remove configuração padrão
RUN rm /etc/nginx/conf.d/default.conf

# Copia configuração customizada
COPY infra/gateway/nginx.conf /etc/nginx/conf.d/default.conf

# Expõe porta 80
EXPOSE 80

# Comando padrão do nginx
CMD ["nginx", "-g", "daemon off;"]
