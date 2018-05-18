//
//  NewResultsViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/23/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

//
//  ResultsViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/6/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import Charts
import Foundation


class NewResultsViewController: UIViewController {
    

    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var imageAvgLossR: UIImageView!
    @IBOutlet weak var imageAvgLossL: UIImageView!
    
    let freq : [Double] = [1000, 2000, 3000, 4000]
    var catchTempR: [Double] = []
    var catchTempL: [Double] = []
    
    //  weight was calculated from sii weights (table c.1 column 2 ANSI-ASA S3.35) = [0.0818, 0.0898, 0.0850, 0.0771]. The sum of these weights at 1, 2, 3, and 4 (note: 3kHz interpolated b/w 2.5 and 3.15 kHz) was then calculated = 0.3337, which then each weight was divided by this sum to get the relative proportion of each frequency = 0.2451, 0.2691, 0.2547, 0.2310. These values were then used to calculate corrections factors by dividing each value in the array by 0.25, which is the value for each if all frequencies have the same weight. This resulted in the weight values below, which will be used to multiply each threshold at each of the respective frequency to determine its contribuion to the overall average hearing threshold.
    let weight : [Double] = [0.9805, 1.0764, 1.0189, 0.9242]
    
    struct GlobalVar{
        static var threshR = [Double]()
        static var threshL = [Double]()
        static var avgR = [Double]()
        static var avgL = [Double]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<4 {
            let temp = [logC(val: TestViewController.GlobalVar.threshold[i]/TestViewController.GlobalVar.calLevelR[i], forBase: 10.0)]
            GlobalVar.threshR.append(contentsOf: temp)
        }
        for i in 0..<4 {
            let temp = [logC(val: TestViewController.GlobalVar.threshold[i+4]/TestViewController.GlobalVar.calLevelL[i], forBase: 10.0)]
            GlobalVar.threshL.append(contentsOf: temp)
        }
        print("Right thresholds (dB HL) are \(GlobalVar.threshR)")
        print("Left thresholds (dB HL) are \(GlobalVar.threshL)")
        updateGraph()
        freqWeight()
        avgLossR()
        avgLossL()
    }
    
    func logC(val: Double, forBase base: Double) -> Double {
        return round(20 * log(val)/log(base) + 70) // calibrated to initial starting level of 70 dB HL (e.g., RETSPL 1 kHz = 75.5 dB SPL)
    }
    
    func freqWeight() {
        for i in 0..<4 {
            let tempR = weight[i] * GlobalVar.threshR[i]
            let tempL = weight[i] * GlobalVar.threshL[i]
            catchTempR.append(tempR)
            catchTempL.append(tempL)
        }
        GlobalVar.avgR = [(catchTempR[0] + catchTempR[1] + catchTempR[2] + catchTempR[3]) / 4.0]
        GlobalVar.avgL = [(catchTempL[0] + catchTempL[1] + catchTempL[2] + catchTempL[3]) / 4.0]
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        var lineChartEntry2 = [ChartDataEntry]()
        
        
        //here is the for loop
        for i in 0..<GlobalVar.threshR.count {
            
            let value = ChartDataEntry(x: freq[i], y: GlobalVar.threshR[i]) // here we set the X and Y status in a data chart entry
            let value2 = ChartDataEntry(x: freq[i], y: GlobalVar.threshL[i])
            lineChartEntry.append(value) // here we add it to the data set
            lineChartEntry2.append(value2)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Right") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.red] //Sets the colour to blue
        line1.setCircleColor(UIColor.red)
        line1.circleHoleColor = UIColor.clear
        line1.circleRadius = 5.0
        let gradientColors = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return}
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let line2 = LineChartDataSet(values: lineChartEntry2, label: "Left")
        line2.colors = [NSUIColor.blue]
        line2.setCircleColor(UIColor.blue)
        line2.circleHoleColor = UIColor.clear
        line2.circleRadius = 4.5
        let gradientColors2 = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations2: [CGFloat] = [1.0, 0.0]
        guard let gradient2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors2, locations: colorLocations2) else { print("gradient error"); return}
        line2.fill = Fill.fillWithLinearGradient(gradient2, angle: 90.0)
        line2.drawFilledEnabled = true
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        data.addDataSet(line2)
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "Hearing Levels" // Here we set the description for the graph
        
