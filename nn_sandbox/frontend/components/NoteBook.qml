import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {
    default property list<Item> pages

    anchors.fill: parent
    TabBar {
        id: bar
        Layout.fillWidth: true

        Repeater {
            model: pages.length
            TabButton { text: pages[index].name }
        }
    }
    StackLayout {
        Layout.fillWidth: true
        currentIndex: bar.currentIndex
        data: pages
    }
}