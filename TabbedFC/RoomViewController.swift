//
//  RoomViewController.swift
//  TabbedFC
//
//  Created by I,N on 2017/03/18.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var blep = BLEP.sharedBleP
    var timer: Timer!
    private var myItems: [String] = []
    @IBOutlet weak var participants: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cell名の登録
        participants.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        //DataSourceを自身に設定
        participants.dataSource = self
        
        //Delegateを自身に設定
        participants.delegate = self
        
        //Cellの選択を不可に設定
        participants.allowsSelection = false
        
        //Viewに追加する
        self.view.addSubview(participants)

        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func update(tm: Timer){
        //接続されたセントラルの名前をテーブルに追加
        myItems = blep.names
        //テーブルビュー更新
        participants.reloadData()
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
        //print(myItems)
        cell.textLabel!.text = "\(myItems[indexPath.row])"

        return cell
    }
    //画面切り替わった時にタイマーを止める
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        /*
         プロフィール未入力時にアラートを出してプロフィール入力画面にとばす．
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