        chtChart.leftAxis.inverted = true
        chtChart.leftAxis.axisMinimum = -10
        chtChart.leftAxis.axisMaximum = 120
        chtChart.rightAxis.labelCount = 14
        chtChart.rightAxis.inverted = true
        chtChart.rightAxis.axisMinimum = -10
        chtChart.rightAxis.axisMaximum = 120
        chtChart.leftAxis.labelCount = 14
        chtChart.xAxis.axisMinimum = 910
        chtChart.xAxis.axisMaximum = 4050
        chtChart.xAxis.granularity = 1000
        
    }
    
    func avgLossR() {
        print("Avg Right: \(GlobalVar.avgR)")
        if GlobalVar.avgR[0] <= 0 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-0")
        }
        else if GlobalVar.avgR[0] > 0 && GlobalVar.avgR[0] <= 5 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-30")
        }
        else if GlobalVar.avgR[0] > 5 && GlobalVar.avgR[0] <= 10 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-45")
        }
        else if GlobalVar.avgR[0] > 10 && GlobalVar.avgR[0] <= 15 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-60")
        }
        else if GlobalVar.avgR[0] > 15 && GlobalVar.avgR[0] <= 25 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-90")
        }
        else if GlobalVar.avgR[0] > 25 && GlobalVar.avgR[0] <= 40 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-120")
        }
        else if GlobalVar.avgR[0] > 40 && GlobalVar.avgR[0] <= 47 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-135")
        }
        else if GlobalVar.avgR[0] > 47 && GlobalVar.avgR[0] <= 55 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-150")
        }
        else if GlobalVar.avgR[0] > 55 && GlobalVar.avgR[0] <= 70 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-180")
        }
        else if GlobalVar.avgR[0] > 70 && GlobalVar.avgR[0] <= 77 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-210")
        }
        else if GlobalVar.avgR[0] > 77 && GlobalVar.avgR[0] <= 85 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-225")
        }
        else if GlobalVar.avgR[0] > 85 && GlobalVar.avgR[0] <= 90 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-240")
        }
        else if GlobalVar.avgR[0] > 90 {
            imageAvgLossR.image = UIImage(named: "hearingMeter-270")
        }
    }
    
    func avgLossL() {
        print("Avg Left: \(GlobalVar.avgL)")
        if GlobalVar.avgL[0] <= 0 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-0")
        }
        else if GlobalVar.avgL[0] > 0 && GlobalVar.avgL[0] <= 5 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-30")
        }
        else if GlobalVar.avgL[0] > 5 && GlobalVar.avgL[0] <= 10 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-45")
        }
        else if GlobalVar.avgL[0] > 10 && GlobalVar.avgL[0] <= 15 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-60")
        }
        else if GlobalVar.avgL[0] > 15 && GlobalVar.avgL[0] <= 25 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-90")
        }
        else if GlobalVar.avgL[0] > 25 && GlobalVar.avgL[0] <= 40 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-120")
        }
        else if GlobalVar.avgL[0] > 40 && GlobalVar.avgL[0] <= 47 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-135")
        }
        else if GlobalVar.avgL[0] > 47 && GlobalVar.avgL[0] <= 55 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-150")
        }
        else if GlobalVar.avgL[0] > 55 && GlobalVar.avgL[0] <= 70 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-180")
        }
        else if GlobalVar.avgL[0] > 70 && GlobalVar.avgL[0] <= 77 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-210")
        }
        else if GlobalVar.avgL[0] > 77 && GlobalVar.avgL[0] <= 85 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-225")
        }
        else if GlobalVar.avgL[0] > 85 && GlobalVar.avgL[0] <= 90 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-240")
        }
        else if GlobalVar.avgL[0] > 90 {
            imageAvgLossL.image = UIImage(named: "hearingMeter-270")
        }
    }
    
}



