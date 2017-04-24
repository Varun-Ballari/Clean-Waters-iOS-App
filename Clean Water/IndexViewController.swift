//
//  ViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 2/22/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit
import Gifu

class IndexViewController: UIViewController {

    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width / 1.3))

        imageView.animate(withGIFNamed: "animation_blue")
        
        self.view.addSubview(imageView)
        
        imageView.startAnimatingGIF()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showRegister(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }

    @IBAction func showLogin(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }

}

