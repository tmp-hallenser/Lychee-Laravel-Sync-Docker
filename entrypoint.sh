#!/bin/sh

echo "**** Starting the Entrypoint Script ****"
set -e

echo "**** Make sure the /uploads folders exist ****"
[ ! -f /uploads ] && \
	mkdir -p /uploads
[ ! -f /import ] && \
	mkdir -p /import

cd /home/lycheesync

echo "**** Updating python script ****"
git pull origin lychee-laravel

echo "**** Create config file from environment variables ****"
echo "{" > conf.json
echo "	\"db\":\"$DB_DATABASE\", " >> conf.json
echo "	\"dbUser\":\"$DB_USERNAME\", " >> conf.json
echo "	\"dbPassword\":\"$DB_PASSWORD\", " >> conf.json
echo "	\"dbHost\":\"$DB_HOST\", " >> conf.json
echo "	\"thumbQuality\":80, " >> conf.json
echo "	\"publicAlbum\": 0, " >> conf.json
echo "	\"excludeAlbums\": [ " >> conf.json
echo "			\"$EXCLUDE_ALBUM_PATH1\", " >> conf.json
echo "			\"$EXCLUDE_ALBUM_PATH2\", " >> conf.json
echo "			\"$EXCLUDE_ALBUM_PATH3\"  " >> conf.json
echo "	] " >> conf.json
echo "} " >> conf.json

echo "**** Setup complete, starting the lync script. ****"
python3 -m lycheesync.sync /import / conf.json
exec $@

