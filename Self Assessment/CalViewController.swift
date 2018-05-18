//
//  CalViewController.swift
//  Self Assessment
//
//  Created by John Ellison on 4/6/18.
//  Copyright © 2018 John Ellison. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class CalViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var masterSlider: UISlider!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    let volumeView = MPVolumeView()

    @IBAction func unwindSegueToCal(_ sender: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeView.alpha = 0.01
        self.view.addSubview(volumeView)
        
        
        start()

        // Do any additional setup after loading the view.
        
        let url = Bundle.main.url(forResource: "warble1k_ramp_1p2", withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
        }catch let error as NSError {
            print(error.debugDescription)
        }
    }

    func start() {
        button.isEnabled = false
        nextButton.isEnabled = false
        enableButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        print("The value of the slider is now: \(slider.value)")
        if let view = volumeView.subviews.first as? UISlider {
            masterSlider = view
            masterSlider?.value = slider.value
        }
        enableButton()
    }
    
    @IBAction func enableButton() {
        if slider.value > 0.55 || slider.value < 0.45 {
            button.isEnabled = false
        } else if slider.value > 0.45 && slider.value < 0.55 {
            button.isEnabled = true
        }
    }
    
    @IBAction func showSoundAlert() {
        
        audioPlayer.setVolume(Float(1.4125), fadeDuration: 0)
        audioPlayer.pan = 1.0
        audioPlayer.play()
        
        let soundAlert = UIAlertController(title: "PLAYING TONE NOW!", message: "Did you hear the tone?", preferredStyle: .alert)
        
        let soundAction1 = UIAlertAction(title: "Yes", style: .default) { (soundAction1) -> Void in
            let viewControllerYes = self.storyboard?.instantiateViewController(withIdentifier: "InstructViewController")
            self.present(viewControllerYes!, animated: true, completion: nil)
        }
        
        let soundAction2 = UIAlertAction(title: "No", style: .default) { (soundAction2) -> Void in
            let viewControllerNo = self.storyboard?.instantiateViewController(withIdentifier: "PositionViewController")
            self.present(viewControllerNo!, animated: true, completion: nil)
            
        }
        
        soundAlert.addAction(soundAction1)
        soundAlert.addAction(soundAction2)
        
        self.present(soundAlert, animated: true, completion: nil)
    }
}
