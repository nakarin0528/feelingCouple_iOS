//
//  FirstViewController.swift
//  TabbedFC
//
//  Created by 永田駿平 on 2017/03/05.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit
import SCLAlertView

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
            userName.text = myName
        }
        
    }

    @IBAction func makeRoom(_ sender: Any) {
        //プロフィール未設定の場合にアラートを表示し、入力画面に遷移させる
        if profile.name == "プロフィールを入力してください" || profile.name == "" {
            let profAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            profAlert.addButton("入力画面へ") {
                //ここに画面遷移を実装
                let storyboard: UIStoryboard = self.storyboard!
                let profView = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
                self.present(profView, animated: true, completion: nil)
            }
            profAlert.showEdit("プロフィール未設定", subTitle: "名前と性別を設定してください") // Edit
        } else {
            self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "pno") as! PartisipantsNoViewController, animated: true)
        }
    }
    
    @IBAction func joinRoom(_ sender: Any) {
        if profile.name == "プロフィールを入力してください" || profile.name == "" {
            let profAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            profAlert.addButton("入力画面へ") {
                //ここに画面遷移を実装
                let storyboard: UIStoryboard = self.storyboard!
                let profView = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
                self.present(profView, animated: true, completion: nil)
            }
            profAlert.showEdit("プロフィール未設定", subTitle: "名前と性別を設定してください") // Edit
        } else {
            self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "asearch") as! AroundSerchViewController, animated: true)
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

