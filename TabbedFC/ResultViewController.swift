//
//  ResultViewController.swift
//  TabbedFC
//
//  Created by 竹内将大 on 2017/03/24.
//  Copyright © 2017年 feelingCouplePBL. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var myName: UILabel! //自分の名前
    @IBOutlet weak var yourName: UILabel! //相手の名前
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var brokenHeart: UIImageView!
    
    let member = OrganizingData.sharedData.males + OrganizingData.sharedData.females
    var timer: Timer!
    var n = 0
    var path: Int?
    var resultArray = [[String]]()
    var lastCell: UITableViewCell?
    var data = OrganizingData.sharedData
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTable.register(UITableViewCell.self, forCellReuseIdentifier: "memberCell")
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.allowsMultipleSelection = false
        myName.text = ""
        yourName.text = ""
        arrow1.alpha = 0
        arrow2.alpha = 0
        arrow3.alpha = 0
        heart2.alpha = 0
        brokenHeart.alpha = 0
        
        resultArray = data.matching(targetData: data.targetData)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cellの総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (member.count)
    }
    
    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = member[indexPath.row]
        return cell
    }
    
    //Cellが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastCell?.accessoryType = .none
        lastCell = tableView.cellForRow(at:indexPath)
        path = indexPath.row
        print(path!)
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showResult), userInfo: nil, repeats: true)
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }

    func showResult(tm: Timer){
        arrow1.alpha = 0
        arrow2.alpha = 0
        arrow3.alpha = 0
        heart2.alpha = 0
        brokenHeart.alpha = 0
        if n == 0{
            yourName.text = ""
            myName.text = member[path!]
            n += 1
        }else if n == 1{
            arrow1.alpha = 1
            n += 1
        }else if n == 2{
            arrow2.alpha = 1
            n += 1
        }else if n == 3{
            arrow3.alpha = 1
            n += 1
        }else{
            yourName.text = resultArray[path!][1]
            if resultArray[path!][2] == "マッチング成立！"{
                heart2.alpha = 1
            }
            else{
                brokenHeart.alpha = 1
            }
            timer.invalidate()
            n = 0
        }
    }
}
