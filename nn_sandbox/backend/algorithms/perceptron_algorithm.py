from . import PredictionAlgorithm
from ..neurons import Perceptron


class PerceptronAlgorithm(PredictionAlgorithm):
    def __init__(self, dataset, total_times=2000, most_correct_rate=None,
                 initial_learning_rate=0.5, search_time_constant=1000):
        super().__init__(dataset)
        self._total_times = total_times
        self._most_correct_rate = most_correct_rate
        self._initial_learning_rate = initial_learning_rate
        self._search_time_constant = search_time_constant

        self.current_times = 0
        self.best_correct_rate = 0
        self._best_synaptic_weights = []

        self._initialize_neurons()

    def run(self):
        for self.current_times in range(self._total_times):
            if self._should_stop:
                break
            self._feed_forward(self.current_data[:-1])
            self._adjust_synaptic_weights()
            self._save_best_neurons()
            if self._most_correct_rate and self.best_correct_rate >= self._most_correct_rate:
                break

        self._load_best_neurons()

    def test(self):
        return self.correct_rate(self.testing_dataset)

    @property
    def current_data(self):
        return self.training_dataset[self.current_times % len(self.training_dataset)]

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate / (1 + self.current_times / self._search_time_constant)

    def correct_rate(self, dataset):
        correct_count = 0
        for data in dataset:
            for idx, neuron in enumerate(self._neurons):
                self._feed_forward(data[:-1])
                if ((neuron.result == 1 and data[-1] == self.group_types[idx]) or
                        (neuron.result == -1 and data[-1] != self.group_types[idx])):
                    correct_count += 1
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
