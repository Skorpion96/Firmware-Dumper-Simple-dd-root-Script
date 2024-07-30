#!/bin/sh

# Create dump directory
mkdir /sdcard/dump

# List all partition names in /dev/block/by-name
for partition in $(ls /dev/block/by-name); do
    # Skip userdata partition
    if [ "$partition" == "userdata" ]; then
        echo "Skipping userdata partition..."
        continue
    fi
    
    # Skip partitions with names like sda, sdb, sdc, sdd, sde, sdf
    if echo "$partition" | grep -qE '^(sda|sdb|sdc|sdd|sde|sdf|mmcblk0)$'; then
        echo "Skipping $partition..."
        continue
    fi

    echo "Dumping $partition..."
    
    # Use dd to dump each partition
    dd if=/dev/block/by-name/$partition of=/sdcard/dump/$partition.img
done
