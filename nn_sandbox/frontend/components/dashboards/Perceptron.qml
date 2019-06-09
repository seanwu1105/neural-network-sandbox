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
                anchors.fill: parent
                model: Object.keys(bridge.data)
                function updateChart() {
                    let xMax = -Infinity, yMax = -Infinity, xMin = Infinity, yMin = Infinity
                    chart.removeAllSeries()
                    let seriesMap = {}
                    for (let row of bridge.data[currentText]) {
                        if (!(row[2] in seriesMap))
                            seriesMap[row[2]] = chart.createSeries(ChartView.SeriesTypeScatter, row[2], xAxis, yAxis)
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
                onActivated: updateChart()
                Component.onCompleted: updateChart()
            }
        }
        GroupBox {
            title: 'Settings'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    text: 'Initial Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox { Layout.fillWidth: true }
                Label {
                    text: 'Search Time Constant'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox { Layout.fillWidth: true }
                Label {
                    text: 'Total Training Times'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox { Layout.fillWidth: true }
                CheckBox {
                    text: 'Most Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                SpinBox {Layout.fillWidth: true }
            }
        }
        GroupBox {
            title: 'Information'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                ExecutionControls {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Training Times'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: '--'
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Current Learning Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: '--'
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Label {
                    text: 'Best Training Correct Rate'
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: '--'
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
    }
}