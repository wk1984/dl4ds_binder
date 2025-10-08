# 使用带有CUDA的官方PyTorch镜像作为基础
FROM tensorflow/tensorflow:2.16.0-gpu
# FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/tensorflow/tensorflow:2.6.0-gpu

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN apt-get update && \
    apt-get install -y libgeos++-dev ffmpeg libsm6 libxext6 nano
	
RUN python --version

# RUN pip install dl4ds climetlab==0.24.0 pyodc==1.4.1 h5py==3.1.0 scikit-learn opencv-python cartopy==0.21.0

# RUN python -c "import dl4ds as dds; import climetlab as cml"

# RUN python -c "import tensorflow as tf; tf.config.list_physical_devices('GPU')"