#!/bin/bash

# Define directories
SNAPSHOT_DIR="/Users/poonersumith/Desktop/meaningful-reading-order/snapshots"
APP_ACCESS_DIR="/Users/poonersumith/Documents/app-accessibility/lib/bstack_rule_engine"
OUTPUT_DIR="/Users/poonersumith/Desktop/meaningful-reading-order/focus_order"
LOG_FILE="/Users/poonersumith/Documents/app-accessibility/log/development.log"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Process each snapshot
for snapshot_file in "$SNAPSHOT_DIR"/snapshot_*.json; do
    if [ ! -f "$snapshot_file" ]; then
        echo "No snapshot files found"
        exit 1
    fi
    
    # Extract the snapshot ID from filename
    filename=$(basename "$snapshot_file")
    snapshot_id=$(echo "$filename" | sed -E 's/snapshot_([0-9]+)\.json/\1/')
    
    echo "Processing snapshot $snapshot_id..."
    
    # Check if the file contains a success wrapper
    if grep -q '"success": *true' "$snapshot_file"; then
        # Extract just the data part if wrapped in success object
        if command -v jq &> /dev/null; then
            jq '.data' "$snapshot_file" > "/tmp/snapshot_data_$snapshot_id.json"
        else
            # Fallback if jq is not available
            sed -n '/"data": {/,/^  }/p' "$snapshot_file" | sed '1s/.*{/{/' > "/tmp/snapshot_data_$snapshot_id.json"
        fi
        input_file="/tmp/snapshot_data_$snapshot_id.json"
    else
        # Already in the right format
        input_file="$snapshot_file"
    fi
    
    # Determine if iOS or Android by examining the JSON content
    if grep -q '"os": *"ios"' "$input_file" || grep -q '"platform": *"ios"' "$input_file"; then
        platform="ios"
        target_file="$APP_ACCESS_DIR/snapshot.json"
        api_endpoint="http://localhost:3000/api/v1/app_scanner/ios/scan"
    else
        platform="android"
        target_file="$APP_ACCESS_DIR/snapshot_android.json"
        api_endpoint="http://localhost:3000/api/v1/app_scanner/android/scan"
    fi
    
    echo "Detected platform: $platform"
    
    # Copy the snapshot file to the appropriate location
    cp "$input_file" "$target_file"
    
    # Clear Rails log file before API call
    echo "Clearing Rails log file..."
    > "$LOG_FILE"
    
    # Call the appropriate API endpoint with auth header using POST
    echo "Calling API endpoint for $platform: $api_endpoint"
    response=$(curl -s -X POST -H "X-Auth-Override: 1" "$api_endpoint" 2>&1)
    
    # Give Rails a moment to finish writing to the log file
    sleep 2
    
    # Extract the focus sequence from the specific debug line
    focus_sequence=$(grep -o "Add this to extract Focus sequence: \[.*\]" "$LOG_FILE" | tail -1 | sed 's/Add this to extract Focus sequence: //')
    
    if [ -n "$focus_sequence" ]; then
        # Clean up the output - remove backslashes
        cleaned_sequence=$(echo "$focus_sequence" | sed 's/\\//g')
        
        # Write to the proper focus_order.json file
        echo "$cleaned_sequence" > "$OUTPUT_DIR/focus_order_$snapshot_id.json"
        
        echo "Processed snapshot $snapshot_id."
        echo "Focus sequence saved to $OUTPUT_DIR/focus_order_$snapshot_id.json"
    else
        echo "Failed to extract focus sequence from log file for snapshot $snapshot_id."
        # If needed, this could create an empty focus order file
        echo "[]" > "$OUTPUT_DIR/focus_order_$snapshot_id.json"
        echo "Created empty focus order file for snapshot $snapshot_id."
    fi
    
    # Clean up temp file if created
    if [ -f "/tmp/snapshot_data_$snapshot_id.json" ]; then
        rm "/tmp/snapshot_data_$snapshot_id.json"
    fi
    
    echo "-----------------------------------"
done

echo "All snapshots processed!"