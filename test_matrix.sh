#!/bin/bash

set -e

# $1 must be the current user with $USER 

# $2 must be the "status", for example idle or running

#      single P core /2 P cores  / all P cores /  1 E core  / 2 E cores / all E cores / 2P2E cores / all Cores 
cpuset=(                 "3-4"           "0-7"                    "8-9"       "8-11"           "6-9"      "0-11" )

batch_size=("250" "500" "1000" "2000" "4000" "8000" )

tunedby=("steve" "ale")

latency_opt=(1 0)

optimize_cpu() {
    if [  $1 -eq 1 ]; then
    echo "optimize"
    (( echo -n 0 ; cat ) > /dev/cpu_dma_latency) & (xxd /dev/cpu_dma_latency)
    else 
    echo "not optimize"
    (xxd /dev/cpu_dma_latency)
    fi
}

mkdir results_$2 

for author in ${tunedby[@]}; do
  for bs in ${batch_size[@]}; do
    for cpu in ${cpuset[@]}; do
        for opt in ${latency_opt[@]}; do
        echo "opt:" $opt "cpu set:" $cpu "author:" $author "bs:" $bs
        
        # remove leftover folder
        rm -rf nav2_mppi_controller
        # copy tuned folder
        cp -r nav2_mppi_controller_$author nav2_mppi_controller
        # replace batch size variable
        sed -i  "s/N_BATCH/$bs/g" nav2_mppi_controller/benchmark/optimizer_benchmark.cpp
        docker compose build
        optimize_cpu $opt & \
        sudo -u $1 docker run --rm  --cpuset-cpus "$cpu"  --name "dummy" -v $PWD/results_$2/auth_$author/bs_$bs/opt_$opt/cpu_$cpu:/root/nav2_ws/output  nav2_mppi_benchmark
      done 
    done
  done
done
