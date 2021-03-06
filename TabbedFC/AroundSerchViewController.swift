//
//  AroundSerchViewController.swift
//  smartQC
//
//  Created by I,N on 2017/03/03.
//

import UIKit
import SCLAlertView

class AroundSerchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, GetPeripheralDelegate {

    var ble = BLE.sharedBle
    var prof = Profile.sharedProfile
    var timer: Timer!
    var num: Int?
    var lastCell: UITableViewCell?
    
    private var myItems: NSArray = []
    @IBOutlet weak var myTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Cell名の登録をおこなう.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceを自身に設定する.
        myTableView.dataSource = self
        
        // Delegateを自身に設定する.
        myTableView.delegate = self
        
        // Cellの複数選択を回避
        myTableView.allowsMultipleSelection = false
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if prof.name == "プロフィールを入力してください" || prof.name == "" {
            let profAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            profAlert.addButton("入力画面へ") {
                //ここに画面遷移を実装
                let storyboard: UIStoryboard = self.storyboard!
                let profView = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
                self.present(profView, animated: true, completion: nil)
            }
            profAlert.showEdit("プロフィール未設定", subTitle: "名前と性別を設定してください") // Edit
        }
        ble.isFirst = true
    }
    
    func update(tm: Timer) {
        //発見したデバイスを取得
        getPeripheral()
        //テーブルビュー更新
        myTableView.reloadData()
        //print("更新")
    }
    
    func getPeripheral() {
        myItems = ble.getPeripheral(delegate: self) as NSArray
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
        num = indexPath.row
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
    
    //画面切り替わった時にタイマーを止める
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // Joinが押された際の処理
    @IBAction func joinButton(_ sender: Any) {
        if num != nil {
            ble.setNewPeripheral(num!)
            self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "waiting") as! WaitingAroundViewController, animated: true)
        } else {
            let JoinAlert = SCLAlertView()
            JoinAlert.showWarning("ルーム未選択", subTitle: "ルームを選択してください", closeButtonTitle: "OK") // Notice
        }
    }
    
}
