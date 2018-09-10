#!/bin/sh

# Trap SIGTERM and SIGINT
trap 'bash bin/apacheds.sh stop; exit $?' TERM INT

# Start the container
bash bin/apacheds.sh start

# Wait for signal
while true; do sleep 1; done
