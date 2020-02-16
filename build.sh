set -x
set -e

cd caffe
docker build . -t caffe:cuda-10.2
cd ..
cd tcnn
docker build . -t tcnn-trainer
cd ..
