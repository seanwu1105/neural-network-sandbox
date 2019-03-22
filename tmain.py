import sys

import PyQt5.QtGui
import PyQt5.QtQml
import PyQt5.QtCore

import nn_sandbox.backend


if __name__ == '__main__':
    app = PyQt5.QtGui.QGuiApplication(sys.argv)
    backend = nn_sandbox.backend.Backend()
    engine = PyQt5.QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty("backend", backend)
    engine.load('./nn_sandbox/frontend/tmain.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
