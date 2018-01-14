//
//  ChatViewController.swift
//  Word-Chain
//
//  Created by kibeom lee on 2018. 1. 14..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var textPassedOver : String?
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = textPassedOver
        
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        retrievMessages()
        configureTableView()
        messageTableView.separatorStyle = .none
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername = messageArray[indexPath.row].sender
        
        
        if cell.senderUsername == Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.flatYellow()
            cell.messageBody.textAlignment = .right
        }else {
            cell.messageBackground.backgroundColor = UIColor.flatWhite()
            cell.messageBody.textAlignment = .left
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped () {
        messageTextfield.endEditing(true)
    }
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 310
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        if messageTextfield.text != "" {
            
            messageTextfield.endEditing(true)
            //TODO: Send the message to Firebase and save it in our database
            
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            let messagesDB = Database.database().reference().child("Messages")
            let messageDictionary = ["sender": Auth.auth().currentUser?.email,
                                     "message" : messageTextfield.text!,
                                     "to" : textPassedOver]
            
            messagesDB.childByAutoId().setValue(messageDictionary) { (error, reference) in
                if error != nil {
                    print(error!)
                }else {
                    //print("message send")
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrievMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["message"]!
            let sender = snapshotValue["sender"]!.lowercased()
            let to = snapshotValue["to"]!.lowercased()
            let currentUser = (Auth.auth().currentUser?.email)!.lowercased()
            let receiveUser = self.textPassedOver!.lowercased()
            
            if (sender == currentUser && to == receiveUser) || (sender == receiveUser && to == currentUser) {
                let message = Message()
                message.messageBody = text
                message.sender = sender
                message.to = to
                self.messageArray.append(message)
                
                self.configureTableView()
                self.messageTableView.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
}
