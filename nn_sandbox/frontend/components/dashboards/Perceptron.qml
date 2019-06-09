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
                model: bridge.data
            }
            Component.onCompleted: () => {
                console.log(bridge.data)
                console.log(bridge.num)
                for (let prop in bridge) {
                    console.log(prop)
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
        width: 600
        Layout.fillWidth: true
        Layout.fillHeight: true
        antialiasing: true
        ScatterSeries {
            name: 'ScatterSeries'
            XYPoint { x: 1.5; y: 1.5 }
            XYPoint { x: 1.5; y: 1.6 }
            XYPoint { x: 1.57; y: 1.55 }
            XYPoint { x: 1.8; y: 1.8 }
            XYPoint { x: 1.9; y: 1.6 }
            XYPoint { x: 2.1; y: 1.3 }
            XYPoint { x: 2.5; y: 2.1 }
        }
        LineSeries {
            name: 'LineSeries'
            XYPoint { x: 1.5; y: 1.5 }
            XYPoint { x: 1.5; y: 1.6 }
            XYPoint { x: 1.57; y: 1.55 }
            XYPoint { x: 1.8; y: 1.8 }
            XYPoint { x: 1.9; y: 1.6 }
            XYPoint { x: 2.1; y: 1.3 }
            XYPoint { x: 2.5; y: 2.1 }
        }
    }
}