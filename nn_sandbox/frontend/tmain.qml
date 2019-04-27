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
                bridge.start()
            }
        }
        Button {
            text: '+2'
            onClicked: {
                bridge.num = bridge.num + 2
            }
        }

        Text {
            text: bridge.num
        }
    }
}
