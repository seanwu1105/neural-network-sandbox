import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

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
                    dataChart.updateDataset(mlpBridge.dataset_dict[datasetCombobox.currentText])
                }
                Component.onCompleted: () => {
                    mlpBridge.current_dataset_name = currentText
                    dataChart.updateDataset(mlpBridge.dataset_dict[datasetCombobox.currentText])
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
                        dataChart.clear()
                        dataChart.updateTrainingDataset(mlpBridge.training_dataset)
                        dataChart.updateTestingDataset(mlpBridge.testing_dataset)
                        rateChart.reset()
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
                    onTextChanged: () => {
                        rateChart.bestCorrectRate.append(
                            mlpBridge.current_iterations + 1,
                            mlpBridge.best_correct_rate
                        )
                        rateChart.trainingCorrectRate.append(
                            mlpBridge.current_iterations + 1,
                            mlpBridge.current_correct_rate
                        )
                        rateChart.testingCorrectRate.append(
                            mlpBridge.current_iterations + 1,
                            mlpBridge.test_correct_rate
                        )
                    }
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
                    text: 'Current Testing Correct Rate'
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
    ColumnLayout {
        DataChart {
            id: dataChart
            width: 700
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        RateChart {
            id: rateChart
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Connections {
        target: mlpBridge
        // update the chart group display to the best synaptic weight at the end
        // of the training.
        // TODO: onHas_finishedChanged: dataChart.updateGroupDisplay()
    }
}