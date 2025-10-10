#FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends wget make m4 patch build-essential ca-certificates cmake curl nano git \
                                                  ffmpeg libsm6 libxext6 \
                                                  libgeos-dev libproj-dev \
#     && apt-get install -y --no-install-recommends libgeos-dev libproj-dev libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RUN python3 -V

# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh -O ~/miniforge.sh \
# RUN wget --quiet https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_23.9.0-0-Linux-x86_64.sh -O ~/miniforge.sh \
RUN wget --quiet https://gh-proxy.com/https://github.com/conda-forge/miniforge/releases/download/4.12.0-0/Mambaforge-4.12.0-0-Linux-x86_64.sh -O ~/miniforge.sh \
    && /bin/bash ~/miniforge.sh -b -p /opt/miniforge \
    && rm ~/miniforge.sh \
    && ln -s /opt/miniforge/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/miniforge/etc/profile.d/conda.sh" >> ~/.bashrc

ENV PATH=/opt/miniforge/bin:${PATH}
ARG PATH=/opt/miniforge/bin:${PATH}
ENV HDF5_DIR=/opt/miniforge/
ENV NETCDF4_DIR=/opt/miniforge/ 
ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# RUN . /root/.bashrc \
#     && /opt/miniforge/bin/conda init bash \
#     && conda info --envs \
#     && conda update -n base -c defaults conda \
# #    && conda config --set custom_channels.conda-forge https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/ \
#     && conda install -c conda-forge mamba -y
# 
# RUN python -m pip install pip==20.2 # -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
# 
RUN pip install --no-cache notebook jupyterlab \
                           dl4ds \
                           tensorflow==2.13.0 keras==2.13.0 \
#						   protobuf==3.19.6 pandas==1.3.5 matplotlib==3.5.3 \
						   scikit-learn \
						   -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
# 
# RUN python -c "import dl4ds as dds; import climetlab as cml"

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER=${NB_USER}
ENV HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}