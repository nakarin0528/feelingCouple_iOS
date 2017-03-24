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
    var resultArray = [[String]]()
    var data = OrganizingData.sharedData
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTable.delegate = self
        resultTable.dataSource = self
        myName.text = ""
        yourName.text = ""
        arrow1.alpha = 0
        arrow2.alpha = 0
        arrow3.alpha = 0
        heart2.alpha = 0
        brokenHeart.alpha = 0
        
        //resultArray = data.matching(targetData: data.targetData)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (member.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = member[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showResult(indexPath:)), userInfo: nil, repeats: true)
        timer.fire()
    }

    func showResult(indexPath: IndexPath){
        arrow1.alpha = 0
        arrow2.alpha = 0
        arrow3.alpha = 0
        heart2.alpha = 0
        brokenHeart.alpha = 0
        if n == 0{
            myName.text = member[indexPath.row]
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
            yourName.text = resultArray[indexPath.row][1]
            if resultArray[indexPath.row][2] == "マッチング成立！"{
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
