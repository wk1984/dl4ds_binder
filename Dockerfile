# 使用带有CUDA的官方PyTorch镜像作为基础
FROM tensorflow/tensorflow:2.13.0-gpu-jupyter
# FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/tensorflow/tensorflow:2.6.0-gpu

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN apt-get update && \
    apt-get install -y libgeos++-dev ffmpeg libsm6 libxext6 nano
	
RUN python --version

RUN pip install climetlab climetlab_maelstrom_downscaling

RUN python -c "import climetlab as cml; \
               cmlds_train = cml.load_dataset("maelstrom-downscaling", dataset="training"); \
               cmlds_val = cml.load_dataset("maelstrom-downscaling", dataset="validation"); \
               cmlds_test = cml.load_dataset("maelstrom-downscaling", dataset="testing"); \
               t2m_hr_train = cmlds_train.to_xarray().t2m_tar"

# RUN python -c "import tensorflow as tf; tf.config.list_physical_devices('GPU')"