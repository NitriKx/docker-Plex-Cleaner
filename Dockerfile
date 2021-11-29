FROM alpine:3.15
MAINTAINER Benoît Sauvère <benoit.sauvere@gmail.com>

RUN mkdir /app && mkdir /config && mkdir /plexdata && mkdir /logs && mkdir /etc/cron.d

RUN apk add --no-cache python3 git bash dcron logrotate && git clone https://github.com/ngovil21/Plex-Cleaner.git /app && apk del git && rm -rf /var/cache/apk/*

# Add the scripts 
COPY run-entry.sh /app/run-entry.sh
COPY run-plexcleaner.sh /app/run-plexcleaner.sh
RUN chmod +x /app/run-entry.sh && chmod +x /app/run-plexcleaner.sh

# Add the logrotate configuration
COPY logrotate.conf /etc/logrotate.d/plexcleaner.conf

# Default interval to 5min
ENV EXECUTION_CRON_EXPRESSION */5 * * * *

# REQUIRED
# Store the configuration out of the container
VOLUME ["/config"]

# OPTIONNAL
# In case the script is configured to directly delete the files, we need to mount the plex data folder
VOLUME ["/plexdata"]

# OPTIONNAL
# Contains the execution logs 
VOLUME ["/logs"]

ENTRYPOINT ["/app/run-entry.sh"]
