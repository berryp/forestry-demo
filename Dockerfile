FROM alpine:3.7 as BUILD

ENV HUGO_VERSION=0.37.1

RUN apk add --update ca-certificates wget && \
    wget "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar -xf "hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    ./hugo version

FROM nginx:1.13-alpine

COPY --from=BUILD hugo /usr/local/bin
COPY . /app
RUN hugo -s /app -d /usr/share/nginx/html

EXPOSE 80
