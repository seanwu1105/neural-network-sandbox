import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import 'components'
import 'components/settings'

ApplicationWindow {
    id: window
    visible: true
    minimumWidth: body.implicitWidth
    minimumHeight: body.implicitHeight

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
                    PerceptronSettings{}
                    MlpSettings{}
                    RbfnSettings{}
                    HopfieldSettings{}
                    SomSettings{}
                }
            }
        }
    }
}
