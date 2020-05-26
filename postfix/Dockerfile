ARG BUILD_FROM
FROM $BUILD_FROM

# Install postfix
WORKDIR /usr/src
RUN apk add --no-cache \
        cyrus-sasl \
        cyrus-sasl-plain \
        openssl \
        postfix \
        syslog-ng

# Configure service
RUN cat /dev/null > /etc/postfix/aliases && newaliases \
    && echo test | saslpasswd2 -p test@test.com \
    && chown postfix /etc/sasl2/sasldb2 \
    && saslpasswd2 -d test@test.com

COPY rootfs /