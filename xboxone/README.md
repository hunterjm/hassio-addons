# Hass.io Add-on: Xbox One

Xbox One support for Home Assistant

## About

This add-on is a packaged version of the [Xbox One SmartGlass RESTful server](https://github.com/OpenXbox/xbox-smartglass-rest-python) and a Home Assistant [Xbox One custom component](https://github.com/tuxuser/home-assistant-xboxone).  It allows you to easily setup and configure controlling your Xbox from Home Assistant.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add our Hass.io add-ons repository](https://github.com/hunterjm/hassio-addons) to your Hass.io instance.
1. Install the "Xbox One" add-on.
1. Put your Xbox Live account details into the `email`/`password` options.
1. Click the `Save` button to store your credentials.
1. Start the "Xbox One" add-on.
1. Check the logs of the "Xbox One" add-on to see if everything went well.
1. Surf to your Hass.io instance and use port `5557`
    (e.g. `http://hassio.local:5557`).

## Add-on Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
  "email": "name@hass.io",
  "password": "changeme"
}
```

**Note**: _This is just an example, don't copy and past it! Create your own!_

### Option: `email`

The email address you use to login to your Xbox Live account.

### Option: `password`

The password you use to login to your Xbox Live account.

## Home Assistant Configuration

This add-on creates a custom component in your hassio instance.  This component needs to be configured in order to display your Xbox in Home Assistant.  Follow the below steps to get started.

1. Turn on all of the Xboxes you wish to be discovered.
1. View the device list in this plugin: [hassio.local:5557/devices](http://hassio.local:5557/devices)
1. Create the `media_player` configuration using the `liveid` as the value for `device`.
1. Restart Home Assistant to pick up the config change.

Example `configuration.yaml`:

```
media_player:
  - platform: xboxone
    device: FD009374623167E
    name: Living Room Xbox One
```

**Note**: _This is just an example, don't copy and past it! Create your own!_

### Option: `platform`

**Required:** This must be set to `xboxone`

### Option: `device`

The LiveID of your Xbox One.  It can be found in `/devices` endpoint.  Once this addon is up and running [click here](http://hassio.local:5557/devices).

### Option: `name`

The friendly name for this Xbox which will appear in Home Assistant.

## Authors & Contributors

The original setup of this repository is by [Jason Hunter](https://github.com/hunterjm).

Huge shoutout to [Team OpenXbox](https://github.com/openxbox) for reverse engineering the SmartGlass protocol and providing the libraries and server used.

Special thanks to the contributions of [tuxuser](https://github.com/tuxuser) for answering late night questions and doing almost all of the heavy lifting on this.
