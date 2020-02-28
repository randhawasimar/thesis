#!/usr/bin/env sh
# Compute the mean image from the 4 kth training lmdbs (4 folds)
# N.B. this is available in EXAMPLE/kth-tips-2b

EXAMPLE=/workspace/examples/
TOOLS=/opt/caffe/build/tools/

$TOOLS/compute_image_mean $EXAMPLE/kth_train_lmdb \
  $EXAMPLE/kth_mean.binaryproto

echo "Mean files created."
