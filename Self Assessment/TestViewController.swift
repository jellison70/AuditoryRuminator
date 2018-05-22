//
//  TestViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/6/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class TestViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var level = Double()
    var timer: Timer!
    var isAudible: Bool = false
    var pastIsAudible: Bool = false
    var upReversal: Int = 0
    var downReversal: Int = 0
    var initial: Bool = true
    var cntMax: Int = 0
    
    var calData = [CalibrationData]()
    
    struct GlobalVar{
        static var threshold = [Double]()
        static var calLevelR = [Double]()
        static var calLevelL = [Double]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromDB()
        
        let url = Bundle.main.url(forResource: "warble1k_pulse_ramp_0p45s_24bit", withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.pan = 1.0
            audioPlayer.setVolume(Float(level), fadeDuration: 0)
            audioPlayer.play()
            print("upReversal: \(self.upReversal), downReversal: \(self.downReversal), level: \(self.level), audible: \(isAudible)")
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(adaptation), userInfo: nil, repeats: true)
    }
    
    @objc
    func adaptation() {
        if initial == true {
            level = GlobalVar.calLevelR[0]
            audioPlayer.setVolume(Float(level), fadeDuration: 0)
            print("beginning level: \(self.level)")
            audioPlayer.play()
            initial = false
        } else if isAudible == true && initial == false{
            if pastIsAudible == false {
                downReversal += 1
            }
            if upReversal == 2 && downReversal >= 2 {
                timer.invalidate()
                GlobalVar.threshold.append(level)
                print("The final threshold is:\(GlobalVar.threshold.self)")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Test1ViewController")
                self.present(newViewController!, animated: false, completion: nil)
            } else {
                level = level * (1 / pow(10, 0.5))
                audioPlayer.setVolume(Float(level), fadeDuration: 0)
                audioPlayer.play()
                pastIsAudible = true
                print("upReversal: \(self.upReversal), downReversal: \(self.downReversal), level: \(self.level), audible: \(isAudible)")
            }
        } else if isAudible == false && initial == false {
            if pastIsAudible == true {
                upReversal += 1
            }
            level = level * pow(10, 0.25)
            audioPlayer.setVolume(Float(level), fadeDuration: 0)
            audioPlayer.play()
            if round(level / GlobalVar.calLevelR[0])  >= 10.0 {
                print("Maximum level Achieved: \(level), ratio = \(level / GlobalVar.calLevelR[0])")
                cntMax += 1
                level = level * (1 / pow(10, 0.25))
                if cntMax == 5 {
                    timer.invalidate()
                    level = level * pow(10, 0.25)
                    GlobalVar.threshold.append(level)
                    print("The final threshold is:\(GlobalVar.threshold.self)")
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Test1ViewController")
                    self.present(newViewController!, animated: false, completion: nil)
                }
            }
            pastIsAudible = false
            print("upReversal: \(self.upReversal), downReversal: \(self.downReversal), level: \(self.level), audible: \(isAudible)")
        }
    }
    
    @IBAction func audible(_ sender: UIButton) {
        isAudible = true
    }
    
    @IBAction func inaudible(_ sender: UIButton) {
        isAudible = false
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        timer.invalidate()
        showCancelAlert()
    }
    
    func getDataFromDB() {
        let fetchRequest: NSFetchRequest<CalibrationData> = CalibrationData.fetchRequest()
        do {
            let calData = try PersistenceService.context.fetch(fetchRequest)
            self.calData = calData
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
            print("RIGHT 1k: \((calData)[4].calR_1k))")
            print("RIGHT 2k: \((calData)[4].calR_2k))")
            print("RIGHT 3k: \((calData)[4].calR_3k))")
            print("RIGHT 4k: \((calData)[4].calR_4k))")
        } catch {}
    }
    
    func showCancelAlert() {
        let cancelAlert = UIAlertController(title: "You are about to quit.", message: "Do you want to stop and proceed to the welcome screen?", preferredStyle: .alert)
        
        let cancelAction1 = UIAlertAction(title: "Yes", style: .default) { (cancelAction1) -> Void in
            _ = self.performSegue(withIdentifier: "unwindToIntro", sender: self)
            self.present(cancelAlert, animated: true, completion: nil)
            GlobalVar.threshold.removeAll()
//            GlobalVar.calLevelL.removeAll()
//            GlobalVar.calLevelR.removeAll()
        }
        
        let cancelAction2 = UIAlertAction(title: "Continue", style: .default) { (cancelAction2) -> Void in
            let viewControllerNo = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")
            self.present(viewControllerNo!, animated: false, completion: nil)
        }
        cancelAlert.addAction(cancelAction1)
        cancelAlert.addAction(cancelAction2)
        
        self.present(cancelAlert, animated: true, completion: nil)
    }
}
