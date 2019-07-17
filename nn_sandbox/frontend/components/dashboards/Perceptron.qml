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
                    chart.updateDataset(perceptronBridge.dataset_dict[datasetCombobox.currentText])
                }
                Component.onCompleted: () => {
                    perceptronBridge.current_dataset_name = currentText
                    chart.updateDataset(perceptronBridge.dataset_dict[datasetCombobox.currentText])
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
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: mostCorrectRateCheckBox
                    enabled: perceptronBridge.has_finished
                    text: 'Most Correct Rate'
                    checked: true
                    onCheckedChanged: perceptronBridge.most_correct_rate_checkbox = checked
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mostCorrectRateCheckBox.checked && perceptronBridge.has_finished
                    editable: true
                    value: 1.00 * 100
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
                    text: 'Search Iteration Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    enabled: perceptronBridge.has_finished
                    editable: true
                    value: 1000
                    to: 999999
                    onValueChanged: perceptronBridge.search_iteration_constant = value
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
                        chart.clear()
                        chart.updateTrainingDataset(perceptronBridge.training_dataset)
                        chart.updateTestingDataset(perceptronBridge.testing_dataset)
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
                        let epoch = Math.floor(perceptronBridge.current_iterations / perceptronBridge.training_dataset.length) + 1
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
                    onTextChanged: chart.updateLineSeries()
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
                    text: 'Testing Correct Rate'
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
    ChartView {
        id: chart
        property var perceptronLines: []
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
            addScatterSeries(perceptronBridge.dataset_dict[datasetCombobox.currentText])
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
            let newSeries = createSeries(
                ChartView.SeriesTypeScatter, name, xAxis, yAxis
            )
            newSeries.hovered.connect((point, state) => {
                let position = mapToPosition(point)
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

        function updateLineSeries() {
            perceptronLines.forEach(line => {removeSeries(line)})
            perceptronLines = []

            let x1, y1, x2, y2
            for (let key in perceptronBridge.current_synaptic_weights) {
                let synaptic_weight = perceptronBridge.current_synaptic_weights[key]
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
                let line = createHoverablePerceptronLine(
                    `Perceptron ${key}`,
                    synaptic_weight
                )
                line.append(x1, y1)
                line.append(x2, y2)
                perceptronLines.push(line)
            }
        }

        function createHoverablePerceptronLine(name, text) {
            let newSeries = createSeries(
                ChartView.SeriesTypeLine, name, xAxis, yAxis
            )
            newSeries.hovered.connect((point, state) => {
                let position = mapToPosition(point)
                chartToolTip.x = position.x - chartToolTip.width
                chartToolTip.y = position.y - chartToolTip.height
                chartToolTip.text = JSON.stringify(text)
                chartToolTip.visible = state
            })
            return newSeries
        }

        function clear() {
            removeAllSeries()
            perceptronLines = []
            scatterSeriesMap = {}
        }
    }

    Connections {
        target: perceptronBridge
        // update the chart line series to the best synaptic weight at the end
        // of the training.
        onHas_finishedChanged: chart.updateLineSeries()
    }
}