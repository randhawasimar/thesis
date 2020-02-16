set -x

mkdir -p data_transforms/rois-jpg
mkdir -p data_transforms/rois-sub
#mkdir results #TODO: write results to a csv file here

python png_to_jpg_converter.py -I ./data/rois/ -O ./data-transforms/rois-jpg/
python sub_roi_generator.py -I ./data-transforms/rois-jpg/ -O ./data-transforms/rois-sub/ -S 32
python fold_generator.py -I ./data-transforms/rois-sub/ -N 4 -S 0

docker run -v ./data-transforms/rois-sub/:/workspace/data/ tcnn-trainer
