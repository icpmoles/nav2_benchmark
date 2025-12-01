#!/bin/bash

set -e

source /opt/ros/jazzy/setup.sh
source /root/nav2_ws/install/local_setup.bash 

./run_benchmark.sh

exec /bin/bash