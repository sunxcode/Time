//
//  ViewController.swift
//  Time
//
//  Created by yaoxinpan on 2018/3/29.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, ClockOffButtonDelegate {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var weekAvg: UILabel!
    @IBOutlet weak var monthAvg: UILabel!
    @IBOutlet weak var quarterAvg: UILabel!
    
    let timeTableDB: TimeTable = TimeTable()
    
    // MARK: - 生成周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initClockOffButton()
        
        weekAvg.text = timeTableDB.averageKnockOffTimeOfTheWeek(date: Date())
        monthAvg.text = timeTableDB.averageKnockOffTimeOfTheMonth(date: Date())
        quarterAvg.text = timeTableDB.averageKnockOffTimeOfTheQuarter(date: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 视图初始化
    func initClockOffButton() {
        let clockOffBtn = ClockOffButton()
        clockOffBtn.delegate = self
        clockOffBtn.setTitle("打卡", for: .normal)
        clockOffBtn.setTitleColor(UIColor.blue, for: .normal)
        buttonView.addSubview(clockOffBtn)
        clockOffBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ClockOffButtonDelegate
    func knockOff(time: Date) {
        
        if timeTableDB.insert(time) {
            weekAvg.text = timeTableDB.averageKnockOffTimeOfTheWeek(date: Date())
            monthAvg.text = timeTableDB.averageKnockOffTimeOfTheMonth(date: Date())
            quarterAvg.text = timeTableDB.averageKnockOffTimeOfTheQuarter(date: Date())
        } else {
            var message: String? = nil
            if let oldTime = timeTableDB.search(time) {
                message = "上次打卡时间：" + oldTime.toString(formatter: "HH:mm:ss")
            }
            
            let alertController = UIAlertController(title: "是否重新打卡", message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) -> Void in
                if self.timeTableDB.forcedInsert(time) {
                    self.weekAvg.text = self.timeTableDB.averageKnockOffTimeOfTheWeek(date: Date())
                    self.monthAvg.text = self.timeTableDB.averageKnockOffTimeOfTheMonth(date: Date())
                    self.quarterAvg.text = self.timeTableDB.averageKnockOffTimeOfTheQuarter(date: Date())
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

