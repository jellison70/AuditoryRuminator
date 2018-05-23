//
//  Test5ViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/12/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation

class Test5ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var level = Double()
    var timer: Timer!
    var isAudible: Bool = false
    var pastIsAudible: Bool = false
    var upReversal: Int = 0
    var downReversal: Int = 0
    var initial: Bool = true
    var cntMax: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            let url = Bundle.main.url(forResource: "warble2k_pulse_ramp_0p45s_24bit", withExtension: "wav")
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.pan = -1.0
                self.audioPlayer.setVolume(Float(self.level), fadeDuration: 0)
                self.audioPlayer.play()
                print("upReversal: \(self.upReversal), downReversal: \(self.downReversal), level: \(self.level), audible: \(self.isAudible)")
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(self.adaptation), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func adaptation() {
        if initial == true {
            level = TestViewController.GlobalVar.calLevelL[1]
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
                TestViewController.GlobalVar.threshold.append(level)
                print("The final threshold is:\(TestViewController.GlobalVar.threshold.self)")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Test6ViewController")
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
            if round(level / TestViewController.GlobalVar.calLevelL[1])  >= 10.0 {
                print("Maximum level Achieved: \(level), ratio = \(level / TestViewController.GlobalVar.calLevelL[1])")
                cntMax += 1
                level = level * (1 / pow(10, 0.25))
                if cntMax == 5 {
                    timer.invalidate()
                    level = level * pow(10, 0.25)
                    TestViewController.GlobalVar.threshold.append(level)
                    print("The final threshold is:\(TestViewController.GlobalVar.threshold.self)")
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Test6ViewController")
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
    
    func showCancelAlert() {
        let cancelAlert = UIAlertController(title: "You are about to quit.", message: "Do you want to stop and proceed to the welcome screen?", preferredStyle: .alert)
        
        let cancelAction1 = UIAlertAction(title: "Yes", style: .default) { (cancelAction1) -> Void in
            _ = self.performSegue(withIdentifier: "unwindToIntro", sender: self)
            self.present(cancelAlert, animated: true, completion: nil)
            TestViewController.GlobalVar.threshold.removeAll()
//            TestViewController.GlobalVar.calLevelL.removeAll()
//            TestViewController.GlobalVar.calLevelR.removeAll()
        }
        
        let cancelAction2 = UIAlertAction(title: "Continue", style: .default) { (cancelAction2) -> Void in
            let viewControllerNo = self.storyboard?.instantiateViewController(withIdentifier: "Test5ViewController")
            self.present(viewControllerNo!, animated: false, completion: nil)
        }
        cancelAlert.addAction(cancelAction1)
        cancelAlert.addAction(cancelAction2)
        
        self.present(cancelAlert, animated: true, completion: nil)
    }
}
