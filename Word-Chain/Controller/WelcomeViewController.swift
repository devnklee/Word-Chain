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
            print("**AUTO LOGIN with \(Auth.auth().currentUser?.email)**")
            //getting FACEBOOK FRIENDS
//            let params = ["fields": "id, name"]
//            let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
//
//            request?.start(completionHandler: { (connection, result, error) in
//                if error == nil {
//                    let list : NSDictionary = result as! NSDictionary
//                    let friendsArray :NSArray = list.object(forKey: "data") as! NSArray
//
//                    print("LET's PRINT NOW \(friendsArray.count)")
//                    for i in 0..<friendsArray.count {
//                        let values : NSDictionary = friendsArray[i] as! NSDictionary
//                        let id = values.object(forKey: "id") as! String
//                        let name = values.object(forKey: "name") as! String
//                        print("\(name) has ID: \(id)")
//                    }
//                    //friendList.append(result)
//                }
//            })
            
            
            
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

