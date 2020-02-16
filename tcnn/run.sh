set -x
set -e

. ./create_kth.sh
. ./make_kth_mean.sh
caffe train -solver ./solver_tcnn3.prototxt -weights ./tcnn3.caffemodel
