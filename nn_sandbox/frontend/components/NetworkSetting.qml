import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

GridLayout {
    property int totalLayers: 6
    

    anchors.fill: parent
    columns: 3
    Label {
        text: 'Number of Layers'
        Layout.alignment: Qt.AlignHCenter
    }
    Slider {
        id: slider
        from: 1
        to: totalLayers
        value: 2
        stepSize: 1
        Layout.fillWidth: true
    }
    Label {
        text: slider.value
        Layout.alignment: Qt.AlignHCenter
    }
    GridLayout {
        columns: totalLayers / 2
        Repeater {
            model: totalLayers
            RowLayout{
                enabled: slider.value >= index + 1
                Label { text: index }
                SpinBox {
                    from: 1
                    to: 100
                    value: 5
                    Layout.fillWidth: true
                }
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        Layout.columnSpan: 3
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}