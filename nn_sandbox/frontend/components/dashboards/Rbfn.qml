import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

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
                    enabled: rbfnBridge.has_finished
                    editable: true
                    value: 3
                    from: 1
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
                        rbfnBridge.start_mlp_algorithm()
                        dataChart.clear()
                        dataChart.updateTrainingDataset(rbfnBridge.training_dataset)
                        dataChart.updateTestingDataset(rbfnBridge.testing_dataset)
                        rateChart.reset()
                    }
                    stopButton.enabled: !rbfnBridge.has_finished
                    stopButton.onClicked: rbfnBridge.stop_mlp_algorithm()
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
}