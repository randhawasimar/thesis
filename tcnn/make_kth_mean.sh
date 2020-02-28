#!/usr/bin/env sh
# Compute the mean image from the 4 kth training lmdbs (4 folds)
# N.B. this is available in EXAMPLE/kth-tips-2b

EXAMPLE=/workspace/examples/
TOOLS=/opt/caffe/build/tools/

$TOOLS/compute_image_mean $EXAMPLE/kth_train1_lmdb \
  $EXAMPLE/kth_mean1.binaryproto

$TOOLS/compute_image_mean $EXAMPLE/kth_train2_lmdb \
  $EXAMPLE/kth_mean2.binaryproto

$TOOLS/compute_image_mean $EXAMPLE/kth_train3_lmdb \
  $EXAMPLE/kth_mean3.binaryproto

$TOOLS/compute_image_mean $EXAMPLE/kth_train4_lmdb \
  $EXAMPLE/kth_mean4.binaryproto

# Link one fold
ln -f -s  kth_mean1.binaryproto $EXAMPLE/kth_mean.binaryproto

echo "Mean files created, fold 1 linked ."
