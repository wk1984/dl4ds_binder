# =====================================================================
# Stage 1: The Builder Stage
# 使用包含完整编译工具的 devel 镜像来安装所有依赖和编译代码
# =====================================================================
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# 1. 安装系统级依赖
# --no-install-recommends 避免安装不必要的包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        wget \
        ffmpeg \
        libsm6 \
        libxext6 \
        libgeos-dev \
        libproj-dev \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev \
        liblzma-dev && \
    # 清理 apt 缓存，减小这一层的大小
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. 安装并配置 Mambaforge (比 Conda 更快的包管理器)
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# 使用 Mambaforge 来加速环境创建
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-25.3.0-3-Linux-x86_64.sh -O ~/mambaforge.sh && \
    /bin/bash ~/mambaforge.sh -b -p $CONDA_DIR && \
    rm ~/mambaforge.sh && \
    # 初始化 Conda，并清理缓存
    conda init bash && \
    conda clean -afy

# 3. 安装所有 Python 依赖
# 将所有 pip install 合并到单个 RUN 指令中，以减少镜像层数
# 使用 --no-cache-dir 来避免缓存
RUN conda create -n py39 python=3.9.13 -y && \
    # 激活环境
    . "$CONDA_DIR/bin/activate" py39 && \
#     pip install --no-cache-dir -U pip && \
#    python -m pip install pip==20.2 && \
    pip install --no-cache-dir \
        notebook==7.3.2 \
        jupyterlab==4.3.4 \
        jupyter-server==2.15.0 \
        referencing==0.35.1 \
        jupyter==1.1.1 \
        dl4ds \
        tensorflow==2.6.0 \
        keras==2.6.0 \
        protobuf==3.19.6 \
        pandas==1.3.5 \
        matplotlib==3.4.3 \
        numpy==1.19.5 \
        scikit-learn \
        python-json-logger==2.0.7 \
        xarray==0.19.0 \
        netCDF4==1.7.2 \
        typing-extensions==3.7.4.3 \
        bokeh==3.4.3 \
        Cartopy==0.21.0 \
        holoviews==1.20.0 \
        scipy==1.7.1 \
        eccodes==2.37.0 \
        dask==2022.12.0 \
#         pyodc==1.4.1 \
#         climetlab \
#         climetlab_maelstrom_downscaling 
#        -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple && \
    # 再次清理所有缓存
    conda clean -afy
    
RUN pip install --no-cache pyodc==1.4.1 --use-feature=2020-resolver
RUN pip install --no-cache typing_extensions --upgrade --use-feature=2020-resolver
RUN pip install --no-cache --quiet climetlab
RUN pip install --no-cache --quiet climetlab_maelstrom_downscaling

# =====================================================================
# Stage 2: The Final Runtime Stage
# 使用一个更小的 runtime 基础镜像，只包含运行应用所需的内容
# =====================================================================
FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

# 仅安装运行时的系统依赖，无需 build-essential, cmake, -dev 等包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libsm6 \
        libxext6 \
        libgeos-c1v5 \
        libproj15 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV HOME=/home/user
WORKDIR $HOME

# 创建一个非 root 用户来运行应用，这是安全最佳实践
RUN useradd -m -s /bin/bash user && \
    chown -R user:user $HOME

# 从 builder 阶段复制已经安装好的 Conda 环境
COPY --from=builder $CONDA_DIR $CONDA_DIR
# 确保新用户拥有 Conda 目录的权限
RUN chown -R user:user $CONDA_DIR

# 切换到非 root 用户
USER user

# 暴露端口
EXPOSE 8888

# 设置默认启动命令
CMD ["jupyter-lab", "--ip=0.0.0.0", "--no-browser", "--notebook-dir=$HOME"]