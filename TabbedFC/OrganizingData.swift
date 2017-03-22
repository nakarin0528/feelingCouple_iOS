//
//  OrganizingData.swift
//  TabbedFC
//
//  Created by 永田駿平 on 2017/03/20.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import Foundation

class OrganizingData: NSObject{
    
    var myprofile = Profile.sharedProfile
    
    var participants = [[String]]()
    var males: [String] = []
    var females: [String] = []
    
    static let sharedData = OrganizingData()
    
    
    private override init(){
        super.init()
    }
    
    func setPersonalData(value: [String]) {

        participants.append(value)
        print("受けとったデータ")
        print(participants)
    }

    func separateByGender() {
        //まず自分のデータを追加
        if myprofile.gender == "0" {
            males.append(myprofile.name)
        } else {
            females.append(myprofile.name)
        }
        //取得したリストを男女別に仕分け
        for i in 0..<participants.count {
            if (participants[i][1] ) == "0" {
                males.append(participants[i][0])
            } else {
                females.append(participants[i][0])
            }
        }
        print("男性"+"\(males)")
        print("女性"+"\(females)")
    }
}
