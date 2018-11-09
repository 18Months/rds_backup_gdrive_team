#!/bin/sh

echo "Backup started."

filename=${PG_DATABASE}_$(date +"%Y%m%d").sql.gz
obsolete_filename=${PG_DATABASE}_$(date --date="5 days ago" +"%Y%m%d").sql.gz

pg_dump -h $PG_HOST -p $PG_PORT -U $PG_USER -c $PG_DATABASE | gzip > /root/$filename

echo "Backup finished."

echo "Copying backup to GDrive."

rclone copy /root/$filename remote:/ -vv
rclone delete remote:/$obsolete_filename -vv
rm /root/$filename

echo "Backup copied to GDrive."
