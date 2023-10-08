//
//  IncludeFinish.swift
//  CodestrokeNuerology
//
//  Created by XCodeClub on 9/8/17.
//  Copyright © 2017 Kaditam V. Reddy, MD, Inc. All rights reserved.
//

import UIKit

class IncludeFinish: UIViewController {
    
    
    @IBOutlet weak var tPA: UIButton!
    @IBOutlet weak var IR: UIButton!
   
    var info: [String: String] = [:]
    var meds: [String] = []
    
    func formatDay(arg: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm:ss"
        let strDate = dateFormatter.string(from: arg)
        return strDate
    }
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
    
    @IBAction func modify(_ sender: UIButton) {
        let SwitchOn = UIImage(named: "SwitchOn")
        let SwitchOff = UIImage(named: "SwitchOff")
        let on = "Yes, " + formatDay(arg: Date())
        let off = "No"
        let title = sender.currentTitle!
        
        if (sender.currentImage?.isEqual(SwitchOn))! {
            sender.setImage(SwitchOff, for: UIControlState.normal)
            
            if title.isEqual("tPA") {
                info.updateValue(off, forKey: "tpa")
            }
            else {
                info.updateValue(off, forKey: "ir")
            }
        }
        else {
            sender.setImage(SwitchOn, for: UIControlState.normal)
            
            if title.isEqual("tPA") {
                info.updateValue(on, forKey: "tpa")
            }
            else {
                info.updateValue(on , forKey: "ir")
            }
        }
    }
    
    func formatAllData() -> Data {
        info.updateValue(self.meds.joined(separator: ", "), forKey: "meds")
        return try! JSONSerialization.data(withJSONObject: info)
    }
    
    @IBAction func send(_ sender: UIButton) {
        // create post request
        let url = URL(string: "https://docreddy.com:8443/apps/ESend")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = formatAllData()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.showAlert(msg: (error?.localizedDescription)!)
                }
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
