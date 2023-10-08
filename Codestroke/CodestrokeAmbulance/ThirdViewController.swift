//
//  ThirdViewController.swift
//  CodestrokeAmbulance
//
//  Created by XCodeClub on 9/3/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import Foundation
import UIKit

class ThridViewController:UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: "Server's response", message: msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func logout() {
        let site = URL(string: "https://docreddy.com:8443/apps/Login")
        var req = URLRequest(url: site!)
        req.httpMethod = "POST"
        let postStr = "func=logout&app=Amb"
        req.httpBody = postStr.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("error=\(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.showAlert(msg: String(data: data!, encoding: String.Encoding.utf8)!)             }
        }
        task.resume()
        
        //clear username and password fields
        username.text = ""
        password.text = ""
    }
    
    @IBAction func login() {
        let warn = "Username and password didn't match"
        let site = URL(string: "https://docreddy.com:8443/apps/Login");
        var req = URLRequest(url: site!)
        req.httpMethod = "POST"
        let postStr = "func=login&app=Amb&user=" + username.text! + "&pass=" + password.text!
        req.httpBody = postStr.data(using: String.Encoding.utf8);
    
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("error=\(error)")
                return
            }
            
            DispatchQueue.main.async {
                let store = String(data: data!, encoding: String.Encoding.utf8)!

               if store == warn {
                     self.showAlert(msg: store) //alert box with error msg
               }
               else {
                    FirstViewController.secret = store //store CSRF token in variable
                    self.performSegue(withIdentifier: "begin", sender: nil)
                }
            }
        }
        task.resume()
    }
}
