#!/bin/sh

cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "$TIMEZONE" > /etc/timezone

sed -i "s~_RCLONE_REFRESH_TOKEN_~$RCLONE_REFRESH_TOKEN~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_ACCESS_TOKEN_~$RCLONE_ACCESS_TOKEN~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_TEAM_DRIVE_~$RCLONE_TEAM_DRIVE~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_EXPIRY_~$RCLONE_EXPIRY~g" /root/.config/rclone/rclone.conf

sed -i "s~_PG_USER_~$PG_USER~g" /root/.pgpass
sed -i "s~_PG_PASSWORD_~$PG_PASSWORD~g" /root/.pgpass

sed -i "s~_CRON_H_~$CRON_H~g" /opt/cron/crontabs/root
sed -i "s~_CRON_M_~$CRON_M~g" /opt/cron/crontabs/root

case ${1} in
  shell)
    /bin/sh
    ;;
  cron)
    crond -c /opt/cron/crontabs \
      -L /var/log/cron.log \
      -l 6 \
      -f &
    wait
    ;;
esac
