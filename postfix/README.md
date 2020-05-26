# Home Assistant Add-on: Postfix Mail Forwarder

A simple email forwarding service.

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

## About

Sets up a postfix server to host a simple email forwarding service. This is typically used to setup and forward email from a domain you own to your primary email address.

Make sure you have generated a certificate before you start this add-on. The [LetsEncrypt][letsencrypt] add-on can generate a Let's Encrypt certificate that can be used by this add-on. Please ensure that your mail `domain` is covered by the certificate.

You will also need to setup an `MX` record for your domain and forward ports `25` and `587` in your router. If you are seeing `Connect Time Out` in the logs, your ISP has likely blocked outbound port 25 on their end. You will need to contact them to remove the block.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[letsencrypt]: https://github.com/home-assistant/hassio-addons/tree/master/letsencrypt
