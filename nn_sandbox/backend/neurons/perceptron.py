import numpy as np

from . import AbstractNeuron


class Perceptron(AbstractNeuron):
    def __init__(self, activation_function):
        super().__init__()
        self._activation_function = activation_function

    @property
    def data(self):
        return self._data

    @data.setter
    def data(self, value):
        if self._data is None:
            self._data = value
            self._data = np.insert(self._data, 0, -1)
        else:
            self._data[1:] = value
        if self.synaptic_weight is None:
            self.synaptic_weight = np.random.uniform(-1, 1, len(self.data))

    @property
    def result(self):
        return self._activation_function(np.dot(self.synaptic_weight, self.data))
