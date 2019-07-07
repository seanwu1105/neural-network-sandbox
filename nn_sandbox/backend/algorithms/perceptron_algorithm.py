import numpy as np

from . import PredictionAlgorithm
from ..neurons import Perceptron


class PerceptronAlgorithm(PredictionAlgorithm):
    def __init__(self, dataset, total_iterations=2000, most_correct_rate=None,
                 initial_learning_rate=0.5, search_iteration_constant=1000,
                 test_ratio=0.3):
        super().__init__(dataset, total_iterations, most_correct_rate, test_ratio)
        self._initial_learning_rate = initial_learning_rate
        self._search_iteration_constant = search_iteration_constant

        self._initialize_neurons()

    def iterate(self):
        self._feed_forward(self.current_data[:-1])
        self._adjust_synaptic_weights()

    def test(self):
        return self.correct_rate(self.testing_dataset)

    @property
    def current_data(self):
        return self.training_dataset[self.current_iterations % len(self.training_dataset)]

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate / (1 + self.current_iterations / self._search_iteration_constant)

    def correct_rate(self, dataset):
        correct_count = 0
        for data in dataset:
            for idx, neuron in enumerate(self._neurons):
                self._feed_forward(data[:-1])
                if ((neuron.result == 1 and data[-1] == self.group_types[idx]) or
                        (neuron.result == -1 and data[-1] != self.group_types[idx])):
                    correct_count += 1
        if correct_count == 0:
            return 0
        return correct_count / (len(dataset) * len(self._neurons))

    def _initialize_neurons(self):
        if len(self.group_types) <= 2:
            self._neurons = [Perceptron()]
        else:
            self._neurons = [Perceptron()
                             for _ in range(len(self.group_types))]

    def _feed_forward(self, data):
        for neuron in self._neurons:
            neuron.data = data

    def _adjust_synaptic_weights(self):
        for idx, neuron in enumerate(self._neurons):
            if neuron.result == 1 and self.current_data[-1] != self.group_types[idx]:
                neuron.synaptic_weight -= self.current_learning_rate * neuron.data
            elif neuron.result == -1 and self.current_data[-1] == self.group_types[idx]:
                neuron.synaptic_weight += self.current_learning_rate * neuron.data

    def _save_best_neurons(self):
        current_correct_rate = self.correct_rate(self.training_dataset)
        if current_correct_rate > self.best_correct_rate:
            self.best_correct_rate = current_correct_rate
            self._best_synaptic_weights = [neuron.synaptic_weight
                                           for neuron in self._neurons]

    def _load_best_neurons(self):
        for neuron, synaptic_weight in zip(self._neurons, self._best_synaptic_weights):
            neuron.synaptic_weight = synaptic_weight
