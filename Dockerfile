#FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
FROM ubuntu:20.04

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

# RUN python3 -V

# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh -O ~/miniforge.sh \
# RUN wget --quiet https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_23.9.0-0-Linux-x86_64.sh -O ~/miniforge.sh \
#RUN wget --quiet https://gh-proxy.com/https://github.com/conda-forge/miniforge/releases/download/4.12.0-0/Mambaforge-4.12.0-0-Linux-x86_64.sh -O ~/miniforge.sh \
#    && /bin/bash ~/miniforge.sh -b -p /opt/miniforge \
#    && rm ~/miniforge.sh \
#    && ln -s /opt/miniforge/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
#    && echo ". /opt/miniforge/etc/profile.d/conda.sh" >> ~/.bashrc

#ENV PATH=/opt/miniforge/bin:${PATH}
#ARG PATH=/opt/miniforge/bin:${PATH}
#ENV HDF5_DIR=/opt/miniforge/
#ENV NETCDF4_DIR=/opt/miniforge/ 
ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN useradd -m -s /bin/bash user && echo "user:111" | chpasswd
RUN usermod -aG sudo user
USER user

# 配置PYTHON环境  

ENV HOME=/home/user
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://gh-proxy.com/https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN git clone https://gh-proxy.com/https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN pyenv install 3.9.13
RUN pyenv global 3.9.13
RUN pyenv rehash
RUN python --version
RUN pip install -U pip pipenv

# RUN . /root/.bashrc \
#     && /opt/miniforge/bin/conda init bash \
#     && conda info --envs \
#     && conda update -n base -c defaults conda \
# #    && conda config --set custom_channels.conda-forge https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/ \
#     && conda install -c conda-forge mamba -y
# 
RUN python -m pip install pip==20.2 # -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN pip install --no-cache notebook==7.3.2 jupyterlab==4.3.4 jupyter-server==2.15.0 referencing==0.35.1 jupyter==1.1.1\
                           dl4ds \
                           tensorflow==2.6.0 keras==2.6.0 \
						   protobuf==3.19.6 pandas==1.3.5 matplotlib==3.4.3 numpy==1.19.5 \
						   scikit-learn python-json-logger==2.0.7 xarray==0.19.0 netCDF4==1.7.2 \
						   jupyter-server==2.15.0 typing-extensions==3.7.4.3 bokeh==3.4.3 \ 
						   Cartopy==0.21.0 holoviews==1.20.0 scipy==1.7.1 eccodes==2.37.0
#						   -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN pip install --no-cache pyodc==1.4.1

RUN pip install --no-cache typing_extensions --upgrade --use-feature=2020-resolver

RUN pip install --no-cache --quiet climetlab

RUN pip install --no-cache --quiet climetlab_maelstrom_downscaling
 
# RUN python -c "import dl4ds as dds; import climetlab as cml"
# notebook==7.3.2 jupyter==1.1.1 jupyterlab==4.3.4 jupyter-server==2.15.0 referencing==0.35.1 typing-extensions==3.7.4.3 python-json-logger==2.0.7