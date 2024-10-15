#!/bin/sh

get_partitions() {
    echo "Available partitions in /dev/block/by-name:"
    ls /dev/block/by-name

    echo ""
    echo "Enter the partitions you want to backup (separate with space), or type 'all' to backup all partitions (including userdata)."
    echo "Example: 'boot recovery' or 'all' for all partitions."
    read -r PARTITIONS
}

get_backup_location() {
    echo ""
    echo "Please specify the directory where the backup will be saved (e.g., /sdcard/backup)."
    read -r BACKUP_DIR

    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Directory doesn't exist, creating $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
    fi
}

get_partitions

get_backup_location

for partition in $(ls /dev/block/by-name); do

    if echo "$partition" | grep -qE '^(sda|sdb|sdc|sdd|sde|sdf|mmcblk0)$'; then
        echo "Skipping $partition..."
        continue
    fi

    if [ "$PARTITIONS" != "all" ] && ! echo "$PARTITIONS" | grep -q "$partition"; then
        continue
    fi

    echo "Dumping $partition..."

    dd if=/dev/block/by-name/$partition of="$BACKUP_DIR/$partition.img"
done

echo "Backup complete!"
