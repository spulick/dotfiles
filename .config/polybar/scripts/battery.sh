#!/bin/sh

# Get acpiconf info for the first battery
BATTERY_INFO=$(acpiconf -i 0)

# Extract percentage and state
PERCENT=$(echo "$BATTERY_INFO" | grep -E 'Remaining capacity' | awk '{print $3}' | tr -d '%')
STATE=$(echo "$BATTERY_INFO" | grep -E 'State' | awk '{print $2}')

# Set icons or colors based on state
if [ "$STATE" = "charging" ]; then
    ICON=""
else
    ICON=""
fi

echo "$ICON $PERCENT%"
