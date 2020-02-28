set -x
set -e

export THESIS_TCNN_SQUARE_SIZE=${THESIS_TCNN_SQUARE_SIZE:-32}
export THESIS_TCNN_SEED=${THESIS_TCNN_SEED:-0}
export THESIS_TCNN_NUM_FOLDS=${THESIS_TCNN_NUM_FOLDS:-4}
export THESIS_TCNN_FOLD=${THESIS_TCNN_FOLD:-1}

if [ ! -d "data-transforms/rois-jpg" ]; then
  mkdir -p data-transforms/rois-jpg
fi

if [ ! -d "data-transforms/rois-sub" ]; then
  mkdir -p data-transforms/rois-sub
fi

# removing previous accuracy file
if [ -e "data-transforms/rois-sub/accuracy.out" ]; then
  rm -f data-transforms/rois-sub/accuracy.out
fi

python ./tools/png_to_jpg_converter.py -I ./data/rois/ -O ./data-transforms/rois-jpg/
python ./tools/sub_roi_generator.py -I ./data-transforms/rois-jpg/ -O ./data-transforms/rois-sub/ -S ${THESIS_TCNN_SQUARE_SIZE}
python ./tools/fold_generator.py -I ./data-transforms/rois-sub/ -N ${THESIS_TCNN_NUM_FOLDS} -S ${THESIS_TCNN_SEED} -F ${THESIS_TCNN_FOLD}

docker run --gpus all -v $(pwd)/data-transforms/rois-sub/:/workspace/data/ tcnn-trainer

python ./tools/write_results_to_csv.py -A ./data-transforms/rois-sub/accuracy.out -C ./data-transforms/rois-sub/results.csv
