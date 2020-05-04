//
//  AudioViewController.swift
//  JAM
//
//  Created by Charles Ellis on 4/18/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit

//class AudioViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "What's that Whistle?"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
//
//        // Do any additional setup after loading the view.
//    }
//
//    @objc func addWhistle() {
//        let vc = RecordViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


///
////  RecordWhistleViewController.swift
////  JAM
////
////  Created by Charles Ellis on 4/18/20.
////  Copyright © 2020 Charles Ellis. All rights reserved.
////
//// source used:
//// https://www.hackingwithswift.com/read/33/2/recording-from-the-microphone-with-avaudiorecorder
////
//
//import UIKit
//import AVFoundation
//
//class RecordViewController: UIViewController, AVAudioRecorderDelegate {
//    
//    var stackView: UIStackView!
//
//    var recordButton: UIButton!
//    
//    var recordingSession: AVAudioSession!
//    
//    var whistleRecorder: AVAudioRecorder!
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "Record your JAM!"
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
//
//        recordingSession = AVAudioSession.sharedInstance()
//
//        do {
//            try recordingSession.setCategory(.playAndRecord, mode: .default)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.loadRecordingUI()
//                    } else {
//                        self.loadFailUI()
//                    }
//                }
//            }
//        } catch {
//            self.loadFailUI()
//        }
//    }
//
//    func loadRecordingUI() {
//        recordButton = UIButton()
//        recordButton.translatesAutoresizingMaskIntoConstraints = false
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
//        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
//        stackView.addArrangedSubview(recordButton)
//    }
//
//    func loadFailUI() {
//        let failLabel = UILabel()
//        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
//        failLabel.numberOfLines = 0
//
//        stackView.addArrangedSubview(failLabel)
//    }
//    
//    class func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//    class func getWhistleURL() -> URL {
//        return getDocumentsDirectory().appendingPathComponent("newSong.m4a")
//    }
//    
//    
//    override func loadView() {
//        view = UIView()
//
//        view.backgroundColor = .systemGray
//        
//        stackView = UIStackView()
//        stackView.spacing = 30
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = UIStackView.Distribution.fillEqually
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        view.addSubview(stackView)
//
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    func startRecording() {
//        // 1
//        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
//
//        // 2
//        recordButton.setTitle("Tap to Stop", for: .normal)
//
//        // 3
//        let audioURL = RecordViewController.getWhistleURL()
//        print(audioURL.absoluteString)
//
//        // 4
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            // 5
//            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
//            whistleRecorder.delegate = self
//            whistleRecorder.record()
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    
//    func finishRecording(success: Bool) {
//        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
//
//        whistleRecorder.stop()
//        whistleRecorder = nil
//        
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//
//            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }
//    }
//    
//    @objc func nextTapped() {
//        
//        let audioFileName = RecordViewController.getWhistleURL().absoluteString
//        
//        
//        // Need to save audio file name, and segue back to Part 2 of the new project.
//        performSegue(withIdentifier: "finishedRecording", sender: Any.self)
//        print(audioFileName)
//    }
//    
//    @objc func recordTapped() {
//        if whistleRecorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
//    }
//    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: false)
//        }
//    }
//    
//
//}
