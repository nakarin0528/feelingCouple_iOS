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
    
    @IBOutlet var advertiseBtn: UIButton!
    var peripheralManager: CBPeripheralManager!
    var peripheral:CBPeripheralManagerDelegate!
    var characteristic: CBMutableCharacteristic!
    
    let serviceUUID = CBUUID(string: "0000")
    
    
    let roomUUID="A001"
    let personalUUID="A002"
    
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
        let characteristicUUID = CBUUID(string: "0001")
        
        let properties: CBCharacteristicProperties = [.read, .write]
        
        let permissions: CBAttributePermissions = [.readable, .writeable]
        
        characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions)
        
        // キャラクタリスティックをサービスにセット
        service.characteristics = [characteristic]
        
        // サービスを Peripheral Manager にセット
        peripheralManager.add(service)
        
        // 値をセット
        let value = UInt8(arc4random() & 0xFF)
        let data = Data(bytes: UnsafePointer<UInt8>([value]), count: 1)
        characteristic.value = data;
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
        if request.characteristic.uuid.isEqual(characteristic.uuid) {
            
            // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
            request.value = characteristic.value;
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
    }
    
    // Writeリクエスト受信時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(requests.count) 件のWriteリクエストを受信！")
        
        for request in requests {
            print("Requested value:\(request.value) service uuid:\(request.characteristic.service.uuid) characteristic uuid:\(request.characteristic.uuid)")
            
            if request.characteristic.uuid.isEqual(characteristic.uuid)
            {
                // CBMutableCharacteristicのvalueに、CBATTRequestのvalueをセット
                characteristic.value = request.value;
            }
        }
        
        // リクエストに応答
        peripheralManager.respond(to: requests[0] , withResult: CBATTError.Code.success)
    }
    
    
    // アドバタイズ開始処理が完了すると呼ばれる
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if let error = error {
            print("アドバタイズ開始失敗！ error: \(error)")
            return
        }
        print("アドバタイズ開始成功！")
    }
    
    
    func advertise() {
        if !peripheralManager.isAdvertising {
            startAdvertise()
        } else {
            stopAdvertise()
        }
    }
}
