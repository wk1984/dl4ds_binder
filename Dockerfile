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

RUN mkdir -p $HOME/.jupyter

RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN pyenv install 3.9.13
RUN pyenv global 3.9.13
RUN pyenv rehash
RUN python --version
RUN pip install -U pip pipenv

RUN python -m pip install pip==20.2 # -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

RUN pip install --no-cache notebook==7.3.2 jupyterlab==4.3.4 jupyter-server==2.15.0 referencing==0.35.1 jupyter==1.1.1\
                           dl4ds \
                           tensorflow==2.6.0 keras==2.6.0 \
						   protobuf==3.19.6 pandas==1.3.5 matplotlib==3.4.3 numpy==1.19.5 \
						   scikit-learn python-json-logger==2.0.7 xarray==0.19.0 netCDF4==1.7.2 \
						   jupyter-server==2.15.0 typing-extensions==3.7.4.3 bokeh==3.4.3 \ 
						   Cartopy==0.21.0 scipy==1.7.1 eccodes==2.37.0 dask==2022.12.0 --use-feature=2020-resolver
#						   holoviews==1.20.0 -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# TEST ONLY:
# pip install --no-cache pyodc==1.4.1 websocket-client==1.9 notebook==7.3.2 jupyterlab==4.3.4 jupyter-server==2.15.0 jupyter-events==0.12.0 send2trash==1.8.3 referencing==0.35.1 jupyter==1.1.1 dl4ds tensorflow==2.6.0 keras==2.6.0 protobuf==3.19.6 pandas==1.3.5 matplotlib==3.4.3 numpy~=1.19.5 scikit-learn python-json-logger==2.0.7 xarray==0.19.0 netCDF4==1.7.2 jupyter-server==2.15.0 typing-extensions==3.7.4.3 bokeh==3.4.3 Cartopy==0.21.0 scipy==1.7.1 eccodes==2.37.0 dask==2022.12.0 --use-feature=2020-resolver

RUN pip install --no-cache pyodc==1.4.1 --use-feature=2020-resolver

RUN pip install --no-cache typing_extensions --upgrade --use-feature=2020-resolver

RUN pip install --no-cache --quiet climetlab

RUN pip install --no-cache --quiet climetlab_maelstrom_downscaling

# 必须要修改权限，否则JUPYTER停止后不能够重新启动
USER root
RUN chown -R user:user $HOME/
RUN chmod -R u+rwx $HOME/

RUN mkdir -p /workdir
RUN chown -R user:user /workdir
RUN chmod -R u+rwx /workdir

# 7. Expose the default Jupyter port
EXPOSE 8888

# 设置工作目录
USER user
WORKDIR /workdir

# CMD ["jupyter-lab",  "--ip=0.0.0.0"  , "--no-browser"]


# conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0 python=3.9
# pip install tensorflow==2.6 keras==2.6 dl4ds "numpy<2"