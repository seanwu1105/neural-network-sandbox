import sys

import PyQt5.QtGui
import PyQt5.QtQml
import PyQt5.QtCore

import nn_sandbox.frontend


if __name__ == '__main__':
    app = PyQt5.QtGui.QGuiApplication(sys.argv)
    bridge = nn_sandbox.frontend.Bridge()
    engine = PyQt5.QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty("bridge", bridge)
    engine.load('./nn_sandbox/frontend/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
