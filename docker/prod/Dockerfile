# Stage 1: Build
FROM node:20-alpine AS build-stage

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Production
FROM nginx:alpine AS production-stage

# Copy custom nginx config
COPY docker/prod/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets from build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
