#!/bin/bash

(

# Handle Ctrl-C and stop the container
trap 'exit 0' SIGTERM

# If the config file does not exists, we create one with the sample values
if [ ! -f /config/Cleaner.conf ]; then
    echo "Creating sample config file...";
    # @see https://github.com/ngovil21/Plex-Cleaner/pull/58
    cp /app/Cleaner.conf.default /config/Cleaner.conf
fi

# If the CRON expression has been erased, we execute the script only once
if [ -z "$EXECUTION_CRON_EXPRESSION" ] || [ "$EXECUTION_CRON_EXPRESSION" == "ONCE" ]; then
    echo "Executing the script once..."
    echo /app/run-plexcleaner.sh "$@"
    /app/run-plexcleaner.sh "$@"
    exit 0;
fi

# Create the crontab configuration file 
echo "Registering CRON expression $EXECUTION_CRON_EXPRESSION /app/run-plexcleaner.sh ""$@"" ..."
cat > crontab.tmp << EOF
$EXECUTION_CRON_EXPRESSION /app/run-plexcleaner.sh "$@" | tee -a /logs/plexcleaner.log
# An empty line is required at the end of this file for a valid cron file.
EOF
crontab "crontab.tmp" 
rm -f "crontab.tmp" 

# Run CRON in foreground in order to stream the logs in the docker stdout
/usr/sbin/crond -L /logs/cron.log 

) >> /logs/plexcleaner.log &

# Tail the logs 
tail -n 5000 -f /logs/plexcleaner.log