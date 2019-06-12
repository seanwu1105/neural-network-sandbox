import numpy as np

from . import AbstractNeuron
from .. import utils


class Perceptron(AbstractNeuron):
    def __init__(self):
        super().__init__()
        self._activation_function = utils.sign

    @property
    def data(self):
        return self._data

    @data.setter
    def data(self, value):
        if self.synaptic_weight is None:
            self.synaptic_weight = np.random.uniform(-1, 1, len(value))
        self._data = value

    @property
    def result(self):
        return self._activation_function(np.dot(self.synaptic_weight, self.data))
