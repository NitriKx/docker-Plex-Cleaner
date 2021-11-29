#!/bin/bash
echo 
echo "===================================================="
echo "$(date) - Running script";
python3 /app/PlexCleaner.py --config "/config/Cleaner.conf" "$@";
echo 