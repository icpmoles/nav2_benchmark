ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}-ros-core

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends --no-install-suggests \
  ros-dev-tools \
  wget

WORKDIR /root/nav2_ws
RUN mkdir -p ~/nav2_ws/src
RUN git clone https://github.com/ros-navigation/navigation2.git --branch ${ROS_DISTRO} --depth 1 ./src/navigation2
RUN rosdep init
RUN apt update && apt upgrade -y \
    && rosdep update \
    && rosdep install -y --ignore-src --from-paths src -r


WORKDIR /root/nav2_ws/src/navigation2/

RUN rm -rf nav2_mppi_controller

COPY nav2_mppi_controller nav2_mppi_controller


WORKDIR /root/nav2_ws/

RUN . /opt/ros/jazzy/setup.sh && \
        colcon build --parallel-workers $(nproc --ignore 1)  --packages-up-to nav2_mppi_controller --cmake-args -DBUILD_TESTING=ON    

#RUN ./root/nav2_ws/install/local_setup.bash    
## no touch 

# colcon test --parallel-workers $(nproc --ignore 1)  --packages-select nav2_mppi_controller
# colcon test-result 


COPY entrypoint.sh /root/nav2_ws/

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/bin/bash", "/root/nav2_ws/entrypoint.sh"]