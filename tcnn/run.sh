set -x
set -e

. ./create_kth.sh
. ./make_kth_mean.sh
caffe train -solver ./solver_tcnn3.prototxt -weights ./tcnn3.caffemodel 2>&1 | tee /workspace/data/trainer.out

cat /workspace/data/trainer.out| tail -n 5|grep accuracy>/workspace/data/accuracy.out
