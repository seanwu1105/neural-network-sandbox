import functools
import threading

import numpy as np


class TrainingAlgorithm(threading.Thread):
    def __init__(self):
        super().__init__()
        self._dataset = None
        self._neurons = []
        self._should_stop = False

    def stop(self):
        self._should_stop = True


class PredictionAlgorithm(TrainingAlgorithm):
    def __init__(self, dataset):
        super().__init__()
        self._dataset = np.array(dataset)
        self._training_dataset = None
        self._testing_dataset = None

        self._split_train_test()

    @property
    @functools.lru_cache()
    def group_types(self):
        return np.unique(self._dataset[:, -1:])

    def _split_train_test(self, test_ratio=0.3):
        test_size = int(len(self._dataset) * test_ratio)
        np.random.shuffle(self._dataset)
        self._training_dataset = self._dataset[test_size:, :]
        self._testing_dataset = self._dataset[:test_size, :]
