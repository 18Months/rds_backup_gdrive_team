FROM postgres:14.1-alpine
LABEL maintainer="18Months S.r.l. <dev@18months.it>"

USER root

ENV HOME_DIR /root
ENV INSTALL_RCLONE_VERSION=v1.57.0

RUN apk update \
    && apk add --no-cache \
    coreutils \
    wget \
    ca-certificates \
    bzip2 \
    tzdata

RUN cd /tmp \
    && wget -q https://downloads.rclone.org/$INSTALL_RCLONE_VERSION/rclone-$INSTALL_RCLONE_VERSION-linux-amd64.zip \
    && unzip /tmp/rclone-$INSTALL_RCLONE_VERSION-linux-amd64.zip \
    && cp /tmp/rclone-$INSTALL_RCLONE_VERSION-linux-amd64/rclone /usr/bin \
    && chown root:root /usr/bin/rclone \
    && chmod 755 /usr/bin/rclone \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN mkdir -p \
    /opt/cron/crontabs && \
    touch /var/log/cron.log && \
    touch /var/log/pg_dump.log

COPY scripts/entrypoint.sh /
COPY scripts/pg_dump.sh $HOME_DIR/pg_dump.sh
COPY cron/crontab /opt/cron/crontabs/root
COPY rclone/rclone.conf $HOME_DIR/.config/rclone/rclone.conf
COPY postgresql/pgpass $HOME_DIR/.pgpass

RUN chmod +x /entrypoint.sh \
    && chmod +x $HOME_DIR/pg_dump.sh \
    && chmod 0600 $HOME_DIR/.pgpass

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron"]
