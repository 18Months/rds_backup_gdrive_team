#!/bin/sh

sed -i "s~_RCLONE_REFRESH_TOKEN_~$RCLONE_REFRESH_TOKEN~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_ACCESS_TOKEN_~$RCLONE_ACCESS_TOKEN~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_TEAM_DRIVE_~$RCLONE_TEAM_DRIVE~g" /root/.config/rclone/rclone.conf
sed -i "s~_RCLONE_EXPIRY_~$RCLONE_EXPIRY~g" /root/.config/rclone/rclone.conf

sed -i "s~_PGUSER_~$PGUSER~g" /root/.pgpass
sed -i "s~_PGPASSWORD_~$PGPASSWORD~g" /root/.pgpass

case ${1} in
  shell)
    /bin/sh
    ;;
  cron)
    crond -s /opt/cron/periodic \
      -c /opt/cron/crontabs \
      -t /opt/cron/cronstamps \
      -L /var/log/cron.log \
      -f &
    wait
    ;;
esac
