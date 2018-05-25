//
//  CalibrationViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 5/10/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class CalibrationViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var earSelector: UISwitch!
    @IBOutlet weak var slider1k: UISlider!
    @IBOutlet weak var slider2k: UISlider!
    @IBOutlet weak var slider3k: UISlider!
    @IBOutlet weak var slider4k: UISlider!
    @IBOutlet weak var setRight1k: UIButton!
    @IBOutlet weak var setRight2k: UIButton!
    @IBOutlet weak var setRight3k: UIButton!
    @IBOutlet weak var setRight4k: UIButton!
    @IBOutlet weak var setLeft1k: UIButton!
    @IBOutlet weak var setLeft2k: UIButton!
    @IBOutlet weak var setLeft3k: UIButton!
    @IBOutlet weak var setLeft4k: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var audioPlayer3: AVAudioPlayer!
    var audioPlayer4: AVAudioPlayer!
    var currentValue: Float = 0.0
    let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-highlight")
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-normal")
    
    var calLevelRight_1k = Double()
    var calLevelRight_2k = Double()
    var calLevelRight_3k = Double()
    var calLevelRight_4k = Double()
    var calLevelLeft_1k = Double()
    var calLevelLeft_2k = Double()
    var calLevelLeft_3k = Double()
    var calLevelLeft_4k = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.isEnabled = false
        
        slider1k.setThumbImage(thumbImageNormal, for: .normal)
        slider2k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageNormal, for: .normal)
        
        let url1 = Bundle.main.url(forResource: "1k_sine_m6db_ramp_24bit", withExtension: "wav")
        let url2 = Bundle.main.url(forResource: "2k_sine_m6db_ramp_24bit", withExtension: "wav")
        let url3 = Bundle.main.url(forResource: "3k_sine_m6db_ramp_24bit", withExtension: "wav")
        let url4 = Bundle.main.url(forResource: "4k_sine_m6db_ramp_24bit", withExtension: "wav")
        
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: url1!)
            audioPlayer1.prepareToPlay()
            audioPlayer2 = try AVAudioPlayer(contentsOf: url2!)
            audioPlayer2.prepareToPlay()
            audioPlayer3 = try AVAudioPlayer(contentsOf: url3!)
            audioPlayer3.prepareToPlay()
            audioPlayer4 = try AVAudioPlayer(contentsOf: url4!)
            audioPlayer4.prepareToPlay()
        
        }catch let error as NSError {
            print(error.debugDescription)
        }

    }
    
    @IBAction func earSwitch(_ sender: UISwitch) {
        if audioPlayer1.isPlaying {
            if earSelector.isOn {
                audioPlayer1.pan = 1
            } else {
                audioPlayer1.pan = -1
            }
        } else if audioPlayer2.isPlaying {
            if earSelector.isOn {
                audioPlayer2.pan = 1
            } else {
                audioPlayer2.pan = -1
            }
        } else if audioPlayer3.isPlaying {
            if earSelector.isOn {
                audioPlayer3.pan = 1
            } else {
                audioPlayer3.pan = -1
            }
        } else if audioPlayer4.isPlaying {
            if earSelector.isOn {
                audioPlayer4.pan = 1
            } else {
                audioPlayer4.pan = -1
            }
        }  else {}
    }
    ///1 kHz block
    @IBAction func levelAdjust1k(_ sender: UISlider) {
        if audioPlayer2.isPlaying {
            audioPlayer2.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer2.pause()
        } else if audioPlayer3.isPlaying {
            audioPlayer3.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer3.pause()
        } else if audioPlayer4.isPlaying {
            audioPlayer4.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer4.pause()
        }
        if earSelector.isOn {
            audioPlayer1.pan = 1
        } else {
            audioPlayer1.pan = -1
        }
        slider2k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageNormal, for: .normal)
        slider1k.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider1k.setThumbImage(thumbImageHighlighted, for: .normal)
        audioPlayer1.volume = 0
        audioPlayer1.delegate = self
        audioPlayer1.play()
        audioPlayer1.setVolume(slider1k.value, fadeDuration: 0.5)
        print("slider1k value = \(slider1k.value)")
    }
     ///2 kHz block
    @IBAction func levelAdjust2k(_ sender: UISlider) {
        if audioPlayer1.isPlaying {
            audioPlayer1.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer1.pause()
        } else if audioPlayer3.isPlaying {
            audioPlayer3.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer3.pause()
        } else if audioPlayer4.isPlaying {
            audioPlayer4.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer4.pause()
        }
        if earSelector.isOn {
            audioPlayer2.pan = 1
        } else {
            audioPlayer2.pan = -1
        }
        slider1k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageNormal, for: .normal)
        slider2k.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider2k.setThumbImage(thumbImageHighlighted, for: .normal)
        audioPlayer2.volume = 0
        audioPlayer2.delegate = self
        audioPlayer2.play()
        audioPlayer2.setVolume(slider2k.value, fadeDuration: 0.5)
        print("slider2k value = \(slider2k.value)")
    }
    ///3 kHz block
    @IBAction func levelAdjust3k(_ sender: UISlider) {
        if audioPlayer1.isPlaying {
            audioPlayer1.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer1.pause()
        } else if audioPlayer2.isPlaying {
            audioPlayer2.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer2.pause()
        } else if audioPlayer4.isPlaying {
            audioPlayer4.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer4.pause()
        }
        if earSelector.isOn {
            audioPlayer3.pan = 1
        } else {
            audioPlayer3.pan = -1
        }
        slider1k.setThumbImage(thumbImageNormal, for: .normal)
        slider2k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider3k.setThumbImage(thumbImageHighlighted, for: .normal)
        audioPlayer3.volume = 0
        audioPlayer3.delegate = self
        audioPlayer3.play()
        audioPlayer3.setVolume(slider3k.value, fadeDuration: 0.5)
        print("slider3k value = \(slider3k.value)")
    }
    ///4 kHz block
    @IBAction func levelAdjust4k(_ sender: UISlider) {
        if audioPlayer1.isPlaying {
            audioPlayer1.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer1.pause()
        } else if audioPlayer2.isPlaying {
            audioPlayer2.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer2.pause()
        } else if audioPlayer3.isPlaying {
            audioPlayer3.setVolume(Float(0), fadeDuration: 0.5)
            audioPlayer3.pause()
        }
        if earSelector.isOn {
            audioPlayer4.pan = 1
        } else {
            audioPlayer4.pan = -1
        }
        slider1k.setThumbImage(thumbImageNormal, for: .normal)
        slider2k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider4k.setThumbImage(thumbImageHighlighted, for: .normal)
        audioPlayer4.volume = 0
        audioPlayer4.delegate = self
        audioPlayer4.play()
        audioPlayer4.setVolume(slider4k.value, fadeDuration: 0.5)
        print("slider4k value = \(slider4k.value)")
    }
    
    @IBAction func setCalRight1k(_ sender: UIButton) {
        if earSelector.isOn {
            calLevelRight_1k = Double(slider1k.value)
            setRight1k.isEnabled = false
        }
        if setRight2k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false {
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalRight2k(_ sender: UIButton) {
        if earSelector.isOn {
            calLevelRight_2k = Double(slider2k.value)
            setRight2k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalRight3k(_ sender: UIButton) {
        if earSelector.isOn {
            calLevelRight_3k = Double(slider3k.value)
            setRight3k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalRight4k(_ sender: UIButton) {
        if earSelector.isOn {
            calLevelRight_4k = Double(slider4k.value)
            setRight4k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight3k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalLeft1k(_ sender: UIButton) {
        if earSelector.isOn == false {
            calLevelLeft_1k = Double(slider1k.value)
            setLeft1k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalLeft2k(_ sender: UIButton) {
        if earSelector.isOn == false {
            calLevelLeft_2k = Double(slider2k.value)
            setLeft2k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft3k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalLeft3k(_ sender: UIButton) {
        if earSelector.isOn == false {
            calLevelLeft_3k = Double(slider3k.value)
            setLeft3k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft4k.isEnabled == false{
            confirmButton.isEnabled = true
        }
    }
    @IBAction func setCalLeft4k(_ sender: UIButton) {
        if earSelector.isOn == false {
            calLevelLeft_4k = Double(slider4k.value)
            setLeft4k.isEnabled = false
        }
        if setRight1k.isEnabled == false && setRight2k.isEnabled == false && setRight3k.isEnabled == false && setRight4k.isEnabled == false && setLeft1k.isEnabled == false && setLeft2k.isEnabled == false && setLeft3k.isEnabled == false {
            confirmButton.isEnabled = true
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        slider1k.setThumbImage(thumbImageNormal, for: .normal)
        slider2k.setThumbImage(thumbImageNormal, for: .normal)
        slider3k.setThumbImage(thumbImageNormal, for: .normal)
        slider4k.setThumbImage(thumbImageNormal, for: .normal)
    }
    ///close
    @IBAction func close() {
        audioPlayer1.pause()
        audioPlayer2.pause()
        audioPlayer3.pause()
        audioPlayer4.pause()
        
        let calibrationData = CalibrationData(context: PersistenceService.context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        let dateString = dateFormatter.string(from: Date())
        calibrationData.date = dateString
        calibrationData.calR_1k = calLevelRight_1k
        calibrationData.calR_2k = calLevelRight_2k
        calibrationData.calR_3k = calLevelRight_3k
        calibrationData.calR_4k = calLevelRight_4k
        calibrationData.calL_1k = calLevelLeft_1k
        calibrationData.calL_2k = calLevelLeft_2k
        calibrationData.calL_3k = calLevelLeft_3k
        calibrationData.calL_4k = calLevelLeft_4k
        PersistenceService.saveContext()
        
        IntroViewController.GlobalVar.calLevelR.removeAll()
        IntroViewController.GlobalVar.calLevelL.removeAll()
        
        let viewControllerToIntro = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController")
        self.present(viewControllerToIntro!, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back() {
        audioPlayer1.pause()
        audioPlayer2.pause()
        audioPlayer3.pause()
        audioPlayer4.pause()
        
        IntroViewController.GlobalVar.calLevelR.removeAll()
        IntroViewController.GlobalVar.calLevelL.removeAll()
        
        let viewControllerToIntro = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController")
        self.present(viewControllerToIntro!, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
}
