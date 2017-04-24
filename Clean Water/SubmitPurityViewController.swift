//
//  SubmitPurityViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 4/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import CoreData

class SubmitPurityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var text = ""
    @IBOutlet var address: UITextField!
    
    @IBOutlet var waterConditionPicker: UIPickerView!


    var waterConditionArray = ["Safe", "Treatable", "Unsafe"]
    
    var waterConditionValue: String!
    
    @IBOutlet var vppmlabel: UILabel!
    @IBOutlet var cppmlabel: UILabel!
    
    var root:FIRDatabaseReference!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waterConditionValue = waterConditionArray[0]
        
        address.text = text
        
        waterConditionPicker.dataSource = self
        waterConditionPicker.delegate = self
        
        root = FIRDatabase.database().reference().child("waterPurityReports")
        
        let fetchRequest:  NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let cur = try managedContext.fetch(fetchRequest)
            currentUser = cur[0].username!
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.waterConditionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return waterConditionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        waterConditionValue = waterConditionArray[row]
    }
    
    @IBAction func changeVirusPPM(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        vppmlabel.text = "\(currentValue)"
    }
    
    
    @IBAction func changeContaminantPPM(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        cppmlabel.text = "\(currentValue)"
    }
    
    @IBAction func saveToFirebase(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address.text!) { placemarks, error in
            
            if error == nil {
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
                let stringFromDate = formatter.string(from: date)
                
                
                let data = [
                    "date": stringFromDate,
                    "llat": placemarks?[0].location?.coordinate.latitude,
                    "llong": placemarks?[0].location?.coordinate.longitude,
                    "location": self.address.text!,
                    "user": self.currentUser,
                    "waterCondition": self.waterConditionValue,
                    "virusPPM": Int(self.vppmlabel.text!),
                    "contaminantPPM": Int(self.cppmlabel.text!),
                    "reportNumber": 2
                    ] as [String : Any]
                
                self.root.child(self.address.text!).setValue(data)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Succesful Completion"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
                
                
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        address.resignFirstResponder()
    }
}
