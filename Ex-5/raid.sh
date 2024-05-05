#!/bin/bash

#kakie diski?
av_disks=($(lsblk -o NAME -n -d | grep -E "sd[b-z]$"))

#skolko diskov?
devices=${#av_disks[@]}

echo "available disks:"
echo "${av_disks[@]}"

#zachistit diski
for disk in "${av_disks[@]}"
do
    mdadm --zero-superblock --force "/dev/$disk"
done

#kakoi raid nuzhen?
read -p "raid number?" raid_number

#sozdaem raid
for el in "${av_disks[@]}"
do
    if [ -z "$disks" ]; then
        disks="$el"
    else
        disks="$disks,$el"
    fi
done

echo "$disks"

mdadm --create --verbose /dev/md0 -l $raid_number -n $devices /dev/{$disks}

