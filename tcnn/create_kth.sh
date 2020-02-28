#!/usr/bin/env sh
# Create the kth lmdb inputs for all the 4 nfolds. The images are resized to 227x227.
# N.B. set the path to the kth train + val data dirs

EXAMPLE=/workspace/examples/
DATA=/workspace/data/
TOOLS=/opt/caffe/build/tools/

TRAIN_DATA_ROOT=$DATA/
VAL_DATA_ROOT=$DATA/

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=227
  RESIZE_WIDTH=227
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_kth.sh to the path" \
       "where the kth training data is stored."
  exit 1
fi

if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_kth.sh to the path" \
       "where the kth validation data is stored."
  exit 1
fi

# Fold 1
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $VAL_DATA_ROOT \
    $DATA/test.txt \
    $EXAMPLE/kth_test_lmdb

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $VAL_DATA_ROOT \
    $DATA/train.txt \
    $EXAMPLE/kth_train_lmdb

echo "lmdbs created."
