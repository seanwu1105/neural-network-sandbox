import QtQuick.Controls 2.5

// call textarea.append(text) to log info

ScrollView {
    anchors.fill: parent
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
    TextArea {
        implicitHeight: 100
        placeholderText : 'logging info...'
        readOnly: true
    }
}