//
//  OrganizingData.swift
//  TabbedFC
//
//  Created by 永田駿平 on 2017/03/20.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import Foundation

class OrganizingData: NSObject{
    
    static let sharedData = OrganizingData()
    
    private override init(){
        super.init()
    }
    
    var participants = [[Any]]()
    var males = [[Any]]()
    var females = [[Any]]()
    
    func setPersonalData(value: [Any]) {

        participants.append(value)
        print("受けとったデータ")
        print(participants)
    }

    func separateByGender() {
        for i in 0...participants.count {
            if (participants[i][1] as! Int) == 0 {
                males.append(participants[i])
            } else {
                females.append(participants[i])
            }
        }
    }
}
