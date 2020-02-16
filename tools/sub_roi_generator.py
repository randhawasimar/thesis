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
parser.add_argument('-I', '--input-dir', dest='input_dir', type=str, nargs=1)
parser.add_argument('-O', '--output-dir', dest='output_dir', type=str, nargs=1)
parser.add_argument('-S', '--square-size', dest='square_size', type=int, nargs=1)
args = parser.parse_args()

input_dir = args.input_dir[0]
output_dir = args.output_dir[0]
square_size = args.square_size[0]

from PIL import Image

# Iterate over class directories in input_dir
for class_dir in os.listdir(input_dir):
    if not os.path.isdir(input_dir + '/' + class_dir):
        continue
    if not os.path.isdir(output_dir + '/' + class_dir):
        log.info('Create directory: ' + output_dir + '/' + class_dir)
        os.mkdir(output_dir + '/' + class_dir)
    # Iterate over images in a class directory
    for image_file in os.listdir(input_dir + '/' + class_dir):
        if not (image_file.endswith('.jpg') or image_file.endswith('.png')):
            continue
        tokens = image_file.rsplit('.', 1)
        image_name = tokens[0]
        image_ext = tokens[1]
        image = Image.open(input_dir + '/' + class_dir + '/' + image_file)
        if square_size > image.height or square_size > image.width:
            log.warn('Sub ROI square size: ' + str(square_size) + ' is too large for image: ' +
                    image_name + ', image dimensions -- height: ' + str(image.height) + 
                    ', width: ' + str(image.width) + '. This image will be skipped.')
        # initialize y_pixel and roi_index
        y_pixel = 0
        roi_index = 0
        while y_pixel < image.height:
            # end vertical movement if sub_roi exceeding image height 
            if y_pixel + square_size > image.height:
                log.warn('discard ' + str(y_pixel + square_size - image.height) + ' lower pixels')
                break
            # initialize x_pixel
            x_pixel = 0
            while x_pixel < image.width:
                # end horizontal movement if sub_roi exceeding image width 
                if x_pixel + square_size > image.width:
                    log.warn('discard ' + str(x_pixel + square_size - image.width) + ' right pixels')
                    break
                # get sub roi
                sub_roi = image.crop((x_pixel, y_pixel, x_pixel + square_size, y_pixel + square_size))
                # save sub_roi in output dir
                sub_roi.save(output_dir + '/' + class_dir + '/' + image_name + '_' + str(roi_index) + '.' + image_ext)
                # increment roi index
                roi_index = roi_index + 1
                # horizontal movement
                x_pixel = x_pixel + square_size
            # vertical movement
            y_pixel = y_pixel + square_size

