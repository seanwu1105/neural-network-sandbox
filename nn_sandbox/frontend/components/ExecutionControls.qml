import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Pane {
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            RoundButton {
                icon.source: '../../assets/images/baseline-play_arrow-24px.svg'
                radius: 0
                onClicked: timer.running = true
                ToolTip.visible: hovered
                ToolTip.text: 'Start Training'
            }
            RoundButton {
                icon.source: '../../assets/images/baseline-check_circle-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Start Testing'
            }
            RoundButton {
                icon.source: '../../assets/images/baseline-stop-24px.svg'
                radius: 0
                onClicked: timer.running = false
                ToolTip.visible: hovered
                ToolTip.text: 'Stop Training'
            }
        }
        ProgressBar {
            id: progressBar
            Layout.fillWidth: true
        }
        Timer {
            id: timer
            repeat: true
            interval: 50
            onTriggered: progressBar.value = Math.random()
        }
    }
}