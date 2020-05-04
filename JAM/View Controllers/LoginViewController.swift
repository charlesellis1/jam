//
//  LoginViewController.swift
//  JAM
//
//  Created by Charles Ellis on 4/17/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
        
        //Check that accounts exist on firebase, and make this account active.
        
        performSegue(withIdentifier: "loginComplete", sender: Any.self)
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "loginComplete" {
                if let dest = segue.destination as? FeedViewController {
                    dest.isModalInPresentation = true
                    //through firebase, set up myDisplayName and myUsername
                }
                else if let dest = segue.destination as? UITabBarController {
                //self.isModalInPresentation = true
                dest.isModalInPresentation = true
                print("NO")
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
