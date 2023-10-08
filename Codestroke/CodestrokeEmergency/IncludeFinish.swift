//
//  IncludeFinish.swift
//  CodestrokeEmergency
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Los Robles. All rights reserved.
//

import UIKit

class IncludeFinish: UIViewController {
    
    @IBOutlet weak var id: UITextField!
    
    static let def = "nil"
    var info: [String: String] = [:]
    var meds: [String] = []
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: "Server's response", message: msg, preferredStyle: .alert)
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
    
    func modify() -> Data {
        info.updateValue(self.meds.joined(separator: ", "), forKey: "meds")
        return try! JSONSerialization.data(withJSONObject: info)
    }
    
    @IBAction func send(_ sender: UIButton) {
        // create post request
        let url = URL(string: "https://docreddy.com:8443/apps/ESend")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = modify()
        
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
