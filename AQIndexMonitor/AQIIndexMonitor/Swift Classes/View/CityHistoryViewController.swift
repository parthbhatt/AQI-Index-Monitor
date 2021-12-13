//
//  BarViewController.swift
//  BarChartDemo
//
//  Copied from danielgindi/Charts ( Customize as per need)
//


import UIKit
import Charts

class CityHistoryViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var cityName: String!
    var arrCityAQI: [Double] = []
    var arrTimeStamp: [Date] = []
    var displayxAxis: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cityName
        
        barChartView.delegate = self
        axisFormatDelegate = self
        
        for val in arrTimeStamp
        {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ss a"
            let dateTime: String = formatter.string(from: val)
            displayxAxis.append(String(dateTime))
        }
        
        setChart(dataPoints: displayxAxis, values: arrCityAQI)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "No Data Available"
        if  dataPoints.count == 0
        {
            return
        }
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<values.count {
            let entry = BarChartDataEntry(x: Double(i), y: values[i], data: displayxAxis as AnyObject?)
            dataEntries.append(entry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightColor = UIColor.orange.withAlphaComponent(0.3)
        chartDataSet.highlightAlpha = 1
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        
        var colorData :[UIColor] = []
        for val in values
        {
            colorData.append(ColorUtility.setColor(aqiValue: val))
        }
        
        chartDataSet.colors = colorData
        
        //Animation bars
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInCubic)
        
        // X axis configurations
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.drawAxisLineEnabled = true
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15.0)
        barChartView.xAxis.labelTextColor = UIColor.black
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelRotationAngle = 45.0
        
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 550
        
        // Right axis configurations
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        
        // Other configurations
        barChartView.highlightPerDragEnabled = false
        barChartView.chartDescription?.text = ""
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.scaleYEnabled = true
        
        barChartView.drawMarkers = true
        
        // On tapped bar marker  before add BalloonMarker.swift
        
        let marker =  BalloonMarker(color: UIColor.white, font: UIFont.boldSystemFont(ofSize: 13), textColor: UIColor.black, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 15.0, right: 7.0))
        marker.chartView = barChartView
        barChartView.marker = marker
        
    }
    
}
extension CityHistoryViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return displayxAxis[Int(value)]//months[Int(value)]
    }
}




