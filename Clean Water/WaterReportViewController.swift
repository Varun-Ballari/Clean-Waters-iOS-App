//
//  WaterReportViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import Gifu

class WaterReportViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var root:FIRDatabaseReference!
    var waterreports: [WaterReport] = []
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    var accountType: String!
    
    @IBOutlet var headerimageView: UIImageView!
    
    @IBOutlet var nameView: UILabel!
    
    private let tableHeaderHeight: CGFloat = 200.0
    var headerView: UIView!

    var clickedOnM: WaterReport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.clear//UIColor.init(rgb: 0xE1E8ED, alpha: 1)

        
        let fetchRequest:  NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let cur = try managedContext.fetch(fetchRequest)
            currentUser = cur[0].username!
            accountType = cur[0].accountType!
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        root = FIRDatabase.database().reference()
        observeData()
        
        if (accountType == "User") {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            self.navigationItem.leftBarButtonItem = nil
        }
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    @IBAction func showCharts(_ sender: Any) {
        performSegue(withIdentifier: "showGraph", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (accountType == "User") {
            segmentedControl.removeSegment(at: 1, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observeData() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            waterreports = []
            nameView.text = "Water Availability"
            headerimageView.image = UIImage(named: "starry")
            let messagesRef = root.child("waterReports")
            messagesRef.observe(.childAdded, with: { snapshot in
                
                if let value = snapshot.value as? [String : Any] {
                    let llat = value["llat"] as! Double
                    let llong = value["llong"] as! Double
                    let date = value["date"] as! String
                    let location = value["location"] as! String
                    let user = value["user"] as! String
                    let waterType = value["waterType"] as! String
                    let waterCondition = value["waterCondition"] as! String
                    
                    let m = WaterReport(llat: llat, llong: llong, date: date, location: location, user: user, waterType: waterType, waterCondition: waterCondition, contaminantPPM: 0, virusPPM: 0, reportNumber: 0)
                    
                    self.waterreports.append(m)
                }
                self.tableView.reloadData()
                
            }, withCancel: nil)
            break
        case 1:
            waterreports = []
            nameView.text = "Water Purity"
            headerimageView.image = UIImage(named: "waterfall")
            let messagesRef = root.child("waterPurityReports")
            messagesRef.observe(.childAdded, with: { snapshot in
                
                if let value = snapshot.value as? [String : Any] {
                    let llat = value["llat"] as! Double
                    let llong = value["llong"] as! Double
                    let date = value["date"] as! String
                    let location = value["location"] as! String
                    let user = value["user"] as! String
                    let waterCondition = value["waterCondition"] as! String
                    let contaminantPPM = value["contaminantPPM"] as! Int
                    let virusPPM = value["virusPPM"] as! Int
                    let reportNumber = value["reportNumber"] as! Int
                    
                    let m = WaterReport(llat: llat, llong: llong, date: date, location: location, user: user, waterType: "null", waterCondition: waterCondition, contaminantPPM: contaminantPPM, virusPPM: virusPPM, reportNumber: reportNumber)
                    
                    self.waterreports.append(m)
                }
                self.tableView.reloadData()
                
            }, withCancel: nil)
            break
            
        default:
            print("default - GoogleMaps")
            break
        }
    }
    
    @IBAction func getDataFromPicket(_sender: AnyObject) {
        observeData()
    }
}

extension WaterReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waterreports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")
        
        let message = waterreports[indexPath.row]
        
        cell?.textLabel?.text = message.location
        cell?.detailTextLabel?.text = message.user
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (accountType != "Manager") {
            let more = UITableViewRowAction(style: .destructive, title: "View") { action, index in
            }
            more.backgroundColor = UIColor.lightGray
            return [more]
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (accountType == "Manager") {
            if editingStyle == .delete {
                confirmDelete(intToDelete: indexPath.row)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedOnM = waterreports[indexPath.row]
        performSegue(withIdentifier: "viewReport", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewReport" {
            let detailViewController = segue.destination as! ReportViewController
            detailViewController.m = clickedOnM
        }
    }
    
    func confirmDelete(intToDelete: Int) {
        let planetToDelete = waterreports[intToDelete]
        let planet = planetToDelete.location
        
        let alert = UIAlertController(title: "Delete Report", message: "Are you sure you want to permanently delete \(planet)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            self.waterreports.remove(at: intToDelete)
            self.tableView.reloadData()
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
