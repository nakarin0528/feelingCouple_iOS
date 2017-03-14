//
//  Profile.swift
//  TabbedFC
//
//  Created by 竹内将大 on 2017/03/07.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import Foundation

class Profile: NSObject{
    var deligate: GetProfileDeligate?
    static let sharedProfile = Profile()
    private override init(){
        super.init()
        initProfile()
    }
    
    private func initProfile(){
        
    }
    
    var  name: String = ""
    var gender: Int = 0 // 0は男、1は女
    var oya: Int = 0 // 0は子供、1は親　make room押したら1になる
    var profArray: Array<Any> = []
    
    func getProfile(deligate: GetProfileDeligate) -> String{
        self.deligate = deligate
        return name
    }

}
