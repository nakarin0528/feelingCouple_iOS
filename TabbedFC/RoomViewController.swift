//
//  RoomViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/18.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    
    var ble = BLEP.sharedBleP
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        /*
         プロフィール未入力時にアラートを出してプロフィール入力画面にとばす．
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
