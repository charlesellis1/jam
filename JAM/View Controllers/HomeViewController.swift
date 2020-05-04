//
//  HomeViewController.swift
//  JAM
//
//  Created by Charles Ellis on 4/9/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    let warmUpSong = "polar-bowler-3"
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var carbonBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
        
        
        let sound = Bundle.main.path(forResource: warmUpSong, ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print("Error playing sound")
        }
        audioPlayer.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: Any.self)
        audioPlayer.stop()
    }
    

    @IBAction func signupButton(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: Any.self)
        audioPlayer.stop()
    }
}

