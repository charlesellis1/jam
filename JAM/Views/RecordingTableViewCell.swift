//
//  RecordingTableViewCell.swift
//  JAM
//
//  Created by Charles Ellis on 4/25/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingTableViewCell: UITableViewCell {
    
    var vc = RecordViewController()
    
    var audioPlayer: AVAudioPlayer!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    var pathToSong: URL!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        if audioPlayer == nil {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pathToSong)
                audioPlayer.play()
                sender.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            catch {
                displayAlert(title: "OOPS!", message: "Error playing your recording.")
                
            }
        }
        else {
            audioPlayer.stop()
            sender.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            audioPlayer = nil
        }
        
        
        
    }
     
    
    
}
