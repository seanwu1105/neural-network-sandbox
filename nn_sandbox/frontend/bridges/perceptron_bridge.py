import abc

import PyQt5.QtCore

from nn_sandbox.backend.algorithms.perceptron_algorithm import PerceptronAlgorithm
from nn_sandbox.frontend.observer import Observer, Observable, ABCQObjectMeta


# the member in this class should be the connection between back and front-end.
# this is the observer

class PerceptronBridge(PyQt5.QtCore.QObject, Observer, metaclass=ABCQObjectMeta):
    bool_changed = PyQt5.QtCore.pyqtSignal(bool)
    int_changed = PyQt5.QtCore.pyqtSignal(int)
    float_changed = PyQt5.QtCore.pyqtSignal(float)
    dict_changed = PyQt5.QtCore.pyqtSignal('QVariantMap')

    def __init__(self):
        super().__init__()
        self.perceptron_algorithm = None
        self._dataset = {}
        self._current_dataset_name = ''
        self._current_times = 0
        self._current_learning_rate = 0
        self._best_correct_rate = 0
        self._test_correct_rate = 0
        self._has_finished = True

    @PyQt5.QtCore.pyqtProperty('QVariantMap', notify=dict_changed)
    def dataset(self):
        return self._dataset

    # XXX: in PySide2, QML will not able to reach data for the bug (https://bugreports.qt.io/browse/PYSIDE-900)
    @dataset.setter
    def dataset(self, val):
        if self._dataset == val:
            return
        self._dataset = val
        self.dict_changed.emit(self._dataset)

    @PyQt5.QtCore.pyqtProperty(str)
    def current_dataset_name(self):
        return self._current_dataset_name

    @current_dataset_name.setter
    def current_dataset_name(self, val):
        if self._current_dataset_name == val:
            return
        self._current_dataset_name = val

    @PyQt5.QtCore.pyqtProperty(int, notify=int_changed)
    def current_times(self):
        return self._current_times

    @current_times.setter
    def current_times(self, val):
        if self._current_times == val:
            return
        self._current_times = val
        self.int_changed.emit(self._current_times)

    @PyQt5.QtCore.pyqtProperty(float, notify=int_changed)
    def current_learning_rate(self):
        return self._current_learning_rate

    @current_learning_rate.setter
    def current_learning_rate(self, val):
        if self._current_learning_rate == val:
            return
        self._current_learning_rate = val
        self.float_changed.emit(self._current_learning_rate)

    @PyQt5.QtCore.pyqtProperty(float, notify=int_changed)
    def best_correct_rate(self):
        return self._best_correct_rate

    @best_correct_rate.setter
    def best_correct_rate(self, val):
        if self._best_correct_rate == val:
            return
        self._best_correct_rate = val
        self.float_changed.emit(self._best_correct_rate)

    @PyQt5.QtCore.pyqtProperty(bool, notify=bool_changed)
    def has_finished(self):
        return self._has_finished

    @has_finished.setter
    def has_finished(self, val):
        if self._has_finished == val:
            return
        self._has_finished = val
        self.bool_changed.emit(self._has_finished)

    @PyQt5.QtCore.pyqtSlot()
    def start_perceptron_algorithm(self):
        self.perceptron_algorithm = ObservablePerceptronAlgorithm(
            self, self._dataset[self._current_dataset_name])
        self.perceptron_algorithm.start()

    @PyQt5.QtCore.pyqtSlot()
    def stop_perceptron_algorithm(self):
        self.perceptron_algorithm.stop()


class ObservablePerceptronAlgorithm(Observable, PerceptronAlgorithm):
    def __init__(self, observer, dataset):
        Observable.__init__(self, observer)
        PerceptronAlgorithm.__init__(self, dataset)

    def __setattr__(self, name, value):
        super().__setattr__(name, value)
        if name in ('current_times', 'best_correct_rate', 'has_finished'):
            self.notify(name, value)

    @property
    def current_learning_rate(self):
        ret = super().current_learning_rate
        self.notify('current_learning_rate', ret)
        return ret
