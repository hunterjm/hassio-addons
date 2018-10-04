#!/bin/bash

# Copy over the xbox component
mkdir -p /config/custom_components/media_player
cp -f xboxone.py /config/custom_components/media_player/xboxone.py

# Persistent tokens on reboot
touch /config/.xbox-token.json
mkdir -p /root/.local/share/xbox/
ln -s /config/.xbox-token.json /root/.local/share/xbox/tokens.json


# Run the server
xbox-rest-server
