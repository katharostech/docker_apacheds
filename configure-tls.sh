#!/bin/bash

if [ "$ACME_ENABLED" = "true" ]; then
    echo "ACME Enabled: TLS certificates will be automatically generated and renewed."
    if [ "$ACME_TEST_MODE" = "true" ]; then test_mode="--test"; fi
    acme.sh --issue --dns $ACME_DOMAIN_PROVIDER -d $ACME_DOMAIN $test_mode
    
    # Install Certificates
    acme.sh --install-cert -d $ACME_DOMAIN \
        --fullchain-file /opt/apacheds/fullchain.pem \
        --key-file /opt/apacheds/key.pem \
        --reloadcmd "bash /update-keystore.sh"
fi
