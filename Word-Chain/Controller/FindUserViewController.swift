//
//  FindUserViewController.swift
//  Word-Chain
//
//  Created by kibeom lee on 2018. 1. 14..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class FindUserViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var userList = [String]()
    var selectUser = false
    var selectUserNum = 0
    @IBOutlet weak var IDTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IDTableView.delegate = self
        IDTableView.dataSource = self
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        retrieveUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IDTableView.dequeueReusableCell(withIdentifier: "IDCell", for: indexPath)
        
        cell.textLabel?.text = userList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectUser = true
        selectUserNum = indexPath.row
    }
    
    
    func retrieveUsers() {
        
        let userDB = Database.database().reference().child("Users")
        userDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! String
            
            if snapshotValue.lowercased() != (Auth.auth().currentUser?.email)! {
                self.userList.append(snapshotValue)
                self.IDTableView.reloadData()
            }
            
            //print(snapshotValue, (Auth.auth().currentUser?.email)!)
            
        }
    }
    
    @IBAction func goToChatButton(_ sender: UIButton) {
        SVProgressHUD.show()
        if selectUser {
            performSegue(withIdentifier: "goToChat", sender: self)
            SVProgressHUD.dismiss()
        }else {
            SVProgressHUD.showError(withStatus: "Select User")
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        //navigationController?.popToRootViewController(animated: true)
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.textPassedOver = userList[selectUserNum]
        }
    }
    
}
