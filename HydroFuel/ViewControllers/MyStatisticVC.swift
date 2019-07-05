//
//  MyStatisticVC.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit
import Charts

class MyStatisticVC: UIViewController {
  
    
    @IBOutlet var lblnineteendays: UILabel!
    @IBOutlet var lblthirteendays: UILabel!
    @IBOutlet var lblsevendays: UILabel!
    var DateArr = [String]()
  
    var unitsSold = [Double]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet var imgback: UIImageView!
    @IBOutlet var linechart: LineChartView!
    var arrDates = NSMutableArray()
    var arrDataForDates = NSMutableArray()
    var arrtotal = NSMutableArray()
    let months = ["15-Aug-2017","20-Aug-2017"]
    let dataofy = [1900,190]
  var arrShowDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         showData()
        if arrDates.count == 0 {
            let today = Date()
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd"
            dateFormattor.timeZone = TimeZone(identifier: "UTC")
            let strDate = dateFormattor.string(from: today)
            print(strDate)
            let Day = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let Yesterday = dateFormattor.string(from: Day!)
            let arrDatesForGraph = NSMutableArray()
            arrDatesForGraph.add(Yesterday)
            arrDatesForGraph.add(strDate)
            arrDates = arrDatesForGraph
            for i in 0..<arrDates.count {
                searchDataForProgress(strDate: arrDates[i] as! String)
                let date = (arrDates[i] as! String).components(separatedBy: "-")
                arrShowDates.append("\(date[1])-\(date[2])")
                if i == arrDates.count - 1 {
                    self.setChartData(months: arrShowDates)
                }
            }
        }else{
            
        for i in 0..<arrDates.count {
            searchDataForProgress(strDate: arrDates[i] as! String)
            let date = (arrDates[i] as! String).components(separatedBy: "-")
            arrShowDates.append("\(date[1])-\(date[2])")
            
            if i == arrDates.count - 1 {
                self.setChartData(months: arrShowDates)
            }
        }
        }
 
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      

        // Do any additional setup after loading the view.
    }

        
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.backvar == "static"
        {
             appDelegate.backvar = "static"
            imgback.image = UIImage(named: "backk")
        }
        else if appDelegate.backvar == "graph"
        {
            appDelegate.backvar = "graph"
            imgback.image = UIImage(named: "menu")
        }
        else{
            appDelegate.backvar = "abc"
            imgback.image = UIImage(named: "backk")
            
        }
    }

    @IBAction func btnmenuclick(_ sender: UIButton) {
        
        if appDelegate.backvar == "static"
        {
            appDelegate.backvar = "static"
            imgback.image = UIImage(named: "backk")
            self.navigationController?.popViewController(animated: true)
            
        }
        else if appDelegate.backvar == "graph"
        {
            appDelegate.backvar = "graph"
            imgback.image = UIImage(named: "menu")
            self.toggleLeft()
            
        }
        else{
            appDelegate.backvar = "abc"
            imgback.image = UIImage(named: "backk")
            self.navigationController?.popViewController(animated: true)
            
        }

    }
    func setChartData(months : [String]) {
        
        var yVals1: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(x:Double(i) , y: Double(arrDataForDates[i] as! Double)))
            
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "-- Water Intake")
        set1.axisDependency = .left // Line will correlate with left axis values
        
        set1.setColor(UIColor.blue)//.withAlphaComponent(0.1))
        set1.setCircleColor(UIColor.blue)
        set1.circleRadius = 3.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.blue
        
      //  set1.highlightColor = UIColor.white
       // set1.drawCircleHoleEnabled = false
        
       // var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
       // for i in 0 ..< months.count {
        ///    yVals2.append(ChartDataEntry(x:Double(i) , y: Double(dollars1[i])))
       // }
        
//        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Second Set")
//        set2.axisDependency = .left // Line will correlate with left axis values
//        set2.setColor(UIColor.green.withAlphaComponent(0.5))
//        set2.setCircleColor(UIColor.green)
//        set2.circleRadius = 3.0
//        set2.fillAlpha = 65 / 255.0
//        set2.fillColor = UIColor.green
//        set2.highlightColor = UIColor.white
//        set2.drawCircleHoleEnabled = false
//        set2.circleHoleRadius = 0.5
//
//        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
//        for i in 0 ..< months.count {
//            yVals3.append(ChartDataEntry(x:Double(i) , y: dollars3[i]))
     //   }
        
//        let set3: LineChartDataSet = LineChartDataSet(values: yVals3, label: "Third Set")
//        set3.axisDependency = .left // Line will correlate with left axis values
//        set3.setColor(UIColor.blue.withAlphaComponent(0.5))
//        set3.setCircleColor(UIColor.blue)
//        set3.circleRadius = 3.0
//        set3.fillAlpha = 65 / 255.0
//        set3.fillColor = UIColor.blue
//        set3.highlightColor = UIColor.white
//        set3.drawCircleHoleEnabled = false
//
        //3 - create an array to store our LineChartDataSets
        var dataSets:[LineChartDataSet] = [LineChartDataSet]()
         dataSets.append(set1)
        print(dataSets)
       // dataSets.append(set2)
        //dataSets.append(set3)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
      let data : LineChartData = LineChartData(dataSets: dataSets)
       
        
        // data.setValueTextColor(UIColor.white)
        
        //5 - finally set our data
        self.linechart.data = data
        let xaxis = self.linechart.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter(values: months)
        //linechart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        linechart.xAxis.granularity = 1 //  to show intervals
        linechart.xAxis.gridColor = UIColor.clear
        linechart.xAxis.wordWrapEnabled = true
        linechart.xAxis.labelWidth = CGFloat(50)
        linechart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 7.0)
        //linechart.xAxis.labelRotationAngle = 90
        
        linechart.xAxis.labelPosition = .top // lebel position on graph
        //linechart.xAxis.drawLabelsEnabled = true
        //linechart.legend.form = .line // indexing shape
       linechart.legend.formSize = 0
        linechart.xAxis.drawGridLinesEnabled = false // show gird on graph
       linechart.rightAxis.drawLabelsEnabled = false// to show right side value on graph
        linechart.data?.setDrawValues(true) //
        linechart.chartDescription?.text = ""
       // linechart.doubleTapToZoomEnabled = false
       // linechart.pinchZoomEnabled = false
        linechart.scaleXEnabled = true
        linechart.scaleYEnabled = true
        
        linechart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
