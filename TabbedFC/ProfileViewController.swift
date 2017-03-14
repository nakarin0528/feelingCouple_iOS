//
//  ProfileViewController.swift
//  TabbedFC
//
//  Created by 竹内将大 on 2017/03/07.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    var profile = Profile.sharedProfile
    var gender: Int = 0 // 0は男、1は女
    var oya: Int = 0 // 0は子供、1は親　makeroom押したら1になる
    var profArray: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else{
            return
        }
        if identifier == "start"{
            let FVC = segue.destination as! FirstViewController
            FVC.myName = self.nameText.text!
        }
    }
    
//    override func touchBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//        if(self.nameText.isFirstResponder){
//            self.nameText.resignFirstResponder()
//        }
//    }
    
    @IBAction func genderSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            gender = 0
        default:
            gender = 1
        }
    }
   
    @IBAction func finishButton(_ sender: Any) {
        profile.name = nameText.text!
        profArray = [profile.name, gender, oya]
//        print(profArray[0])
//        print(profArray[1])
//        print(profArray[2])
    }

    }
