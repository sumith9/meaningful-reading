#!/bin/bash

# Check if snapshot ID is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <snapshot_id>"
    echo "Example: $0 329424"
    exit 1
fi

snapshot_id="$1"
snapshots_dir="/Users/poonersumith/Desktop/meaningful-reading-order/snapshots"
focus_order_dir="/Users/poonersumith/Desktop/meaningful-reading-order/focus_order"
snapshot_file="${snapshots_dir}/snapshot_${snapshot_id}.json"
focus_order_file="${focus_order_dir}/focus_order_${snapshot_id}.json"

# Create focus_order directory if it doesn't exist
mkdir -p "$focus_order_dir"

echo "Extracting focus order from snapshot ${snapshot_id}..."

# Check if snapshot file exists
if [ ! -f "$snapshot_file" ]; then
    echo "❌ Error: Snapshot file not found: $snapshot_file"
    exit 1
fi

# Check if snapshot file has content
if [ ! -s "$snapshot_file" ]; then
    echo "❌ Error: Snapshot file is empty: $snapshot_file"
    exit 1
fi

# Extract OS type and focus order data using jq
echo "📱 Detecting OS and extracting focus order data..."

# Get OS type
os_type=$(jq -r '.data.os // empty' "$snapshot_file")

if [ -z "$os_type" ]; then
    echo "❌ Error: Could not determine OS type from snapshot"
    exit 1
fi

echo "🔍 Detected OS: $os_type"

# Extract focus order based on OS type
if [ "$os_type" = "ios" ]; then
    echo "🍎 Extracting iOS focus_order_caption_data..."
    
    # Check if focus_order_caption_data exists
    if ! jq -e '.data.focus_order_caption_data' "$snapshot_file" >/dev/null 2>&1; then
        echo "❌ Error: focus_order_caption_data not found in iOS snapshot"
        exit 1
    fi
    
    # Extract focus_order_caption_data
    jq '.data.focus_order_caption_data' "$snapshot_file" > "$focus_order_file"
    
elif [ "$os_type" = "android" ]; then
    echo "🤖 Extracting Android focusOrder..."
    
    # Check if focusOrder exists
    if ! jq -e '.data.focusOrder' "$snapshot_file" >/dev/null 2>&1; then
        echo "❌ Error: focusOrder not found in Android snapshot"
        exit 1
    fi
    
    # Extract focusOrder
    jq '.data.focusOrder' "$snapshot_file" > "$focus_order_file"
    
else
    echo "❌ Error: Unsupported OS type: $os_type"
    echo "Supported OS types: ios, android"
    exit 1
fi

# Verify the output file was created and has content
if [ -s "$focus_order_file" ]; then
    element_count=$(jq 'length' "$focus_order_file" 2>/dev/null || echo "0")
    echo "✅ Successfully extracted focus order to: $focus_order_file"
    echo "📊 Focus order elements: $element_count"
    
    # Show preview of extracted data
    echo "📋 Preview of focus order data:"
    if [ "$os_type" = "ios" ]; then
        echo "First 3 iOS focus elements:"
        jq '.[0:3] | .[] | {caption, spoken_description}' "$focus_order_file" 2>/dev/null || echo "Could not preview data"
    else
        echo "First 3 Android focus elements:"
        jq '.[0:3] | .[] | {text, desc}' "$focus_order_file" 2>/dev/null || echo "Could not preview data"
    fi
else
    echo "❌ Error: Failed to create focus order file or file is empty"
    exit 1
fi

echo "🎉 Focus order extraction completed!"