import pathlib

import numpy as np


def sign(value):
    return 1 if value >= 0 else -1


def read_data(folder='nn_sandbox/assets/data'):
    data = {}
    for filepath in pathlib.Path(folder).glob('**/*.txt'):
        with filepath.open() as file_object:
            # make sure the data is stored in native Python type in order to
            # communicate with QML.
            data[filepath.stem] = np.loadtxt(file_object).tolist()
    return data
