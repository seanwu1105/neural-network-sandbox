import abc

import PySide2.QtCore


class Observer(abc.ABC):

    @abc.abstractmethod
    def update(self):
        pass


class Observable(abc.ABC):

    @abc.abstractmethod
    def notify(self):
        pass


class ABCQObjectMeta(abc.ABCMeta, type(PySide2.QtCore.QObject)):
    pass
