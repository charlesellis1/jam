//
//  NewProjectView-2.swift
//  JAM
//
//  Created by Charles Ellis on 4/30/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SoundWave

class NewProjectView2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var audioPlayer = AVAudioPlayer()
    
    var instruments: [String] = ["Guitar 🎸", "Sax 🎷", "Keyboard 🎹", "Trumpet 🎺", "Violin 🎻", "Drums 🥁", "Vocals 🎤", "Beats 🎧"]
    
    let placeholdMeteringLevels: [Float] = [0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.2, 0.1, 0.4, 0.45, 0.5, 0.6, 0.8, 0.95, 0.8, 0.5, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.2, 0.1, 0.4, 0.45, 0.5, 0.6, 0.8, 0.95, 0.8, 0.5]
    
    var soundFileName: String!
    
    
    
    //Outlets
    @IBOutlet weak var soundView: AudioVisualizationView!
       
       
    @IBOutlet weak var captionTextField: UITextField!
       
       
    @IBOutlet weak var jamPrivacy: UISegmentedControl!
       
       
       
    @IBOutlet weak var instrumentPickerView: UIPickerView!
    
    
    @IBOutlet weak var addedInstrumentsList: UILabel!
    
    
    @IBOutlet weak var addedFriendsList: UILabel!
    
       
    @IBOutlet weak var addFriendTextField: UITextField!
    
       
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentPickerView.delegate = self
        instrumentPickerView.dataSource = self
        
        soundView.gradientStartColor = .systemTeal
        soundView.gradientEndColor = .green
        soundView.backgroundColor = .black
        
        
        //SETUP THE WAVEFORM, mode is going to be write so we get a gradient. FeedData has the functions.
        
        soundView.audioVisualizationMode = .write
        
        if soundFileName!.count > 0 {
            let meteringLevels = feed.getMeteringLevels(song: soundFileName!)
            
            feed.setupSoundViewWithMeteringLevels(soundView: soundView, meteringLevels: meteringLevels)
        }
        else {
            soundView.meteringLevels = placeholdMeteringLevels
        }
        
        
        
        
        soundView.meteringLevels = placeholdMeteringLevels
        
        addedFriendsList.text = ""
        addedInstrumentsList.text = ""
        
    }
    
    
    
    //Actions
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        if (audioPlayer.isPlaying) {
            audioPlayer.pause()
            sender.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            let sound = Bundle.main.path(forResource: soundFileName, ofType: nil)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            }
            catch {
                print("Error playing sound or acquiring sound")
            }
            audioPlayer.play()
            sender.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        
    }
    
    
    
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        

        //Throw alerts if inputs are bad
        if soundFileName.count < 1 {
            presentAlertViewController(title: "Alert!", message: "Go back and add a song.")
        }
        
        else if captionTextField.text!.count < 1 {
            presentAlertViewController(title: "Alert", message: "Caption is empty, do you still want to proceed?")
        }
        else {
            feed.addPost(post: Post(displayName: feed.displayName, username: feed.username, profilePic: feed.profilePic!, caption: captionTextField.text!, date: Date(), audioFileName: soundFileName, waveform: soundView))
        }
        
        
        
        
        print("Made a post!! 💦")
    }
    
    
    
    @IBAction func addInstrumentsButton(_ sender: Any) {
        
        let numRow = instrumentPickerView.selectedRow(inComponent: 0)
        
        if addedInstrumentsList.text!.count > 1 {
            addedInstrumentsList.text! += ", "
        }
        
        addedInstrumentsList.text! += instruments[numRow]
    }
    
    
    @IBAction func addFriendsButton(_ sender: Any) {
        
        let friendHandle = addFriendTextField.text
        
        //see if handle exists on the firebase, set name equal to their display name. Or else stick with handle
        let friendName = friendHandle
        
        if addedFriendsList.text!.count > 1 {
            addedFriendsList.text! += ", "
        }
        
        addedFriendsList.text! += friendName!
        addFriendTextField.text?.removeAll()
    }
    
    
    
    
    
    
    
    
    
    @IBAction func clearInstrumentsButtonPressed(_ sender: Any) {
        
        addedInstrumentsList.text = ""
        
    }
    
    
    @IBAction func clearFriendsButtonPressed(_ sender: Any) {
        
        addedFriendsList.text = ""
        
    }
    
    
    
    
    //Picker View functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
        
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
        
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowI = instruments[row]
        return rowI
        
    }
    
    
    
    
    
    func presentAlertViewController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
