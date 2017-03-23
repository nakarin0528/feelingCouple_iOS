//
//  BLE.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/13.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLE: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    var profile = Profile.sharedProfile
    var isScanning = false
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var manReadCharacteristic: CBCharacteristic!
    var womanReadCharacteristic: CBCharacteristic!
    var selectDataCharacteristic: CBCharacteristic!
//    var malesNumCharacteristic: CBCharacteristic!
//    var femalesNumCharacteristic: CBCharacteristic!
    var myPeripheral: [CBPeripheral] = []
    var peripheralList: [String] = []
    static var flag = false
    static var isCorrectDevice = false
    static var isError = false
    var isFirst = true
    
    //異性の数
    var malesNum = 0
    var femalesNum = 0
    var willPartner: [String] = []
    var selectedNum = 0
    
    let manUUID = "A001"
    let womanUUID = "A002"
    let writeUUID = "A003"
    let selectDataUUID = "A004"
//    let malesNumUUID = "A004"
//    let femalesNumUUID = "A005"
    
    static let sharedBle = BLE()
    var peripheralDelegate: GetPeripheralDelegate?
    
    private override init(){
        super.init()
        initBle()
    }
    
    private func initBle(){

        BLE.flag = false
        BLE.isCorrectDevice = false
        isScanning = false
        isFirst = true
        myPeripheral.removeAll()
        if self.peripheral != nil {

            centralManager.connect(self.peripheral, options: nil)
        } else {
            //セントラルマネージャ初期化
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    //セントラルマネージャの状態
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")

        if central.state == CBManagerState.poweredOn{
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    //scan結果
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("発見したBLEデバイス: \(peripheral)")
        //発見したデバイスを配列に追加
        myPeripheral.append(peripheral)
        //同じものを削除
        let orderedSet = NSOrderedSet(array: myPeripheral)
        //元の配列を更新
        myPeripheral = orderedSet.array as! [CBPeripheral]
        
        peripheralList.removeAll()
        for i in 0..<myPeripheral.count{
            if myPeripheral[i].name != nil {
                peripheralList.append(myPeripheral[i].name!)
            } else {
                peripheralList.append("no name")
            }
        }
        print(myPeripheral)
        print("nameList")
        print(peripheralList)
        BLE.flag = false
    }
    
    public func getPeripheral(delegate: GetPeripheralDelegate) -> [String] {
        
        self.peripheralDelegate = delegate
        
        return peripheralList
        
    }
    
    //指定されたデバイスに接続
    func setNewPeripheral(_ num: Int) {
        print("選択された")
        if myPeripheral[num].name == nil {
            differentPeripheral()
            BLE.flag = true
        } else {
            self.peripheral = myPeripheral[num]
            centralManager.connect(myPeripheral[num], options: nil)
        }
    }
    
    //ペリフェラルへの接続が成功すると呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続成功！")
        print(centralManager.state)
        //デリゲートをセット
        peripheral.delegate = self
        //サービス探索開始
        peripheral.discoverServices([CBUUID(string: "A000")])    //サービスID
    }
    
    //ペリフェラルへの接続が失敗すると呼ばれる
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        differentPeripheral()
        BLE.isError = true
        print("接続失敗・・・")
    }
    
    //サービス発見時
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("エラー: \(error)")
            differentPeripheral()
            return
        }
        
        guard let services = peripheral.services, services.count > 0 else {
            print("no services")
            differentPeripheral()
            //違うのに接続した
            return
        }
        print("\(services.count) 個のサービスを発見！ \(services)")
        
        for service in services {
            //キャラクタリスティック探索開始
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    //キャラクタリスティック発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?){
        if let error = error {
            print("エラー: \(error)")
            differentPeripheral()
            //違うのに接続した
            return
        }
        
        guard let characteristics = service.characteristics, characteristics.count > 0 else {
            print("no characteristics")
            differentPeripheral()
            //違うのに接続した
            return
        }
        
        print("\(characteristics.count) 個のキャラクタリスティックを発見！ \(characteristics)")
        
        for characteristic in characteristics {
            //男のReadプロパティを持つのキャラクタリスティックの値を読み出す
            if characteristic.uuid.isEqual(CBUUID(string: manUUID)){
                manReadCharacteristic = characteristic
            }
            //女のReadプロパティを持つのキャラクタリスティックの値を読み出す
            if characteristic.uuid.isEqual(CBUUID(string: womanUUID)){
                womanReadCharacteristic = characteristic
            }
            //プロフィールを書き込めるキャラクタリスティック
            if characteristic.uuid.isEqual(CBUUID(string: writeUUID)) {
                writeCharacteristic = characteristic
                if isFirst {
                    sendProfile()
                    isFirst = false
                }
            }
            //セレクトデータを書き込めるキャラクタリスティック
            if characteristic.uuid.isEqual(CBUUID(string: selectDataUUID)){
                selectDataCharacteristic = characteristic
            }
//            //男の人数を得るキャラクタリスティック
//            if characteristic.uuid.isEqual(CBUUID(string: malesNumUUID)){
//                malesNumCharacteristic = characteristic
//            }
//            //女の人数を得るキャラクタリスティック
//            if characteristic.uuid.isEqual(CBUUID(string: femalesNumUUID)){
//                femalesNumCharacteristic = characteristic
//            }
        }
            centralManager.stopScan()

    }
    
    //データ読み出しが完了すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if let error = error {
            print("読み出し失敗...error: \(error), characteristic uuid: \(characteristic.uuid)")
            return
        }
        
        print("読み出し成功！service uuid: \(characteristic.service.uuid), characteristic uuid: \(characteristic.uuid), value: \(characteristic.value)")
        //欲しいキャラクタリスティックかどうかを判定
        if characteristic.uuid.isEqual(CBUUID(string: manUUID)){
            let text = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            willPartner.append(text! as String)
            print(text!)
        }
        if characteristic.uuid.isEqual(CBUUID(string: womanUUID)){
            let text = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            willPartner.append(text! as String)
            print(text!)

        }
