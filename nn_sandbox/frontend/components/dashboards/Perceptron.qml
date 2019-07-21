import QtQml 2.12
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
                id: datasetCombobox
                anchors.fill: parent
                model: Object.keys(perceptronBridge.dataset_dict)
                enabled: perceptronBridge.has_finished
                onActivated: () => {
                    perceptronBridge.current_dataset_name = currentText
                    dataChart.updateDataset(perceptronBridge.dataset_dict[datasetCombobox.currentText])
                }
                Component.onCompleted: () => {
                    perceptronBridge.current_dataset_name = currentText
                    dataChart.updateDataset(perceptronBridge.dataset_dict[datasetCombobox.currentText])
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
                    text: 'Total Training Epoches'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    id: totalEpoches
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 5
                    to: 999999
                    onValueChanged: perceptronBridge.total_epoches = value
                    Component.onCompleted: perceptronBridge.total_epoches = value
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: mostCorrectRateCheckBox
                    enabled: perceptronBridge.has_finished
                    text: 'Most Correct Rate'
                    checked: true
                    onCheckedChanged: perceptronBridge.most_correct_rate_checkbox = checked
                    Component.onCompleted: perceptronBridge.most_correct_rate_checkbox = checked
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mostCorrectRateCheckBox.checked && perceptronBridge.has_finished
                    editable: true
                    value: 1.00 * 100
                    onValueChanged: perceptronBridge.most_correct_rate = value / 100
                    Component.onCompleted: perceptronBridge.most_correct_rate = value / 100
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
                    Component.onCompleted: perceptronBridge.initial_learning_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Search Iteration Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 1000
                    to: 999999
                    onValueChanged: perceptronBridge.search_iteration_constant = value
                    Component.onCompleted: perceptronBridge.search_iteration_constant = value
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Test-Train Ratio'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 0.3 * 100
                    from: 30
                    to: 90
                    onValueChanged: perceptronBridge.test_ratio = value / 100
                    Component.onCompleted: perceptronBridge.test_ratio = value / 100
                    Layout.fillWidth: true
                }
            }
        }
        GroupBox {
            title: 'Information'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                columns: 2
                ExecutionControls {
                    startButton.enabled: perceptronBridge.has_finished
                    startButton.onClicked: () => {
                        perceptronBridge.start_perceptron_algorithm()
                        dataChart.clear()
                        dataChart.updateTrainingDataset(perceptronBridge.training_dataset)
                        dataChart.updateTestingDataset(perceptronBridge.testing_dataset)
                    }
                    stopButton.enabled: !perceptronBridge.has_finished
                    stopButton.onClicked: perceptronBridge.stop_perceptron_algorithm()
                    progressBar.value: (perceptronBridge.current_iterations + 1) / (totalEpoches.value * perceptronBridge.training_dataset.length)
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Epoch'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: currentEpoch()
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    function currentEpoch() {
                        const epoch = Math.floor(perceptronBridge.current_iterations / perceptronBridge.training_dataset.length) + 1
                        if (isNaN(epoch))
                            return 1
                        return epoch
                    }
                }
                Label {
                    text: 'Current Training Iteration'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.current_iterations + 1
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: dataChart.updateLineSeries()
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.current_learning_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Best Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.best_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.current_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Testing Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: perceptronBridge.test_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
    DataChart {
        id: dataChart
        property var perceptronLines: []
        width: 600
        Layout.fillWidth: true
        Layout.fillHeight: true

        function updateLineSeries() {
            perceptronLines.forEach(line => {removeSeries(line)})
            perceptronLines = []

            let x1, y1, x2, y2
            for (let key in perceptronBridge.current_synaptic_weights) {
                const synaptic_weight = perceptronBridge.current_synaptic_weights[key]
                if (Math.abs(synaptic_weight[1]) < Math.abs(synaptic_weight[2])) {
                    // the absolute value of slope < 1, and the coordinate-x
                    // reaches the edge of chart view first.
                    x1 = xAxis.min
                    x2 = xAxis.max
                    y1 = (synaptic_weight[0] - synaptic_weight[1] * x1) / synaptic_weight[2]
                    y2 = (synaptic_weight[0] - synaptic_weight[1] * x2) / synaptic_weight[2]
                } else if (Math.abs(synaptic_weight[1]) > Math.abs(synaptic_weight[2])) {
                    // the absolute value of slope > 1, and the coordinate-y
                    // reaches the edge of chart view first.
                    y1 = yAxis.min
                    y2 = yAxis.max
                    x1 = (synaptic_weight[0] - synaptic_weight[2] * y1) / synaptic_weight[1]
                    x2 = (synaptic_weight[0] - synaptic_weight[2] * y2) / synaptic_weight[1]
                }
                const line = createHoverablePerceptronLine(
                    `Perceptron ${key}`,
                    synaptic_weight
                )
                line.append(x1, y1)
                line.append(x2, y2)
                perceptronLines.push(line)
            }
        }

        function createHoverablePerceptronLine(name, text) {
            const newSeries = createSeries(
                ChartView.SeriesTypeLine, name, xAxis, yAxis
            )
            newSeries.hovered.connect((point, state) => {
                const position = mapToPosition(point)
                chartToolTip.x = position.x - chartToolTip.width
                chartToolTip.y = position.y - chartToolTip.height
                chartToolTip.text = JSON.stringify(text)
                chartToolTip.visible = state
            })
            return newSeries
        }
    }

    Connections {
        target: perceptronBridge
        // update the chart line series to the best synaptic weight at the end
        // of the training.
        onHas_finishedChanged: dataChart.updateLineSeries()
    }
}