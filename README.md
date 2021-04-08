## RDS Backup to Google Team Drive

This repo contains the Docker image that will capture a RDS Postgres Database backup in production and upload it to a Google Team Drive.

### Running the container

The container needs to be run in the background to capture and replace rclone environment variables into the `rclone.conf` file.
Cron rule backup runs everyday at hour and minute defined in CRON_H and CRON_M variables.
Set timezone in TZ format as listed here [Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
Set CLEAN_D_START and CLEAN_D_END for backup cleanup, process will delete backup files older than CLEAN_D_START, but newer than CLEAN_D_END.

```
$ docker run -d --restart unless-stopped \
  --name rds_backup_gdrive_team \
  -e "RCLONE_REFRESH_TOKEN=<RCLONE_REFRESH_TOKEN>" \
  -e "RCLONE_TEAM_DRIVE=<RCLONE_TEAM_DRIVE>" \
  -e "RCLONE_EXPIRY=<RCLONE_EXPIRY>" \
  -e "RCLONE_ACCESS_TOKEN=<RCLONE_ACCESS_TOKEN>" \
  -e "PG_HOST=<your_postgres_host>" \
  -e "PG_PORT=<your_postgres_port>" \
  -e "PG_USER=<your_postgres_username>" \
  -e "PG_DATABASE=<your_postgres_database>" \
  -e "PG_PASSWORD=<your_postgres_password>" \
  -e "TIMEZONE=UTC" \
  -e "CRON_H=0" \
  -e "CRON_M=0" \
  -e "CLEAN_D_START=5" \
  -e "CLEAN_D_END=10" \
  eighteenmonths/rds_backup_gdrive_team:latest
```
