import os
import sys

import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets

from nn_sandbox.bridges import PerceptronBridge
import nn_sandbox.backend.utils

if __name__ == '__main__':
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Material'
    app = PyQt5.QtWidgets.QApplication(sys.argv)
    # XXX: Why I Have To Use QApplication instead of QGuiApplication? Because it seams QGuiApplication cannot load QML Chart libs!
    perceptron_bridge = PerceptronBridge()
    perceptron_bridge.dataset = nn_sandbox.backend.utils.read_data()
    engine = PyQt5.QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty('perceptronBridge', perceptron_bridge)
    engine.load('./nn_sandbox/frontend/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
