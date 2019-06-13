from PyQt5.QtCore import pyqtSignal, QObject


class C(QObject):
    signal = pyqtSignal(dict)

    def __init__(self):
        super().__init__()
        self.signal.emit({'a': 1, 'b': 2})


c = C()
