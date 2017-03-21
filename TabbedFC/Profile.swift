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
    var name: String = ""
    var gender: String = "0" // 0は男、1は女
    var profArray: Array<String> = []
    let defaults = UserDefaults.standard
    static let sharedProfile = Profile()
    
    
    private override init(){
        super.init()
        initProfile()
    }
    

    
    private func initProfile(){
        defaults.register(defaults: ["myProf": ["プロフィールを入力してください", "0"]])
        profArray = readProf()
        name = profArray[0]
        gender = profArray[1]
    }
    
    
    func saveProf(){ //保存する
        defaults.set(profArray, forKey: "myProf")
        defaults.synchronize()
    }
    func readProf() -> [String]{ //読み込む
        let theProf = defaults.object(forKey: "myProf")
        // print(defaults.object(forKey: "myProf"))
        // print(theProf)
        return theProf as! [String]
    }
    
    func getProfile(deligate: GetProfileDeligate) -> Array<Any>{
        self.deligate = deligate
//        return name
        return profArray

    }

}
