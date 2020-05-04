//
//  RecordWhistleViewController.swift
//  JAM
//
//  Created by Charles Ellis on 4/18/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//
// source used:
// https://www.hackingwithswift.com/read/33/2/recording-from-the-microphone-with-avaudiorecorder
//

import UIKit
import AVFoundation
import SoundWave

class RecordViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var recordingSession: AVAudioSession!
    
    var audioRecorder: AVAudioRecorder!
    
    var audioPlayer: AVAudioPlayer!
    
    var supercolor: UIColor!
    
    var pathOfSongToExport: URL!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var buttonOutlet: UIButton!
    
    @IBOutlet weak var recordingsTableView: UITableView!
    
    var numberOfRecordings = 0
    
    var numberOfDeletedRecordings = 0
    
    
    
    //Nik stuff
    var isRecording: Bool = false
    let recordRed = UIColor(displayP3Red: 221/256, green: 109/256, blue: 102/256, alpha: 1)
    var counter = 0.0
    var timer = Timer()
    var outerView: UIView!
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outerView = UIView(frame: CGRect(x: view.center.x, y: view.center.y + 100, width: 90, height: 90))
        
        navigationController?.navigationBar.backItem?.hidesBackButton = true
        
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
        
        //NS -----------------------------------
        
        timeLabel.text = String(counter)
//        resetButton.isEnabled = false
        configureRecordButton()
        
        
        //--------------------------------------
        
        
        
        
        supercolor = .white
        
        recordingSession = AVAudioSession.sharedInstance()
        
//        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
//            numberOfRecordings = number
//        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
    
    
    //------------------------------------------------------------
    //------------------------------------------------------------
    
    @objc func updateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
    
    
    func configureRecordButton() {
        outerView.layer.cornerRadius = outerView.frame.height / 2
        outerView.layer.masksToBounds = true
        outerView.layer.borderWidth = 10
        outerView.layer.borderColor = recordRed.cgColor
        outerView.backgroundColor = .clear
        
        buttonOutlet.layer.cornerRadius = buttonOutlet.frame.height / 2
        buttonOutlet.layer.masksToBounds = true
        buttonOutlet.backgroundColor = recordRed
    }
    
    
    
    
    func startTimer() {
        //resetButton.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        //resetButton.isEnabled = true
        timer.invalidate()
    }
    
    func resetTimer() {
        timer.invalidate()
        counter = 0.0
        timeLabel.text = String(counter)
    }
    
    //------------------------------------------------------------
    //------------------------------------------------------------
    
    
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }

    
    
    
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if audioRecorder == nil {
            numberOfRecordings += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecordings).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //Start recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                
                //change features of the button
//                buttonOutlet.setTitle("Stop Recording", for: .normal)
//                buttonOutlet.titleLabel?.textColor = .red
                UIView.animate(withDuration: 0.5) {
                    self.buttonOutlet.layer.cornerRadius = 15
                    self.buttonOutlet.setTitle("STOP", for: .normal)
                }
            }
            catch {
                displayAlert(title: "OOPS!", message: "Recording failed. Please do something.")
            }
        }
        else {
            //Stop recording
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.set(numberOfRecordings, forKey: "myNumber")
            recordingsTableView.reloadData()
            
//            buttonOutlet.setTitle("Start Recording", for: .normal)
//            buttonOutlet.titleLabel?.textColor = supercolor
            UIView.animate(withDuration: 0.5) {
                self.buttonOutlet.layer.cornerRadius = self.buttonOutlet.frame.height / 2
                self.buttonOutlet.setTitle("START", for: .normal)
            }
        }
        
    }
    
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    
    //Delete a recording......
    func deleteRecording(index: Int) {
        let dirPath = getDirectory().appendingPathComponent("\(index).m4a")
        let f = FileManager.default
        do {
            try f.removeItem(at: dirPath)
            numberOfDeletedRecordings += 1
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Set up table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecordings - numberOfDeletedRecordings
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = recordingsTableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as? RecordingTableViewCell {
            cell.recordingLabel.text = "jamRecording" + String(indexPath.row + 1)
            cell.pathToSong = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Go back to first page of make post VC, carrying this file with it.
        
        
        pathOfSongToExport = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        
        
        print("Selected this song:", String(pathOfSongToExport.absoluteString))
        
        
        performSegue(withIdentifier: "unwind", sender: Any.self)
        
        //FIXME: unwind back to navigation controller
//        navigationController?.unwind(for: <#T##UIStoryboardSegue#>, towards: NewProjectView.init())
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete from directory and delete from table view
            deleteRecording(index: indexPath.row)
            recordingsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    
    //------------------------------------------------------------
    //------------------------------------------------------------
    
    func configureRecordProgButton() {
        let recordRed = UIColor(displayP3Red: 221/256, green: 109/256, blue: 102/256, alpha: 1)
        outerView = UIView(frame: CGRect(x: view.center.x, y: view.center.y + 100, width: 90, height: 90))
        let innerView = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        outerView.backgroundColor = .clear
        outerView.layer.borderColor = recordRed.cgColor
        outerView.layer.borderWidth = 3
        outerView.layer.cornerRadius = outerView.frame.height / 2
        outerView.layer.masksToBounds = true
        outerView.alpha = 0.6
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(outerView)
                
        let outerViewConstraints = [
            outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            outerView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        ]
        NSLayoutConstraint.activate(outerViewConstraints)
        
        
        innerView.backgroundColor = recordRed
        innerView.layer.cornerRadius = innerView.frame.height / 2
        innerView.layer.masksToBounds = true
        innerView.titleLabel?.text = "REC"
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(innerView)
        let innerViewConstraints = [
            innerView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(innerViewConstraints)

    }
    
    
    
}
