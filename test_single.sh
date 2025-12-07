
cpu=3-4
bs=2000
author=ale
opt=1

optimize_cpu() {
    if [  $1 -eq 1 ]; then
    echo "optimize"
    (( echo -n 0 ; cat ) > /dev/cpu_dma_latency) & (xxd /dev/cpu_dma_latency)
    else 
    echo "not optimized"
    fi
}

mkdir results_$2 

# remove leftover folder
rm -rf nav2_mppi_controller
# copy tuned folder
cp -r nav2_mppi_controller_$author nav2_mppi_controller
# replace batch size variable
sed -i  "s/N_BATCH/$bs/g" nav2_mppi_controller/benchmark/optimizer_benchmark.cpp
docker compose build
optimize_cpu $opt & \
sudo -u $1 docker run --rm  --cpuset-cpus "$cpu"  --name "dummy" -v $PWD/results_$2/auth_$author/bs_$bs/opt_$opt/cpu_$cpu:/root/nav2_ws/output  nav2_mppi_benchmark

