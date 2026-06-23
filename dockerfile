# Estágio 1: Build
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copia apenas o pubspec para aproveitar cache de dependências
COPY pubspec.yaml ./
RUN flutter pub get

# Copia o restante do projeto
COPY . .

RUN flutter build web --release

# Estágio 2: Serve com Nginx
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
