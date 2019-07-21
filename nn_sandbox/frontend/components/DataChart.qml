import QtQuick.Controls 2.5
import QtCharts 2.3

ChartView {
    property var scatterSeriesMap: ({})
    property alias xAxis: xAxis
    property alias yAxis: yAxis

    antialiasing: true
    legend.visible: false
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
    ToolTip {
        id: chartToolTip
    }

    function updateDataset(dataset) {
        clear()
        addScatterSeries(dataset)
        updateAxesRange(dataset)
    }

    function updateTrainingDataset(dataset) {
        addScatterSeries(dataset)
    }

    function updateTestingDataset(dataset) {
        dataset.sort((a, b) => {return a[2] - b[2]})
        for (let data of dataset) {
            if (!(`${data[2]}test` in scatterSeriesMap)) {
                scatterSeriesMap[`${data[2]}test`] = createHoverableScatterSeries(`${data[2]}test`)
                if (data[2] in scatterSeriesMap)
                    scatterSeriesMap[`${data[2]}test`].color = Qt.lighter(scatterSeriesMap[data[2]].color)
            }
            scatterSeriesMap[`${data[2]}test`].append(data[0], data[1])
        }
    }

    function addScatterSeries(dataset) {
        dataset.sort((a, b) => {return a[2] - b[2]})
        for (let data of dataset) {
            if (!(data[2] in scatterSeriesMap))
                scatterSeriesMap[data[2]] = createHoverableScatterSeries(data[2])
            scatterSeriesMap[data[2]].append(data[0], data[1])
        }
    }

    function createHoverableScatterSeries(name) {
        const newSeries = createSeries(
            ChartView.SeriesTypeScatter, name, xAxis, yAxis
        )
        newSeries.hovered.connect((point, state) => {
            const position = mapToPosition(point)
            chartToolTip.x = position.x - chartToolTip.width
            chartToolTip.y = position.y - chartToolTip.height
            chartToolTip.text = `(${point.x}, ${point.y})`
            chartToolTip.visible = state
        })
        return newSeries
    }

    function updateAxesRange(dataset) {
        let xMax = -Infinity, yMax = -Infinity, xMin = Infinity, yMin = Infinity
        for (let row of dataset) {
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

    function clear() {
        removeAllSeries()
        scatterSeriesMap = {}
    }
}