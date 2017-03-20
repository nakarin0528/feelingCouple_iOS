//
//  FirstViewController.swift
//  TabbedFC
//
//  Created by 永田駿平 on 2017/03/05.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, GetProfileDeligate {
    var profile = Profile.sharedProfile
    
    @IBOutlet weak var userName: UILabel!
    
    var myName: String = ""
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getProfile()
        if myName != "" {
            userName.text = myName + "　の"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getProfile() {
        myName = profile.name
    }
    
}

