//
//  RegisterViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 2/22/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreData

class RegisterViewController: UIViewController {


    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zipcode: UITextField!
    
    @IBOutlet var userType: UIPickerView!
    
    var userTypes = ["User", "Worker", "Manager", "Admin"]
    
    var typeOfUser: String!
    
    var root:FIRDatabaseReference!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image : UIImage = UIImage(named: "navBar")!
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)

        typeOfUser = userTypes[0]
        
        userType.delegate = self
        userType.dataSource = self
        
        root = FIRDatabase.database().reference().child("users")
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        
        if (self.username.text != "" && self.email.text != "" && self.password.text != "" && self.address.text != "" && self.city.text != "" && self.state.text != "" && self.zipcode.text != "") {
            if typeOfUser == "Admin" {
                self.performSegue(withIdentifier: "goToAdminHome2", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToHome2", sender: self)
            }
            
        } else {
            self.alert(title: "Improper Registration", body: "Some or all of the fields are empty. Please fill in all fields and try again.")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let userName = CurrentUser(context: self.managedObjectContext)
        userName.username = self.username.text
        
        let data = [
            "account_type" : typeOfUser,
            "attempts": 0,
            "city": self.city.text,
            "email": self.email.text,
            "locked": false,
            "password": self.password.text!,
            "state": self.state.text!,
            "street_address": self.address.text!,
            "username": self.username.text!,
            "zip_code": self.zipcode.text!
        ] as [String : Any]
        
        root.child(self.username.text!).setValue(data)
        
        root.childByAutoId().setValue(data)
    }
    
    func alert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfUser = userTypes[row]
    }
}
