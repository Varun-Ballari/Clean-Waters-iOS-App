//
//  SettingsTableViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    
    var root:FIRDatabaseReference!
    
    var userData: [String] = []
    var userDataType = ["Username", "Password", "Email", "Account Type", "Locked", "Attempts", "Street Address", "City", "State", "Zip Code"]
    
    var firebaseDataTypes = ["username", "password", "email", "account_type", "locked", "attempts", "street_address", "city", "state", "zip_code"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)
        
        root = FIRDatabase.database().reference().child("users")
        
        
        let fetchRequest:  NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let cur = try managedContext.fetch(fetchRequest)
            currentUser = cur[0].username!
            observeData(childNode: currentUser)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observeData(childNode: String) {
        let messagesRef = root.child(childNode)
        print(messagesRef)
        
        messagesRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? [String : AnyObject] ?? [:]
            let account_type = value["account_type"] as! String
            let attempts = String(describing: value["attempts"])
            let city = value["city"] as! String
            let email = value["email"] as! String
            let locked = String(describing: value["locked"])
            let password = value["password"] as! String
            let state = value["state"] as! String
            let street_address = value["street_address"] as! String
            let username = value["username"] as! String
            let zip_code = String(describing: value["zip_code"])
            
            
            self.userData = [username, password,email, account_type, locked,attempts, street_address, city, state, zip_code]
            
            print(self.userData)
            self.tableView.reloadData()
        })
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = userDataType[indexPath.row]
        cell.detailTextLabel?.text = userData[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "edit" {
            
            var path = self.tableView.indexPathForSelectedRow
            
            
            let destinationNavigationController = segue.destination as! UINavigationController
            
            let detailViewController: EditTableViewController = destinationNavigationController.topViewController as! EditTableViewController

            
            detailViewController.index = path?.row
            detailViewController.modelArray = userData
            
        }
    }
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        
        let detailViewController = segue.source as! EditTableViewController
        
        let index = detailViewController.index
        
        let modelString = detailViewController.editedModel
        
        userData[index!] = modelString!
        
        self.tableView.reloadData()
        
        let changeData = root.child(currentUser).child(firebaseDataTypes[index!])
        changeData.setValue(userData[index!])

        
    }

    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
