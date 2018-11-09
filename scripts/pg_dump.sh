#!/bin/sh

echo "Backup started."

filename=${PGDATABASE}_$(date +"%Y%m%d").sql.gz
obsolete_filename=${PGDATABASE}_$(date --date="5 days ago" +"%Y%m%d").sql.gz

pg_dump -h $PGHOST -p $PGPORT -U $PGUSER -c $PGDATABASE | gzip > /root/$filename

echo "Backup finished."

echo "Copying backup to GDrive."

rclone copy /root/$filename remote:/ -vv
rclone delete remote:/$obsolete_filename -vv
rm /root/$filename

echo "Backup copied to GDrive."
