//
//  IncludePart.swift
//  CodestrokeEmergency
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import UIKit

class IncludePart: UIViewController {
    
    @IBOutlet weak var id: UITextField!
    
    static var secret: String?
    let def = "nil"
    var exam: [String] = []
    
    func formatDate(arg: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let strDate = dateFormatter.string(from: arg)
        return strDate
    }
    
    @IBAction func examHandler(_ sender: UIButton) {
        let UnCheckBox = UIImage(named: "UnCheckBox")
        let CheckBox = UIImage(named: "CheckBox")
        let title = sender.currentTitle!
        
        if (sender.currentImage?.isEqual(CheckBox))! {
            sender.setImage(UnCheckBox, for: UIControlState.normal)
            if let pos = self.exam.index(of: title) {
                self.exam.remove(at: pos) //remove elmnt
            }
        }
        else {
            sender.setImage(CheckBox, for: UIControlState.normal)
            self.exam.append(title)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "end", let vc = segue.destination as? IncludeFinish {
            vc.info = [ "er": formatDate(arg: Date()), "exam": self.exam.joined(separator: ", "), "meds": def, "token": IncludePart.secret!, "query": id.text!, "app": "Emer"]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
