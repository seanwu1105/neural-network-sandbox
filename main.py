import os
import sys

import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets

from nn_sandbox.bridges import PerceptronBridge, MlpBridge
import nn_sandbox.backend.utils

if __name__ == '__main__':
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Default'

    # XXX: Why I Have To Use QApplication instead of QGuiApplication? It seams
    # QGuiApplication cannot load QML Chart libs!
    app = PyQt5.QtWidgets.QApplication(sys.argv)
    engine = PyQt5.QtQml.QQmlApplicationEngine()

    bridges = {
        'perceptronBridge': PerceptronBridge(),
        'mlpBridge': MlpBridge()
    }
    for name in bridges:
        bridges[name].dataset_dict = nn_sandbox.backend.utils.read_data()
        engine.rootContext().setContextProperty(name, bridges[name])

    engine.load('./nn_sandbox/frontend/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
