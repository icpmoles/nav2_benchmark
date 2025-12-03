#!/bin/bash

set -e



#      same P core /diff P core  / all P cores / 2 E cores / all E cores / 2P2E cores / all Cores 
cpuset=("2-3"      "3-4"           "0-7"        "8-9"       "8-11"           "6-9"      "0-11" )

latency_opt=(1 0)

optimize_cpu() {
    if [  $1 -eq 1 ]; then
    echo "optimize"
    ( echo -n 0 ; cat ) > /dev/cpu_dma_latency
    else 
    echo "not optimize"
    fi
}

for cpu in ${cpuset[@]}; do
    for opt in ${latency_opt[@]}; do
    echo "opt:" $opt "cpu set:" $cpu 
    mkdir results_$2 
    optimize_cpu $opt & \
    sudo -u $1 docker run --rm  --cpuset-cpus "$cpu"  --name "dummy" -v $PWD/results_$2/opt_$opt/cpu_$cpu:/root/nav2_ws/output  nav2_benchmark-mppi 
  done 
done

