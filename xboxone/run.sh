#!/bin/bash

# Copy over the xbox component
mkdir -p /config/custom_components/media_player
cp -f xboxone.py /config/custom_components/media_player/xboxone.py

# Run the server
xbox-rest-server