FROM nikolaik/python-nodejs:python3.10-nodejs16-alpine AS builder

WORKDIR /opt
COPY . .

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache git \
    && yarn config set registry https://registry.npmmirror.com \
    && yarn install \
    && yarn docusaurus build

FROM nginx:1.21.6-alpine

COPY --from=builder /opt/build /app/
COPY nginx.conf /etc/nginx/nginx.conf


