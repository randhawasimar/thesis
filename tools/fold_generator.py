import logging
import os
import sys

frmt = logging.Formatter(
    "%(asctime)s - %(levelname)s - %(processName)s (%(process)s) - %(threadName)s - %(module)s - %(filename)s - %(lineno)d - "
    "%(message)s", "%Y-%m-%d %H:%M:%S %Z")
h1 = logging.StreamHandler(sys.stdout)
h1.setFormatter(frmt)
log = logging.getLogger()
log.setLevel('INFO')
log.addHandler(h1)

import argparse

parser = argparse.ArgumentParser(description='Crops SROI (Sub-Region-of-Interest) images from larger ROI images.')
parser.add_argument('-I', '--input-dir', dest='input_dir', type=str, nargs=1, required=True)
parser.add_argument('-N', '--num-folds', dest='num_folds', type=int, nargs=1, required=True)
parser.add_argument('-S', '--seed', dest='seed', type=int, nargs=1, required=True)
parser.add_argument('-F', '--fold', dest='fold', type=int, nargs=1, required=True)
args = parser.parse_args()

input_dir = args.input_dir[0]
num_folds = args.num_folds[0]
seed = args.seed[0]
fold = args.fold[0]

import random

random.seed(seed)

class_to_img = dict()

# Iterate over class directories in input_dir
for class_name in os.listdir(input_dir):
    if not os.path.isdir(input_dir + '/' + class_name):
        continue
    
    img_list = list()
    class_to_img[class_name] = img_list
    # Iterate over images in a class directory
    for image_file in os.listdir(input_dir + '/' + class_name):
        if not (image_file.endswith('.jpg') or image_file.endswith('.png')):
            continue
        img_list.append('./' + class_name + '/' + image_file)

# remove pre-existing test/train files
for i in range(1, num_folds + 1):
    testfile = input_dir + '/test' + str(i) + '.txt'
    if os.path.exists(testfile):
        os.remove(testfile)
    trainfile = input_dir + '/train' + str(i) + '.txt'
    if os.path.exists(trainfile):
        os.remove(trainfile)
if os.path.isfile(input_dir + '/test.txt')
    os.remove(input_dir + '/test.txt')
if os.path.isfile(input_dir + '/train.txt')
    os.remove(input_dir + '/train.txt')

# maintain class index
class_index = 0
for class_name, img_list in class_to_img.items():
    # shuffle img_list
    random.shuffle(img_list)
    # these many minimum entries to write per fold
    num_min_entries_per_fold = int(len(img_list)/num_folds)
    # these many extra entries to write for all folds
    num_extra_entries_all_folds = len(img_list)%num_folds
    # intialize img_list index
    img_list_index = 0
    # populate test/train files
    for i in range(1, num_folds + 1):
        testfile = input_dir + '/test' + str(i) + '.txt'
        testfile_handler = open(testfile, "a") 
        trainfile = input_dir + '/train' + str(i) + '.txt'
        trainfile_handler = open(trainfile, "a") 
        # determine range of img_list indexes to be written in test fold
        img_list_test_range_left = img_list_index
        img_list_test_range_right = img_list_index + num_min_entries_per_fold + (1 if num_extra_entries_all_folds else 0) - 1
        # increment img_list_index
        img_list_index = img_list_test_range_right + 1
        log.debug('img_list_test_range_left: ' + str(img_list_test_range_left) + ', img_list_test_range_right: ' + str(img_list_test_range_right))
        for j in range(len(img_list)):
            if j < img_list_test_range_left or j > img_list_test_range_right:
                # write in train file
                trainfile_handler.write(img_list[j] + ' ' + str(class_index) + '\n')
            else:
                # write in test file
                testfile_handler.write(img_list[j] + ' ' + str(class_index) + '\n')
        # close test/train file handlers
        testfile_handler.close()
        trainfile_handler.close()

    # increment class index before moving to the next class
    class_index = class_index + 1

os.symlink('test' + str(fold) + '.txt', input_dir + '/test.txt')
os.symlink('train' + str(fold) + '.txt', input_dir + '/train.txt')

