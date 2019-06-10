import QtQuick 2.12
import QtQuick.Controls 2.5

SpinBox {
    id: spinbox
    value: realValue * 100
    from: realFrom * 100
    to: realTo * 100
    stepSize: 1

    property int decimals: 2
    property real realValue: 0
    property real realFrom: 0
    property real realTo: 1
    

    validator: DoubleValidator {
        bottom: Math.min(spinbox.from, spinbox.to)
        top:  Math.max(spinbox.from, spinbox.to)
    }

    textFromValue: (value, locale) => {
        return Number(value / 100).toLocaleString(locale, 'f', spinbox.decimals)
    }

    valueFromText: (text, locale) => {
        return Number.fromLocaleString(locale, text) * 100
    }
}