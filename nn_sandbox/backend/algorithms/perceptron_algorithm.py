from . import PredictiveAlgorithm
from ..neurons import Perceptron
from ..utils import sign


class PerceptronAlgorithm(PredictiveAlgorithm):
    def __init__(self, dataset, total_epoches=10, most_correct_rate=None,
                 initial_learning_rate=0.5, search_iteration_constant=1000,
                 test_ratio=0.3):
        super().__init__(dataset, total_epoches, most_correct_rate,
                         initial_learning_rate, search_iteration_constant,
                         test_ratio)

        self._initialize_neurons()

    def iterate(self):
        self._feed_forward(self.current_data[:-1])
        self._adjust_synaptic_weights()

    def _initialize_neurons(self):
        if len(self.group_types) <= 2:
            self._neurons = [Perceptron(sign)]
        else:
            self._neurons = [Perceptron(sign)
                             for _ in range(len(self.group_types))]

    def _feed_forward(self, data):
        for neuron in self._neurons:
            neuron.data = data

    def _adjust_synaptic_weights(self):
        expect = self.current_data[-1]
        for idx, neuron in enumerate(self._neurons):
            if neuron.result == 1 and expect != self.group_types[idx]:
                neuron.synaptic_weight -= self.current_learning_rate * neuron.data
            elif neuron.result == -1 and expect == self.group_types[idx]:
                neuron.synaptic_weight += self.current_learning_rate * neuron.data

    def _correct_rate(self, dataset):
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
