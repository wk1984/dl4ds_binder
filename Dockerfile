FROM condaforge/mambaforge:4.9.2-7

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN conda install -c conda-forge jupyterlab==4.3.4 jupyter==1.1.1 notebook==7.3.2 cython==3.0.11 shapely==1.8.4 cartopy==0.21.0 numpy==1.19.5 pandas==1.3.5 scipy==1.7.1 matplotlib==3.4.3 xarray==0.19.0 tensorflow==2.6.0 tensorflow-gpu==2.6.0 tensorflow-estimator==2.6.0 keras==2.6.0 scikit-learn==1.0 joblib==1.1.1 seaborn==0.11.2 absl-py==0.14.1 -y

#RUN pip install dl4ds climetlab climetlab_maelstrom_downscaling scikit-learn jupyterlab notebook

# 7. Expose the default Jupyter port
#EXPOSE 8888

# 设置工作目录
#WORKDIR /home

#CMD ["jupyter-lab",  "--ip=0.0.0.0"  , "--no-browser" ,  "--allow-root"]