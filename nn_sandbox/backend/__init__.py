import threading

import PyQt5.QtCore


class Backend(PyQt5.QtCore.QObject):
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
        self.s = Subject(self)
        self.s.start()

    def update(self, name, value):
        setattr(self, name, value)


class Task(threading.Thread):
    def __init__(self):
        super().__init__()
        self.num = 0

    def run(self):
        for i in range(35):
            self.num = fib(i)


class Subject(Task):
    def __init__(self, obs):
        self.obs = obs
        super().__init__()

    def __setattr__(self, name, value):
        # print(name, value)
        super().__setattr__(name, value)
        if name == 'num':
            self.notify(name, value)

    def notify(self, name, value):
        self.obs.update(name, value)


def fib(N):
    if N <= 1:
        return 1
    return fib(N - 1) + fib(N - 2)
