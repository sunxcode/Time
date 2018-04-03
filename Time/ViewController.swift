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
    
    // MARK: - 生成周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initClockOffButton()
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
        view.addSubview(clockOffBtn)
        clockOffBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
    
    // MARK: - ClockOffButtonDelegate
    func knockOff(time: Date) {
        
        let str = time.toString(formatter: "yyyy-MM-dd HH:mm:ss")
        print("\(str)")
        TimeTable().forcedInsert(time)
        if TimeTable().exist(time) {
            print("exist: \(String(describing: time.toString(formatter: "yyyy-MM-dd")))")
        } else {
            print("not exist: \(String(describing: time.toString(formatter: "yyyy-MM-dd")))")
        }
        let newTime = TimeTable().search(time)
        
        print(newTime)
    }
}

