FROM condaforge/mambaforge:4.14.0-0

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

RUN pip install dl4ds climetlab climetlab_maelstrom_downscaling scikit-learn