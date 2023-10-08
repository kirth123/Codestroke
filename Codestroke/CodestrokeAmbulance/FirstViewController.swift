//
//  FirstViewController.swift
//  AmbulanceCodestroke
//
//  Created by XCodeClub on 8/27/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import UIKit

struct json {
    var name: String
    var age: String
    var LKW: String
    var amb: String
    var exam: String
    var meds: String
    var token: String
}

class FirstViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var LKW: UIDatePicker!
    
    static var secret: String?
    var exam: [String] = []
    var def = "nil"
    
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
            if let pos = exam.index(of: title) {
                exam.remove(at: pos) //remove elmnt
            }
        }
        else {
            sender.setImage(CheckBox, for: UIControlState.normal)
            exam.append(title)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let def = "nil"
        if segue.identifier == "dest", let myVC = segue.destination as? SecondViewController {
            myVC.temp = json(name: name.text!, age: age.text!, LKW: formatDate(arg: LKW.date), amb: formatDate(arg: Date()), exam: exam.joined(separator: ", "), meds: def, token: FirstViewController.secret!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
