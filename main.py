import sys

import PySide2.QtQml
import PySide2.QtCore
import PySide2.QtWidgets

import nn_sandbox.frontend


if __name__ == '__main__':
    app = PySide2.QtWidgets.QApplication(sys.argv)
    # XXX: WHY I HAVE TO USE QApplication instead of QGuiApplication? Because it seams QGuiApplication cannot load QML Chart libs!
    bridge = nn_sandbox.frontend.Bridge()
    engine = PySide2.QtQml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty("bridge", bridge)
    engine.load('./nn_sandbox/frontend/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
