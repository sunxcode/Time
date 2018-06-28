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
        initNavigationBar()
        
        initClockOffButton()
        
        refreshAvgTime()
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshAvgTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshAvgTime() {
        weekAvg.text = timeTableDB.averageKnockOffTimeOfTheWeek(date: Date()) ?? "00:00:00"
        monthAvg.text = timeTableDB.averageKnockOffTimeOfTheMonth(date: Date()) ?? "00:00:00"
        quarterAvg.text = timeTableDB.averageKnockOffTimeOfTheQuarter(date: Date()) ?? "00:00:00"
    }

    @objc private func showCalendar() {
        
        navigationController?.pushViewController(CalendarViewController(), animated: true)
        
    }
    
    // MARK: - 视图初始化
    func initNavigationBar() {
        
        guard let _ = navigationController else { return }
        
        title = "打卡下班"
        
        let button = UIButton(type: .custom)
        
        button.setTitle("日历", for: .normal)
        
        button.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        
        button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    
    func initClockOffButton() {
        let clockOffBtn = ClockOffButton()
        clockOffBtn.delegate = self
        clockOffBtn.setTitle("长按打卡", for: .normal)
        clockOffBtn.setTitleColor(UIColor.blue, for: .normal)
        buttonView.addSubview(clockOffBtn)
        clockOffBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ClockOffButtonDelegate
    func knockOff(time: Date) {
        
        if timeTableDB.insert(time) {
            refreshAvgTime()
        } else {
            var message: String? = nil
            if let oldTime = timeTableDB.search(time) {
                message = "上次打卡时间：" + oldTime.toString(formatter: "HH:mm:ss")
            }
            
            let alertController = UIAlertController(title: "是否重新打卡", message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) -> Void in
                if self.timeTableDB.forcedInsert(time) {
                    self.refreshAvgTime()
                }
            })
            let deleteAction = UIAlertAction(title: "删除今天打卡记录", style: .default, handler: { (action) -> Void in
                if self.timeTableDB.delete(time) {
                    self.refreshAvgTime()
                } else {
                    // TODO: 添加删除失败告警框
                }
                
            })
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

