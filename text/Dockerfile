FROM alpine:3.9

MAINTAINER Adi Linden <adi@adis.ca>

RUN apk add --no-cache \
        curl \
        jq

WORKDIR /text

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["do"]
