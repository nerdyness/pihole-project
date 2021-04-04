FROM alpine:latest

RUN apk add --update bash aws-cli bind-tools
WORKDIR "/app"
CMD ["./dynDNS.sh"]

ADD ./dynDNS.sh .

ENV DDNS_ROUTE53_ZONE_ID "aws-route53-hosted-zone-id"
ENV DDNS_ROUTE53_RECORD_SET "subdomain.domain.tld without trailing dot"
ENV AWS_ACCESS_KEY_ID "set me"
ENV AWS_SECRET_ACCESS_KEY "set me"
ENV AWS_DEFAULT_REGION "set me"
