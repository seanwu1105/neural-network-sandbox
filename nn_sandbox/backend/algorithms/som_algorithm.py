import math

from . import TraningAlgorithm


class SomAlgorithm(TraningAlgorithm):
    def __init__(self, dataset, total_epoches=10, initial_learning_rate=0.8,
                 initial_standard_deviation=1, topology_shape=None):
        super().__init__(dataset, total_epoches)
        self._initial_learning_rate = initial_learning_rate
        self._initial_standard_deviation = initial_standard_deviation

        # the default topology shape is (10 * 10)
        self.topology_shape = topology_shape if topology_shape else [10, 10]

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate * math.exp(
            -self.current_iterations
            / (self._total_epoches * len(self._dataset))
        )
