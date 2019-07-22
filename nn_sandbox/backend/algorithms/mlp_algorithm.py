import collections

import numpy as np

from . import PredictiveAlgorithm
from ..neurons import Perceptron
from ..utils import sigmoid


class MlpAlgorithm(PredictiveAlgorithm):
    """ Backpropagation prototype. """

    def __init__(self, dataset, total_epoches=10, most_correct_rate=None,
                 initial_learning_rate=0.8, search_iteration_constant=10000,
                 momentum_weight=0.5, test_ratio=0.3, network_shape=None):
        super().__init__(dataset, total_epoches, most_correct_rate,
                         initial_learning_rate, search_iteration_constant,
                         test_ratio)
        self._momentum_weight = momentum_weight

        # the default network shape is (2 * 5)
        self._initialize_neurons(network_shape if network_shape else (5, 5))

        # for momentum
        self._synaptic_weight_diff = collections.defaultdict(lambda: 0)

    def iterate(self):
        result = self._feed_forward(self.current_data[:-1])
        deltas = self._pass_backward(self._normalize(self.current_data[-1]),
                                     result)
        self._adjust_synaptic_weights(deltas)

    def _initialize_neurons(self, shape):
        """ Build the neuron network with single neuron as output layer. """
        self._neurons = tuple((Perceptron(sigmoid),) * size
                              for size in list(shape) + [1])

    def _feed_forward(self, data):
        results = [None]
        for idx, layer in enumerate(self._neurons):
            if idx == 0:
                results = get_layer_results(layer, data)
                continue
            results = get_layer_results(layer, results)
        return results[0]

    def _pass_backward(self, expect, result):
        """ Calculate the delta for each neuron. """
        deltas = {}

        deltas[self._neurons[-1][0]] = ((expect - result)
                                        * result * (1 - result))

        for layer_idx, layer in reversed(tuple(enumerate(self._neurons[:-1]))):
            for neuron_idx, neuron in enumerate(layer):
                deltas[neuron] = (
                    # sum of (delta) * (synaptic weight) for each neuron in next layer
                    sum(deltas[n] * n.synaptic_weight[neuron_idx]
                        for n in self._neurons[layer_idx + 1])
                    * neuron.result
                    * (1 - neuron.result)
                )
        return deltas

    def _adjust_synaptic_weights(self, deltas):
        for neuron in deltas:
            self._synaptic_weight_diff[neuron] = (
                self._synaptic_weight_diff[neuron] * self._momentum_weight
                + self.current_learning_rate * deltas[neuron] * neuron.data
            )
            neuron.synaptic_weight += self._synaptic_weight_diff[neuron]

    def _correct_rate(self, dataset):
        if not self._neurons:
            return 0
        correct_count = 0
        for data in dataset:
            self._feed_forward(data[:-1])
            expect = self._normalize(data[-1])
            interval = 1 / (2 * len(self.group_types))
            if expect - interval < self._neurons[-1][0].result < expect + interval:
                correct_count += 1
        if correct_count == 0:
            return 0
        return correct_count / len(dataset)

    def _normalize(self, value):
        """ Normalize expected output. """
        return (2 * (value - np.amin(self.group_types)) + 1) / (2 * len(self.group_types))


def get_layer_results(layer, data):
    for neuron in layer:
        neuron.data = data
    return np.fromiter((neuron.result for neuron in layer), dtype=float)
