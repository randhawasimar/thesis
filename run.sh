set -x
set -e

THESIS_TCNN_SQUARE_SIZE=${THESIS_TCNN_SQUARE_SIZE:-32}
THESIS_TCNN_SEED=${THESIS_TCNN_SEED:-0}
THESIS_TCNN_NUM_FOLDS=${THESIS_TCNN_NUM_FOLDS:-4}

if [ ! -d "data-transforms/rois-jpg" ]; then
  mkdir -p data-transforms/rois-jpg
fi

if [ ! -d "data-transforms/rois-sub" ]; then
  mkdir -p data-transforms/rois-sub
fi
#mkdir results #TODO: write results to a csv file here

python ./tools/png_to_jpg_converter.py -I ./data/rois/ -O ./data-transforms/rois-jpg/
python ./tools/sub_roi_generator.py -I ./data-transforms/rois-jpg/ -O ./data-transforms/rois-sub/ -S ${THESIS_TCNN_SQUARE_SIZE}
python ./tools/fold_generator.py -I ./data-transforms/rois-sub/ -N ${THESIS_TCNN_NUM_FOLDS} -S ${THESIS_TCNN_SEED}

docker run --gpus all -v $(pwd)/data-transforms/rois-sub/:/workspace/data/ tcnn-trainer
