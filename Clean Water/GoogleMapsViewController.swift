//
//  GoogleMapsViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/1/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class GoogleMapsViewController: UIViewController, GMSMapViewDelegate {

    var root:FIRDatabaseReference! = FIRDatabase.database().reference()
    var waterreports: [WaterReport] = []
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)

        
        let camera = GMSCameraPosition.camera(withLatitude: 34.12, longitude: -84.26, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        view = mapView
        observeMessages()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observeMessages() {
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

                
                let m = WaterReport(llat: llat, llong: llong, date: date, location: location, user: user, waterType: waterType, waterCondition: waterCondition)
                
                self.waterreports.append(m)
                self.putWaterReportsonMap()

            }

            
        }, withCancel: nil)
    }
    
    func putWaterReportsonMap() {
        //print(waterreports)
        for i in 0..<waterreports.count {
            let cor = waterreports[i]
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: cor.llat, longitude: cor.llong)
            marker.title = "(" + String(describing: cor.llat) + ", " + String(describing: cor.llong) + ")"
            marker.snippet = String(describing: i)
            marker.map = self.mapView

            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        performSegue(withIdentifier: "goToScreen", sender: marker)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToScreen") {
            
            let destinationNavigationController = segue.destination as! UINavigationController
            
            let WaterReportVC: NewWaterReportViewController = destinationNavigationController.topViewController as! NewWaterReportViewController
            
            print("SelectedMarker: \((sender as! GMSMarker).title!)")

            
            WaterReportVC.text = (sender as! GMSMarker).title!
        }
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
}
