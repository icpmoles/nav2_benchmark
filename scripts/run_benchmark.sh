#!/bin/bash

set -e
export BENCHMARK_FORMAT=json
echo "BENCHMARK"
build/nav2_mppi_controller/benchmark/optimizer_benchmark --benchmark_repetitions=9   > output/optimizer_benchmark.json 2>output/benchmark_context.txt
jq -r '.benchmarks | map( select (.name == "BM_DiffDrivePointFootprint_mean"))' output/optimizer_benchmark.json 
jq -r '.benchmarks | map( select (.name == "BM_DiffDrive_mean"))' output/optimizer_benchmark.json 
#jq -r '.benchmarks[0]' output/optimizer_benchmark.json  


#build/nav2_mppi_controller/benchmark/controller_benchmark > output/controller_benchmark.json 2>/dev/null --benchmark_repetitions=9 

# we expect around 10ms https://github.com/ros-navigation/navigation2/pull/4621#issuecomment-2518703599