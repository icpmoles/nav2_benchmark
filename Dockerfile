ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}-ros-core

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends --no-install-suggests \
  ros-dev-tools \
  wget \
  jq

WORKDIR /root/nav2_ws
RUN mkdir -p ~/nav2_ws/src
RUN git clone https://github.com/ros-navigation/navigation2.git --branch ${ROS_DISTRO} --depth 1 ./src/navigation2
RUN rosdep init
RUN apt update && apt upgrade -y \
    && rosdep update \
    && rosdep install -y --ignore-src --from-paths src -r

WORKDIR /root/nav2_ws/

RUN . /opt/ros/jazzy/setup.sh && \
        colcon build --parallel-workers $(nproc --ignore 1)  --packages-up-to nav2_mppi_controller    --cmake-args -DCMAKE_BUILD_TYPE=Release
        #--packages-skip nav2_mppi_controller 

WORKDIR /root/nav2_ws/src/navigation2/

RUN rm -rf nav2_mppi_controller

COPY ./nav2_mppi_controller nav2_mppi_controller

WORKDIR /root/nav2_ws/

RUN . /root/nav2_ws/install/setup.sh && \
        colcon build --parallel-workers $(nproc --ignore 1)  --packages-select nav2_mppi_controller  --cmake-args  -DBUILD_TESTING=ON  -DCMAKE_BUILD_TYPE=Release

# -DBUILD_TESTING=ON

COPY scripts/*.sh /root/nav2_ws/

RUN chmod +x *.sh

ENV BASH_ENV=/root/nav2_ws/install/setup.sh

RUN chmod +x  /root/nav2_ws/install/setup.sh
RUN /root/nav2_ws/install/setup.sh

#CMD ["bash"]

ENTRYPOINT ["/bin/bash", "-c", "/root/nav2_ws/entrypoint.sh"]