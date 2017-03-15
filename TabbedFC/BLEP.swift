//
//  BLEP.swift
//  TabbedFC
//
//  Created by 宮脇瞳 on 2017/03/13.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEP: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet var advertiseBtn: UIButton!
    private var peripheralManager: CBPeripheralManager!
    private var peripheral:CBPeripheralManagerDelegate!
    
    
    let pointerCharacteristicUUID="A001"
    let tempCharacteristicUUID="A002"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ペリフェラルマネージャ初期化
        peripheralManager = CBPeripheralManager(
            delegate: self,
            queue: nil,
            options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // =========================================================================
    // MARK: Private
    
    private func startAdvertise() {
        // アドバタイズメントデータを作成する
        let advertisementData = [CBAdvertisementDataLocalNameKey: "Test Device"]
        
        // アドバタイズ開始
        peripheralManager.startAdvertising(advertisementData)
        
        //advertiseBtn.setTitle("STOP ADVERTISING", forState: UIControlState.normal)ここでスタートするための関数（ボタンとか）を入力
    }
    
    private func stopAdvertise () {
        // アドバタイズ停止
        peripheralManager.stopAdvertising()
        
        //advertiseBtn.setTitle("START ADVERTISING", forState: UIControlState.normal)止めるための関数ボタンとか
    }
    
    // =========================================================================
    // MARK: CBPeripheralManagerDelegate
    
    // ペリフェラルマネージャの状態が変化すると呼ばれる
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
        //これっていうのがCBPeripheralManagerDelegateに@required指定されているので必須

        switch peripheral.state {
        case .poweredOn:
        // アドバタイズ開始
            startAdvertise()
        default:
            break
        }
    }
    
    
    // アドバタイズ開始処理が完了すると呼ばれる
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if let error = error {
            print("アドバタイズ開始失敗！ error: \(error)")
            return
        }
        print("アドバタイズ開始成功！")
    }
    
    // =========================================================================
    // MARK: Actions
    
    @IBAction func advertiseBtnTapped(sender: UIButton) {
        if !peripheralManager.isAdvertising {
            startAdvertise()
        } else {
            stopAdvertise()
        }
    }
}
