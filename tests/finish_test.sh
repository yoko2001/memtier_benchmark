#! /bin/bash
set -e
CGROUPNAME=memtier_benchmark

# check for alternative config schema
echo "finish test, try get peak"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.peak
echo "finish test, try get stat"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.stat
