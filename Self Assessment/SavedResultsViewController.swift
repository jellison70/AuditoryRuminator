//
//  SavedResultsViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 5/1/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import CoreData
import Charts

class SavedResultsViewController: UIViewController {
    
    var selectedTest: CurrentTest?
    
    @IBOutlet weak var chtChart2: LineChartView!
    @IBOutlet weak var imageAvgLossR2: UIImageView!
    @IBOutlet weak var imageAvgLossL2: UIImageView!
    
    let freq : [Double] = [1000, 2000, 3000, 4000]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGraph()
        avgLossL()
        avgLossR()

    }
    
    @IBAction func clearGlobals(_ sender: Any) {
        TestViewController.GlobalVar.threshold.removeAll()
        NewResultsViewController.GlobalVar.threshL.removeAll()
        NewResultsViewController.GlobalVar.threshR.removeAll()
        NewResultsViewController.GlobalVar.avgL.removeAll()
        NewResultsViewController.GlobalVar.avgR.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshL.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshR.removeAll()
        StoredResultsViewController.GlobalVar.retrieveAvgL.removeAll()
        StoredResultsViewController.GlobalVar.retrieveAvgR.removeAll()
        TestViewController.GlobalVar.calLevelL.removeAll()
        TestViewController.GlobalVar.calLevelR.removeAll()
    }
    
    @IBAction func unwindSeguePlotSavedResults(_ sender: UIStoryboardSegue) {
    
    }
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        var lineChartEntry2 = [ChartDataEntry]()
        
        
        //here is the for loop
        for i in 0..<StoredResultsViewController.GlobalVar.retrieveThreshR.count {
            
            let value = ChartDataEntry(x: freq[i], y: StoredResultsViewController.GlobalVar.retrieveThreshR[i]) 
            let value2 = ChartDataEntry(x: freq[i], y: StoredResultsViewController.GlobalVar.retrieveThreshL[i])
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
        
        chtChart2.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart2.chartDescription?.text = "Hearing Levels" // Here we set the description for the graph
        
        chtChart2.leftAxis.inverted = true
        chtChart2.leftAxis.axisMinimum = -10
        chtChart2.leftAxis.axisMaximum = 120
        chtChart2.rightAxis.labelCount = 14
        chtChart2.rightAxis.inverted = true
        chtChart2.rightAxis.axisMinimum = -10
        chtChart2.rightAxis.axisMaximum = 120
        chtChart2.leftAxis.labelCount = 14
        chtChart2.xAxis.axisMinimum = 900
        chtChart2.xAxis.axisMaximum = 4100
        chtChart2.xAxis.granularity = 1000
        
    }
    func avgLossR() {
        print("Avg Right: \(StoredResultsViewController.GlobalVar.retrieveAvgR)")
        if StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 0 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-0")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 0 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 5 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-30")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 5 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 10 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-45")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 10 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 15 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-60")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 15 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 25 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-90")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 25 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 40 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-120")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 40 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 47 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-135")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 47 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 55 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-150")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 55 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 70 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-180")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 70 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 77 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-210")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 77 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 85 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-225")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 85 && StoredResultsViewController.GlobalVar.retrieveAvgR[0] <= 90 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-240")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgR[0] > 90 {
            imageAvgLossR2.image = UIImage(named: "hearingMeter-270")
        }
    }
    
    func avgLossL() {
        print("Avg Left: \(StoredResultsViewController.GlobalVar.retrieveAvgL)")
        if StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 0 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-0")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 0 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 5 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-30")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 5 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 10 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-45")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 10 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 15 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-60")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 15 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 25 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-90")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 25 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 40 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-120")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 40 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 47 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-135")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 47 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 55 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-150")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 55 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 70 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-180")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 70 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 77 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-210")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 77 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 85 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-225")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 85 && StoredResultsViewController.GlobalVar.retrieveAvgL[0] <= 90 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-240")
        }
        else if StoredResultsViewController.GlobalVar.retrieveAvgL[0] > 90 {
            imageAvgLossL2.image = UIImage(named: "hearingMeter-270")
        }
    }

}
