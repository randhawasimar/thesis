set -x

THESIS_TCNN_SQUARE_SIZE=${THESIS_TCNN_SQUARE_SIZE:-32}
THESIS_TCNN_SEED=${THESIS_TCNN_SEED:-0}
THESIS_TCNN_NUM_FOLDS=${THESIS_TCNN_NUM_FOLDS:-4}

mkdir -p data_transforms/rois-jpg
mkdir -p data_transforms/rois-sub
#mkdir results #TODO: write results to a csv file here

python png_to_jpg_converter.py -I ./data/rois/ -O ./data-transforms/rois-jpg/
python sub_roi_generator.py -I ./data-transforms/rois-jpg/ -O ./data-transforms/rois-sub/ -S ${THESIS_TCNN_SQUARE_SIZE}
python fold_generator.py -I ./data-transforms/rois-sub/ -N ${THESIS_TCNN_NUM_FOLDS} -S ${THESIS_TCNN_SEED}

docker run -v ./data-transforms/rois-sub/:/workspace/data/ tcnn-trainer
