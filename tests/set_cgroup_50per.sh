#!/bin/bash
CGROUPNAME=memtier_benchmark
cgget -g memory:/sys/fs/cgroup/yuri/memtier_benchmark
cgdelete -r cpu,memory:/sys/fs/cgroup/yuri/${CGROUPNAME}
cgdelete -r cpu,memory:/sys/fs/cgroup/yuri/${CGROUPNAME}

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

let totalmem=$((1073741824 * 8)) #8G # $((134217728*4)) #256mb = (4*128mb)*50%

echo ${totalmem} > /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
exit 0