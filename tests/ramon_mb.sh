#!/bin/bash
#delete existing ram disks
swapoff /dev/ram0
rmmod brd

if [ -z "$1" ]; then
  echo "err, needs ramdisk size (mv)"
  exit -1
fi

num_mb=$1
modprobe brd rd_nr=1 rd_size=$(($num_mb * 1024))
dd if=/dev/zero of=/dev/ram0 bs=1M count=$num_mb
swapoff /dev/ram0

#swap on
mkswap /dev/ram0
#setting the max priority
swapon -p 1005 /dev/ram0