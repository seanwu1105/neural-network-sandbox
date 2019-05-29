import abc

import PyQt5.QtCore


class Observer(abc.ABC):

    @abc.abstractmethod
    def update(self):
        pass


class Observable(abc.ABC):

    @abc.abstractmethod
    def notify(self):
        pass


class ABCQObjectMeta(abc.ABCMeta, type(PyQt5.QtCore.QObject)):
    pass
