import PyQt5.QtCore

from nn_sandbox.backend.algorithms import PerceptronAlgorithm
from . import Bridge, BridgeProperty
from .observer import Observable


class PerceptronBridge(Bridge):
    dataset_dict = BridgeProperty({})
    training_dataset = BridgeProperty([])
    testing_dataset = BridgeProperty([])
    current_dataset_name = BridgeProperty('')
    total_epoches = BridgeProperty(10)
    most_correct_rate_checkbox = BridgeProperty(True)
    most_correct_rate = BridgeProperty(0.98)
    initial_learning_rate = BridgeProperty(0.5)
    search_iteration_constant = BridgeProperty(1000)
    test_ratio = BridgeProperty(0.3)
    current_iterations = BridgeProperty(0)
    current_learning_rate = BridgeProperty(0.0)
    best_correct_rate = BridgeProperty(0.0)
    test_correct_rate = BridgeProperty(0.0)
    has_finished = BridgeProperty(True)
    current_synaptic_weights = BridgeProperty({})

    def __init__(self):
        super().__init__()
        self.perceptron_algorithm = None

    @PyQt5.QtCore.pyqtSlot()
    def start_perceptron_algorithm(self):
        self.perceptron_algorithm = ObservablePerceptronAlgorithm(
            self,
            dataset=self.dataset_dict[self.current_dataset_name],
            total_epoches=self.total_epoches,
            most_correct_rate=self._most_correct_rate,
            initial_learning_rate=self.initial_learning_rate,
            search_iteration_constant=self.search_iteration_constant,
            test_ratio=self.test_ratio
        )
        self.perceptron_algorithm.start()

    @PyQt5.QtCore.pyqtSlot()
    def stop_perceptron_algorithm(self):
        self.perceptron_algorithm.stop()

    @property
    def _most_correct_rate(self):
        if self.most_correct_rate_checkbox:
            return self.most_correct_rate
        return None


class ObservablePerceptronAlgorithm(Observable, PerceptronAlgorithm):
    def __init__(self, observer, **kwargs):
        Observable.__init__(self, observer)
        PerceptronAlgorithm.__init__(self, **kwargs)

    def __setattr__(self, name, value):
        super().__setattr__(name, value)
        if name == 'current_iterations':
            self.notify(name, value)
            self.notify('current_synaptic_weights',
                        {str(idx): neuron.synaptic_weight.tolist()
                         for idx, neuron in enumerate(self._neurons)
                         if neuron.synaptic_weight is not None})
            self.notify('test_correct_rate', self.test())
        elif name in ('best_correct_rate',):
            self.notify(name, value)
        elif name in ('training_dataset', 'testing_dataset') and value is not None:
            self.notify(name, value.tolist())

    def run(self):
        self.notify('has_finished', False)
        self.notify('test_correct_rate', 0)
        super().run()
        self.notify('current_synaptic_weights',
                    {str(idx): neuron.synaptic_weight.tolist()
                     for idx, neuron in enumerate(self._neurons)
                     if neuron.synaptic_weight is not None})
        self.notify('test_correct_rate', self.test())
        self.notify('has_finished', True)

    @property
    def current_learning_rate(self):
        ret = super().current_learning_rate
        self.notify('current_learning_rate', ret)
        return ret
