import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Pane {
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            RoundButton {
                icon.source: '../../assets/images/baseline-play_arrow-24px.svg'
                radius: 0
            }
            RoundButton {
                icon.source: '../../assets/images/baseline-stop-24px.svg'
                radius: 0
            }
        }
        ProgressBar {
            indeterminate: true
            Layout.fillWidth: true
        }
    }
}