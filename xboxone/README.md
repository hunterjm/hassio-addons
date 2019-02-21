# Hass.io Add-on: Xbox One

Xbox One support for Home Assistant

## About

This add-on is a packaged version of the [Xbox One SmartGlass RESTful server](https://github.com/OpenXbox/xbox-smartglass-rest-python) and a Home Assistant [Xbox One custom component](https://github.com/tuxuser/home-assistant-xboxone).  It allows you to easily setup and configure controlling your Xbox from Home Assistant.

## Features

This component replicates many of the features of the Xbox App.  If it can't be done there, it can't be done here.

- Power On/Off
- Display name and image of current Game/App
  - Requires auth with Xbox Live
- Media Controls: Play/Pause & Seek
  - Supported apps only
- Volume Controls: Up/Down/Mute
  - Requires `Device Control` to be cofigured in `Settings` on the Xbox
- Source Selection: Launch Pinned Apps from within Home Assistant
  - Apps only, Games not supported

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add our Hass.io add-ons repository](https://github.com/hunterjm/hassio-addons) to your Hass.io instance.
2. Install the "Xbox One" add-on.
3. Start the "Xbox One" add-on.
4. Check the logs of the "Xbox One" add-on to see if everything went well.
5. Surf to your Hass.io instance and use port `5557`
    (e.g. `http://hassio.local:5557`).
6. Authenticate with Xbox Live by going to [/auth/oauth](http://hassio.local:5557/auth/oauth)
    and following the directions.
    
## Manual Installation
1. Enter your home assistant python virtual-environment.
2. Execute `pip install xbox-smartglass-rest`.
3. Create a service to autostart the server (e.g. for Systemd).
4. Enable / start the service.
5. Copy `xboxone.py` to `<hass config path>/custom_components/media_player/xboxone.py`.
6. Proceed with __Installation__ step 5.

### Systemd service example

File location: `/etc/systemd/system/xbox-smartglass-rest@homeassistant.service`

__NOTE:__ This assumes running the service as user `homeassistant`.
If you want to run the server with a different user, change
the filename to: `xbox-smartglass-rest@<username>.service`!

Edit `ExecStart` to your needs!

```
#
# Service file for systems with systemd to run Xbox One SmartGlass REST server.
#

[Unit]
Description=Xbox One SmartGlass REST for %i
After=network.target

[Service]
Type=simple
User=%i
ExecStart=/path/to/bin/inside/venv/xbox-rest-server
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
```

## Home Assistant Configuration

This add-on creates a custom component in your hassio instance.  This component needs to be configured in order to display your Xbox in Home Assistant.  Follow the below steps to get started.

1. Turn on all of the Xboxes you wish to be discovered.
1. View the device list in this plugin: [hassio.local:5557/device](http://hassio.local:5557/device)
1. Create the `media_player` configuration using the `liveid` as the value for `device`.
1. Restart Home Assistant to pick up the config change.

Example `configuration.yaml`:

```
media_player:
  - platform: xboxone
    device: FD009374623167E
    name: Living Room Xbox One
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `platform`

**Required:** This must be set to `xboxone`

### Option: `device`

The LiveID of your Xbox One.  It can be found in `/device` endpoint.  Once this addon is up and running [click here](http://hassio.local:5557/device).

### Option: `ip_address`

The IP Address of your Xbox One.  Useful if your xbox lives on a separate subnet.

### Option: `name`

The friendly name for this Xbox which will appear in Home Assistant.

### Option: `authentication`

**Default:** `true`

Set to `false` if you have multiple consoles on your network and have issues with getting signed out.  Future features may require an authenticated connection with the console.

**Note:** _This refers to an authenticated connection with the console.  You will still need to [authenticate with Xbox Live](http://hassio.local:5557/auth/oauth) to have the most useful features enabled (i.e. Friendly app names, images, and Source selection)._

## Authors & Contributors

The original setup of this repository is by [Jason Hunter](https://github.com/hunterjm).

Huge shoutout to [Team OpenXbox](https://github.com/openxbox) for reverse engineering the SmartGlass protocol and providing the libraries and server used.

Special thanks to the contributions of [tuxuser](https://github.com/tuxuser) for answering late night questions and doing almost all of the heavy lifting on this.
