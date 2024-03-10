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


let totalmem=$((134217728 * 10)) #approx 128MB*9.2, we give it a little bit more 
#$((1073741824 * 8)) #8G # $((134217728*4)) #256mb = (4*128mb)*50%

echo ${totalmem} > /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
exit 0