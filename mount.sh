#!/sbin/sh

rw=("/systemt" "/vendor" "/system_ext" "/product")
unmount_partition() {
    local partition="$1"
    umount "$partition" 2>&1 | grep message
}

mount_partition_rw() {
    local partition="$1"
    mount -o rw "$partition" | grep message
}

set_partition_rw() {
    local device_node="$1"
    /bin/blockdev --setrw "$device_node" | grep message
}

for partition in "${rw[@]}"; do
    unmount_partition "$partition"
    mount_partition_rw "$partition"
    device_node="/dev/block/mapper/${partition}"
    set_partition_rw "$device_node"
done
