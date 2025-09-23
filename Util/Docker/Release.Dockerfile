ARG UBUNTU_DISTRO="22.04"

FROM carla-base:ue4-${UBUNTU_DISTRO}

ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m carla

WORKDIR /workspace/carla
COPY --chown=carla:carla . .

RUN packages='libsdl2-2.0 xserver-xorg libvulkan1 libomp5 xdg-user-dirs python3 python3-pip git' \
    && apt-get update \
    && apt-get install -y $packages \
    && rm -rf /var/lib/apt/lists/*

ENV CARLA_API_PATH=/workspace/carla/PythonAPI

# Install CARLA PythonAPI wheel
RUN set -e; \
    pyver=$(python3 -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')"); \
    wheel=$(echo ${CARLA_API_PATH}/carla/dist/*${pyver}*.whl); \
    pip install --no-cache-dir "$wheel"

# Create script that adds API to pythonpath and make .bashrc source it
RUN echo "export PYTHONPATH=\$PYTHONPATH:$CARLA_API_PATH/carla/agents" >> /setup_carla_env.sh; \
    echo "export PYTHONPATH=\$PYTHONPATH:$CARLA_API_PATH/carla" >> /setup_carla_env.sh; \
    echo "export CARLA_API_PATH=$CARLA_API_PATH" >> /setup_carla_env.sh; \
    chmod +x /setup_carla_env.sh; \
    echo "source /setup_carla_env.sh" >> ~/.bashrc

ENV OMP_PROC_BIND="FALSE"
ENV OMP_NUM_THREADS="48"
ENV NVIDIA_DRIVER_CAPABILITIES="all"
ENV NVIDIA_VISIBLE_DEVICES="all"

USER carla

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD python3 ./PythonAPI/util/ping.py

# you can also run CARLA in offscreen mode with -RenderOffScreen
# CMD ["/bin/bash", "CarlaUE4.sh", "-RenderOffScreen"]
CMD ["/bin/bash", "CarlaUE4.sh"]
