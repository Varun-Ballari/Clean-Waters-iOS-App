//
//  EditTableViewController.swift
//  Clean Water
//
//  Created by Varun Ballari on 3/24/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {

    @IBOutlet weak var editModelTextField: UITextField!
    
    var index:Int?
    
    var modelArray:[String]!
    var editedModel:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0xE1E8ED, alpha: 1)
        
        editModelTextField.text = modelArray[index!]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.section == 0 && indexPath.row == 0 {
            editModelTextField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            editedModel = editModelTextField.text
        }

    }

}
