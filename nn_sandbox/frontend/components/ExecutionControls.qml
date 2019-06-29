import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Pane {
    property alias startButton: startButton
    property alias stopButton: stopButton
    property alias testButton: testButton
    
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            RoundButton {
                id: startButton
                enabled: perceptronBridge.has_finished
                icon.source: '../../assets/images/baseline-play_arrow-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Start Training'
            }
            RoundButton {
                id: stopButton
                enabled: !perceptronBridge.has_finished
                icon.source: '../../assets/images/baseline-stop-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Stop Training'
            }
            RoundButton {
                id: testButton
                enabled: perceptronBridge.has_finished
                icon.source: '../../assets/images/baseline-check_circle-24px.svg'
                radius: 0
                ToolTip.visible: hovered
                ToolTip.text: 'Start Testing'
            }
        }
        ProgressBar {
            id: progressBar
            value: (perceptronBridge.current_times + 1) / totalTimes.value
            Layout.fillWidth: true
        }
    }
}