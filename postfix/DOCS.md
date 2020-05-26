# Home Assistant Add-on: Postfix Mail Forwarder

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Click <ha-icon icon="mdi:dots-vertical"></ha-icon> -> **Repositories**
3. Add `https://github.com/hunterjm/hassio-addons`
4. Find the "Postfix Mail Forwarder" add-on and click it.
5. Click on the "INSTALL" button.

## How to use

The Postfix Mail Forwarder add-on is commonly used in conjunction with the [LetsEncrypt][letsencrypt] add-on to set up email forwarding for a custom domain. The following instructions covers this scenario.

1. Create an `MX` record in your DNS provider for your mail server to use. **i.e.** `mail.mydomain.com`. This domain should also resolve to your IP via an `A` record or `CNAME`.
2. The certificate to your `MX` domain should already be created via the [LetsEncrypt][letsencrypt] add-on or another method. Make sure that the certificate files exist in the `/ssl` directory.
3. Change the `domain` option to the domain name in your `MX` record.
4. Configure your forwarding preferences.
5. Save configuration.
6. Start the add-on.
7. Have some patience and wait a minute.
8. Check the add-on log output to see the result.

## Configuration

Add-on configuration:

```yaml
forward:
  - from: testi@testo.com
    password: test
    to:
      - myemail@gmail.com
domain: mail.testo.com
certfile: fullchain.pem
keyfile: privkey.pem
```

### Option `forward.from` (required)

The email address on your domain that you wish to forward to your other email address(es).

### Option `forward.password` (required)

The password to use for SASL authentication. A common use case is setting this up as an alias in Gmail to be able to send messages from this domain.

### Option `forward.to` (required)

The email address(es) that this addon should forward mail to.

### Option: `domain` (required)

The domain name to use for the mail service.

### Option: `certfile` (required)

The certificate file to use in the `/ssl` directory. Keep filename as-is if you used default settings to create the certificate with the [LetsEncrypt][letsencrypt] add-on.

### Option: `keyfile` (required)

Private key file to use in the `/ssl` directory.

## Known issues and limitations

- Many residential ISPs block outbound traffic on port 25 by default. In that case, you will likely see a `Connect Time Out` message in the logs. You may be able to contact your ISP to remove this block.
- Some email service providers require a `PTR` record for reverse DNS lookup. Your residential ISP may not provide one for dynamically assigned IP addresses. These emails will bounce.
- Gmail may not deliver messages to the user's inbox unless the `forward.from` domain is also configured as an alias. [This article][gmail] will walk you through setting that up.

## Support

In case you've found a bug, please [open an issue on our GitHub][issue].

[letsencrypt]: https://github.com/home-assistant/hassio-addons/tree/master/letsencrypt
[issue]: https://github.com/hunterjm/hassio-addons/issues
[gmail]: https://support.google.com/mail/answer/22370?hl=en
