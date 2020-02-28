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

parser = argparse.ArgumentParser(description='Write results from Caffe training of TCNN network to a CSV file.')
parser.add_argument('-A', '--accuracy-file', dest='accuracy_file', type=str, nargs=1, required=True)
parser.add_argument('-C', '--csv-file', dest='csv_file', type=str, nargs=1, required=True)
args = parser.parse_args()

accuracy_file = args.accuracy_file[0]
csv_file = args.csv_file[0]

with open(accuracy_file, "r") as accuracy_file_handler:
    accuracy_lines = accuracy_file_handler.readlines()
    accuracy = 0
    for line in accuracy_lines:
        accuracy = float(line.split()[-1]) * 100
        break

THESIS_TCNN_SQUARE_SIZE = os.environ.get('THESIS_TCNN_SQUARE_SIZE')
THESIS_TCNN_SEED = os.environ.get('THESIS_TCNN_SEED')
THESIS_TCNN_NUM_FOLDS = os.environ.get('THESIS_TCNN_NUM_FOLDS')
THESIS_TCNN_FOLD = os.environ.get('THESIS_TCNN_FOLD')

# check if csv_file exists
csv_file_exists = os.path.isfile(csv_file)
import csv
with open(csv_file, "a") as csv_file_handler:
    writer = csv.writer(csv_file_handler)
    if not csv_file_exists:
        writer.writerow(['seed', 'square_size', 'num_folds', 'fold', 'accuracy'])
    writer.writerow([THESIS_TCNN_SEED, THESIS_TCNN_SQUARE_SIZE, THESIS_TCNN_NUM_FOLDS, THESIS_TCNN_FOLD, accuracy])
