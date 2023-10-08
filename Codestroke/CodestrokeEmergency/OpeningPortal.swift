//
//  OpeningPortal.swift
//  CodestrokeAmbulance
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

//
//  FIrstScreen.swift
//  CodestrokeAmbulance
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import Foundation
import UIKit

class OpeningPortal:UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: "Server's response", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func logout() {
        let site = URL(string: "https://docreddy.com:8443/apps/Login")
        var req = URLRequest(url: site!)
        req.httpMethod = "POST"
        let postStr = "func=logout&app=Emer"
        req.httpBody = postStr.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("error=\(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.showAlert(msg: String(data: data!, encoding: String.Encoding.utf8)!)
            }
        }
        task.resume()
        
        //clear username and password fields
        username.text = ""
        password.text = ""
    }
    
    @IBAction func login() {
        let cond = "token:"
        let site = URL(string: "https://docreddy.com:8443/apps/Login");
        var req = URLRequest(url: site!)
        req.httpMethod = "POST"
        let postStr = "func=login&app=Emer&user=" + username.text! + "&pass=" + password.text!
        req.httpBody = postStr.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                self.showAlert(msg: (error?.localizedDescription)!)
            }
            else  {
                DispatchQueue.main.async {
                    var store = String(data: data!, encoding: String.Encoding.utf8)!
                    let part = store.substring(to: store.index(store.startIndex, offsetBy: 6))
                    
                    if  part == cond {
                        store = store.replacingOccurrences(of: part, with: "")
                        
                        Fetch.secret = store //store CSRF token in variable
                        IncludePart.secret = store //store CSRF token in variable
                        self.performSegue(withIdentifier: "begin", sender: nil)
                    }
                    else {
                        self.showAlert(msg: store) //alert box with error msg
                    }
                }
            }
        }
        task.resume()
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

