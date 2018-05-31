//
//  InstructViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/16/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation

class InstructViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var practiceButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var level: Double = 0
    var timer: Timer!
    var isAudible: Bool = false
    var pastIsAudible: Bool = false
    var upReversal: Int = 0
    var downReversal: Int = 0
    var initial: Bool = true
    var timerOn: Bool = false
    var cntMax: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        start()
        
        let url = Bundle.main.url(forResource: "warble1k_pulse_ramp_0p45s_24bit", withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.pan = 1.0
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    func start() {
        button.isEnabled = false
    }
    
    @IBAction func pracPractButPush(_ sender: UIButton) {
        button.isEnabled = true
        practiceButton.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(adaptation), userInfo: nil, repeats: true)
        timerOn = true
    }
    
    @objc
    func adaptation() {
        if initial == true {
            level = 0.5
            audioPlayer.setVolume(Float(level), fadeDuration: 0)
            print("beginning level: \(level)")
            audioPlayer.play()
            initial = false
        } else if isAudible == true && initial == false{
            if pastIsAudible == false {
                downReversal += 1
            }
            if upReversal == 2 && downReversal >= 2 {
                timer.invalidate()
                print("The final threshold is:\(level), upReversal \(self.upReversal), downReverseal: \(self.downReversal)")
                showPracAlert()
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
            if round(level / 0.5) >= 10.0 {
                print("Maximum level Achieved: \(level)")
                cntMax += 1
                level = level * (1 / pow(10, 0.25))
                if cntMax == 5 {
                    timer.invalidate()
                    level = level * pow(10, 0.25)
                    print("The final threshold is:\(TestViewController.GlobalVar.threshold.self)")
                    showPracAlert()
                }
            }
            pastIsAudible = false
            print("upReversal: \(self.upReversal), downReversal: \(self.downReversal), level: \(self.level), audible: \(isAudible)")
        }
    }
    
    @IBAction func audioTimerOff(_ sender: Any) {
        if timerOn == true {
            timer.invalidate()
            audioPlayer.stop()
        } else {
        }
    }
    
    @IBAction func disableTimer(_ sender: Any) {
        if timerOn == true {
            timer.invalidate()
            showPracAlert()
        }else {
            let viewControllerYes = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")
            self.present(viewControllerYes!, animated: true, completion: nil)
        }
        
    }
    @IBAction func audible(_ sender: UIButton) {
        isAudible = true
    }
    
    @IBAction func inaudible(_ sender: UIButton) {
        isAudible = false
    }
    
    func showPracAlert() {
        let proceedAlert = UIAlertController(title: "Practice Round is Complete", message: "Do you want to proceed to the assessment?", preferredStyle: .alert)
        
        let proceedAction1 = UIAlertAction(title: "Yes", style: .default) { (proceedAction1) -> Void in
            let viewControllerYes = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")
            self.present(viewControllerYes!, animated: true, completion: nil)
        }
        
        let proceedAction2 = UIAlertAction(title: "No", style: .default) { (proceedAction2) -> Void in
            let viewControllerNo = self.storyboard?.instantiateViewController(withIdentifier: "InstructViewController")
            self.present(viewControllerNo!, animated: false, completion: nil)
        }
        proceedAlert.addAction(proceedAction1)
        proceedAlert.addAction(proceedAction2)
        
        self.present(proceedAlert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
