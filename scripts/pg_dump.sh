#!/bin/sh

echo "Backup started."

filename=${PG_DATABASE}_$(date +"%Y%m%d%H%M").sql.gz

pg_dump -h $PG_HOST -p $PG_PORT -U $PG_USER -c $PG_DATABASE | gzip > /root/$filename

echo "Backup finished."

echo "Copying backup to GDrive..."
rclone copy /root/$filename remote:/
echo "Backup copied to GDrive."

echo "Deleting tmp backup copy..."
rm /root/$filename

echo "Deleting old backups..."

for x in $(seq $CLEAN_D_START $CLEAN_D_END); do 
  rclone lsf remote:/ | grep ${PG_DATABASE}_$(date --date="${x} days ago" +"%Y%m%d") | xargs -I{} rclone delete remote:/{}
done

echo "Process complete."
