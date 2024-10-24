import sys
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

if __name__ == '__main__':
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load('main.qml')

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
