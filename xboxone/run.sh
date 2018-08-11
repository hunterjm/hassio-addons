#!/bin/bash
CONFIG_PATH=/data/options.json

# Copy over the xbox component
mkdir -p /config/custom_components/media_player
cp -f xboxone.py /config/custom_components/media_player/xboxone.py

EMAIL=$(jq --raw-output ".email" $CONFIG_PATH)
PASSWORD=$(jq --raw-output ".password" $CONFIG_PATH)

xbox-authenticate --email "$EMAIL" --password "$PASSWORD"
xbox-rest-server