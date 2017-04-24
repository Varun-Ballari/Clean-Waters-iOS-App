//
//  AdminUsersViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 4/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AdminUsersViewController: UIViewController {
        
    var root:FIRDatabaseReference!
        
    var u: [User] = []
    
    @IBOutlet var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        root = FIRDatabase.database().reference().child("users")
        
        root.observe(.childAdded, with: { snapshot in
                
            if let value = snapshot.value as? [String : Any] {
                
                self.u.append(User(username: value["username"] as! String!, email: value["email"] as! String!))
                
            }
            self.tableView.reloadData()
                
        }, withCancel: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension AdminUsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return u.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell")
        cell?.textLabel?.text = u[indexPath.row].username
        cell?.detailTextLabel?.text = u[indexPath.row].email
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.confirmDelete(indexPath: indexPath, intToDelete: indexPath.row, title: "Delete User")
        }
        delete.backgroundColor = UIColor.init(rgb: 0xEF4F55, alpha: 1.0)
        
        let block = UITableViewRowAction(style: .destructive, title: "Block") { action, index in
            self.confirmDelete(indexPath: indexPath, intToDelete: indexPath.row, title: "Block User")

        }
        block.backgroundColor = UIColor.init(rgb: 0xF79044, alpha: 1.0)
        let unblock = UITableViewRowAction(style: .destructive, title: "Unblock") { action, index in
            self.confirmDelete(indexPath: indexPath, intToDelete: indexPath.row, title: "Unblock User")

        }
        unblock.backgroundColor = UIColor.init(rgb: 0x61DB6D, alpha: 1.0)
        
        return [delete, block, unblock]
    }
    
    func confirmDelete(indexPath: IndexPath, intToDelete: Int, title:String) {
        let planetToDelete = u[intToDelete]
        let planet = planetToDelete.username
        
        let alert = UIAlertController(title: title, message: "Are you sure you want to \(title) \(planet)?", preferredStyle: .actionSheet)
        
        if title == "Delete User" {
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.u.remove(at: intToDelete)
                self.tableView.reloadData()
            })
            alert.addAction(DeleteAction)
        } else if title == "Block User" {
            let DeleteAction = UIAlertAction(title: "Block", style: .destructive, handler: { (action: UIAlertAction!) in
                self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.init(rgb: 0xEF4F55, alpha: 1.0)
            })
            alert.addAction(DeleteAction)

        } else {
            let DeleteAction = UIAlertAction(title: "Unblock", style: .default, handler: { (action: UIAlertAction!) in
                self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.clear
            })
            alert.addAction(DeleteAction)
        }

        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

struct User {
    var username: String
    var email: String
}
