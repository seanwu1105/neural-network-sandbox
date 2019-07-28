import time
import math
import operator

import numpy as np

from . import TraningAlgorithm
from ..neurons import SomNeuron
from ..utils import dist, flatten


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
        data_range = tuple(zip(np.amin(self._dataset[:, :-1], axis=0),
                               np.amax(self._dataset[:, :-1], axis=0)))
        self._neurons = [[SomNeuron(data_range)
                          for _ in range(self.topology_shape[0])]
                         for _ in range(self.topology_shape[1])]

    def _iterate(self):
        self._feed_forward()
        winner = self._get_winner()
        self._adjust_synaptic_weight(winner)

    def _feed_forward(self):
        for row in self._neurons:
            for neuron in row:
                neuron.data = self.current_data[:-1]

    def _get_winner(self):
        return min(flatten(self._neurons), key=operator.attrgetter('dist'))

    def _adjust_synaptic_weight(self, winner: SomNeuron):
        for i, row in enumerate(self._neurons):
            if winner in row:
                winner_index = (i, row.index(winner))
                break

        for i, row in enumerate(self._neurons):
            for j, neuron in enumerate(row):
                neuron.synaptic_weight += (
                    self.current_learning_rate
                    * math.exp(-dist(winner_index, (i, j))**2
                               / (2 * self.current_standard_deviation**2))
                    * (self.current_data[:-1] - neuron.synaptic_weight)
                )

    @property
    def current_data(self):
        return self._dataset[self.current_iterations % len(self._dataset)]

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate * math.exp(
            -self.current_iterations /
            (self._total_epoches * len(self._dataset))
        )

    @property
    def current_standard_deviation(self):
        return self._initial_standard_deviation * math.exp(
            -self.current_iterations /
            (self._total_epoches * len(self._dataset))
        )
