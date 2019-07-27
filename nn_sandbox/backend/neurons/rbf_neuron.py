import numpy as np

from . import Perceptron

from ..utils import gaussian


class RbfNeuron(Perceptron):
    def __init__(self, mean=None, standard_deviation=None,
                 activation_function=gaussian, is_threshold=False):
        super().__init__(activation_function)
        self.mean = mean
        self.standard_deviation = standard_deviation
        self.is_threshold = is_threshold
        self.synaptic_weight = np.random.uniform(-1, 1)

    @property
    def data(self):
        return self._data

    @data.setter
    def data(self, value):
        self._data = value

    @property
    def result(self):
        if self.is_threshold:
            return self.synaptic_weight
        return self.synaptic_weight * self.activation_function(
            self.data, self.mean, self.standard_deviation
        )
