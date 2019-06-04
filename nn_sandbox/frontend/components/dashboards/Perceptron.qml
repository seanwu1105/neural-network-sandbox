import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import '..'

Page {
    name: 'Perceptron'
    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            GroupBox {
                title: 'Dataset'
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            GroupBox {
                title: 'Settings'
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            GroupBox {
                title: 'Information'
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            GroupBox {
                title: 'Logging'
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        StackLayout {
            Button { text: '1' }
            Button { text: '2' }
            Button { text: '3' }
        }
    }
}