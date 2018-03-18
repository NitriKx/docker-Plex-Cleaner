#!/bin/bash

# Handle Ctrl-C and stop the container
trap 'exit 0' SIGTERM | tee -a /logs/plexcleaner.log

# If the config file does not exists, we create one with the sample values
if [ ! -f /config/Cleaner.conf ]; then
    echo "Creating sample config file..." | tee -a /logs/plexcleaner.log
    # @see https://github.com/ngovil21/Plex-Cleaner/pull/58
    cp /app/Cleaner.conf.default /config/Cleaner.conf | tee -a /logs/plexcleaner.log
fi

# If the CRON expression has been erased, we execute the script only once
if [ -z "$EXECUTION_CRON_EXPRESSION" ] || [ "$EXECUTION_CRON_EXPRESSION" == "ONCE" ]; then
    echo "Executing the script once..." | tee -a /logs/plexcleaner.log
    echo /app/run-plexcleaner.sh "$@" | tee -a /logs/plexcleaner.log
    /app/run-plexcleaner.sh "$@" | tee -a /logs/plexcleaner.log
    exit 0;

else
    # Create the crontab configuration file 
    echo "Registering CRON expression $EXECUTION_CRON_EXPRESSION /app/run-plexcleaner.sh ""$@"" ..." >> /logs/plexcleaner.log
    cat > crontab.tmp << EOF
$EXECUTION_CRON_EXPRESSION /app/run-plexcleaner.sh $@ | tee -a /logs/plexcleaner.log
# An empty line is required at the end of this file for a valid cron file.
EOF
    crontab "crontab.tmp" 
    rm -f "crontab.tmp" 

    # Run CRON in background
    /usr/sbin/crond -L /logs/cron.log

    # Tail the logs 
    tail -n 5000 -f /logs/plexcleaner.log
fi
