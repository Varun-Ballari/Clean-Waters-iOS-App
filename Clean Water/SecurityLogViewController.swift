//
//  SecurityLogViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 4/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SecurityLogViewController: UIViewController {

    var root:FIRDatabaseReference!
    
    var reports: [LoginReport] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root = FIRDatabase.database().reference().child("loginReports")

        root.observe(.childAdded, with: { snapshot in
            
            if let value = snapshot.value as? [String : Any] {

                self.reports.append(LoginReport(time: value["login_timestamp"] as! String, success: String(describing: value["success_status"]), user: value["user"] as! String))

            }
            self.tableView.reloadData()
            
        }, withCancel: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension SecurityLogViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDataCell")
        cell?.textLabel?.text = reports[indexPath.row].user
        cell?.detailTextLabel?.text = reports[indexPath.row].time
        return cell!
    }

}

struct LoginReport {
    var time : String
    var success : String
    var user : String
}
