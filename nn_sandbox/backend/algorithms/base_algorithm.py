import abc
import copy
import functools
import threading

import numpy as np


class TraningAlgorithm(threading.Thread, abc.ABC):
    def __init__(self, dataset, total_epoches):
        super().__init__()
        self._dataset = np.array(dataset)
        self._total_epoches = total_epoches
        self._neurons = []
        self._should_stop = False

    def stop(self):
        self._should_stop = True


class PredictiveAlgorithm(TraningAlgorithm, abc.ABC):
    def __init__(self, dataset, total_epoches, most_correct_rate,
                 initial_learning_rate, search_iteration_constant, test_ratio):
        super().__init__(dataset, total_epoches)
        self.training_dataset: np.ndarray = None
        self.testing_dataset: np.ndarray = None
        self._most_correct_rate = most_correct_rate
        self._initial_learning_rate = initial_learning_rate
        self._search_iteration_constant = search_iteration_constant

        self._split_train_test(test_ratio=test_ratio)

        self.current_iterations = 0
        self.current_correct_rate = 0
        self.best_correct_rate = 0
        self._best_neurons = []

    def run(self):
        self._initialize_neurons()
        for self.current_iterations in range(self._total_epoches * len(self.training_dataset)):
            if self._should_stop:
                break
            if self.current_iterations % len(self.training_dataset) == 0:
                np.random.shuffle(self.training_dataset)
            self._iterate()
            self._save_best_neurons()
            if self._most_correct_rate and self.best_correct_rate >= self._most_correct_rate:
                break
        self._load_best_neurons()

    def test(self):
        return self._correct_rate(self.testing_dataset)

    @abc.abstractmethod
    def _initialize_neurons(self):
        """ initialize neurons and save to self._neurons """

    @abc.abstractmethod
    def _iterate(self):
        """ do things in each iteration of the training algorithm """

    @abc.abstractmethod
    def _correct_rate(self, dataset):
        """ calculate the correct rate for given dataset against current neuron network. """

    def _save_best_neurons(self):
        self.current_correct_rate = self._correct_rate(self.training_dataset)
        if self.current_correct_rate > self.best_correct_rate:
            self.best_correct_rate = self.current_correct_rate
            self._best_neurons = copy.deepcopy(self._neurons)

    def _load_best_neurons(self):
        self._neurons = copy.deepcopy(self._best_neurons)

    @property
    def current_data(self):
        return self.training_dataset[self.current_iterations % len(self.training_dataset)]

    @property
    def current_learning_rate(self):
        return self._initial_learning_rate / (1 + self.current_iterations
                                              / self._search_iteration_constant)

    @property
    @functools.lru_cache()
    def group_types(self):
        return np.unique(self._dataset[:, -1:])

    def _split_train_test(self, test_ratio=0.3):
        test_size = max(int(len(self._dataset) * test_ratio), 1)
        np.random.shuffle(self._dataset)
        self.training_dataset = self._dataset[test_size:, :]
        self.testing_dataset = self._dataset[:test_size, :]
