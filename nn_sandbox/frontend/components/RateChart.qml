import QtQuick 2.12
import QtQuick.Controls 2.5
import QtCharts 2.3

ChartView {
    id: chart
    property var bestCorrectRate: LineSeries { axisX: xAxis; axisY: yAxis }
    property var trainingCorrectRate: LineSeries { axisX: xAxis; axisY: yAxis }
    property var testingCorrectRate: LineSeries { axisX: xAxis; axisY: yAxis }
    
    ValueAxis{
        id: xAxis
        min: 1.0
        max: 2.0
    }
    ValueAxis{
        id: yAxis
        min: 0.0
        max: 1.0
    }

    function updateAxes(point) {
        xAxis.max = Math.max(xAxis.max, point.x)
        xAxis.min = Math.min(xAxis.min, point.x)
    }

    function reset() {
        removeAllSeries()
        trainingCorrectRate = createSeries(
            ChartView.SeriesTypeLine, 'Training Correct Rate', xAxis, yAxis
        )
        trainingCorrectRate.pointAdded.connect((index) => {
            updateAxes(trainingCorrectRate.at(index))
        })
        testingCorrectRate = createSeries(
            ChartView.SeriesTypeLine, 'Testing Correct Rate', xAxis, yAxis
        )
        testingCorrectRate.pointAdded.connect((index) => {
            updateAxes(testingCorrectRate.at(index))
        })
        bestCorrectRate = createSeries(
            ChartView.SeriesTypeLine, 'Best Training Correct Rate', xAxis, yAxis
        )
        bestCorrectRate.pointAdded.connect((index) => {
            updateAxes(bestCorrectRate.at(index))
        })
        xAxis.max = 1
        xAxis.min = 0
        yAxis.max = 1
        yAxis.min = 0
    }

    Component.onCompleted: reset()
}