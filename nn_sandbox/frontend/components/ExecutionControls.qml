import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Pane {
    property alias startButton: startButton
    property alias stopButton: stopButton
    property alias progressBar: progressBar
    
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            RoundButton {
                id: startButton
                icon.source: '../../assets/images/baseline-play_arrow-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Start Training'
            }
            RoundButton {
                id: stopButton
                icon.source: '../../assets/images/baseline-stop-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Stop Training'
            }
        }
        ProgressBar {
            id: progressBar
            Layout.fillWidth: true
        }
    }
}