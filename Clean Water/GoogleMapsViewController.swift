//
//  GoogleMapsViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/1/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import Firebase

class GoogleMapsViewController: UIViewController, GMSMapViewDelegate {

    var root:FIRDatabaseReference! = FIRDatabase.database().reference()
    var waterreports: [WaterReport] = []
    var mapView: GMSMapView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    var accountType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)

        
        let camera = GMSCameraPosition.camera(withLatitude: 34.12, longitude: -84.26, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        view = mapView
        
        let fetchRequest:  NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let cur = try managedContext.fetch(fetchRequest)
            currentUser = cur[0].username!
            accountType = cur[0].accountType!
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        observeData()
        if (accountType == "User") {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            self.navigationItem.leftBarButtonItem = nil
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (accountType == "User") {
            segmentedControl.removeSegment(at: 1, animated: true)
        }
    }
    
    func observeData() {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                waterreports = []
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
                        self.putWaterReportsonMap()
                    }
                }, withCancel: nil)
                break
            case 1:
                waterreports = []
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
                    
                        let m = WaterReport(llat: llat, llong: llong, date: date, location: location, user: user, waterType: "This", waterCondition: waterCondition, contaminantPPM: contaminantPPM, virusPPM: virusPPM, reportNumber: reportNumber)
                    
                        self.waterreports.append(m)
                        self.putWaterReportsonMap()
                    
                    }
                
                }, withCancel: nil)
                break
            
            default:
                print("default - GoogleMaps")
                break
        }
    }
    
    @IBAction func changeData(_ sender: Any) {
        observeData()
    }
    
    func putWaterReportsonMap() {
        //print(waterreports)
        mapView.clear()

        for i in 0..<waterreports.count {
            let cor = waterreports[i]
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: cor.llat, longitude: cor.llong)
            marker.title = "(" + String(describing: cor.llat) + ", " + String(describing: cor.llong) + ")"
            marker.snippet = String(describing: i)
            marker.map = self.mapView
//            print(i)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        performSegue(withIdentifier: "gViewReport", sender: marker)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gViewReport") {
            
            let destinationViewController = segue.destination as! ReportViewController
            destinationViewController.m = waterreports[Int((sender as! GMSMarker).snippet!)!]
        }
    }
    
    @IBAction func showCharts(_ sender: Any) {
        performSegue(withIdentifier: "gShowGraph", sender: self)
    }
    
    @IBAction func addReport(_ sender: Any) {
        performSegue(withIdentifier: "gAddReport", sender: self)
    }
    
    
}

struct WaterReport {
    var llat: Double
    var llong: Double
    var date: String
    var location: String
    var user: String
    var waterType: String
    var waterCondition: String
    var contaminantPPM: Int
    var virusPPM: Int
    var reportNumber:Int
}
