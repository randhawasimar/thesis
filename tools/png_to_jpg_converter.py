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

parser = argparse.ArgumentParser(description='Converts PNG images in all sub-directories (1-level deep) to JPG. Retains the original Directory hierarchy (only 1-level deep) in the output.')
parser.add_argument('-I', '--input-dir', dest='input_dir', type=str, nargs=1)
parser.add_argument('-O', '--output-dir', dest='output_dir', type=str, nargs=1)
args = parser.parse_args()

input_dir = args.input_dir[0]
output_dir = args.output_dir[0]

import subprocess

for sub_dir in os.listdir(input_dir):
    if not os.path.isdir(input_dir + '/' + sub_dir):
        continue
    log.info('Processing images in sub-directory: ' + sub_dir)
    if not os.path.isdir(output_dir + '/' + sub_dir):
        log.info('Create directory: ' + output_dir + '/' + sub_dir)
        os.mkdir(output_dir + '/' + sub_dir)
    for img_with_ext in os.listdir(input_dir + '/' + sub_dir):
        if img_with_ext.endswith('.png'):
            img_png = img_with_ext
            img = img_png.rstrip('.png')
            img_jpg = img + '.jpg'
            bashCommand = 'convert ' + input_dir + '/' + sub_dir + '/' + img_png + ' ' + output_dir + '/' + sub_dir + '/' + img_jpg  
            process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
            output, error = process.communicate()
            if error:
                log.error('error during conversion')

