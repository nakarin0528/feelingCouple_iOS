//
//  SelectViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/21.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ble = BLE.sharedBle
    var timer: Timer!
    private var myItems: [String] = []
    @IBOutlet weak var willPartnersList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cell名の登録
        willPartnersList.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        //DataSourceを自身に設定
        willPartnersList.dataSource = self
        
        //Delegateを自身に設定
        willPartnersList.delegate = self
        
        //Cellの選択を不可に設定
        willPartnersList.allowsSelection = false
        
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
}

