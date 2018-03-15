#!/bin/bash
echo 
echo "===================================================="
echo "$(date) - Running script";
python /app/PlexCleaner.py --config "/config/Cleaner.conf"; 
echo 