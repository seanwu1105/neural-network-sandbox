import math

import numpy as np

from . import TraningAlgorithm


class SomAlgorithm(TraningAlgorithm):
    def __init__(self, dataset, total_epoches=10, initial_learning_rate=0.8,
                 initial_standard_deviation=1, topology_shape=None):
        super().__init__(dataset, total_epoches)
        self._initial_learning_rate = initial_learning_rate
        self._initial_standard_deviation = initial_standard_deviation

        # the default topology shape is (10 * 10)
        self.topology_shape = topology_shape if topology_shape else [10, 10]

        self.current_iterations = 0

    def run(self):
        self._initialize_neurons()
        for self.current_iterations in range(self._total_epoches * len(self._dataset)):
            if self._should_stop:
                break
            if self.current_iterations % len(self._dataset) == 0:
                np.random.shuffle(self._dataset)
            self._iterate()

    def _initialize_neurons(self):
        pass

    def _iterate(self):
        pass

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate * math.exp(
            -self.current_iterations
            / (self._total_epoches * len(self._dataset))
        )
