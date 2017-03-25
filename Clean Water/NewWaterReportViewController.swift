//
//  NewWaterReportViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class NewWaterReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var text = ""
    @IBOutlet var addressTextField: UITextField!

    @IBOutlet var waterConditionPicker: UIPickerView!
    @IBOutlet var waterTypePicker: UIPickerView!
    
    
    var waterTypeArray = ["Bottled", "Well", "Stream", "Lake", "Spring", "Other"]
    var waterConditionArray = ["Waste", "Treatable-Clear", "Treatable-Muddy", "Potable"]

    var waterTypeValue: String!
    var waterConditionValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)
        
        waterTypeValue = waterTypeArray[0]
        waterConditionValue = waterConditionArray[0]

        addressTextField.text = text
        
        waterTypePicker.dataSource = self
        waterTypePicker.delegate = self
        waterConditionPicker.dataSource = self
        waterConditionPicker.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveToFirebase(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressTextField.text!) { placemarks, error in
            
            if error == nil {
                print(placemarks)
                print(placemarks?[0].addressDictionary?[5])
                print(placemarks?[0].location?.coordinate.latitude)
                print(placemarks?[0].location?.coordinate.longitude)

                print(placemarks?[0].name)



            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        

    }

}
