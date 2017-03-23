//
//  LaunchAnimationViewController.swift
//  TabbedFC
//
//  Created by 永田駿平 on 2017/03/23.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class LaunchAnimationViewController: UIViewController {

    @IBOutlet weak var launchheart: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                                   delay: 1.0,
             
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.launchheart.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                                   delay: 1.3,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.launchheart.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.launchheart.alpha = 0
        }, completion: { (Bool) in
            self.launchheart.removeFromSuperview()
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(nextView, animated: false, completion: nil)
        }
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
