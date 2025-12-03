#!/bin/bash

set -e

source /opt/ros/jazzy/setup.sh
source /root/nav2_ws/install/local_setup.bash 

echo "STARTING..."
./run_benchmark.sh
echo "DONE!"
#exec /bin/bash