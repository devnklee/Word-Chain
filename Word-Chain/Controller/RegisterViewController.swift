//
//  RegisterViewController.swift
//  Word-Chain
//
//  Created by kibeom lee on 2018. 1. 14..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    
    //Pre-linked IBOutlets
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        
        SVProgressHUD.show()
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "Error")
                SVProgressHUD.dismiss(withDelay: 1)
                print("----------Error")
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToFindUser", sender: self)
                
                
                let userDB = Database.database().reference().child("Users")
                userDB.childByAutoId().setValue(self.emailTextfield.text, withCompletionBlock: { (error, reference) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: "Error")
                        SVProgressHUD.dismiss(withDelay: 1)
                    }else {
                    }
                }
                )
            }
        }
        
        
        
        
    }
    
    
}
