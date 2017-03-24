//
//  CollectViewController.swift
//  TabbedFC
//
//  Created by 宮脇瞳 on 2017/03/24.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class CollectViewController:UIViewController{
    
    
    var blep = BLEP.sharedBleP
    var tmp = true
    
    override func viewDidLoad(){
    super.viewDidLoad()
    
        while tmp==true{
            
       if blep.participantsNum==blep.ellectingNum {
        
        tmp=false
    //条件が揃ったら結果画面へ遷移
    self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "result") as! ResultViewController, animated:true)
        
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
