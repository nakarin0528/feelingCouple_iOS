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
    
    let member = OrganizingData.sharedData.males + OrganizingData.sharedData.females

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTable.delegate = self
        resultTable.dataSource = self
        myName.text = ""
        yourName.text = ""
        
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
        myName.text = member[indexPath.row]
    }


}
