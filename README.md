# Thesis Project
## How to build
* `./build.sh`
* Build caffe container. Refer detailed [instructions](caffe/README.md#building-caffe-container) for custom builds.
* Build tcnn container. Refer detailed [instructions](tcnn/README.md#building-tcnn-container) for custom builds.
## How to run
* `./run.sh`
  * Parameters provided via environment variables:
    * THESIS_TCNN_SQUARE_SIZE=${THESIS_TCNN_SQUARE_SIZE:-32}
    * THESIS_TCNN_SEED=${THESIS_TCNN_SEED:-0}
    * THESIS_TCNN_NUM_FOLDS=${THESIS_TCNN_NUM_FOLDS:-4}
  * Installing dependencies for run.sh
    * `pip install -r requirements.txt`
* Refer detailed [instructions](tcnn/README.md#running-tcnn-container) for custom runs.

