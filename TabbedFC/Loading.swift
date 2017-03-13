//
//  Loading.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/13.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

struct Loading{
    
    static var myActivityIndicator: UIActivityIndicatorView!
    
    static func set(_ v:UIViewController){
        self.myActivityIndicator = UIActivityIndicatorView()
        self.myActivityIndicator.frame = CGRect(x:0, y:0, width:80, height:80)
        self.myActivityIndicator.center = v.view.center
        self.myActivityIndicator.hidesWhenStopped = false
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.myActivityIndicator.backgroundColor = UIColor.gray
        self.myActivityIndicator.layer.masksToBounds = true
        self.myActivityIndicator.layer.cornerRadius = 5.0
        self.myActivityIndicator.layer.opacity = 0.8
        v.view.addSubview(self.myActivityIndicator);
        
        self.off();
    }
    static func on(){
        myActivityIndicator.startAnimating();
        myActivityIndicator.isHidden = false;
    }
    static func off(){
        myActivityIndicator.stopAnimating();
        myActivityIndicator.isHidden = true;
        
    }
    
}
