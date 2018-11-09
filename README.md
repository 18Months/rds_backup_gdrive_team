## RDS Backup to Google Team Drive

This repo contains the Docker image that will capture a RDS Postgres Database backup in production and upload it to a Google Team Drive.

### Installing and configuring [rclone](https://rclone.org)

```
$ cd ~/tmp
$ wget -q https://downloads.rclone.org/v1.38/rclone-v1.38-linux-amd64.zip
$ unzip ~/tmp/rclone-v1.38-linux-amd64.zip
$ cp ~/tmp/rclone-v1.38-linux-amd64/rclone /usr/local/bin
$ rclone config
```

**Please only select `RDS Backups` Team Drive.**

When the configuration process is finished, a file will be generated in this location: `~/.config/rclone/rclone.conf`
The file will look like this:

```
[remote]
type = drive
scope = drive
token = {"access_token":"<RCLONE_ACCESS_TOKEN>","token_type":"Bearer","refresh_token":"<RCLONE_REFRESH_TOKEN>","expiry":"<RCLONE_EXPIRY>"}
team_drive = <RCLONE_TEAM_DRIVE>
```

Extract the following environment variables from that file:

- RCLONE_REFRESH_TOKEN
- RCLONE_ACCESS_TOKEN
- RCLONE_EXPIRY
- RCLONE_TEAM_DRIVE

These are some of the environment variables you will need to pass to the Docker run command.

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
