# docker build -t cmcdtqg.fe .
#Stage 1
FROM node:20-alpine AS build-stage
WORKDIR /app
ARG VITE_API_URL
ARG VITE_DES_ENCRYPT_KEY
ENV VITE_API_URL=$VITE_API_URL
ENV VITE_DES_ENCRYPT_KEY=$VITE_DES_ENCRYPT_KEY

COPY package*.json .
COPY yarn*.lock .
RUN yarn install
COPY . .
RUN yarn build

#Stage 2
FROM nginx:1.25-alpine AS run-stage
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]