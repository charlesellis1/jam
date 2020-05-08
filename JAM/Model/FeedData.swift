//
//  FeedData.swift
//  JAM
//
//  Created by Charles Ellis on 4/16/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SoundWave
import Firebase
//import FirebaseFirestore

var feed = FeedData()

struct Post {
    var displayName: String
    var username: String
    var profilePic: UIImage
    var caption: String
    var date: Date
    var audioFileName: String
    var waveform: AudioVisualizationView?
    
    
    
}
class FeedData {
    
    var displayName = "Charlie Ellis"
    
    var username = "@chellis11"
    
    var profilePic = UIImage(named: "default_avatar")
    
    
    //Firebase stuff
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    
    
    var posts: [Post] = [
        Post(displayName: "Charlie Ellis", username: "@chellis11", profilePic: UIImage(named: "default_avatar")!, caption: "Yoooo", date: Date(), audioFileName: "polar-bowler-3.mp3", waveform: nil),
        Post(displayName: "Nikhil Yerasi", username: "nyerasi", profilePic: UIImage(named: "default_avatar")!, caption: "In my feels 😷", date: Date(), audioFileName: "maria.mp3", waveform: nil)
    ]
    
    
    
    var myLikedPosts: [Post] = []
    
    func getMyOwnPosts() -> [Post] {
        var myPosts: [Post] = []
        for p in posts {
            if p.displayName == displayName {
                myPosts.append(p)
            }
        }
        return myPosts
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }
    
    
    
    
    
    var instruments: [String] = ["Guitar 🎸", "Sax 🎷", "Keyboard 🎹", "Trumpet 🎺", "Violin 🎻", "Drums 🥁", "Vocals 🎤", "Beats 🎧"]
    
    let placeholdMeteringLevels: [Float] = [0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.2, 0.1, 0.4, 0.45, 0.5, 0.6, 0.8, 0.95, 0.8, 0.5, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.3, 0.6, 0.9, 0.6, 0.3, 0.1, 0.1, 0.3, 0.6, 0.9, 0.95, 0.9, 0.6, 0.2, 0.1, 0.4, 0.45, 0.5, 0.6, 0.8, 0.95, 0.8, 0.5]
    
    
    
    
    
    
    //Function for getting waveform
    
    
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
    
    
    
    ///FIREBASE IMPLEMENTATION
    
    
    
    func updatePostToFirestore(post: Post) {
        let postID = UUID.init().uuidString
        let dbDisplayName = post.displayName
        let dbDate = post.date
        let dbUser = post.username
        let dbCaption = post.caption
        
    
        
        //firebase can play sound? or na ****
        let dbSound = post.audioFileName
        
        
        
        //Storage reference
        let storageRef = storage.reference(withPath: "posts/\(postID)/sound")
        
        
        
        
        //Will this Work??? vvvv
        let dbAudio = Bundle.main.path(forResource: dbSound, ofType: nil)
        
        let soundURL = URL(fileURLWithPath: dbAudio!)
        
//        var dbAudioPlayer: AVAudioPlayer?
//
//        do {
//            dbAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dbAudio!))
//        }
//        catch {
//            print("Error playing sound or acquiring sound")
//        }
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "audio"
        storageRef.putFile(from: soundURL)
        
        
        
//        //From snapagram
//        guard let postImageData = post.image?.jpegData(compressionQuality: 0.75) else { return }
//        let uploadMetaData = StorageMetadata.init()
//        uploadMetaData.contentType = "image/jpeg"
//        storageRef.putData(postImageData)
    
        let dbProfilePic = post.profilePic.jpegData(compressionQuality: 0.75)
    
        
        var ref: DocumentReference? = nil


        ref = db.collection("posts").addDocument(data: [
            "postID": postID,
            "displayName": dbDisplayName,
            "username": dbUser,
            "profilePic": dbProfilePic,
            "date": dbDate,
            "caption": dbCaption,
            "soundFileName": dbSound
        ]) {err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }


    
    func fetch() {
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                
                var postID: String
                var displayName: String
                var username: String
                //this doesn't work
                var profilePic: UIImage
                var date: Date
                var caption: String
                var soundFileName: String
                
                for document in querySnapshot!.documents {
                    postID = document.data()["postID"] as! String
                    displayName = document.data()["displayName"] as! String
                    username = document.data()["username"] as! String
                    let profilePicData = document.data()["profilePic"] as! Data
                    profilePic = UIImage(data: profilePicData) ?? UIImage(named: "default_avatar") as! UIImage
                    caption = document.data()["caption"] as! String
                    date = document.data()["date"] as! Date
                    soundFileName = document.data()["soundFileName"] as! String
                    
                    
                    
                    let storageRef = self.storage.reference(withPath: "posts/\(postID)/sound")
                    
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, err) in
                        if err != nil {
                            print("Error in storage")
                        }
                        if let data = data {
                            
                            self.posts.append(Post(displayName: displayName, username: username, profilePic: profilePic, caption: caption, date: date, audioFileName: soundFileName, waveform: nil))
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
