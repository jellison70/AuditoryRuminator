//
//  InputViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/11/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation

class InputViewController: UIViewController {
    
    @IBOutlet weak var imageMeterSetting: UIImageView!
    @IBOutlet weak var contButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var timer: Timer!
    var micInput: Int = 0
    
    @IBAction func nextScreen(_ sender: Any) {
        if micInput == 2 {
            timer.invalidate()
            showAlertNoise()
            imageMeterSetting.image = UIImage(named: "led circle level meter blank")
        } else if micInput == 1 {
            timer.invalidate()
            showAlertBorder()
            imageMeterSetting.image = UIImage(named: "led circle level meter blank")
        } else {
            let viewControllerYes = self.storyboard?.instantiateViewController(withIdentifier: "CalViewController")
            timer.invalidate()
            audioRecorder.stop()
            audioRecorder.deleteRecording()
            audioRecorder.isMeteringEnabled = false
            self.present(viewControllerYes!, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindSegueToInput(_ sender: UIStoryboardSegue) {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 11025.0] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        audioRecorder.prepareToRecord()
        audioRecorder.isMeteringEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.audioRecorder.record()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(powerLevel), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        timer.invalidate()
        audioRecorder.stop()
        audioRecorder.deleteRecording()
        audioRecorder.isMeteringEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 11025.0] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        audioRecorder.prepareToRecord()
        audioRecorder.isMeteringEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.audioRecorder.record()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(powerLevel), userInfo: nil, repeats: true)
    }
    
    @objc func powerLevel() {
        //we have to update meters before we can get the metering values
        audioRecorder.updateMeters()
        let power = audioRecorder.averagePower(forChannel: 0)
        print("power level: \(power)")
        print(audioRecorder.isMeteringEnabled)
        if power >= -5.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter11")
            micInput = 2
        } else if power >= -11 && power < -5.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter10")
            micInput = 2
        } else if power >= -16.5 && power < -11 {
            imageMeterSetting.image = UIImage(named: "levelMeter9")
            micInput = 2
        } else if power >= -22 && power < -16.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter8")
            micInput = 1
        } else if power >= -27.5 && power < -22 {
            imageMeterSetting.image = UIImage(named: "levelMeter7")
            micInput = 1
        } else if power >= -33 && power < -27.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter6")
            micInput = 1
        } else if power >= -38.5 && power < -33 {
            imageMeterSetting.image = UIImage(named: "levelMeter5")
            micInput = 0
        } else if power >= -44 && power < -38.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter4")
            micInput = 0
        } else if power >= -49.5 && power < -44 {
            imageMeterSetting.image = UIImage(named: "levelMeter3")
            micInput = 0
        } else if power >= -55 && power < -49.5 {
            imageMeterSetting.image = UIImage(named: "levelMeter2")
            micInput = 0
        } else if power < -55 {
            imageMeterSetting.image = UIImage(named: "levelMeter1")
            micInput = 0
        } else {
            imageMeterSetting.image = UIImage(named: "led circle level meter blank")
        }
    }
    
    func showAlertNoise() {
        let noiseAlert = UIAlertController(title: "Noise levels are too high", message: "Find a quieter place to continue", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController")
            self.present(viewControllerYouWantToPresent!, animated: false, completion: nil)
        }
        noiseAlert.addAction(action)
        self.present(noiseAlert, animated: false, completion: nil)
    }
    
    func showAlertBorder() {
        let borderAlert = UIAlertController(title: "Noise levels could impact test accuracy", message: "Please find a quieter place if possible. If not possible, you may 'Continue'.", preferredStyle: .alert)
        let borderAction1 = UIAlertAction(title: "OK", style: .default) { (borderAction1) -> Void in
            let viewControllerBack = self.storyboard?.instantiateViewController(withIdentifier: "InputViewController")
            self.present(viewControllerBack!, animated: false, completion: nil)
        }
        let borderAction2 = UIAlertAction(title: "Continue", style: .default) { (borderAction2) -> Void in
            let viewControllerContinue = self.storyboard?.instantiateViewController(withIdentifier: "CalViewController")
            self.timer.invalidate()
            self.audioRecorder.stop()
            self.audioRecorder.deleteRecording()
            self.audioRecorder.isMeteringEnabled = false
            self.present(viewControllerContinue!, animated: true, completion: nil)
        }
        borderAlert.addAction(borderAction1)
        borderAlert.addAction(borderAction2)
        self.present(borderAlert, animated: false, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
