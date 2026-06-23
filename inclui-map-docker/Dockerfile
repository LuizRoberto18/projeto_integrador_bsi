FROM nginx:alpine

# Remove a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Injeta a nossa configuração de proxy reverso
COPY nginx.conf /etc/nginx/conf.d/

EXPOSE 80
