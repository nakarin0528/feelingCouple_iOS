//
//  BLEP.swift
//  TabbedFC
//
//  Created by 宮脇瞳 on 2017/03/13.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEP: NSObject, CBPeripheralManagerDelegate {
    
    var data = OrganizingData.sharedData
    var profile = Profile.sharedProfile
    
    @IBOutlet var advertiseBtn: UIButton!
    var peripheralManager: CBPeripheralManager!
    var peripheral:CBPeripheralManagerDelegate!
    var manCharacteristic: CBMutableCharacteristic!
    var womanCharacteristic: CBMutableCharacteristic!
    var writeCharacteristic: CBMutableCharacteristic!
    var getSelectDataCharacteristic: CBMutableCharacteristic!
    var malesNumCharacteristic: CBMutableCharacteristic!
    var femalesNumCharacteristic: CBMutableCharacteristic!
    
    //参加人数
    var malesNum = 0
    var femalesNum = 0
    var participantsNum = 0
    var personal: [String] = []
    var names: [String] = []
    var personalSelectData: [String] = []
    
    var malesCount = 0
    var femalesCount = 0
    //受け取り回数
    var count = 0
    var count2 = 0
    //データ受信数
    var datasNum = 0
    
    let serviceUUID = CBUUID(string: "A000")
    
    
    
    static let sharedBleP = BLEP()
    
    private override init(){
        super.init()
        initBleP()
    }
    
    private func initBleP(){
        // ペリフェラルマネージャ初期化
        peripheralManager = CBPeripheralManager(
            delegate: self,
            queue: nil,
            options: nil)
    }
    
    
    func publishservice () {
        // サービスを作成
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // キャラクタリスティックを作成
        let manUUID = CBUUID(string: "A001")
        let womanUUID = CBUUID(string: "A002")
        let writeUUID = CBUUID(string: "A003")
        let getSelectDataUUID = CBUUID(string: "A004")
        let malesNumUUID = CBUUID(string: "A005")
        let femalesNumUUID = CBUUID(string: "A006")
        
        let manReadProperties: CBCharacteristicProperties = [.read]
        let womanReadProperties: CBCharacteristicProperties = [.read]
        let writeProperties: CBCharacteristicProperties = [.write]
        let getSelectDataProperties: CBCharacteristicProperties = [.write]
        let malesNumProperties: CBCharacteristicProperties = [.read]
        let femalesNumProperties: CBCharacteristicProperties = [.read]
        
        let manReadPermissions: CBAttributePermissions = [.readable]
        let womanReadPermissions: CBAttributePermissions = [.readable]
        let writePermissions: CBAttributePermissions = [.writeable]
        let getSelectDataPermissions: CBAttributePermissions = [.writeable]
        let malesNumPermissions: CBAttributePermissions = [.readable]
        let femalesNumPermissions: CBAttributePermissions = [.readable]
        
        manCharacteristic = CBMutableCharacteristic(
            type: manUUID,
            properties: manReadProperties,
            value: nil,
            permissions: manReadPermissions)
        
        womanCharacteristic = CBMutableCharacteristic(
            type: womanUUID,
            properties: womanReadProperties,
            value: nil,
            permissions: womanReadPermissions)
        
        writeCharacteristic = CBMutableCharacteristic(
            type: writeUUID,
            properties: writeProperties,
            value: nil,
            permissions: writePermissions)
        
        getSelectDataCharacteristic = CBMutableCharacteristic(
            type: getSelectDataUUID,
            properties: getSelectDataProperties,
            value: nil,
            permissions: getSelectDataPermissions)
        
        malesNumCharacteristic = CBMutableCharacteristic(
            type: malesNumUUID,
            properties: malesNumProperties,
            value: nil,
            permissions: malesNumPermissions)

        femalesNumCharacteristic = CBMutableCharacteristic(
            type: femalesNumUUID,
            properties: femalesNumProperties,
            value: nil,
            permissions: femalesNumPermissions)
        
        // キャラクタリスティックをサービスにセット
        service.characteristics = [manCharacteristic, womanCharacteristic, writeCharacteristic, getSelectDataCharacteristic, malesNumCharacteristic, femalesNumCharacteristic]
        
        // サービスを Peripheral Manager にセット
        peripheralManager.add(service)

    }
    
    func startAdvertise() {
        // アドバタイズメントデータを作成する
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: profile.name+"'s Room",
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
            ] as [String : Any]
        
        // アドバタイズ開始
        peripheralManager.startAdvertising(advertisementData)
    }
    
    private func stopAdvertise () {
        // アドバタイズ停止
        peripheralManager.stopAdvertising()
        
    }
    
    
    // ペリフェラルマネージャの状態が変化すると呼ばれる
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
        //これっていうのがCBPeripheralManagerDelegateに@required指定されているので必須

        switch peripheral.state {
        case .poweredOn:
            // サービス登録開始
            publishservice()
        default:
            break
        }    }
    
    // サービス追加処理が完了すると呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("サービス追加失敗！ error: \(error)")
            return
        }
        print("サービス追加成功！")
        
        // アドバタイズ開始
        //startAdvertise()
    }
    
    // アドバタイズ開始処理が完了すると呼ばれる
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("アドバタイズ開始失敗！ error: \(error)")
            return
        }
        print("アドバタイズ開始成功！")
    }
    
    
    // Readリクエスト受信時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Readリクエスト受信！ requested service uuid:\(request.characteristic.service.uuid) characteristic uuid:\(request.characteristic.uuid) value:\(request.characteristic.value)")
        
        //女に男の人数を送る
        if request.characteristic.uuid.isEqual(malesNumCharacteristic.uuid){
            let num = String(malesNum)
            let value = num.data(using:String.Encoding.utf8)
            malesNumCharacteristic.value = value
            request.value = malesNumCharacteristic.value
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
        
        //男に女の人数を送る
        if request.characteristic.uuid.isEqual(femalesNumCharacteristic.uuid){
            let num = String(femalesNum)
            let value = num.data(using:String.Encoding.utf8)
            femalesNumCharacteristic.value = value
            request.value = femalesNumCharacteristic.value
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
        
        // 男に送信
        if request.characteristic.uuid.isEqual(manCharacteristic.uuid) {
            
            
            // 値をセット
            let value = data.females[femalesCount].data(using:String.Encoding.utf8)
            manCharacteristic.value = value
            request.value = manCharacteristic.value
            
            if femalesCount == data.females.count-1{
                femalesCount = 0
            } else {
                femalesCount = femalesCount + 1
            }
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
        
        // 女に送信
        if request.characteristic.uuid.isEqual(womanCharacteristic.uuid) {
            
            // 値をセット
            let value = data.males[malesCount].data(using:String.Encoding.utf8)
            womanCharacteristic.value = value
            request.value = womanCharacteristic.value
            
            if malesCount == data.males.count-1{
                malesCount = 0
            } else {
                malesCount = malesCount + 1
            }
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
    }
    
    // Writeリクエスト受信時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(requests.count) 件のWriteリクエストを受信！")
        
        
        for request in requests {
            print("Requested value:\(request.value) service uuid:\(request.characteristic.service.uuid) characteristic uuid:\(request.characteristic.uuid)")
            //プロフィール書き込み
            if request.characteristic.uuid.isEqual(writeCharacteristic.uuid){
                // CBMutableCharacteristicのvalueに、CBATTRequestのvalueをセット
                writeCharacteristic.value = request.value;
                
                let text = NSString(data: request.value!, encoding: String.Encoding.utf8.rawValue)
                print(text!)
                personal.append(text! as String)
                
                if count <= 1 {
                    if count == 1 {
                        //データを処理するクラスに渡す
                        data.setPersonalData(value: personal)
                        personal.removeAll()
                        count = 0
                    } else {
                        names.append(text! as String)
                        count = count + 1
                    }
                }
            }
            //セレクトデータ書き込み
            if request.characteristic.uuid.isEqual(getSelectDataCharacteristic.uuid){
                // CBMutableCharacteristicのvalueに、CBATTRequestのvalueをセット
                getSelectDataCharacteristic.value = request.value;
                
                let text = NSString(data: request.value!, encoding: String.Encoding.utf8.rawValue)
                print(text!)
                
                if count <= 2 {
                    if count == 2 {
                        //データを処理するクラスに渡す
                        personalSelectData.append(text! as String)
                        data.setPersonalTarget(value: personalSelectData)
                        personalSelectData.removeAll()
                        count = 0
                    }else{
                        personalSelectData.append(text! as String)
                        count += 1
                    }
                }
            }
        }
        // リクエストに応答
        peripheralManager.respond(to: requests[0] , withResult: CBATTError.Code.success)
    }
    
    func sendMan(){
        
    }
    
    func advertise() {
        if !peripheralManager.isAdvertising {
            startAdvertise()
        } else {
            stopAdvertise()
        }
    }
}
