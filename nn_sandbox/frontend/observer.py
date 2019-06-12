import abc

import PyQt5.QtCore


class Observer(abc.ABC):
    def update(self, name, value):
        setattr(self, name, value)


class Observable(abc.ABC):
    def __init__(self, observer):
        self._observer = observer

    @abc.abstractmethod
    def __setattr__(self, name, value):
        """
        Call `notify(name, value)` if the attributes are required by the
        observer.
        """
        super().__setattr__(name, value)

    def notify(self, name, value):
        self._observer.update(name, value)


class ABCQObjectMeta(abc.ABCMeta, type(PyQt5.QtCore.QObject)):
    pass
