#!/bin/sh
set -e
set -x

if [ "$(grep -ci "${CUPS_USER_ADMIN}" /etc/shadow)" -eq 0 ]; then
    adduser -S -G lpadmin --no-create-home "${CUPS_USER_ADMIN}"
fi

echo "${CUPS_USER_ADMIN}:${CUPS_USER_PASSWORD}" | chpasswd

cat <<EOF
===========================================================
The dockerized CUPS instance is now ready for use! The web
interface is available here:
URL:       https://<docker host>:631/
Username:  ${CUPS_USER_ADMIN}
Password:  ${CUPS_USER_PASSWORD}
===========================================================
EOF

touch /config/cupsd.conf

### Start AVAHI instance ###
exec /usr/sbin/avahi-daemon -D

### Start CUPS instance ###
exec /usr/sbin/cupsd -f -c /config/cupsd.conf