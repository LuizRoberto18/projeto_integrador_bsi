# Estágio 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release

# Estágio 2: Serve com Nginx
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
