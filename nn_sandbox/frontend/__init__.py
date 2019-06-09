import abc

import PyQt5.QtCore

from nn_sandbox.backend import Task
from .observer import Observer, Observable, ABCQObjectMeta


# the member in this class should be the connection between back and front-end.
# this is the observer

class Bridge(PyQt5.QtCore.QObject, Observer, metaclass=ABCQObjectMeta):
    intChanged = PyQt5.QtCore.pyqtSignal(int)
    dictChanged = PyQt5.QtCore.pyqtSignal('QVariantMap')

    def __init__(self):
        super().__init__()
        self._num = 0
        self._data = {}

    @PyQt5.QtCore.pyqtProperty('QVariantMap', notify=dictChanged)
    def data(self):
        return self._data

    # XXX: in PySide2, QML will not able to reach data for the bug (https://bugreports.qt.io/browse/PYSIDE-900)
    @data.setter
    def data(self, val):
        if self._data == val:
            return
        self._data = val
        self.dictChanged.emit(self._data)

    @PyQt5.QtCore.pyqtSlot()
    def start(self):
        self.s = ObservableTask(self)
        self.s.start()

    def update(self, name, value):  # this should be a ABS inherited from ABC
        setattr(self, name, value)


class ObservableTask(Task, Observable):  # this should implement observable
    def __init__(self, obs):
        self.obs = obs
        super().__init__()

    def __setattr__(self, name, value):
        super().__setattr__(name, value)
        if name == 'num':
            self.notify(name, value)

    def notify(self, name, value):  # this should be a ABS inherited from ABC
        self.obs.update(name, value)
