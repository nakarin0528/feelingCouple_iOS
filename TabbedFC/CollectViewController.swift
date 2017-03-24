//
//  CollectViewController.swift
//  TabbedFC
//
//  Created by 宮脇瞳 on 2017/03/24.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class CollectViewController:UIViewController{
    
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    var blep = BLEP.sharedBleP
    var timer: Timer!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        resultButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func update(tm: Timer){

        if blep.malesNum+blep.femalesNum+1 == BLEP.ellectingNum {
            //条件が揃ったら結果画面へ遷移
            alertLabel.text = "結果を押してね!"
            resultButton.isHidden = false
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
