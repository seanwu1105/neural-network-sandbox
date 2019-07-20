import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtCharts 2.3

import '..'

Page {
    name: 'MLP'
    ColumnLayout {
        GroupBox {
            title: 'Dataset'
            Layout.fillWidth: true
            ComboBox {
                id: datasetCombobox
                anchors.fill: parent
                model: Object.keys(mlpBridge.dataset_dict)
                enabled: mlpBridge.has_finished
                onActivated: () => {
                    mlpBridge.current_dataset_name = currentText
                    chart.updateDataset(mlpBridge.dataset_dict[datasetCombobox.currentText])
                }
                Component.onCompleted: () => {
                    mlpBridge.current_dataset_name = currentText
                    chart.updateDataset(mlpBridge.dataset_dict[datasetCombobox.currentText])
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
                    enabled: mlpBridge.has_finished
                    editable: true
                    value: 50
                    to: 999999
                    onValueChanged: mlpBridge.total_epoches = value
                    Component.onCompleted: mlpBridge.total_epoches = value
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: mostCorrectRateCheckBox
                    enabled: mlpBridge.has_finished
                    text: 'Most Correct Rate'
                    checked: true
                    onCheckedChanged: mlpBridge.most_correct_rate_checkbox = checked
                    Component.onCompleted: mlpBridge.most_correct_rate_checkbox = checked
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mostCorrectRateCheckBox.checked && mlpBridge.has_finished
                    editable: true
                    value: 1.00 * 100
                    onValueChanged: mlpBridge.most_correct_rate = value / 100
                    Component.onCompleted: mlpBridge.most_correct_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Initial Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mlpBridge.has_finished
                    editable: true
                    value: 0.8 * 100
                    onValueChanged: mlpBridge.initial_learning_rate = value / 100
                    Component.onCompleted: mlpBridge.initial_learning_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Search Iteration Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    enabled: mlpBridge.has_finished
                    editable: true
                    value: 10000
                    to: 999999
                    onValueChanged: mlpBridge.search_iteration_constant = value
                    Component.onCompleted: mlpBridge.search_iteration_constant = value
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Momentum Weight'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mlpBridge.has_finished
                    editable: true
                    value: 0.5 * 100
                    from: 0
                    to: 99
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Test-Train Ratio'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mlpBridge.has_finished
                    editable: true
                    value: 0.3 * 100
                    from: 30
                    to: 90
                    onValueChanged: mlpBridge.test_ratio = value / 100
                    Component.onCompleted: mlpBridge.test_ratio = value / 100
                    Layout.fillWidth: true
                }
            }
        }
        GroupBox {
            title: 'Network'
            Layout.fillWidth: true
            NetworkSetting {
                enabled: mlpBridge.has_finished
                onShapeChanged: mlpBridge.network_shape = shape
                Component.onCompleted: mlpBridge.network_shape = shape
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
                    startButton.enabled: mlpBridge.has_finished
                    startButton.onClicked: () => {
                        mlpBridge.start_mlp_algorithm()
                        chart.clear()
                        chart.updateTrainingDataset(mlpBridge.training_dataset)
                        chart.updateTestingDataset(mlpBridge.testing_dataset)
                    }
                    stopButton.enabled: !mlpBridge.has_finished
                    stopButton.onClicked: mlpBridge.stop_mlp_algorithm()
                    progressBar.value: (mlpBridge.current_iterations + 1) / (totalEpoches.value * mlpBridge.training_dataset.length)
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
                        const epoch = Math.floor(mlpBridge.current_iterations / mlpBridge.training_dataset.length) + 1
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
                    text: mlpBridge.current_iterations + 1
                    horizontalAlignment: Text.AlignHCenter
                    // TODO: onTextChanged: chart.updateGroupDisplay()
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: mlpBridge.current_learning_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Best Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: mlpBridge.best_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: mlpBridge.current_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training RMSE'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: 'haha'
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Testing Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: mlpBridge.test_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
    ChartView {
        id: chart
        property var scatterSeriesMap: ({})
        
        width: 600
        antialiasing: true
        legend.visible: false
        Layout.fillWidth: true
        Layout.fillHeight: true
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

        function updateDataset(dataset) {
            clear()
            addScatterSeries(mlpBridge.dataset_dict[datasetCombobox.currentText])
            updateAxesRange(dataset)
        }

        function updateTrainingDataset(dataset) {
            addScatterSeries(dataset)
        }

        function updateTestingDataset(dataset) {
            dataset.sort((a, b) => {return a[2] - b[2]})
            for (let data of dataset) {
                if (!(`${data[2]}test` in scatterSeriesMap)) {
                    scatterSeriesMap[`${data[2]}test`] = createHoverableScatterSeries(`${data[2]}test`)
                    if (data[2] in scatterSeriesMap)
                        scatterSeriesMap[`${data[2]}test`].color = Qt.lighter(scatterSeriesMap[data[2]].color)
                }
                scatterSeriesMap[`${data[2]}test`].append(data[0], data[1])
            }
        }

        function addScatterSeries(dataset) {
            dataset.sort((a, b) => {return a[2] - b[2]})
            for (let data of dataset) {
                if (!(data[2] in scatterSeriesMap))
                    scatterSeriesMap[data[2]] = createHoverableScatterSeries(data[2])
                scatterSeriesMap[data[2]].append(data[0], data[1])
            }
        }

        function createHoverableScatterSeries(name) {
            const newSeries = createSeries(
                ChartView.SeriesTypeScatter, name, xAxis, yAxis
            )
            newSeries.hovered.connect((point, state) => {
                const position = mapToPosition(point)
                chartToolTip.x = position.x - chartToolTip.width
                chartToolTip.y = position.y - chartToolTip.height
                chartToolTip.text = `(${point.x}, ${point.y})`
                chartToolTip.visible = state
            })
            return newSeries
        }

        function updateAxesRange(dataset) {
            let xMax = -Infinity, yMax = -Infinity, xMin = Infinity, yMin = Infinity
            for (let row of dataset) {
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

        function clear() {
            removeAllSeries()
            scatterSeriesMap = {}
        }
    }

    Connections {
        target: mlpBridge
        // update the chart group display to the best synaptic weight at the end
        // of the training.
        // TODO: onHas_finishedChanged: chart.updateGroupDisplay()
    }
}