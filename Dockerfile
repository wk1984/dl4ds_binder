# 使用带有CUDA的官方PyTorch镜像作为基础
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
#FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends wget make m4 patch build-essential ca-certificates cmake curl nano git \
#     && apt-get install -y --no-install-recommends libgeos-dev libproj-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN apt-get update && \
    apt-get install -y libgeos++-dev ffmpeg libsm6 libxext6 nano

RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN pyenv install 3.9.13
RUN pyenv global 3.9.13
RUN pyenv rehash
RUN pip install -U pip pipenv	

RUN python --version

RUN pip install climetlab climetlab_maelstrom_downscaling maelstrom

RUN python -c "import climetlab as cml; \
               cmlds_train = cml.load_dataset("maelstrom-downscaling", dataset="training"); \
               cmlds_val = cml.load_dataset("maelstrom-downscaling", dataset="validation"); \
               cmlds_test = cml.load_dataset("maelstrom-downscaling", dataset="testing"); \
               t2m_hr_train = cmlds_train.to_xarray().t2m_tar"

# RUN python -c "import tensorflow as tf; tf.config.list_physical_devices('GPU')"