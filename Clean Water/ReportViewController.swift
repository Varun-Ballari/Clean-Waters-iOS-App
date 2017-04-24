//
//  ReportViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 4/23/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var m:WaterReport!
    
    var data: [String]!
    var t:[String] = ["User", "Location", "Lat", "Long", "Date", "Water Type", "Water Condition", "Virus PPM", "Report Number"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)
        self.navigationItem.title = "Water Report"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        data = [m.user as String, m.location as String, String(describing: m.llat), String(describing: m.llong), m.date as String, m.waterType as String, String(describing: m.waterCondition), String(describing: m.virusPPM), String(describing: m.reportNumber)]
//        print(data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return t.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDataCell")
        cell?.textLabel?.text = t[indexPath.row]
        cell?.detailTextLabel?.text = data[indexPath.row]
        return cell!
    }


}
