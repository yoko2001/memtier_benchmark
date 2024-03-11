#! /bin/bash
set -e

#init state
echo $$ >> /sys/fs/cgroup/cgroup.procs
#turn off trace first
echo 0 > /sys/kernel/debug/tracing/tracing_on

CGROUPNAME=memtier_benchmark

total_workload=232 #mb
dram_partition=0.5
sleep 1
CGROUP_SH=/home/yuri/memtier_benchmark/tests/set_cgroup_50per.sh
echo "create a cgroup for all existing daemons"
${CGROUP_SH} ${total_workload} ${dram_partition}

sleep 1

# check for alternative config schema
echo "init memory.peak of cgroup ${CGROUPNAME}"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.peak
echo "init memory.stat of cgroup ${CGROUPNAME}"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.stat

echo "adding all redis-server daemon to cgroup"
CUR_REDIS_PID=$(pgrep redis-server)
echo ${CUR_REDIS_PID}
echo ${CUR_REDIS_PID}>>/sys/fs/cgroup/yuri/${CGROUPNAME}/cgroup.procs

sleep 1
./ramon_mb.sh 1024 #add 1024mb ram block