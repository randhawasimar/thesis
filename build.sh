set -x

docker build . -t caffe:cuda-10.2
docker build . -t tcnn-trainer
