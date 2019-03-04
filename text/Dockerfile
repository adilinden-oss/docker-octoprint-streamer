FROM alpine:3.9

MAINTAINER Adi Linden <adi@adis.ca>

RUN apk add --no-cache --update \
        curl \
        jq \
        ttf-freefont \
        ttf-opensans

WORKDIR /text

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["do"]
