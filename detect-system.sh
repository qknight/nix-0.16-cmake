#!/bin/bash
cpu_name=$(uname -p | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ' 'abcdefghijklmnopqrstuvwxyz_')
machine_name=$(uname -m | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ' 'abcdefghijklmnopqrstuvwxyz_')

case $machine_name in
    i*86)
        machine_name=i686
        ;;
    x86_64)
        machine_name=x86_64
        ;;
    ppc)
        machine_name=powerpc
        ;;
    *)
        if test "$cpu_name" != "unknown"; then
            machine_name=$cpu_name
        fi
        ;;
esac

sys_name=$(uname -s | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ' 'abcdefghijklmnopqrstuvwxyz_')

case $sys_name in
    cygwin*)
        sys_name=cygwin
        ;;
esac

echo -n ${machine_name}-${sys_name}
