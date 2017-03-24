//
//  CollectViewController.swift
//  TabbedFC
//
//  Created by 宮脇瞳 on 2017/03/24.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class CollectViewController:UIViewController{
    
    
    @IBOutlet weak var alertLabel: UILabel!
    var blep = BLEP.sharedBleP
    var timer: Timer!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func update(tm: Timer){
        print("受け取るべきデータ数: \(BLEP.participantsNum-1)")
        print("受け取った人数: \(BLEP.ellectingNum)")
        if BLEP.participantsNum-1 == BLEP.ellectingNum {
            //条件が揃ったら結果画面へ遷移
            alertLabel.text = "次へを押してね！"
            //self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "result") as! ResultViewController, animated:true)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        /*
        while tmp{
            print(blep.participantsNum-1)
            print(blep.ellectingNum)
            if blep.participantsNum-1 == blep.ellectingNum {
                
                tmp=false
                //条件が揃ったら結果画面へ遷移
                self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "result") as! ResultViewController, animated:true)
                
            }
        }
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //画面切り替わった時にタイマーを止める
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
}
