# Étape 1 : Build de l'app
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build

# Étape 2 : Serveur Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
