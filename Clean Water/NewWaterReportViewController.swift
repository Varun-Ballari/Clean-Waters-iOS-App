//
//  NewWaterReportViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreData

class NewWaterReportViewController: UIViewController {
    
    @IBOutlet var availabilityCV: UIView!
    @IBOutlet var purityCV: UIView!
    var accountType: String!

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)
        
        availabilityCV.alpha = 1
        purityCV.alpha = 0
        
        let fetchRequest:  NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let cur = try managedContext.fetch(fetchRequest)
            accountType = cur[0].accountType!
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (accountType == "User") {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (accountType == "User") {
            segmentedControl.removeSegment(at: 1, animated: true)
        }
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {

        if (sender.selectedSegmentIndex == 0) {
            availabilityCV.alpha = 1
            purityCV.alpha = 0
        } else {
            availabilityCV.alpha = 0
            purityCV.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
