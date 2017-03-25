//
//  LoginViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 2/22/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreData


class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var login: UIBarButtonItem!
    
    var root:FIRDatabaseReference!
    var managedObjectContext: NSManagedObjectContext!
    
    var userType: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image : UIImage = UIImage(named: "navBar")!
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)

        
        root = FIRDatabase.database().reference()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: Any) {
        emailTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func login(_ sender: Any) {

        let messagesRef = root.child("users").child(emailTextField.text!)
        
        root.child("users").child(emailTextField.text!).observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String : AnyObject] {
                let password = value["password"] as! String
                self.userType = value["account_type"] as! String

                if (self.emailTextField.text == snapshot.key && self.passwordTextField.text == password) {
                    
                    if self.userType == "Admin" {
                        self.performSegue(withIdentifier: "goToAdminHome", sender: self)

                    } else {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    
                } else {
                    self.alert(title: "Wrong Credentials", body: "Username or Password is wrong. Please try again.")
                }
            }
            self.alert(title: "Wrong Credentials", body: "Username or Password is wrong. Please try again.")

        }, withCancel: nil)

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userName = CurrentUser(context: self.managedObjectContext)
        userName.username = self.emailTextField.text
        
        if self.userType != "Admin" {
    
            let setDataPosition = root.child("loginReports")
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
            let stringFromDate = formatter.string(from: date)
        
            let data: [String: Any] = [
                "login_timestamp" : stringFromDate,
                "success_status" : true,
                "user" : self.emailTextField.text,
                "type" : "Login From iOS"
            ]
            setDataPosition.child(stringFromDate).setValue(data)
        } else {
            
        }
    }
    
    func alert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
