import abc
import functools
import threading

import numpy as np


class PredictiveAlgorithm(threading.Thread, abc.ABC):
    def __init__(self):
        super().__init__()
        self._dataset = None
        self._neurons = []
        self._should_stop = False

    def stop(self):
        self._should_stop = True

    @abc.abstractmethod
    def test(self):
        """ use the trained model to test the testing dataset """


class PredictionAlgorithm(PredictiveAlgorithm, abc.ABC):
    def __init__(self, dataset, total_epoches,
                 most_correct_rate, test_ratio):
        super().__init__()
        self._dataset = np.array(dataset)
        self.training_dataset = None
        self.testing_dataset = None
        self._total_epoches = total_epoches
        self._most_correct_rate = most_correct_rate

        self._split_train_test(test_ratio=test_ratio)

        self.current_iterations = 0
        self.best_correct_rate = 0
        self._best_synaptic_weights = []

    def run(self):
        for self.current_iterations in range(self._total_epoches * len(self.training_dataset)):
            if self._should_stop:
                break
            if self.current_iterations % len(self.training_dataset) == 0:
                np.random.shuffle(self.training_dataset)
            self.iterate()
            self._save_best_neurons()
            if self._most_correct_rate and self.best_correct_rate >= self._most_correct_rate:
                break
        self._load_best_neurons()

    @abc.abstractmethod
    def iterate(self):
        """ do things in each iteration of the training algorithm """

    @abc.abstractmethod
    def _save_best_neurons(self):
        """ save the best synaptic weights of all neurons for highest correct rate """

    @abc.abstractmethod
    def _load_best_neurons(self):
        """ load the best synaptic weights into all neurons """

    @property
    @functools.lru_cache()
    def group_types(self):
        return np.unique(self._dataset[:, -1:])

    def _split_train_test(self, test_ratio=0.3):
        test_size = max(int(len(self._dataset) * test_ratio), 1)
        np.random.shuffle(self._dataset)
        self.training_dataset = self._dataset[test_size:, :]
        self.testing_dataset = self._dataset[:test_size, :]
