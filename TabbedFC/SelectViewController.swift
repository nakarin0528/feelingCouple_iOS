//
//  SelectViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/21.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit
import SCLAlertView

class SelectViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var ble = BLE.sharedBle
    var timer: Timer!
    private var myItems: [String] = []
    var lastCell: UITableViewCell?
    var selectedNum: Int?
    var selectedName: String?
    @IBOutlet weak var willPartnersList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cell名の登録
        willPartnersList.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        //DataSourceを自身に設定
        willPartnersList.dataSource = self
        
        //Delegateを自身に設定
        willPartnersList.delegate = self
        
        //Cellの複数選択を回避
        willPartnersList.allowsMultipleSelection = false
        
        //Viewに追加する
        self.view.addSubview(willPartnersList)

        
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func update(tm: Timer){
        //テーブルビュー更新
        myItems = ble.willPartner
        willPartnersList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myItems[indexPath.row])")
        // 前に選択されたセルのチェックを外す
        lastCell?.accessoryType = .none
        lastCell = tableView.cellForRow(at:indexPath)
        let cell = tableView.cellForRow(at:indexPath)
        ble.selectedNum = indexPath.row
        selectedNum = indexPath.row
        print(ble.selectedNum)
        selectedName = ble.willPartner[indexPath.row]
        // チェックマークを入れる
        cell?.accessoryType = .checkmark
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
    //Cellの総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Cellに値を設定する.
        cell.textLabel!.text = "\(myItems[indexPath.row])"
        
        return cell
    }
    
    @IBAction func decideButton(_ sender: Any) {
        if selectedNum == nil {
            let noParticipantsAlert = SCLAlertView()
            noParticipantsAlert.showWarning("相手未選択", subTitle: "気になる相手を選択してください", closeButtonTitle: "OK") // Wait
        } else {
            let startAlert = SCLAlertView()
            startAlert.addButton("OK") {
                //ここにデータ送信・画面遷移を記述してください
                self.ble.sendSelectData()
                self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "waitresult") as! WaitingResultViewController, animated: true)
            }
            startAlert.showNotice("確認", subTitle: selectedName!+"さんに決定しますか?", closeButtonTitle: "Cancel")
        }
    }
}

