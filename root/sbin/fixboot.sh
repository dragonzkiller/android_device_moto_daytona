#!/sbin/hijack sh

export PATH="/sbin:${PATH}"

/sbin/taskset -p -c 0,1 1