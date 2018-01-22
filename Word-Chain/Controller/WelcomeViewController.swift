//
//  ViewController.swift
//  Word-Chain
//
//  Created by kibeom lee on 2018. 1. 14..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class WelcomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func autoLogin() {
        if Auth.auth().currentUser?.uid != nil {
            print("**AUTO LOGIN**")
            let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
            let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
            //var friendList = []()
            request?.start(completionHandler: { (connection, result, error) in
                if error == nil {
                    print("yalllo")
                
                    //friendList.append(result)
                }
            })
            
            performSegue(withIdentifier: "goToFindUser", sender: self)
        }
    }
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self) { (result, error) in
            if error != nil {
                print("error occured - \(error!)")
            } else if (result?.isCancelled)! {
                print("login cancelled")
            } else {
                print("loggin in ")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        print("Error")
                    }else {
                        self.performSegue(withIdentifier: "goToFindUser", sender: self)
                    }
                })
            }
        }
    }
}

