//
//  SecondViewController.swift
//  AmbulanceCodestroke
//
//  Created by XCodeClub on 8/27/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var meds: [String] = []
    var temp: json?
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: "Server's response", message: msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func medsHandler(_ sender: UIButton) {
        let UnCheckBox = UIImage(named: "UnCheckBox")
        let CheckBox = UIImage(named: "CheckBox")
        let title = sender.currentTitle!
        
        if (sender.currentImage?.isEqual(CheckBox))! {
            sender.setImage(UnCheckBox, for: UIControlState.normal)
            if let pos = meds.index(of: title) {
                meds.remove(at: pos) //remove elmnt
            }
        }
        else {
            sender.setImage(CheckBox, for: UIControlState.normal)
            meds.append(title)
        }
    }
    
    func convert(arg: json) -> Data {
        //Transform Dictionary type
        let dict = [ "name": arg.name, "age": arg.age, "LKW": arg.LKW, "amb": arg.amb, "exam": arg.exam, "meds": arg.meds, "token": arg.token]
        return try! JSONSerialization.data(withJSONObject: dict)
    }
    
    @IBAction func send(_ sender: UIButton) {
        var info: Data?
        //convert struct to dictionary type, so json can be serialized
        if temp != nil {
            temp?.meds = meds.joined(separator: ", ")
            info = convert(arg: temp!)
        }
        
       // create post request
        let url = URL(string: "https://docreddy.com:8443/apps/EAmb")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = info
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            DispatchQueue.main.async {
                self.showAlert(msg: String(data: data, encoding: String.Encoding.utf8)!)
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

