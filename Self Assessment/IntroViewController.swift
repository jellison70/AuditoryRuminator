//
//  IntroViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/11/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import MessageUI

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        TestViewController.GlobalVar.threshold.removeAll()
        NewResultsViewController.GlobalVar.threshL.removeAll()
        NewResultsViewController.GlobalVar.threshR.removeAll()
        NewResultsViewController.GlobalVar.avgL.removeAll()
        NewResultsViewController.GlobalVar.avgR.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshL.removeAll()
        StoredResultsViewController.GlobalVar.retrieveThreshR.removeAll()
        TestViewController.GlobalVar.calLevelR.removeAll()
        TestViewController.GlobalVar.calLevelL.removeAll()
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
