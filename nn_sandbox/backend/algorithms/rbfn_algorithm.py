from . import PredictiveAlgorithm
from .k_means import KMeans
from ..neurons import RbfNeuron


class RbfnAlgorithm(PredictiveAlgorithm):
    def __init__(self, dataset, total_epoches=10, most_correct_rate=None,
                 acceptable_range=0.5, initial_learning_rate=0.8,
                 search_iteration_constant=10000, cluster_count=3,
                 test_ratio=0.3):
        super().__init__(dataset, total_epoches, most_correct_rate,
                         initial_learning_rate, search_iteration_constant,
                         test_ratio)
        self.acceptable_range = acceptable_range
        self.cluster_count = cluster_count

    def _iterate(self):
        result = self._feed_forward(self.current_data[:-1])
        self._adjust_neurons(result)

    def _initialize_neurons(self):
        self._neurons = [RbfNeuron(cluster.center, cluster.avg_distance)
                         for cluster in KMeans(self.cluster_count).fit(self.training_dataset)]
        self._neurons.insert(0, RbfNeuron(is_threshold=True))

    def _feed_forward(self, data):
        for neuron in self._neurons:
            neuron.data = data
        return sum(neuron.result for neuron in self._neurons)

    def _adjust_neurons(self, output):
        expect = self.current_data[-1]
        for neuron in self._neurons:
            new_synaptic_weight_diff = self._get_synaptic_weight_diff(
                output, expect, neuron
            )
            if not neuron.is_threshold and neuron.standard_deviation != 0:
                data_mean_diff = neuron.data - neuron.mean
                new_mean = (neuron.mean
                            + new_synaptic_weight_diff
                            * neuron.synaptic_weight
                            * data_mean_diff
                            / neuron.standard_deviation**2)
                new_standard_deviation = (neuron.standard_deviation
                                          + new_synaptic_weight_diff
                                          * neuron.synaptic_weight
                                          * data_mean_diff.dot(data_mean_diff)
                                          / neuron.standard_deviation**3)
                neuron.mean, neuron.standard_deviation = new_mean, new_standard_deviation
            neuron.synaptic_weight += new_synaptic_weight_diff

    def _get_synaptic_weight_diff(self, output, expect, neuron):
        if neuron.is_threshold:
            return self.current_learning_rate * (expect - output)
        return self.current_learning_rate * (expect - output) * neuron.activation_function(
            neuron.data, neuron.mean, neuron.standard_deviation
        )

    def _correct_rate(self, dataset):
        correct_count = 0
        for data in dataset:
            result = self._feed_forward(data[:-1])
            if data[-1] - self.acceptable_range < result < data[-1] + self.acceptable_range:
                correct_count += 1
        if correct_count == 0:
            return 0
        return correct_count / len(dataset)
