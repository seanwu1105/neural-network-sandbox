import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import 'components'
import 'components/dashboards'

ApplicationWindow {
    id: window
    visible: true
    minimumWidth: body.implicitWidth
    // minimumHeight: body.implicitHeight
    // We will set the minimum height of window after notebook has added pages.
    Pane {
        id: body
        anchors.fill: parent
        GridLayout {
            anchors.fill: parent
            columns: 2
            GroupBox {
                Layout.fillWidth: true
                Layout.fillHeight: true
                NoteBook {
                    Perceptron {}
                    Mlp {}
                    Rbfn {}
                    Hopfield {}
                    Som {}
                }
            }
        }
    }
}
