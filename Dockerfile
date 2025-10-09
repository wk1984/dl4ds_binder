FROM tensorflow/tensorflow:2.6.1-jupyter

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN which python
RUN python --version

RUN pip install dl4ds climetlab climetlab_maelstrom_downscaling scikit-learn