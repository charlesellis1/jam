//
//  ProfileTableViewCell.swift
//  JAM
//
//  Created by Charles Ellis on 5/1/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit
import AVFoundation
import SoundWave

class ProfileTableViewCell: UITableViewCell {
    
    
    var audioPlayer = AVAudioPlayer()
    
    var soundFileName: String? = ""
    
    
    

    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var soundView: AudioVisualizationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.soundView.meteringLevelBarWidth = 3.0
        self.soundView.meteringLevelBarInterItem = 1.0
        self.soundView.meteringLevelBarCornerRadius = 0.0
        soundView.gradientStartColor = .systemTeal
        soundView.gradientEndColor = .green
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
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
    
    
    

}
