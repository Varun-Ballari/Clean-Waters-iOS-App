//
//  SubmitAvailabilityViewController.swift
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


class SubmitAvailabilityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var text = ""
    @IBOutlet var address: UITextField!
    
    @IBOutlet var waterConditionPicker: UIPickerView!
    @IBOutlet var waterTypePicker: UIPickerView!
    
    var waterTypeArray = ["Bottled", "Well", "Stream", "Lake", "Spring", "Other"]
    var waterConditionArray = ["Waste", "Treatable-Clear", "Treatable-Muddy", "Potable"]
    
    var waterTypeValue: String!
    var waterConditionValue: String!
    
    
    var root:FIRDatabaseReference!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waterTypeValue = waterTypeArray[0]
        waterConditionValue = waterConditionArray[0]
        
        address.text = text
        
        waterTypePicker.dataSource = self
        waterTypePicker.delegate = self
        waterConditionPicker.dataSource = self
        waterConditionPicker.delegate = self

        root = FIRDatabase.database().reference().child("waterReports")
        
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
        if pickerView.tag == 1 {
            return self.waterTypeArray.count
        } else {
            return self.waterConditionArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return waterTypeArray[row]
        } else {
            return waterConditionArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            waterTypeValue = waterTypeArray[row]
        } else {
            waterConditionValue = waterConditionArray[row]
        }
    }

    
    @IBAction func saveToFirebase(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address.text!) { placemarks, error in
            
            if error == nil {
//                print(placemarks)
//                print(placemarks?[0].addressDictionary?[5])
//                print(placemarks?[0].location?.coordinate.latitude)
//                print(placemarks?[0].location?.coordinate.longitude)
//                print(placemarks?[0].name)
                
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
                    "waterType": self.waterTypeValue
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
