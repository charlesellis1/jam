//
//  NewProjectView.swift
//  JAM
//
//  Created by Charles Ellis on 4/16/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import Foundation
import UIKit
import SoundWave
import AVFoundation

class NewProjectView: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    var pathToSong: URL?
    
    
    
    
    
    //Post outlets
    
    @IBOutlet weak var uploadStatus: UILabel!
    
    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var uploadedSongName: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        
        //Stuff
        uploadedSongName.text = "No song to upload"
        uploadStatus.isHidden = true
        uploadActivityIndicator.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let songPath = pathToSong {
            uploadedSongName.text = "Success!"
            uploadStatus.isHidden = false
            uploadActivityIndicator.isHidden = false
        }
        else {
            uploadedSongName.text = ""
            uploadStatus.isHidden = true
            uploadActivityIndicator.isHidden = true
        }
        
    }
    
    
    
    @IBAction func recordViaJamPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRecordViewController", sender: Any.self)
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if uploadedSongName.text!.count <= 1 {
            presentAlertViewController(title: "Alert!", message: "Please add a song.")
        }
        else {
            performSegue(withIdentifier: "toStepTwo", sender: Any.self)
        }
        
        
    }
    
    
    
    @IBAction func unwindToNewProjectView(segue: UIStoryboardSegue) {
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStepTwo" {
            if let dest = segue.destination as? NewProjectView2 {
                dest.soundFileURL = pathToSong
            }
        }
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
