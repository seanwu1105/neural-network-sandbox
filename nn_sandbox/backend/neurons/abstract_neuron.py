import abc


class AbstractNeuron(abc.ABC):
    def __init__(self):
        self._data = None
        self.synaptic_weight = None
        self._activation_function = None

    @abc.abstractproperty
    def result(self):
        """ Get the result after activation function of data and synaptic weight. """
