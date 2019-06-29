import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtCharts 2.3

import '..'

Page {
    name: 'Perceptron'
    ColumnLayout {
        GroupBox {
            title: 'Dataset'
            Layout.fillWidth: true
            ComboBox {
                anchors.fill: parent
                model: Object.keys(perceptronBridge.dataset)
                enabled: perceptronBridge.has_finished
                function updateChart() {
                    let xMax = -Infinity, yMax = -Infinity, xMin = Infinity, yMin = Infinity
                    chart.removeAllSeries()
                    let seriesMap = {}
                    for (let row of perceptronBridge.dataset[currentText]) {
                        if (!(row[2] in seriesMap)) {
                            seriesMap[row[2]] = chart.createSeries(ChartView.SeriesTypeScatter, row[2], xAxis, yAxis)
                            seriesMap[row[2]].hovered.connect((point, state) => {
                                let position = chart.mapToPosition(point)
                                chartToolTip.x = position.x - chartToolTip.width
                                chartToolTip.y = position.y - chartToolTip.height
                                chartToolTip.text = `(${point.x}, ${point.y})`
                                chartToolTip.visible = state
                            })
                        }
                        seriesMap[row[2]].append(row[0], row[1])
                        xMax = Math.max(xMax, row[0])
                        xMin = Math.min(xMin, row[0])
                        yMax = Math.max(yMax, row[1])
                        yMin = Math.min(yMin, row[1])
                    }
                    xAxis.max = xMax + 0.1 * (xMax - xMin)
                    xAxis.min = xMin - 0.1 * (xMax - xMin)
                    yAxis.max = yMax + 0.1 * (yMax - yMin)
                    yAxis.min = yMin - 0.1 * (yMax - yMin)
                }
                onActivated: () => {
                    perceptronBridge.current_dataset_name = currentText
                    updateChart()
                }
                Component.onCompleted: () => {
                    perceptronBridge.current_dataset_name = currentText
                    updateChart()
                }
            }
        }
        GroupBox {
            title: 'Settings'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    text: 'Total Training Times'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    id: totalTimes
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 2000
                    to: 999999
                    onValueChanged: perceptronBridge.total_times = value
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: mostCorrectRateCheckBox
                    enabled: perceptronBridge.has_finished
                    text: 'Most Correct Rate'
                    onCheckedChanged: perceptronBridge.most_correct_rate_checkbox = checked
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mostCorrectRateCheckBox.checked && perceptronBridge.has_finished
                    editable: true
                    value: 0.98 * 100
                    onValueChanged: perceptronBridge.most_correct_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Initial Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 0.5 * 100
                    onValueChanged: perceptronBridge.initial_learning_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Search Time Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 1000
                    to: 999999
                    onValueChanged: perceptronBridge.search_time_constant = value
                    Layout.fillWidth: true
                }
            }
        }
        GroupBox {
            title: 'Information'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                ExecutionControls {
                    startButton.onClicked: perceptronBridge.start_perceptron_algorithm()
                    stopButton.onClicked: perceptronBridge.stop_perceptron_algorithm()
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Times'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.current_times + 1
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.current_learning_rate
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Best Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.best_correct_rate
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Testing Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: '--'
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
        GroupBox {
            title: 'Logging'
            Layout.fillWidth: true
            Layout.fillHeight: true
            Logger {}
        }
    }
    ChartView {
        id: chart
        width: 600
        Layout.fillWidth: true
        Layout.fillHeight: true
        antialiasing: true
        ValueAxis{
            id: xAxis
            min: -1.0
            max: 1.0
        }
        ValueAxis{
            id: yAxis
            min: -1.0
            max: 1.0
        }
        ToolTip {
            id: chartToolTip
        }
    }
}