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

        self._initialize_neurons(cluster_count)

    def iterate(self):
        pass

    def run(self):
        pass

    def _initialize_neurons(self, num):
        self._neurons = [RbfNeuron(cluster.center, cluster.avg_distance)
                         for cluster in KMeans(num).fit(self.training_dataset)]

    def _feed_forward(self):
        pass

    def _adjust_neurons(self):
        pass

    def _correct_rate(self, dataset):
        return 0
