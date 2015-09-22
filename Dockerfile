FROM alpine

MAINTAINER Aleksandr Chazov <develop@chazer.ru>

RUN /sbin/apk update \
 && /sbin/apk add alpine-sdk autoconf cmake openssl-dev \
 && /sbin/apk add php-dev \
 && /sbin/apk add git \
 && rm -rf /var/cache/apk/*

ADD ./main.sh /

VOLUME ["/build"]

ENTRYPOINT ["/main.sh"]
