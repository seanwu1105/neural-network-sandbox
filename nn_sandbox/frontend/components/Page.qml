import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

// TODO: after Qt 5.13 release, switch to SplitView for better adjustability.
// XXX: even after PyQt and Qt 5.13 has released, it still can NOT find SplitView type, which seems to be a bug.

RowLayout {
    property string name
}