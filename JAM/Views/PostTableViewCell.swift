//
//  PostTableViewCell.swift
//  JAM
//
//  Created by Charles Ellis on 4/16/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit
import AVFoundation
import SoundWave

class PostTableViewCell: UITableViewCell {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var nameLabel: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var propsLabel: UIButton!
    
    var soundFileName: String? = ""
    
    let placeholdMeteringLevels: [Float] = [Float]()
    
    
    
    
    
    @IBOutlet weak var soundwaveView: AudioVisualizationView!
    
    

    
    //something to keep track of audio file and waveform per cell.
    
    //keep track of friends/other users involved too?
    
   
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
    
    
//    let audioVisualizationView = AudioVisualizationView(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 500.0))
//    view.addSubview(audioVisualizationView)
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        
        self.soundwaveView.meteringLevelBarWidth = 3.0
        self.soundwaveView.meteringLevelBarInterItem = 1.0
        self.soundwaveView.meteringLevelBarCornerRadius = 0.0
                
//        soundwaveView.layer.cornerRadius = soundwaveView.frame.height / 2
        
        
        //soundwaveView.backgroundColor = .systemTeal
        //soundwaveView.backgroundColor = .lightGray
        
        soundwaveView.gradientStartColor = .systemTeal
        soundwaveView.gradientEndColor = .green
        
        
        //get the waveform, mode can be either read or write
        soundwaveView.audioVisualizationMode = .write
        
//        soundwaveView.add(meteringLevel: 0.3)
//        soundwaveView.add(meteringLevel: 0.6)
//        soundwaveView.add(meteringLevel: 0.9)
//        soundwaveView.add(meteringLevel: 0.6)
//        soundwaveView.add(meteringLevel: 0.3)
//        soundwaveView.add(meteringLevel: 0.1)
//        soundwaveView.add(meteringLevel: 0.3)
//        soundwaveView.add(meteringLevel: 0.6)
//        soundwaveView.add(meteringLevel: 0.9)
//        soundwaveView.add(meteringLevel: 0.6)
//        soundwaveView.add(meteringLevel: 0.3)
//        soundwaveView.add(meteringLevel: 0.1)
        
        
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    func averagePowers(audioFileURL: URL, forChannel channelNumber: Int, completionHandler: @escaping(_ success: [Float]) -> ()) {
        
        let audioFile = try! AVAudioFile(forReading: audioFileURL)
        let audioFilePFormat = audioFile.processingFormat
        //let audioFileLength = audioFile.length

        //Set the size of frames to read from the audio file, you can adjust this to your liking
        let frameSizeToRead = Int(audioFilePFormat.sampleRate/20)

        //This is to how many frames/portions we're going to divide the audio file
        let numberOfFrames = 80

        //Create a pcm buffer the size of a frame
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFilePFormat, frameCapacity: AVAudioFrameCount(frameSizeToRead))
            else {
                fatalError("Couldn't create the audio buffer")
        }
        
        //This is the array to be returned
        var returnArray : [Float] = [Float]()

        //We're going to read the audio file, frame by frame
        for i in 0..<numberOfFrames {
                
            //Change the position from which we are reading the audio file, since each frame starts from a different position in the audio file
            audioFile.framePosition = AVAudioFramePosition(i * frameSizeToRead)

            //Read the frame from the audio file
            try! audioFile.read(into: audioBuffer, frameCount: AVAudioFrameCount(frameSizeToRead))

            //Get the data from the chosen channel
            let channelData = audioBuffer.floatChannelData![channelNumber]

            //This is the array of floats
            let arr = Array(UnsafeBufferPointer(start:channelData, count: frameSizeToRead))

            //Calculate the mean value of the absolute values
            let meanValue = arr.reduce(0, {$0 + abs($1)})/Float(arr.count)

            //Calculate the dB power (You can adjust this), if average is less than 0.000_000_01 we limit it to -160.0
            let dbPower: Float = meanValue > 0.000_000_01 ? 20 * log10(meanValue) : -100.0

            //append the db power in the current frame to the returnArray
            returnArray.append(dbPower * -0.03)
            
        }
        //Return the dBPowers
        completionHandler(returnArray)
    }
    
    
    
    
    func getMeteringLevels(song: String) -> [Float] {
        var finalArray: [Float] = [Float]()
        let path = Bundle.main.path(forResource: song, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        averagePowers(audioFileURL: url, forChannel: 0, completionHandler: { array in
            
            //Set my array equal to this one
            finalArray = array
            
        })
        return finalArray
    }
    
    
    
    func setupSoundViewWithMeteringLevels(soundView: AudioVisualizationView, meteringLevels: [Float]) {
        
        for i in 0...meteringLevels.count - 1 {
            if meteringLevels[i] > 1 {
                soundView.add(meteringLevel: 0.99)
            }
            else {
                soundView.add(meteringLevel: meteringLevels[i])
            }
        }
        
        
    }
}
