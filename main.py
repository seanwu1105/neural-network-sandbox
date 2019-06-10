import os
import sys

import PyQt5.QtQml
import PyQt5.QtCore
import PyQt5.QtWidgets

import nn_sandbox.frontend
import nn_sandbox.backend

if __name__ == '__main__':
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Material'
    app = PyQt5.QtWidgets.QApplication(sys.argv)
    # XXX: Why I Have To Use QApplication instead of QGuiApplication? Because it seams QGuiApplication cannot load QML Chart libs!
    bridge = nn_sandbox.frontend.Bridge()
    backend = nn_sandbox.backend.Backend()
    bridge.data = backend.data
    engine = PyQt5.QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty('bridge', bridge)
    engine.load('./nn_sandbox/frontend/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
