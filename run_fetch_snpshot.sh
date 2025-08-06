#!/bin/bash

# Make sure snapshot_ids.txt exists
if [ ! -f snapshot_ids.txt ]; then
  echo "snapshot_ids.txt not found!"
  exit 1
fi

# Read each line from snapshot_ids.txt and run fetch_snapshot.sh
while IFS= read -r snapshot_id || [[ -n "$snapshot_id" ]]; do
  if [[ -n "$snapshot_id" ]]; then
    echo "Fetching snapshot $snapshot_id..."
    ./fetch_snapshot.sh "$snapshot_id"
  fi
done < snapshot_ids.txt
