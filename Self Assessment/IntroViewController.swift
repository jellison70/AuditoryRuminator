//
//  IntroViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/11/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class IntroViewController: UIViewController {
    
    var calData = [CalibrationData]()
    
    struct GlobalVar{
        static var calLevelR = [Double]()
        static var calLevelL = [Double]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromDB()
    }
    
    func getDataFromDB() {
        let fetchRequest: NSFetchRequest<CalibrationData> = CalibrationData.fetchRequest()
        do {
            let calData = try PersistenceService.context.fetch(fetchRequest)
            self.calData = calData
            
            if calData.isEmpty {
                print("CalData for right is empty")
                print("CalData for left is empty")
            } else {
                GlobalVar.calLevelR.append(calData[calData.count-1].calR_1k)
                GlobalVar.calLevelR.append(calData[calData.count-1].calR_2k)
                GlobalVar.calLevelR.append(calData[calData.count-1].calR_3k)
                GlobalVar.calLevelR.append(calData[calData.count-1].calR_4k)
                GlobalVar.calLevelL.append(calData[calData.count-1].calL_1k)
                GlobalVar.calLevelL.append(calData[calData.count-1].calL_2k)
                GlobalVar.calLevelL.append(calData[calData.count-1].calL_3k)
                GlobalVar.calLevelL.append(calData[calData.count-1].calL_4k)
                print("calibration date: ", calData[calData.count-1].date!)
                print("right: \(GlobalVar.calLevelR)")
                print("left: \(GlobalVar.calLevelL)")
                print("RIGHT 1k: \((calData)[calData.count-1].calR_1k))")
                print("RIGHT 2k: \((calData)[calData.count-1].calR_2k))")
                print("RIGHT 3k: \((calData)[calData.count-1].calR_3k))")
                print("RIGHT 4k: \((calData)[calData.count-1].calR_4k))")
            }
        } catch {}
    }
    
    func showCalAlert() {
        let calAlert = UIAlertController(title: "You have not calibrated!", message: "Do you want to calibrate or use estimated values for earbuds?", preferredStyle: .alert)
        
        let calAction1 = UIAlertAction(title: "Calibrate", style: .default) { (calAction1) -> Void in
            let viewControllerYes = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewController")
            self.present(viewControllerYes!, animated: true, completion: nil)
        }
        
        let calAction2 = UIAlertAction(title: "Use estimated values", style: .default) { (calAction2) -> Void in
            let viewControllerNo = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController")
            self.present(viewControllerNo!, animated: false, completion: nil)
            GlobalVar.calLevelR = [0.31965649127960205, 0.5, 0.29732823371887207, 0.3009541928768158]
            GlobalVar.calLevelL = GlobalVar.calLevelR
        }
        calAlert.addAction(calAction1)
        calAlert.addAction(calAction2)
        
        self.present(calAlert, animated: true, completion: nil)
    }
    
    @IBAction func calibrate(_ sender: UIButton) {
        print("right: \(GlobalVar.calLevelR)")
        print("left: \(GlobalVar.calLevelL)")
        if calData.isEmpty {
            showCalAlert()
        } else {
            let viewControllerContinue = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController")
            self.present(viewControllerContinue!, animated: false, completion: nil)
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        TestViewController.GlobalVar.threshold.removeAll()
        NewResultsViewController.GlobalVar.threshL.removeAll()
        NewResultsViewController.GlobalVar.threshR.removeAll()
        NewResultsViewController.GlobalVar.avgL.removeAll()
        NewResultsViewController.GlobalVar.avgR.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshL.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshR.removeAll()
//        IntroViewController.GlobalVar.calLevelR.removeAll()
//        IntroViewController.GlobalVar.calLevelL.removeAll()
    }
    
    @IBAction func showAlertContact() {
        
        let contactAlert = UIAlertController(title: "Need help or have a question?", message: "For questions, comments or needs please contact John Ellison.", preferredStyle: .alert)
        
        let actionTele = UIAlertAction(title: "Call", style: .default) { (actionTele) -> Void in
            UIApplication.shared.open(NSURL(string: "tel://4023501086")! as URL)
        }
        let actionEmail = UIAlertAction(title: "Text", style: .default) { (actionTele) -> Void in
            UIApplication.shared.open(NSURL(string: "sms://4023501086")! as URL, options: [:], completionHandler: nil)
        }
        let actionContact = UIAlertAction(title: "Cancel", style: .default) {_ in }
        
        contactAlert.addAction(actionTele)
        contactAlert.addAction(actionEmail)
        contactAlert.addAction(actionContact)
        
        present(contactAlert, animated: true, completion: nil)
    }
}
