#!/bin/bash

# Run the docker by linking a test script instead of the Plex-Cleaner script. This script will print the parameters it receives and so we can determine if 
# the parameters forwarding is working

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# STEP 1
# Test if the parameters are correctly passed in the single execution mode
echo "Testing parameters forwarding in single execution mode..."
SINGLE_EXECUTION_RESULT=$(docker run --rm -e "EXECUTION_CRON_EXPRESSION=ONCE" -v "${SCRIPT_PATH}/print-parameters.py:/app/PlexCleaner.py" "nitrikx/plex-cleaner:latest" --foo bar)

SINGLE_EXECUTION_RESULT_GREP=$(echo "$SINGLE_EXECUTION_RESULT" | grep "'--foo', 'bar'")
if [ -z "${SINGLE_EXECUTION_RESULT_GREP}" ]; then
    echo "[FAIL] The parameters are not forwarded in single execution mode"
    exit 20;
else 
	echo "[OK]   The parameters are forwarded in single execution mode"
fi

# STEP 2
# Test if the parameters are correctly passed in the cron execution mode
echo "Testing parameters forwarding in CRON mode..."
CRON_EXECUTION_DOCKER_ID=$(docker run -d --rm -e "EXECUTION_CRON_EXPRESSION=* * * * *" -v "${SCRIPT_PATH}/print-parameters.py:/app/PlexCleaner.py" "nitrikx/plex-cleaner:latest" --foo bar)

# Wait 1 min to be sure that the script has been executed at least one time
echo "Waiting 1min (to let enough time to CRON to execute the script)..."
sleep 60

# Get the logs and terminate the container 
echo "Getting logs and terminating container..."
CRON_EXECUTION_RESULT=$(docker logs ${CRON_EXECUTION_DOCKER_ID})
docker stop $CRON_EXECUTION_DOCKER_ID -t 0

CRON_EXECUTION_RESULT_GREP=$(echo "$CRON_EXECUTION_RESULT" | grep "'--foo', 'bar'")
if [ -z "${CRON_EXECUTION_RESULT_GREP}" ]; then
    echo "[FAIL] The parameters are not forwarded in CRON execution mode"
    exit 21;
else 
	echo "[OK]   The parameters are forwarded in CRON execution mode"
fi
