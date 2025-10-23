#FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
FROM tensorflow/tensorflow:2.6.1-gpu-jupyter

RUN export DEBIAN_FRONTEND=noninteractive \
    export DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends wget make m4 patch build-essential ca-certificates cmake curl nano git \
                                                  ffmpeg libsm6 libxext6 \
                                                  libgeos-dev libproj-dev \
												  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
												  llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
#     && apt-get install -y --no-install-recommends libgeos-dev libproj-dev libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN useradd -m -s /bin/bash user && echo "user:111" | chpasswd
RUN usermod -aG sudo user
USER user

# RUN python -m pip install pip==20.2 # -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN pip install --no-cache dl4ds
 
# RUN python -c "import dl4ds as dds; import climetlab as cml"
# notebook==7.3.2 jupyter==1.1.1 jupyterlab==4.3.4 jupyter-server==2.15.0 referencing==0.35.1 typing-extensions==3.7.4.3 python-json-logger==2.0.7