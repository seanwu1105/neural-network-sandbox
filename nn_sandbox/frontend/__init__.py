import abc

import PySide2.QtCore

from nn_sandbox.backend import Task
from .observer import Observer, Observable, ABCQObjectMeta


# the member in this class should be the connection between back and front-end.
# this is the observer

# XXX: in PyQt5, after convert Python dict into QML object (via QVariantMap), there is no `keys()` or other JavaScript methods.
# XXX: in PySide2, after QML link objects via `setContextProperty` to Python object, QML cannot get the correct object members.

class Bridge(PySide2.QtCore.QObject, Observer, metaclass=ABCQObjectMeta):
    intChanged = PySide2.QtCore.Signal(int)
    dictChanged = PySide2.QtCore.Signal('QVariantMap')

    def __init__(self):
        super().__init__()
        self._num = 0
        self._data = {'a': 0, 'b': 1, 'c': 2}

    @PySide2.QtCore.Property('QVariantMap', notify=dictChanged)
    def data(self):
        return self._data

    @data.setter
    def data(self, val):
        if self._data == val:
            return
        self._data = val
        self.dictChanged.emit(self._data)

    @PySide2.QtCore.Property(int, notify=intChanged)
    def num(self):
        print('getter', self._num)
        return self._num

    @num.setter
    def num(self, val):
        if self._num == val:
            return
        self._num = val
        self.intChanged.emit(self._num)
        print('setter', self._num)

    @PySide2.QtCore.Slot()
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
