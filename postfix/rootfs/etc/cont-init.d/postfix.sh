#!/usr/bin/with-contenv bashio

# Ensures the postfix data is stored outside the container
if ! bashio::fs.directory_exists '/data/postfix'; then
    mkdir -p /data/postfix
fi

DHPARAMS_PATH=/data/dhparams.pem
SNAKEOIL_CERT=/data/ssl-cert-snakeoil.pem
SNAKEOIL_KEY=/data/ssl-cert-snakeoil.key

DOMAIN=$(bashio::config 'domain')
CERTFILE="/ssl/$(bashio::config 'certfile')"
KEYFILE="/ssl/$(bashio::config 'keyfile')"

# Create snakeoil cert if invalid certificate passed in
if ! bashio::fs.file_exists "${CERTFILE}"; then
    # Generate dhparams
    if ! bashio::fs.file_exists "${DHPARAMS_PATH}"; then
        bashio::log.info  "Generating dhparams (this will take some time)..."
        openssl dhparam -dsaparam -out "$DHPARAMS_PATH" 4096 > /dev/null
    fi

    # Generate certificate
    if ! bashio::fs.file_exists "${SNAKEOIL_CERT}"; then
        bashio::log.info "Creating 'snakeoil' self-signed certificate..."
        openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout $SNAKEOIL_KEY -out $SNAKEOIL_CERT -subj '/CN=localhost'
    fi

    CERTFILE=$SNAKEOIL_CERT
    KEYFILE=$SNAKEOIL_KEY
fi

# Prepare config file
sed -i "s~%%FULLCHAIN%%~$CERTFILE~g" /etc/postfix/main.cf
sed -i "s~%%PRIVKEY%%~$KEYFILE~g" /etc/postfix/main.cf

#
# Set virtual user maping
#
bashio::log.info "Creating SMTP users..."

NEWLINE=$'\n'

forwardList=$(bashio::config 'forward')

virtualDomains=""
virtualUsers=""

password='' # global variable for save password in the next for loop.

for forward in $(bashio::config "forward|keys"); do
    emailFrom=$(bashio::config "forward[${forward}].from")
    emailToArr=$(bashio::config "forward[${forward}].to")
    emailTo=$(printf "\t%s" "${emailToArr[@]}")
    emailTo=${emailTo:1}
    password=$(bashio::config "forward[${forward}].password")

    bashio::log.info "Configuring user $emailFrom..."
    echo $password | saslpasswd2 $emailFrom

    newLine=$(printf '%s\t%s' $emailFrom "$emailTo")
    virtualUsers="${virtualUsers}${newLine}${NEWLINE}"

    domainFrom=${emailFrom##*@}

    [[ $virtualDomains =~ $domainFrom ]] || {
        virtualDomains="$virtualDomains $domainFrom"
    }
done

# Forward all other emails to the original domain
for virtualDomain in $virtualDomains; do
    virtualUsers="${virtualUsers}@${virtualDomain} @${virtualDomain} $NEWLINE"
done

echo "$virtualUsers"  > /etc/postfix/virtual

postconf -e relay_domains="$virtualDomains"
postconf -e virtual_alias_maps="hash:/etc/postfix/virtual"

# initial user database
postmap /etc/postfix/virtual

# add domain
bashio::log.info "Set hostname to $DOMAIN..."
postconf -e myhostname="$DOMAIN"
postconf -e mydestination="localhost"
echo "$DOMAIN" > /etc/mailname
echo "$DOMAIN" > /etc/hostname

# if [ "$MYNETWORKS" != "" ]
# then
#     postconf -e mynetworks="$MYNETWORKS"
# fi

# if [ "$RELAYHOST" != "" ]
# then
#     postconf -e relayhost="$RELAYHOST"
# fi

# if [ "$RELAYAUTH" != "" ]
# then
#     echo "$RELAYHOST   $RELAYAUTH" > /etc/postfix/sasl_passwd
#     postmap /etc/postfix/sasl_passwd
#     postconf -e smtp_use_tls=yes
#     postconf -e smtp_sasl_auth_enable=yes
#     postconf -e smtp_sasl_security_options=
#     postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
#     postconf -e smtp_tls_CAfile=/etc/ssl/certs/ca-certificates.crt
# fi

postfix start

bashio::log.info "Finished configuring postfix"
