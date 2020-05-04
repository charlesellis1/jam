//
//  SignUpViewController.swift
//  JAM
//
//  Created by Charles Ellis on 4/17/20.
//  Copyright © 2020 Charles Ellis. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayNameTF: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    var imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        
        navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        let displayName = displayNameTF.text;
        let username = usernameTextField.text;
        let password = passwordTextField.text;
        let confirmedPassword = confirmPasswordTextField.text;
        
        // Check for empty fields, matching passwords.
        
        if (displayName!.isEmpty || username!.isEmpty || password!.isEmpty || confirmedPassword!.isEmpty) {
            
            presentAlertViewController(title: "Alert!", message: "Please fill in all text fields.")
            
            return;
        }
        if (password != confirmedPassword) {
            presentAlertViewController(title: "Alert!", message: "Passwords do not match")
            return;
        }
        
        // Store the data via Firebase.
        
        feed.displayName = displayName!
        feed.username = "@" + username!
        
        
        performSegue(withIdentifier: "toChoosePic", sender: Any.self)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "signupComplete" {
                if let dest = segue.destination as? FeedViewController {
                    //self.isModalInPresentation = true
                    dest.isModalInPresentation = true
                    dest.myDisplayName = displayNameTF.text
                    dest.myUsername = usernameTextField.text
                    dest.myProfilePic = profilePicture.image
                }
                
            }
        }
    }
    
    
    @IBAction func fromCameraRollButton(_ sender: UIButton) {
        if sender.tag == 0 {
            self.imagePickerController.sourceType = .photoLibrary
        }
        else if sender.tag == 1 {
            self.imagePickerController.sourceType = .camera
        }
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profilePicture.image = image
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func getJamminButtonPressed(_ sender: Any) {
        //make sure an image is selected (maybe they can just go without), and move on to the FVC
        if profilePicture.image == nil {
            presentAlertViewController(title: "Alert!", message: "Please choose a profile picture.")
        }
        performSegue(withIdentifier: "signupComplete", sender: Any.self)
        
        
    }
    
    
    func presentAlertViewController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
