import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {
    default property list<Item> pages

    anchors.fill: parent
    TabBar {
        id: bar
        Layout.fillWidth: true
        Component.onCompleted: () => {
            for (let i = 0; i < pages.length; i++) {
                let component = Qt.createQmlObject(`
                import QtQuick.Controls 2.5
                TabButton { text: '${pages[i].name}' }
                `, bar)
            }
            window.height = body.implicitHeight
        }
    }
    StackLayout {
        Layout.fillWidth: true
        currentIndex: bar.currentIndex
        data: pages
    }
}