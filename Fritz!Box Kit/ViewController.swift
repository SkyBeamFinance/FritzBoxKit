//
//  ViewController.swift
//  Fritz!Box Kit
//
//  Created by Roman Gille on 25.12.17.
//  Copyright © 2017 Roman Gille. All rights reserved.
//

import UIKit
import AEXML

class ViewController: UITableViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var manager: FritzBox!
    var devices: [Device] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = FritzBox(
            host: "https://.myfritz.net:46048",
            user: "",
            password: ""
        )
        
        manager.login { [weak self] (info, error) in
            if let error = error {
                print("Error: \(error)")
            }
            else {
                print("Info: \(String(describing: info))")
                self?.loadDevices()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDevices() {
        manager.getDevices(completion: { [weak self] (devices, deviceError) in
            if let error = deviceError {
                print("Device Error: \(error)")
            }
            else {
                self?.devices = devices
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let device = devices[indexPath.row]
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "deviceCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "deviceCell")
        }
        
        cell.textLabel?.text = device.displayName
        cell.detailTextLabel?.text = device.identifier
        
        return cell
    }

}

