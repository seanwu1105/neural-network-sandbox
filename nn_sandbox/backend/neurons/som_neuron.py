import numpy as np

from ..utils import dist


class SomNeuron:
    def __init__(self, synaptic_weight_range):
        """
        A neuron for Self-Organizing Map.

        Args:
            synaptic_weight_range: The range for synaptic weight initialization.

        The following creates a neuron with target data, 2-dimension in this
        case, rangeing from -10 to 10 in 1st dimension and from 5 to 7.5 in 2nd dimension.

        >>> SomNeuron(((-10, 10), (5, 7.5)))
        """
        self._data: np.ndarray = None
        self.synaptic_weight = np.fromiter(
            (np.random.uniform(lower, upper)
             for lower, upper in synaptic_weight_range), dtype=float
        )

    @property
    def data(self):
        return self._data

    @data.setter
    def data(self, value):
        self._data = value

    @property
    def dist(self):
        """ the distance between input data and synaptic weight """
        return dist(self._data, self.synaptic_weight)
