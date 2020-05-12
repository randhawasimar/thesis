import logging
import os
import sys
import matplotlib.pyplot as plt

frmt = logging.Formatter(
    "%(asctime)s - %(levelname)s - %(processName)s (%(process)s) - %(threadName)s - %(module)s - %(filename)s - %(lineno)d - "
    "%(message)s", "%Y-%m-%d %H:%M:%S %Z")
h1 = logging.StreamHandler(sys.stdout)
h1.setFormatter(frmt)
log = logging.getLogger()
log.setLevel('INFO')
log.addHandler(h1)

import argparse

parser = argparse.ArgumentParser(description='Plot mean range plots for each column in the CSV file. Multiple classes plotted as distinct series in the mean range plot.')
parser.add_argument('-I', '--input-file', dest='input_file', type=str, nargs=1, required=True)
parser.add_argument('-O', '--output-dir', dest='output_dir', type=str, nargs=1, required=True)
parser.add_argument('-P', '--plot-type', dest='plot_type', type=str, nargs=1, required=True)
args = parser.parse_args()

input_file = args.input_file[0]
output_dir = args.output_dir[0]
plot_type = args.plot_type[0]

csv_file_exists = os.path.isfile(input_file)
if not csv_file_exists:
    log.error('file ' + str(input_file) + ' does not exist.')
    os._exit()

import statistics
import csv

# Populate plot names for each column
column_names = {}
with open(input_file, 'r') as csv_file_handler:
    reader = csv.reader(csv_file_handler, delimiter=',')
    for index_row, row in enumerate(reader):
        if index_row == 0:
            for index_column, column in enumerate(row):
                column_names[index_column] = column

    log.info('column_names: ' + str(column_names))

# Populate class names for each row
class_names = {}
with open(input_file, 'r') as csv_file_handler:
    reader = csv.reader(csv_file_handler, delimiter=',')
    for index_row, row in enumerate(reader):
        if index_row == 0:
            continue
        for index_column, column in enumerate(row):
            if index_column == 0:
                class_names[index_row] = column
                break

    log.info('class_names ' + str(class_names))
                
# Populate metrics for each class
feature_class_metrics = {}
with open(input_file, 'r') as csv_file_handler:
    reader = csv.reader(csv_file_handler, delimiter=',')
    for index_row, row in enumerate(reader):
        if index_row == 0:
            continue
        class_name = class_names[index_row]
        for index_column, column in enumerate(row):
            feature_name = column_names[index_column] 
            if index_column == 0:
                continue
            try:
                metric = float(column)
            except:
                metric = 0
            if feature_name not in feature_class_metrics:
                feature_class_metrics[feature_name] = {class_name: [metric]}
            else:
                class_metrics = feature_class_metrics[feature_name]
                if class_name not in class_metrics:
                    class_metrics[class_name] = [metric]
                else:
                    class_metrics[class_name].append(metric)

    log.info('feature_class_metrics ' + str(feature_class_metrics))

# Generate plots
if plot_type == 'Mean_Range':
    for feature_name, class_metrics in feature_class_metrics.items():
        x = []
        x_labels = []
        x_i = 0
        y = []
        lower_err = []
        upper_err = []
        err = [lower_err, upper_err]
        log.info('feature_name: ' + str(feature_name) + ' class_metrics: ' + str(class_metrics))
        for class_name, metrics in class_metrics.items():
            mean = statistics.mean(metrics)
            metric_min = min(metrics)
            metric_max = max(metrics)
            x_labels.append(class_name)
            x_i = x_i + 1
            x.append(x_i * 10 / (len(class_metrics) + 2))
            y.append(mean)
            log.info('feature_name: ' + str(feature_name) + ', metric_min: ' + str(metric_min) + ', metric_max: ' + str(metric_max))
            lower_err.append(mean - metric_min)
            upper_err.append(metric_max - mean)

        f = plt.figure()
        plt.plot(x,y, 'bo', label='')
        plt.ylim(0, 1)
        plt.xlim(0, 9)
        plt.xticks(x, x_labels)
        plt.xlabel('Class')
        plt.title(feature_name)
        plt.legend()
        plt.errorbar(x, y, yerr=err, xerr=None, fmt='', ecolor=None, elinewidth=None, capsize=None, barsabove=False, lolims=False, uplims=False, xlolims=False, xuplims=False, errorevery=1, capthick=None, hold=None, data=None, linestyle='None')

        f.savefig(output_dir + '/' + feature_name.replace('/', '.') + '.pdf', bbox_inches='tight')
elif plot_type == 'Box_Plot':
    for feature_name, class_metrics in feature_class_metrics.items():
        x = []
        y = []
else:
    log.error('unknown plot type: '+str(plot_type))
