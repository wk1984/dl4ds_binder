FROM ubuntu/python:3.8-20.04_stable

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN which python
RUN python --version

RUN pip install dl4ds climetlab climetlab_maelstrom_downscaling scikit-learn