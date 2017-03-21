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
    
    @IBOutlet var advertiseBtn: UIButton!
    var peripheralManager: CBPeripheralManager!
    var peripheral:CBPeripheralManagerDelegate!
    var manCharacteristic: CBMutableCharacteristic!
    var womanCharacteristic: CBMutableCharacteristic!
    var writeCharacteristic: CBMutableCharacteristic!
    var personal: [Any] = []
    var names: [String] = []
    //受け取り回数
    var count = 0
    
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
        
        let manReadProperties: CBCharacteristicProperties = [.read]
        let womanReadProperties: CBCharacteristicProperties = [.read]
        let writeProperties: CBCharacteristicProperties = [.write]
        
        let manReadPermissions: CBAttributePermissions = [.readable]
        let womanReadPermissions: CBAttributePermissions = [.readable]
        let writePermissions: CBAttributePermissions = [.writeable]

        
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
        
        // キャラクタリスティックをサービスにセット
        service.characteristics = [manCharacteristic, womanCharacteristic, writeCharacteristic]
        
        // サービスを Peripheral Manager にセット
        peripheralManager.add(service)
        
        // 値をセット
        let value = UInt8(arc4random() & 0xFF)
        let data = Data(bytes: UnsafePointer<UInt8>([value]), count: 1)
        manCharacteristic.value = data;

    }
    
    private func startAdvertise() {
        // アドバタイズメントデータを作成する
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: "Test Device",
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
        startAdvertise()
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
        
        // プロパティで保持しているキャラクタリスティックへのReadリクエストかどうかを判定
        if request.characteristic.uuid.isEqual(manCharacteristic.uuid) {
            
            // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
            request.value = manCharacteristic.value;
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
        // プロパティで保持しているキャラクタリスティックへのReadリクエストかどうかを判定
        if request.characteristic.uuid.isEqual(womanCharacteristic.uuid) {
            
            // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
            request.value = womanCharacteristic.value;
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
    }
    
    // Writeリクエスト受信時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(requests.count) 件のWriteリクエストを受信！")
        
        
        for request in requests {
            print("Requested value:\(request.value) service uuid:\(request.characteristic.service.uuid) characteristic uuid:\(request.characteristic.uuid)")
        
            if request.characteristic.uuid.isEqual(writeCharacteristic.uuid){
                // CBMutableCharacteristicのvalueに、CBATTRequestのvalueをセット
                writeCharacteristic.value = request.value;
                
                let text = NSString(data: request.value!, encoding: String.Encoding.utf8.rawValue)
                print(text!)
                personal.append(text!)
                
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
        }
        // リクエストに応答
        peripheralManager.respond(to: requests[0] , withResult: CBATTError.Code.success)
    }
    
    func advertise() {
        if !peripheralManager.isAdvertising {
            startAdvertise()
        } else {
            stopAdvertise()
        }
    }
}
