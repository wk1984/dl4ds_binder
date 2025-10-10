FROM condaforge/mambaforge:4.9.2-7

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN pip install cartopy --no-binary :all:

RUN pip install dl4ds climetlab climetlab_maelstrom_downscaling scikit-learn jupyterlab notebook

# 7. Expose the default Jupyter port
EXPOSE 8888

# 设置工作目录
WORKDIR /home

CMD ["jupyter-lab",  "--ip=0.0.0.0"  , "--no-browser" ,  "--allow-root"]