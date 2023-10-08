//
//  Fetch.swift
//  CodestrokeEmergency
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import UIKit

class Fetch: UIViewController {
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var info: UITextView!
    
    static let def = "nil"
    static var secret: String?
    var dict = ["token": secret, "query": def, "app": "Emer"]
    
    func modify() -> Data {
        dict.updateValue(id.text!, forKey: "query")
        return try! JSONSerialization.data(withJSONObject: dict)
    }
    
    @IBAction func send(_ sender: UIButton) {
        // create post request
        let url = URL(string: "https://docreddy.com:8443/apps/EGet")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = modify()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            DispatchQueue.main.async {
                self.info.text = String(data: data, encoding: String.Encoding.utf8)!
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

