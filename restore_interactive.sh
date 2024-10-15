#!/bin/sh

get_backup_directory() {
    echo "Please specify the directory where the backup is stored (e.g., /sdcard/backup)."
    read -r BACKUP_DIR

    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Directory does not exist. Please check the path and try again."
        exit 1
    fi
}

get_restore_partitions() {
    echo ""
    echo "Available backups in $BACKUP_DIR:"
    ls "$BACKUP_DIR"/*.img

    echo ""
    echo "Do you want to restore all partitions or specific ones?"
    echo "Type 'all' to restore everything or specify the partitions (e.g., 'boot recovery system')"
    read -r PARTITIONS
}

confirm_restore() {
    echo ""
    echo "You are about to restore the following partitions from $BACKUP_DIR:"
    if [ "$PARTITIONS" = "all" ]; then
        ls "$BACKUP_DIR"/*.img
    else
        for partition in $PARTITIONS; do
            if [ -f "$BACKUP_DIR/$partition.img" ]; then
                echo "$partition"
            else
                echo "$partition.img not found in the backup directory."
                exit 1
            fi
        done
    fi
    echo ""
    echo "WARNING: This will overwrite the selected partitions on your device."
    echo "Do you want to proceed? Type 'yes' to confirm, or anything else to cancel."
    read -r CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
        echo "Restore operation cancelled."
        exit 1
    fi
}

restore_partitions() {
    echo "Starting restore process..."

    if [ "$PARTITIONS" = "all" ]; then
        for img_file in "$BACKUP_DIR"/*.img; do
            partition=$(basename "$img_file" .img)
            echo "Restoring $partition..."
            dd if="$img_file" of="/dev/block/by-name/$partition"
        done
    else
        for partition in $PARTITIONS; do
            echo "Restoring $partition..."
            dd if="$BACKUP_DIR/$partition.img" of="/dev/block/by-name/$partition"
        done
    fi

    echo "Restore complete!"
}

get_backup_directory
get_restore_partitions
confirm_restore
restore_partitions
