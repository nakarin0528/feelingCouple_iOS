//
//  WaitingAroundViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/13.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class WaitingAroundViewController: BaseViewController {

    var ble = BLE.sharedBle
    var profile = Profile.sharedProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startButton(_ sender: Any) {
        if profile.gender == "0" {
            ble.manRead()
        } else {
            ble.womanRead()
        }
    }
    


}
