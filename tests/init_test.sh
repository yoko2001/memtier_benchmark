#! /bin/bash
set -e

#init state
echo $$ >> /sys/fs/cgroup/cgroup.procs
#turn off trace first
echo 0 > /sys/kernel/debug/tracing/tracing_on

CGROUPNAME=memtier_benchmark

sleep 1
CGROUP_SH=/home/yuri/memtier_benchmark/tests/set_cgroup_50per.sh
echo "create a cgroup for all existing daemons"
${CGROUP_SH}

sleep 1

# check for alternative config schema
echo "adding all redis-server daemon to cgroup"
CUR_REDIS_PID=$(pgrep redis-server)
echo ${CUR_REDIS_PID}
echo ${CUR_REDIS_PID}>>/sys/fs/cgroup/yuri/${CGROUPNAME}/cgroup.procs
# if [ -r "${FILES[0]}" ]; then
#   CONFIGS=()
#   for FILE in "${FILES[@]}";
#   do
#     # remove prefix
#     NAME=${FILE#/etc/}
#     # remove suffix
#     NAME=${NAME%.conf}
#     PIDFILE="/var/run/$NAME.pid"
#     # check optional second param
#     CUR_SERVER_PID=$(cat ${PIDFILE})

#     echo ${CUR_SERVER_PID}>>/sys/fs/cgroup/yuri/${CGROUPNAME}/cgroup.procs
#   done;
# fi;
# sleep 1
# echo "cleaning all tracer"
# echo > /sys/kernel/debug/tracing/set_event
# echo "nop" > /sys/kernel/debug/tracing/current_tracer
# echo >> /sys/kernel/debug/tracing/set_ftrace_filter

# #setting trace funcs
# echo "add all lru_gen tracers below: "
# echo 1 > /sys/kernel/debug/tracing/events/lru_gen/folio_ws_chg/enable
# #echo 1 > /sys/kernel/debug/tracing/events/lru_gen/folio_ws_chg_se/enable

# echo "currently in ${CGROUPNAME} are:"
# cat /sys/fs/cgroup/yuri/${CGROUPNAME}/cgroup.procs