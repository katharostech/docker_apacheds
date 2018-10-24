#!/bin/sh

# Trap SIGTERM and SIGINT
trap 'bash /stop-container.sh; exit $?' TERM INT

# Configure TLS
bash /configure-tls.sh

# Start Cron
crond

# Start ApacheDS
bash bin/apacheds.sh start

# Tail logs
while [ ! -f instances/default/log/apacheds.out ]; do sleep 1; done
tail -f instances/default/log/apacheds.out &

# Wait for signal
while true; do sleep 1; done
