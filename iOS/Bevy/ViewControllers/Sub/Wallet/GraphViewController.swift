//
//  GraphViewController.swift
//  Bevy
//
//  Created by macOS on 8/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
//import ScrollableGraphView
//import PNChart

class GraphViewController: BaseSubViewController {
    var linePlotData: [Double] = [30, 40, 20, 10, 50]

//    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
//        switch(plot.identifier) {
//        case "line":
//            return linePlotData[pointIndex]
//        default:
//            return 0
//        }
//    }
//
//    func label(atIndex pointIndex: Int) -> String {
//        return "FEB \(pointIndex)"
//    }
//
//    func numberOfPoints() -> Int {
//        return linePlotData.count
//    }

    @IBOutlet weak var viewGraph: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let graphView = ScrollableGraphView(frame: self.viewGraph.frame, dataSource: self)
//
//        // Setup the plot
//        let linePlot = LinePlot(identifier: "darkLine")
//
//        linePlot.lineWidth = 1
//        linePlot.lineColor = UIColor(rgb: 0x777777)
//        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
//
//        linePlot.shouldFill = true
//        linePlot.fillType = ScrollableGraphViewFillType.gradient
//        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
//        linePlot.fillGradientStartColor = UIColor(rgb: 0x555555)
//        linePlot.fillGradientEndColor = UIColor(rgb: 0x444444)
//
//        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//
//        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
//        dotPlot.dataPointSize = 2
//        dotPlot.dataPointFillColor = UIColor.white
//
//        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//
//        // Setup the reference lines.
//        let referenceLines = ReferenceLines()
//
//        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
//        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
//        referenceLines.referenceLineLabelColor = UIColor.white
//
//        referenceLines.positionType = .absolute
//        // Reference lines will be shown at these values on the y-axis.
//        referenceLines.absolutePositions = [10, 20, 25, 30]
//        referenceLines.includeMinMax = false
//
//        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
//
//        // Setup the graph
//        graphView.backgroundFillColor = UIColor(rgb: 0x333333)
//        graphView.dataPointSpacing = 80
//
//        graphView.shouldAnimateOnStartup = true
//        graphView.shouldAdaptRange = true
//        graphView.shouldRangeAlwaysStartAtZero = true
//
//        graphView.rangeMax = 50
//
//        // Add everything to the graph.
//        graphView.addReferenceLines(referenceLines: referenceLines)
//        graphView.addPlot(plot: linePlot)
//        graphView.addPlot(plot: dotPlot)
//
//        self.viewGraph.addSubview(graphView)

//        let lineChart = self.setLineChart()
//        self.view.addSubview(lineChart)
    }

//    private func setLineChart() -> PNLineChart {
//        let lineChart = PNLineChart(frame: CGRect(x: 0, y: 135, width: 320, height: 250))
//        lineChart.yLabelFormat = "%1.1f"
//        lineChart.showLabel = true
//        lineChart.backgroundColor = UIColor.clear
//        lineChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
//        lineChart.isShowCoordinateAxis = true
//        lineChart.center = self.view.center
//
//        let dataArr = [60.1, 160.1, 126.4, 232.2, 186.2, 127.2, 176.2]
//        var data = PNLineChartData()
//        data.itemCount = UInt(dataArr.count)
//        data.inflexionPointStyle = .none
//        data.getData = ({
//            (index: Int) -> PNLineChartDataItem in
//            let yValue = CGFloat(dataArr[index])
//            let item = PNLineChartDataItem(y: yValue)
//            return item
//        })
//
//        lineChart.chartData = [data]
//        lineChart.stroke()
//        return lineChart
//    }

}
