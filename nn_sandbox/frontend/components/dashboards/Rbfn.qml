import QtQml 2.13
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtCharts 2.3

import '..'

Page {
    name: 'RBFN'
    ColumnLayout {
        GroupBox {
            title: 'Dataset'
            Layout.fillWidth: true
            ComboBox {
                id: datasetCombobox
                anchors.fill: parent
                model: Object.keys(rbfnBridge.dataset_dict)
                enabled: rbfnBridge.has_finished
                onActivated: () => {
                    rbfnBridge.current_dataset_name = currentText
                    dataChart.updateDataset(rbfnBridge.dataset_dict[datasetCombobox.currentText])
                }
                Component.onCompleted: () => {
                    rbfnBridge.current_dataset_name = currentText
                    dataChart.updateDataset(rbfnBridge.dataset_dict[datasetCombobox.currentText])
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
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 10
                    to: 999999
                    onValueChanged: rbfnBridge.total_epoches = value
                    Component.onCompleted: rbfnBridge.total_epoches = value
                    Layout.fillWidth: true
                }
                CheckBox {
                    id: mostCorrectRateCheckBox
                    enabled: rbfnBridge.has_finished
                    text: 'Most Correct Rate'
                    checked: true
                    onCheckedChanged: rbfnBridge.most_correct_rate_checkbox = checked
                    Component.onCompleted: rbfnBridge.most_correct_rate_checkbox = checked
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: mostCorrectRateCheckBox.checked && rbfnBridge.has_finished
                    editable: true
                    value: 1.00 * 100
                    onValueChanged: rbfnBridge.most_correct_rate = value / 100
                    Component.onCompleted: rbfnBridge.most_correct_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Acceptable Range (±)'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 0.5 * 100
                    to: 999999 * 100
                    onValueChanged: rbfnBridge.acceptable_range = value / 100
                    Component.onCompleted: rbfnBridge.acceptable_range = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Initial Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 0.8 * 100
                    onValueChanged: rbfnBridge.initial_learning_rate = value / 100
                    Component.onCompleted: rbfnBridge.initial_learning_rate = value / 100
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Search Iteration Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 10000
                    to: 999999
                    onValueChanged: rbfnBridge.search_iteration_constant = value
                    Component.onCompleted: rbfnBridge.search_iteration_constant = value
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Number of K-Means Clusters'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {
                    id: clusterCount
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 3
                    from: 1
                    to: Math.ceil((rbfnBridge.dataset_dict[datasetCombobox.currentText].length) * (1 - rbfnBridge.test_ratio))
                    onValueChanged: rbfnBridge.cluster_count = value
                    Component.onCompleted: rbfnBridge.cluster_count = value
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Test-Train Ratio'
                    Layout.alignment: Qt.AlignHCenter
                }
                DoubleSpinBox {
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 0.3 * 100
                    from: 30
                    to: 90
                    onValueChanged: rbfnBridge.test_ratio = value / 100
                    Component.onCompleted: rbfnBridge.test_ratio = value / 100
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
                    startButton.enabled: rbfnBridge.has_finished
                    startButton.onClicked: () => {
                        rbfnBridge.start_rbfn_algorithm()
                        dataChart.clear()
                        dataChart.updateTrainingDataset(rbfnBridge.training_dataset)
                        dataChart.updateTestingDataset(rbfnBridge.testing_dataset)
                        rateChart.reset()
                    }
                    stopButton.enabled: !rbfnBridge.has_finished
                    stopButton.onClicked: rbfnBridge.stop_rbfn_algorithm()
                    progressBar.value: (rbfnBridge.current_iterations + 1) / (totalEpoches.value * rbfnBridge.training_dataset.length)
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
                        const epoch = Math.floor(rbfnBridge.current_iterations / rbfnBridge.training_dataset.length) + 1
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
                    text: rbfnBridge.current_iterations + 1
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: () => {
                        dataChart.updateNeurons()
                        neuronChart.updateAxisY()
                        rateChart.bestCorrectRate.append(
                            rbfnBridge.current_iterations + 1,
                            rbfnBridge.best_correct_rate
                        )
                        rateChart.trainingCorrectRate.append(
                            rbfnBridge.current_iterations + 1,
                            rbfnBridge.current_correct_rate
                        )
                        rateChart.testingCorrectRate.append(
                            rbfnBridge.current_iterations + 1,
                            rbfnBridge.test_correct_rate
                        )
                    }
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: rbfnBridge.current_learning_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Best Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: rbfnBridge.best_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: rbfnBridge.current_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Testing Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: rbfnBridge.test_correct_rate.toFixed(toFixedValue)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
    ColumnLayout {
        DataChart {
            id: dataChart
            property var neuronScatters: []
            

            width: 700
            Layout.fillWidth: true
            Layout.fillHeight: true

            function updateNeurons() {
                neuronScatters.forEach(neuron => {removeSeries(neuron)})
                neuronScatters = []

                for (let {mean: m, standardDeviation: sd, synapticWeight: sw} of rbfnBridge.current_neurons) {
                    neuronScatters.push(createHoverableNeuronSeries(m))
                }
            }

            function createHoverableNeuronSeries(mean) {
                const newSeries = createSeries(
                    ChartView.SeriesTypeScatter, 'center',
                    xAxis, yAxis
                )
                newSeries.color = 'black'
                newSeries.hovered.connect((point, state) => {
                    const position = mapToPosition(point)
                    chartToolTip.x = position.x - chartToolTip.width
                    chartToolTip.y = position.y - chartToolTip.height
                    chartToolTip.text = `Mean: (${point.x}, ${point.y})`
                    chartToolTip.visible = state
                })
                newSeries.append(mean[0], mean[1])
                newSeries.useOpenGL = true
                return newSeries
            }

            // XXX: sadly, QML does not have `super` access to the base class. Thus,
            // we cannot call super method in overridden methods.
            // Further details: https://bugreports.qt.io/browse/QTBUG-25942
            function clear() {
                removeAllSeries()
                scatterSeriesMap = {}
                neuronScatters = []
            }
        }
        RowLayout {
            ChartView {
                id: neuronChart
                antialiasing: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                ToolTip {
                    id: neuronChartToolTip
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                }
                BarSeries {
                    id: neuronChartSeries
                    useOpenGL: true
                    axisX: BarCategoryAxis {
                        titleText: 'Neurons'
                        categories: Array.from(Array(clusterCount.value).keys())
                    }
                    axisY: ValueAxis {
                        id: neuronChartAxisY
                        max: 0
                        min: 0
                    }
                    BarSet {
                        id: standardDeviationBarSet
                        label: 'Standard Deviation'
                        values: rbfnBridge.current_neurons.map(neuron => neuron.standard_deviation)
                    }
                    BarSet {
                        id: synapticWeightBarSet
                        label: 'Synaptic Weight'
                        values: rbfnBridge.current_neurons.map(neuron => neuron.synaptic_weight)
                    }
                    onHovered: (status, index, barset) => {
                        neuronChartToolTip.text = barset.at(index)
                        neuronChartToolTip.visible = status
                    }
                }
                function updateAxisY() {
                    const max = Math.max(...standardDeviationBarSet.values)
                    const min = Math.min(...standardDeviationBarSet.values)
                    neuronChartAxisY.max = isFinite(max) ? max : 0
                    neuronChartAxisY.min = isFinite(min) ? min : 0
                }
            }
            RateChart {
                id: rateChart
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
    Connections {
        target: rbfnBridge
        // update the chart scatter series to the best neurons at the end of the
        // training.
        onHas_finishedChanged: dataChart.updateNeurons()
    }
}