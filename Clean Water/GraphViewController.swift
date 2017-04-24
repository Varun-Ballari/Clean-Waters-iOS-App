//
//  GraphViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 4/23/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import ScrollableGraphView

class GraphViewController: UIViewController {
    
    @IBOutlet var address: UITextField!
    @IBOutlet var year: UITextField!
    
    
    @IBOutlet var sv: UIScrollView!
    @IBOutlet var underView: UIView!
    @IBOutlet var graphFrame: UIView!
    
    var data: [Double]!
    var labels: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        if sv.contentOffset.y < 0 {
            headerRect.origin.y = 0
            headerRect.size.height = 400 - sv.contentOffset.y
        }
        underView.frame = headerRect
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        
        address.resignFirstResponder()
        year.resignFirstResponder()
    }
    
    @IBAction func generateGraph(_ sender: Any) {
        
        UIView.animate(withDuration: 1, animations: {
            
            
        }, completion: { (_ : Bool) in
            let graphView = ScrollableGraphView(frame: self.graphFrame.frame)
            
            self.data = []
            self.labels = []
            for i in 1...5 {
                self.data.append(Double(Int(arc4random_uniform(50))))
                self.labels.append("Day" + String(i))
            }
            
            
            graphView.set(data: self.data, withLabels: self.labels)
            
            graphView.backgroundFillColor = UIColor.init(rgb: 0x101C2C, alpha: 1.0)
            graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
            graphView.shouldDrawDataPoint = false
            graphView.lineColor = UIColor.init(rgb: 0x1F96FF, alpha: 1.0)
            graphView.dataPointLabelColor = UIColor.init(rgb: 0x7A828A, alpha: 1.0)
//
//            graphView.shouldFill = true
//            graphView.fillType = ScrollableGraphViewFillType.gradient
//            graphView.fillColor = UIColor.init(rgb: 0x1F96FF, alpha: 0.8)
//            graphView.fillGradientType = ScrollableGraphViewGradientType.linear
//            graphView.fillGradientStartColor = UIColor.init(rgb: 0x1F96FF, alpha: 0.8)
//            graphView.fillGradientEndColor = UIColor.init(rgb: 0x1F96FF, alpha: 0.5)
            
            graphView.dataPointSpacing = 50
            graphView.dataPointSize = 2
            graphView.dataPointFillColor = UIColor.white
            
            graphView.referenceLineThickness = 1
            graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
            graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
            graphView.referenceLineLabelColor = UIColor.white
            graphView.rangeMax = 50

            self.graphFrame.addSubview(graphView)

        })
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
