#!/bin/bash

# Stop Cron
echo "Stopping Cron..."
kill -TERM `cat /run/dcron.pid`

# Stop ApacheDS
echo "Stopping Apacheds..."
bash bin/apacheds.sh stop
