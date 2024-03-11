#!/bin/bash
CGROUPNAME=memtier_benchmark
cgget -g memory:/sys/fs/cgroup/yuri/memtier_benchmark
target_cgroup="/yuri/memtier_benchmark"
in_cgroup_pids=$(ps -e -o pid,cgroup | grep "$target_cgroup" | awk '{print $1}')
if [ -z "$in_cgroup_pids" ]; then
  echo "No processes found in the target cgroup."
else
  sudo cgclassify -g memory:/ "$in_cgroup_pids"
fi
cgdelete -r memory:/yuri/${CGROUPNAME}
# cgdelete -r memory:/sys/fs/cgroup/yuri/${CGROUPNAME}

if [ ! -d "/sys/fs/cgroup/yuri/" ];then
	mkdir /sys/fs/cgroup/yuri
else
	echo "cgroup yuri already exists"
fi
echo "+memory" >> /sys/fs/cgroup/yuri/cgroup.subtree_control

if [ ! -d "/sys/fs/cgroup/yuri/${CGROUPNAME}/" ];then
	mkdir /sys/fs/cgroup/yuri/${CGROUPNAME}
else
	echo "cgroup yuri/${CGROUPNAME} already exists"
fi

if [ -z "$1" ]; then
  echo "lack a total workload size"
  exit -1
fi
if [ -z "$2" ]; then
  echo "lack a total workload size"
  exit -1
fi
let totalmem=$(($1 * 1024 * 1024)) #232mb
#$((1073741824 * 8)) #8G # $((134217728*4)) #256mb = (4*128mb)*50%
restrictsize=$(echo "$2 * $totalmem" | bc)
restrictsize=$(printf "%.0f" "$restrictsize")
echo ${restrictsize} > /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
exit 0