//        if characteristic.uuid.isEqual(CBUUID(string: malesNumUUID)){
//            let text = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
//            willPartnerNum = Int(text as! String)!
//            print("相手候補\(willPartner)+1人")
//            womanRead()
//        }
//        if characteristic.uuid.isEqual(CBUUID(string: femalesNumUUID)){
//            let text = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
//            willPartnerNum = Int(text as! String)!
//            print("相手候補\(willPartner)+1人")
//            manRead()
//        }
    }
    
    
    //データ書き込み成功時
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("書き込み失敗...error: \(error), characteristic uuid: \(characteristic.uuid)")
            return
        }
    }
    
    //プロフィールを送る関数
    public func sendProfile(){
        
        let namtmp = Profile.sharedProfile.name.data(using:String.Encoding.utf8)
        let gentmp = Profile.sharedProfile.gender.data(using:String.Encoding.utf8)
        
        if self.peripheral.state.rawValue == 0 {
            initBle()
        }
    
        do{
            try peripheral.writeValue(namtmp! as Data, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
            
            try peripheral.writeValue(gentmp! as Data, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
            //一旦接続を切る
            //centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManager.stopScan()
        }catch{
            initBle()
        }
    }
    
//    //男の人数をゲット
//    public func readMalesNum(){
//        centralManager.connect(peripheral, options: nil)
//        do{
//            peripheral.readValue(for: malesNumCharacteristic)
//            
//        }catch{
//            initBle()
//        }
//    }
//    
//    //女の人数をゲット
//    public func readFemalesNum(){
//        centralManager.connect(peripheral, options: nil)
//        do{
//            peripheral.readValue(for: femalesNumCharacteristic)
//            
//        }catch{
//            initBle()
//        }
//    }

    //男が読み取る
    public func manRead(){
        centralManager.connect(peripheral, options: nil)

        for i in 0...femalesNum {
            do{
                peripheral.readValue(for: manReadCharacteristic)
            }catch{
                initBle()
            }
        }
        //一旦接続を切る
        //centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.stopScan()
    }
    
    //女が読み取る
    public func womanRead(){
        centralManager.connect(peripheral, options: nil)

        for i in 0...malesNum {
            do{
                peripheral.readValue(for: womanReadCharacteristic)
            }catch{
                initBle()
            }
        }
        //centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.stopScan()
    }
    
    //相手をセレクト
    public func sendSelectData(){
        centralManager.connect(peripheral, options: nil)
        
        let namtmp = Profile.sharedProfile.name.data(using:String.Encoding.utf8)
        let gentmp = Profile.sharedProfile.gender.data(using:String.Encoding.utf8)
        let num = String(selectedNum).data(using: String.Encoding.utf8)
        if self.peripheral.state.rawValue == 0 {
            initBle()
        }
        
        do{
            try peripheral.writeValue(namtmp! as Data, for: selectDataCharacteristic, type: CBCharacteristicWriteType.withResponse)
            
            try peripheral.writeValue(gentmp! as Data, for: selectDataCharacteristic, type: CBCharacteristicWriteType.withResponse)
            
            try peripheral.writeValue(num! as Data, for: selectDataCharacteristic, type: CBCharacteristicWriteType.withResponse)
            //一旦接続を切る
            //centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManager.stopScan()
        }catch{
            initBle()
        }
    }
    
    func differentPeripheral(){
        BLE.isCorrectDevice = false
        centralManager.stopScan()
        }
    
    
}

