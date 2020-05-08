//
//  Profile.swift
//  JAM
//
//  Created by Charles Ellis on 4/16/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SoundWave

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    let myPosts = feed.getMyOwnPosts()
    
    let myLikedPosts = feed.myLikedPosts
    
    @IBOutlet weak var postLineView: UIView!
    
    @IBOutlet weak var mediaLineView: UIView!
    
    @IBOutlet weak var likesLineView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        postLineView.isHidden = false
        likesLineView.isHidden = true
        mediaLineView.isHidden = true
        
        print(myPosts)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileTableView.reloadData()
    }
    
    
    @IBAction func postsButtonPressed(_ sender: Any) {
        
        postLineView.isHidden = false
        mediaLineView.isHidden = true
        likesLineView.isHidden = true
        
        //tableview with myPosts
        
    }
    
    
    @IBAction func mediaButtonPressed(_ sender: Any) {
        
        postLineView.isHidden = true
        mediaLineView.isHidden = false
        likesLineView.isHidden = true
        
        //tableview of my media
    }
    
    @IBAction func likesButtonPressed(_ sender: Any) {
        postLineView.isHidden = true
        mediaLineView.isHidden = true
        likesLineView.isHidden = false
        
        //tableview of liked posts
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell {
            // configure cell
            let currentPost = myPosts[indexPath.row]
            
            
            //fixme FIX DIS SHIT ASAP!
            cell.captionLabel?.text = currentPost.caption
            cell.dateLabel?.text = formatDate(date: currentPost.date)



            //Add song
            cell.soundFileName = currentPost.audioFileName
            
            
            //Add waveform
            if currentPost.waveform == nil {
                
                cell.soundView.audioVisualizationMode = .write
                
                
                if cell.soundFileName!.count > 0 {
                    let meteringLevels = feed.getMeteringLevels(song: cell.soundFileName!)
                    
                    feed.setupSoundViewWithMeteringLevels(soundView: cell.soundView, meteringLevels: meteringLevels)
                }
                else {
                    cell.soundView.meteringLevels = feed.placeholdMeteringLevels
                }
            }
            else {
                cell.soundView = currentPost.waveform
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func formatDate(date: Date) -> String {
    // returns a concise string corresponding to time since post
    let minutesAgo =  -Int((date.timeIntervalSinceNow / 60))
    return "\(minutesAgo) minutes ago"
        
    }
    
    
    
}
