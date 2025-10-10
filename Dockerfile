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

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh -O ~/miniforge.sh \
# RUN wget --quiet https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_23.9.0-0-Linux-x86_64.sh -O ~/miniforge.sh \
    && /bin/bash ~/miniforge.sh -b -p /opt/miniforge \
    && rm ~/miniforge.sh \
    && ln -s /opt/miniforge/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/miniforge/etc/profile.d/conda.sh" >> ~/.bashrc

ENV PATH=/opt/miniforge/bin:${PATH}
ARG PATH=/opt/miniforge/bin:${PATH}
ENV HDF5_DIR=/opt/miniforge/
ENV NETCDF4_DIR=/opt/miniforge/ 
ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN . /root/.bashrc \
    && /opt/miniforge/bin/conda init bash \
    && conda info --envs \
    && conda update -n base -c defaults conda \
#    && conda config --set custom_channels.conda-forge https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/ \
    && conda install -c conda-forge mamba -y

RUN python -m pip install pip==20.2 # -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN pip install pyodc==1.4.1

RUN . /root/.bashrc \
#    && conda config --set custom_channels.conda-forge https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/ \
    && mamba install -c conda-forge jupyterlab==4.3.4 jupyter==1.1.1 notebook==7.3.2 cython==3.0.11 shapely==1.8.4 \
                                    cartopy==0.21.0 numpy==1.19.5 pandas==1.3.5 scipy==1.7.1 matplotlib==3.4.3 xarray==0.19.0 \
                                    tensorflow==2.6.0 tensorflow-gpu==2.6.0 tensorflow-estimator==2.6.0 keras==2.6.0 \
                                    scikit-learn==1.0 joblib==1.1.1 seaborn==0.11.2 absl-py==0.14.1 -y

RUN git clone https://github.com/wk1984/dl4ds_fixed.git \
     && cd dl4ds_fixed \
     && pip install -e . \
     && pip install -e . \
     && python -c "import dl4ds"

RUN pip install climetlab==0.24.0 climetlab-maelstrom-downscaling==0.4.0

# RUN pip install ecubevis==1.0.2 eccodes==2.37.0 dask==2022.12.0 climetlab==0.24.0 climetlab-maelstrom-downscaling==0.4.0 \
#                 cfgrib==0.9.15.0 contourpy==1.3.0 protobuf==3.19.6 cartopy==0.21.0 \
#                 numpy==1.19.5 pandas==1.3.5 --use-feature=2020-resolver



RUN python -c "import dl4ds as dds; import climetlab as cml"