//        let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
//        let colorLocations:[CGFloat] = [1.0, 0.1] // Positioning of the gradient
//        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        let gradColors = [UIColor.blue.cgColor, UIColor.clear.cgColor]
        let colorLocations:[CGFloat] = [0.5, 0.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set1.fill = Fill(linearGradient: gradient, angle: 500.0)

        set1.drawFilledEnabled = true // Draw the Gradient
        }
    }
    
    func searchDataForProgress(strDate : String) {
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO where DATE='\(strDate)'"
        print(strURL)
        
        let data = AFSQLWrapper.selectIdDataTable(strURL)
        print(data)
        if data.Status == 1 {
            print(data.Success)
            let arrLocalData = data.arrData
            let dictPrevious = (arrLocalData[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
         
            let TOTALATTEMPT = dictPrevious.value(forKey: "TOTALATTEMPT") as! Int
            let WATERQTYPERATTEMPT = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
            
            let totalWater = TOTALATTEMPT * WATERQTYPERATTEMPT
            
            self.arrDataForDates.add(totalWater)
       
        }else{
            self.arrDataForDates.add(0)
            print(data.Failure)
        }
        
    }
    func showData() {
        let today = Date()
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd"
        dateFormattor.timeZone = TimeZone(identifier: "UTC")
        let _ = dateFormattor.string(from: today)
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO"
        print(strURL)
        //arrLocalData.removeAllObjects()
        let data = AFSQLWrapper.selectTable(strURL)
        print(data)
        if data.Status == 1 {
            let arrLocalData = data.arrData
            for i in 0..<arrLocalData.count
            {
                print(arrLocalData.count)
                
                let dictPrevious = (arrLocalData[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print("total atempt--",dictPrevious)
                let TOTALATTEMPT = dictPrevious.value(forKey: "TOTALATTEMPT") as! Int
                let WATERQTYPERATTEMPT = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
                let totalWater = TOTALATTEMPT * WATERQTYPERATTEMPT
                //let ans = totalWater / TOTALATTEMPT
                //print(ans)
                self.arrtotal.add(totalWater)
                print("total",arrtotal)
                //                    let ans =  ((arrtotal[i]) as AnyObject) as! Int
                //                    let ans1 = (ans / Int(arrLocalData.count))
                //                    print("ans1 is",ans1)
                //                    print("ans is",ans)
                //
                
            }
            
            print(arrLocalData.count)
            
            if arrLocalData.count < 7
            {
                for j in 0..<arrtotal.count
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / Int(arrLocalData.count))
                    lblsevendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                    print("ans is",ans)
                }
            }
            else  if arrLocalData.count > 7
            {
                for j in 0..<7
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / 7)
                    lblsevendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                }
            }
            if arrLocalData.count < 30
            {
                for j in 0..<arrtotal.count
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / Int(arrLocalData.count))
                    lblthirteendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                    print("ans is",ans)
                }
            }
            else  if arrLocalData.count > 30
            {
                for j in 0..<30
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / 30)
                    lblthirteendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                }
            }
            if arrLocalData.count < 90
            {
                for j in 0..<arrtotal.count
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / Int(arrLocalData.count))
                    lblnineteendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                    print("ans is",ans)
                }
            }
            else if arrLocalData.count > 90
            {
                for j in 0..<90
                {
                    let ans =  ((arrtotal[j]) as AnyObject) as! Int
                    let ans1 = (ans / 90)
                    lblnineteendays.text = "\(ans1)" + " " +  "ml"
                    print("ans1 is",ans1)
                }
            }
            
            
            
            
            //            let WEIGHT1 = dictPrevious.value(forKey: "WEIGHT") as! Int
            //            let GENDER1 = dictPrevious.value(forKey: "GENDER") as! String
            //            let ACTIVITYLAVEL1 = dictPrevious.value(forKey: "ACTIVITYLAVEL") as! String
            //            let WATERQTY1 = dictPrevious.value(forKey: "WATERQTY") as! Int
            //let REMAININGWATERQTY1 = dictPrevious.value(forKey: "REMAININGWATERQTY") as! Int
            //let TOTALDRINK1 = dictPrevious.value(forKey: "TOTALDRINK") as! Int
            //let TOTALATTEMPT1 = dictPrevious.value(forKey: "TOTALATTEMPT") as! Int
            //   let WATERQTYPERATTEMPT1 = dictPrevious.value(forKey: "WATERQTYPERATTEMPT") as! Int
            
            
            //            self.insertData(DATE: strDate, WEIGHT: WEIGHT1, GENDER: GENDER1, ACTIVITYLAVEL: ACTIVITYLAVEL1, WATERQTY: WATERQTY1, REMAININGWATERQTY: WATERQTY1, TOTALDRINK: 0, TOTALATTEMPT: 0, WATERQTYPERATTEMPT: WATERQTYPERATTEMPT1)
            
        }
        
    }

}

