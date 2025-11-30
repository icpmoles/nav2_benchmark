#!/bin/bash

set -e

source /opt/ros/jazzy/setup.sh
source /root/nav2_ws/install/local_setup.bash 

build/nav2_mppi_controller/benchmark/optimizer_benchmark > output/out.txt 2>/dev/null