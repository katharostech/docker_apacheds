#!/bin/bash

echo "Updating Apache Keystore..."
openssl pkcs12 -export \
    -in /opt/apacheds/fullchain.pem \
    -inkey /opt/apacheds/key.pem \
    -out /opt/apacheds/instances/default/conf/apacheds.p12 \
    -password pass:$ACME_KEYSTORE_PASSWORD

echo "Certificate installed to: /opt/apacheds/instances/default/conf/apacheds.p12"

if [ -f /opt/apacheds/instances/default/run/apacheds.pid ]; then
    echo "Restarting ApacheDS to load certificate change:"
    echo "Stopping ApacheDS..."
    bash /opt/apacheds/bin/apacheds.sh stop

    echo "Starting ApacheDS..."
    bash /opt/apacheds/bin/apacheds.sh start
fi
