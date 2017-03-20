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
    
    let defaults = UserDefaults.standard
    func saveProf(){ //保存する
        defaults.set(profArray, forKey: "myProf")
        defaults.synchronize()
    }
    func readProf() -> Array<Any>{ //読み込む
        let theProf: Array<Any> = defaults.object(forKey: "myProf") as! Array<Any>
        return theProf
    }
    
    var name: String = ""
    var gender: String = "0" // 0は男、1は女
    var oya: Int = 0 // 0は子供、1は親　make room押したら1になる
    var profArray: Array<Any> = [0,0,0]

    
    func getProfile(deligate: GetProfileDeligate) -> Array<Any>{
        self.deligate = deligate
//        return name
        return profArray

    }

}
