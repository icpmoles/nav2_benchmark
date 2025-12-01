#!/bin/bash

set -e
export BENCHMARK_FORMAT=json
build/nav2_mppi_controller/benchmark/optimizer_benchmark > output/optimizer_benchmark.json 2>/dev/null
#build/nav2_mppi_controller/benchmark/controller_benchmark > output/controller_benchmark.json 2>/dev/null