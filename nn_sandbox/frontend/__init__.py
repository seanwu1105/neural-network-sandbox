import abc

import PyQt5.QtCore

from nn_sandbox.backend import Task
from .observer import Observer, Observable, ABCQObjectMeta


# the member in this class should be the connection between back and front-end.
# this is the observer
class Bridge(PyQt5.QtCore.QObject, Observer, metaclass=ABCQObjectMeta):
    changed = PyQt5.QtCore.pyqtSignal(int)

    def __init__(self):
        super().__init__()
        self._num = 0

    @PyQt5.QtCore.pyqtProperty(int, notify=changed)
    def num(self):
        print('getter', self._num)
        return self._num

    @num.setter
    def num(self, val):
        if self._num == val:
            return
        self._num = val
        self.changed.emit(self._num)
        print('setter', self._num)

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
