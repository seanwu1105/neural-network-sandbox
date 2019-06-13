import abc

import PyQt5.QtCore

from nn_sandbox.backend.algorithms import PerceptronAlgorithm
from . import Bridge, BridgeProperty
from .observer import Observable


# the member in this class should be the connection between back and front-end.
# this is the observer

class PerceptronBridge(Bridge):
    dataset = BridgeProperty({})
    current_dataset_name = BridgeProperty('')
    initial_learning_rate = BridgeProperty(0.5)
    most_correct_rate = BridgeProperty(0.99)
    current_times = BridgeProperty(0)
    current_learning_rate = BridgeProperty(0.0)
    best_correct_rate = BridgeProperty(0.0)
    test_correct_rate = BridgeProperty(0.0)
    has_finished = BridgeProperty(True)

    def __init__(self):
        super().__init__()
        self.perceptron_algorithm = None

    @PyQt5.QtCore.pyqtSlot()
    def start_perceptron_algorithm(self):
        self.perceptron_algorithm = ObservablePerceptronAlgorithm(
            self,
            self.dataset[self.current_dataset_name],
            self.initial_learning_rate
        )
        self.perceptron_algorithm.start()

    @PyQt5.QtCore.pyqtSlot()
    def stop_perceptron_algorithm(self):
        self.perceptron_algorithm.stop()


class ObservablePerceptronAlgorithm(Observable, PerceptronAlgorithm):
    def __init__(self, observer, dataset, initial_learning_rate):
        Observable.__init__(self, observer)
        PerceptronAlgorithm.__init__(
            self, dataset, initial_learning_rate=initial_learning_rate
        )

    def __setattr__(self, name, value):
        super().__setattr__(name, value)
        if name == 'current_times':
            self.notify(name, value)
            self.notify('current_synaptic_weights',
                        (neuron.synaptic_weight for neuron in self._neurons))
        elif name in ('best_correct_rate',):
            self.notify(name, value)

    def run(self):
        self.notify('has_finished', False)
        super().run()
        self.notify('has_finished', True)

    @property
    def current_learning_rate(self):
        ret = super().current_learning_rate
        self.notify('current_learning_rate', ret)
        return ret
