import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import 'components'
import 'components/dashboards'

ApplicationWindow {
    id: window
    visible: true
    // minimumWidth: body.implicitWidth
    // XXX: using body.implicitWidth will cause BadValue and BadWindow error in
    // Linux (Kubuntu). Need further research. Currently, I use
    // Component.onCompleted instead as a workaround.

    // minimumHeight: body.implicitHeight
    // We will set the minimum height of window after notebook has added pages.
    Pane {
        id: body
        anchors.fill: parent
        NoteBook {
            Perceptron {}
            Mlp {}
            Rbfn {}
            Hopfield {}
            Som {}
        }
    }
    Component.onCompleted: width = minimumWidth = body.implicitWidth
}
