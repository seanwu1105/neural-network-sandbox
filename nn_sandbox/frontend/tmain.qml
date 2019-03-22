import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    visible: true

    Material.theme: Material.Dark

    Column {

        Button {
            text: 'hello'
            onClicked: {
                backend.start()
            }
        }
        Button {
            text: '+2'
            onClicked: {
                backend.num = backend.num + 2
            }
        }

        Text {
            text: backend.num
        }
    }
}
