//
//  BaseViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/23.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*ナビゲーションバー*/
        //background
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 0.5)
        //タイトル画像
        self.navigationItem.titleView = UIImageView(image:UIImage(named:"smallHeart.png"))
        //ボタン
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.3032694777)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
