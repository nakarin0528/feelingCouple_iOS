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
    var readCharacteristic: CBMutableCharacteristic!
    var writeCharacteristic: CBMutableCharacteristic!
    
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
        let readUUID = CBUUID(string: "A001")
        let writeUUID = CBUUID(string: "A002")
        
        let readProperties: CBCharacteristicProperties = [.read]
        let writeProperties: CBCharacteristicProperties = [.write]
        
        let readPermissions: CBAttributePermissions = [.readable]
        let writePermissions: CBAttributePermissions = [.writeable]

        
        readCharacteristic = CBMutableCharacteristic(
            type: readUUID,
            properties: readProperties,
            value: nil,
            permissions: readPermissions)
        
        writeCharacteristic = CBMutableCharacteristic(
            type: writeUUID,
            properties: writeProperties,
            value: nil,
            permissions: writePermissions)
        
        // キャラクタリスティックをサービスにセット
        service.characteristics = [readCharacteristic, writeCharacteristic]
        
        // サービスを Peripheral Manager にセット
        peripheralManager.add(service)
        
        // 値をセット
        let value = UInt8(arc4random() & 0xFF)
        let data = Data(bytes: UnsafePointer<UInt8>([value]), count: 1)
        readCharacteristic.value = data;
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
        if request.characteristic.uuid.isEqual(readCharacteristic.uuid) {
            
            // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
            request.value = readCharacteristic.value;
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: CBATTError.Code.success)
        }
    }
    
    // Writeリクエスト受信時に呼ばれる
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(requests.count) 件のWriteリクエストを受信！")
        
        for request in requests {
            print("Requested value:\(request.value) service uuid:\(request.characteristic.service.uuid) characteristic uuid:\(request.characteristic.uuid)")
            
            if request.characteristic.uuid.isEqual(writeCharacteristic.uuid)
            {
                // CBMutableCharacteristicのvalueに、CBATTRequestのvalueをセット
                writeCharacteristic.value = request.value;
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
