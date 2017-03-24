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
    var targetData = [[String]]()
    var resultArray = [[String]]()
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
    func setPersonalTarget(value: [String]){
        targetData.append(value)
        print("受け取ったデータ")
        print(targetData)
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
    
    func matching(targetData: [[String]]) -> [[String]]{
        var mTarget = [String](repeating: "0", count: males.count) //男の人が何番の女の人を選んでるか
        var fTarget = [String](repeating: "0", count: females.count)
        var numberOfCouple = 0 //成立したカップル数
        var result = [[String]]() //[[誰が,誰を選んで,カップル成立かどうか]]
        
        for i in 0...(targetData.count-1){ //mTarget,fTarget作成　名前版
            if (targetData[i][1]) == "0"{
                for j in 0...(males.count-1){
                    if targetData[i][0] == males[j]{
                        mTarget[j] = targetData[i][2]
                        break
                    }
                }
            } else {
                for j in 0...(females.count-1){
                    if targetData[i][0] == females[j]{
                        fTarget[j] = targetData[i][2]
                        break
                    }
                }
            }
        }
        
        for i in 0...(mTarget.count-1){ //result男,numberOfCouple作成
            result.append([males[i]])
            result[i].append(females[Int(mTarget[i])!])
            if Int(fTarget[Int(mTarget[i])!])!  == i{
                numberOfCouple += 1
                result[i].append("マッチング成立！")
            } else {
                result[i].append("マッチング不成立…")
            }
        }
        
        for i in 0...(fTarget.count-1){ //result女作成
            result.append([females[i]])
            result[i+males.count].append(males[Int(fTarget[i])!])
            if Int(mTarget[Int(fTarget[i])!])!  == i{
                result[i+males.count].append("マッチング成立！")
            } else {
                result[i+males.count].append("マッチング不成立…")
            }
            
        }
        return(result)
    }
}
