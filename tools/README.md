## Description for png_to_jpg_converter.py

### What it does?
* Converts PNG images in all sub-directories (1-level deep) to JPG. Retains the original Directory hierarchy (only 1-level deep) in the output.

### INPUT:
* Input Directory -I, --input-dir
* Output Directory -O, --output-dir

## Description for sub_roi_generator.py

### What it does?
* Crops SROI (Sub-Region-of-Interest) images from larger ROI images.

### INPUT:
* Input Directory -I, --input-dir
* Output Directory -O, --output-dir
* Square Size -S, --square-size

### Directory Structure Format (Input):
```
  ./<class 1>
    ./<img 1>.jpg
    ./<img 2>.jpg
    ...
    ./<img m>.jpg
  ./<class 2>
  ...
  ./<class n>
```

### Directory Structure Format (Output):
```
  ./<class 1>
    # sroi's from img 1
      ./<img 1>_<sroi 1>.jpg
      ./<img 1>_<sroi 2>.jpg
      ...
      ./<img 1>_<sroi l>.jpg
    # sroi's from img 2
      ./<img 2>_<sroi 1>.jpg
      ./<img 2>_<sroi 2>.jpg
      ...
      ./<img 2>_<sroi l>.jpg
    ...
    # sroi's from img m
      ./<img m>_<sroi 1>.jpg
      ./<img m>_<sroi 2>.jpg
      ...
      ./<img m>_<sroi l>.jpg
  ./<class 2>
  ...
  ./<class n>
```

## Description for fold_generator.py

### What it does?
* Generate n-folds for a dataset of images. The n-folds are in Caffe compatible format of test and equivalent train datasets for each fold.

### INPUT:
* Input Directory -I, --input-dir
* Number of Folds -N, --num-folds
* Randomization Seed -S, --seed

### Directory Structure Format (Before):
```
  ./<class 1>
    ./<img 1>.jpg
    ./<img 2>.jpg
    ...
    ./<img m>.jpg
  ./<class 2>
  ...
  ./<class n>
```

### Directory Structure Format (After):
```
  ./<class 1>
    ./<img 1>.jpg
    ./<img 2>.jpg
    ...
    ./<img m>.jpg
  ./<class 2>
  ...
  ./<class n>
  test1.txt
  train1.txt
  ...
  testn.txt
  trainn.txt
```
