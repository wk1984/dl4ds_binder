https://mybinder.org/v2/gh/wk1984/dl4ds_binder/HEAD?urlpath=%2Fdoc%2Ftree%2FDL4DS_tutorial.ipynb


python -c "import dl4ds as dss;import climetlab as cml; \
              cmlds_train = cml.load_dataset("maelstrom-downscaling-tier1", dataset="training");\
              cmlds_val = cml.load_dataset("maelstrom-downscaling-tier1", dataset="validation");\
              cmlds_test = cml.load_dataset("maelstrom-downscaling-tier1", dataset="testing");\
              t2m_hr_train = cmlds_train.to_xarray().t2m_tar"
