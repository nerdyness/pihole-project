FROM alpine:latest

ENV API_TOKEN "set me"
ENV DOMAIN "domain.tld"
ENV SUBDOMAIN "home"

RUN apk add --update jq bash curl
WORKDIR "/app"
CMD ["./dynDNS.sh"]

ADD ./dynDNS.sh .
