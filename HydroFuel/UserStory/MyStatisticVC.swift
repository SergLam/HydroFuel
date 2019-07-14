//
//  MyStatisticVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import Charts

final class MyStatisticVC: UIViewController {
    
    @IBOutlet private weak var lblnineteendays: UILabel!
    @IBOutlet private weak var lblthirteendays: UILabel!
    @IBOutlet private weak var lblsevendays: UILabel!
    @IBOutlet private weak var imgback: UIImageView!
    @IBOutlet private weak var linechart: LineChartView!
    
    var DateArr = [String]()
    var unitsSold = [Double]()
    private weak var axisFormatDelegate: IAxisValueFormatter?
    
    var arrDates = Array<String>()
    var arrDataForDates = Array<String>()
    var arrtotal = Array<String>()
    let months = ["15-Aug-2017","20-Aug-2017"]
    let dataofy = [1900,190]
    var arrShowDates: [String] = []
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
        if arrDates.count == 0 {
            let today = Date()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormatter.string(from: today)
            
            let Day = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let Yesterday = dateFormatter.string(from: Day!)
            var arrDatesForGraph = Array<String>()
            arrDatesForGraph.append(Yesterday)
            arrDatesForGraph.append(strDate)
            
            arrDates = arrDatesForGraph
            for i in 0..<arrDates.count {
                searchDataForProgress(strDate: arrDates[i])
                let date = (arrDates[i]).components(separatedBy: "-")
                arrShowDates.append("\(date[1])-\(date[2])")
                if i == arrDates.count - 1 {
                    // self.setChartData(months: arrShowDates)
                }
            }
        }else{
            
            for i in 0..<arrDates.count {
                searchDataForProgress(strDate: arrDates[i])
                let date = (arrDates[i]).components(separatedBy: "-")
                arrShowDates.append("\(date[1])-\(date[2])")
                
                if i == arrDates.count - 1 {
                    // self.setChartData(months: arrShowDates)
                }
            }
        }
        
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch appDelegate.backvar {
            
        case "static":
            imgback.image = UIImage(named: "backk")
            appDelegate.backvar = "static"
            
        case "graph":
            imgback.image = UIImage(named: "menu")
            appDelegate.backvar = "graph"
            
        default:
            appDelegate.backvar = "abc"
            imgback.image = UIImage(named: "backk")
        }
    }
    
    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        switch appDelegate.backvar {
            
        case "static":
            imgback.image = UIImage(named: "backk")
            appDelegate.backvar = "static"
            self.navigationController?.popViewController(animated: true)
            
        case "graph":
            imgback.image = UIImage(named: "menu")
            appDelegate.backvar = "graph"
            self.toggleLeft()
            
        default:
            appDelegate.backvar = "abc"
            imgback.image = UIImage(named: "backk")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func configureChartView() {
        
        linechart.xAxis.granularity = 1 //  to show intervals
        linechart.xAxis.gridColor = UIColor.clear
        linechart.xAxis.wordWrapEnabled = true
        linechart.xAxis.labelWidth = CGFloat(50)
        linechart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 7.0)
        
        linechart.xAxis.labelPosition = .top // lebel position on graph
        linechart.legend.formSize = 0
        linechart.xAxis.drawGridLinesEnabled = false // show gird on graph
        linechart.rightAxis.drawLabelsEnabled = false// to show right side value on graph
        linechart.data?.setDrawValues(true) //
        linechart.chartDescription?.text = ""
        linechart.scaleXEnabled = true
        linechart.scaleYEnabled = true
    }
    
    
    func setChartData(months : [String]) {
        
        var yVals1: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(x:Double(i) , y: Double(arrDataForDates[i] as! Double)))
            
        }
        
        let set1: LineChartDataSet = LineChartDataSet(entries: yVals1, label: "-- Water Intake")
        set1.axisDependency = .left // Line will correlate with left axis values
        
        set1.setColor(UIColor.blue)
        set1.setCircleColor(UIColor.blue)
        set1.circleRadius = 3.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.blue
        
        //3 - create an array to store our LineChartDataSets
        var dataSets:[LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        print(dataSets)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data : LineChartData = LineChartData(dataSets: dataSets)
        
        //5 - finally set our data
        linechart.data = data
        
        linechart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        configureChartView()
        
        linechart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
        let gradColors = [UIColor.blue.cgColor, UIColor.clear.cgColor]
        let colorLocations:[CGFloat] = [0.5, 0.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set1.fill = Fill(linearGradient: gradient, angle: 500.0)
            
            set1.drawFilledEnabled = true // Draw the Gradient
        }
    }
    
    func searchDataForProgress(strDate: String) {
        
        let result = DataManager.shared.selectAllByDate(strDate)
        
        guard let dictPrevious = result.first else {
            return
        }
        
        let TOTALATTEMPT = dictPrevious.totalAttempt
        let WATERQTYPERATTEMPT = dictPrevious.waterPerAttempt
        
        let totalWater = TOTALATTEMPT * WATERQTYPERATTEMPT
        
        arrDataForDates.append(String(totalWater))
    }
    
    func showData() {
        
    }
    
}

