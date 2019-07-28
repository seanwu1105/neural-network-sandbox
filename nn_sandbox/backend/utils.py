import pathlib
import math

import numpy as np


def sign(value):
    return 1 if value >= 0 else -1


def sigmoid(value):
    return 1 / (1 + math.exp(-value))


def gaussian(value: np.ndarray, mean: np.ndarray, standard_deviation):
    if standard_deviation == 0:
        return 0
    return math.exp((value - mean).dot(value - mean) / (-2 * standard_deviation**2))


def dist(p1, p2):
    return sum((x1 - x2)**2 for x1, x2 in zip(p1, p2))**0.5


def flatten(list_or_tuple):
    for element in list_or_tuple:
        if isinstance(element, (list, tuple)):
            yield from flatten(element)
        else:
            yield element


def read_data(folder='nn_sandbox/assets/data'):
    data = {}
    for filepath in pathlib.Path(folder).glob('**/*.txt'):
        with filepath.open() as file_object:
            # make sure the data is stored in native Python type in order to
            # communicate with QML.
            data[filepath.stem] = np.loadtxt(file_object).tolist()
    return data
