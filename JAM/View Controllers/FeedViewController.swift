//
//  FeedView.swift
//  JAM
//
//  Created by Charles Ellis on 4/16/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import Foundation
import UIKit


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var myDisplayName: String?
    var myUsername: String?
    var myProfilePic: UIImage?
    
    
 
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //NAV BACK BUTTON WON'T DELETE
        navigationController?.isNavigationBarHidden = true
        
//        navItem.hidesBackButton = true
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        
        
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .singleLine
        postTableView.separatorColor = .black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell {
            // configure cell
            let currentPost = feed.posts[indexPath.row]
            
            cell.nameLabel.setTitle(currentPost.displayName, for: .normal)
            cell.captionLabel.text = currentPost.caption
            cell.dateLabel.text = formatDate(date: currentPost.date)
            cell.profileImage.image = currentPost.profilePic
            
            
            //Add song
            cell.soundFileName = currentPost.audioFileName
            
            
            
            //Waveform: Basically if waveform is not initialized, we make one here (useful for pre-initialized posts). Attaches soundwaveView of cell, to the waveform of the current post.
//            if currentPost.waveform == nil {
//
//                if cell.soundFileName!.count > 0 {
//                    let meteringLevels = cell.getMeteringLevels(song: cell.soundFileName!)
//
//                    cell.setupSoundViewWithMeteringLevels(soundView: cell.soundwaveView, meteringLevels: meteringLevels)
//                }
//                else {
//                    cell.soundwaveView.meteringLevels = cell.placeholdMeteringLevels
//                }
//            }
//            else {
//                cell.soundwaveView = currentPost.waveform
//            }
            
            
            
            if cell.soundFileName!.count > 0 {
                let meteringLevels = cell.getMeteringLevels(song: cell.soundFileName!)
                
                cell.setupSoundViewWithMeteringLevels(soundView: cell.soundwaveView, meteringLevels: meteringLevels)
            }
            else {
                cell.soundwaveView.meteringLevels = cell.placeholdMeteringLevels
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
