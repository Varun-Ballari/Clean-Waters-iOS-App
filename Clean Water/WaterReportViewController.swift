//
//  WaterReportViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WaterReportViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var root:FIRDatabaseReference!
    
    var messages:[Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)


        root = FIRDatabase.database().reference()
        
        observeData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observeData() {
        let messagesRef = root.child("waterReports")
        messagesRef.observe(.childAdded, with: { snapshot in
            
            if let value = snapshot.value as? [String : Any] {
                let location = value["location"] as! String
                let user = value["user"] as! String

                
                let m = Message(text: location, user: user)
                
                self.messages.append(m)
                
                self.tableView.reloadData()
//                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section:0), at: .bottom, animated: true)
            }
            
        }, withCancel: nil)
    }
    
}

extension WaterReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")
        
        let message = messages[indexPath.row]
        
        cell?.textLabel?.text = message.text
        cell?.detailTextLabel?.text = message.user
        
        return cell!
    }
    
}

struct Message {
    var text: String
    var user: String
    
}
