#!/bin/bash

# This script automates the process of cloning the used portion of a partition to a backup folder on a USB drive.
# Usage: ./dd_backup_parameterized.sh [SOURCE_PARTITION] [USB_MOUNT_POINT] [BACKUP_FOLDER] [IMAGE_NAME]
# Example:
# ./dd_backup_parameterized.sh /dev/sda2 /run/media/dmei/Gigastone backup sda2_backup.img
#
# To find the required parameter values, you can use the following commands:
# 1. To find the source partition (e.g., /dev/sda2):
#    - Use `lsblk` to list block devices and their partitions:
#      $ lsblk
#      This will show you the partitions on your system. Look for the partition that contains the used data.
#
# 2. To find the USB mount point (e.g., /run/media/dmei/Gigastone):
#    - Use `lsblk -f` to view mount points and filesystems:
#      $ lsblk -f
#      This will show the filesystems and mount points. Look for the device that represents your USB drive.
#
# 3. To check the USB device info:
#    - Use `usbutils` to list USB devices:
#      $ lsusb
#      This shows all USB devices connected to your system. Look for your USB device in the list.
#
# 4. To check partition details, use `parted`:
#    - Use `parted` to view the partitions on the USB drive:
#      $ sudo parted /dev/sdc print
#      This will show you the partition table on the USB drive (adjust `/dev/sdc` to your actual USB device).
#
# 5. If your USB drive uses `exFAT`, use `exfatprogs` to manage it:
#    - You can check the filesystem type and repair or format the USB drive using `exfatprogs`:
#      $ sudo mkfs.exfat /dev/sdc1
#
# 6. Alternatively, you can use `udisks2` service to mount or manage the USB:
#    - To view mounted devices:
#      $ udisksctl status
#    - To mount the USB (if not already mounted):
#      $ udisksctl mount -b /dev/sdc1
#    - To unmount the USB:
#      $ udisksctl unmount -b /dev/sdc1

# Default values (change these if you want different defaults)
DEFAULT_SOURCE_PARTITION="/dev/sda2"
DEFAULT_USB_MOUNT_POINT="/run/media/dmei/Gigastone"
DEFAULT_BACKUP_FOLDER="backup"
DEFAULT_IMAGE_NAME="sda2_backup.img"

# Function to print usage information
usage() {
    echo "Usage: $0 [SOURCE_PARTITION] [USB_MOUNT_POINT] [BACKUP_FOLDER] [IMAGE_NAME]"
    echo "Example: $0 /dev/sda2 /run/media/dmei/Gigastone backup sda2_backup.img"
    exit 1
}

# Check if the number of arguments is correct
if [ $# -lt 4 ]; then
    echo "Error: Missing arguments!"
    usage
fi

# Parameters (or use defaults)
SOURCE_PARTITION="${1:-$DEFAULT_SOURCE_PARTITION}"
USB_MOUNT_POINT="${2:-$DEFAULT_USB_MOUNT_POINT}"
BACKUP_FOLDER="${3:-$DEFAULT_BACKUP_FOLDER}"
IMAGE_NAME="${4:-$DEFAULT_IMAGE_NAME}"

# Ensure the USB drive is mounted and the backup folder exists
if [ ! -d "$USB_MOUNT_POINT" ]; then
    echo "Error: USB drive is not mounted at $USB_MOUNT_POINT."
    exit 2
fi

# Create the backup folder if it doesn't exist
mkdir -p "$USB_MOUNT_POINT/$BACKUP_FOLDER"

# Start the cloning process
echo "Cloning $SOURCE_PARTITION to $USB_MOUNT_POINT/$BACKUP_FOLDER/$IMAGE_NAME"
sudo dd if="$SOURCE_PARTITION" of="$USB_MOUNT_POINT/$BACKUP_FOLDER/$IMAGE_NAME" bs=64K status=progress

# Verify the backup size and display the folder contents
echo "Backup complete. Verifying backup size..."
ls -lh "$USB_MOUNT_POINT/$BACKUP_FOLDER/$IMAGE_NAME"

# List the contents of the USB to ensure the backup was added
echo "Listing contents of the USB drive..."
ls "$USB_MOUNT_POINT"

# Optional: To restore from the backup, uncomment the following lines and modify as necessary
# echo "To restore from the backup, run the following:"
# echo "sudo dd if=$USB_MOUNT_POINT/$BACKUP_FOLDER/$IMAGE_NAME of=$SOURCE_PARTITION bs=64K status=progress"

