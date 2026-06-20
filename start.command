#!/bin/bash
# CrisisConnect — local launcher.
# Double-click this file (macOS) to run the app on localhost, where GPS/location works.
# (Opening index.html directly via file:// blocks browser geolocation — this fixes that.)

cd "$(dirname "$0")" || exit 1
PORT=8123

# Free the port if a previous run is still holding it
lsof -ti:"$PORT" 2>/dev/null | xargs kill 2>/dev/null

echo "CrisisConnect is running at:  http://localhost:$PORT/index.html"
echo "Keep this window open. Press Ctrl+C to stop."
( sleep 1 && open "http://localhost:$PORT/index.html" ) &
python3 -m http.server "$PORT" --bind 127.0.0.1
