//
//  LoginViewController.swift
//  Word-Chain
//
//  Created by kibeom lee on 2018. 1. 14..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD


class LogInViewController: UIViewController{
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                SVProgressHUD.showError(withStatus: "Error")
                SVProgressHUD.dismiss(withDelay: 1)
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToFindUser", sender: self)
            }
        }
    }

    
    
    
    
}

