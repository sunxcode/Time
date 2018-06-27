//
//  CalendarViewController.swift
//  Time
//
//  Created by yaoxinpan on 2018/6/27.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: CustomFSCalendar!
    
    /// 要求达到的平均加班时间
    let deadline = "20:00:00"
    
    /// 合格显示的颜色
    let qualifiedColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    /// 不合格显示的颜色
    let disqualifiedColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    
    let timeTableDB: TimeTable = TimeTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configNavgationBar() {
        guard let _ = navigationController else { return }
        
        let button = UIButton(type: .custom)
        
        button.setTitle("补/重新打卡", for: .normal)
        
        button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func configCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.longPressDelegate = self
        calendar.appearance.todayColor = UIColor.white
        calendar.appearance.titleTodayColor = UIColor.blue
        calendar.swipeToChooseGesture.isEnabled = true
    }
    
    @objc func showDatePicker() {
        
    }
    
}

// MARK: - FSCalendarDataSource
extension CalendarViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard let date = timeTableDB.search(date) else { return nil }
        
        return date.toString(formatter: "HH:mm:ss")

    }
    
}

// MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
}

// MARK: - FSCalendarDelegateAppearance
extension CalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        guard let date = timeTableDB.search(date) else { return nil }
        
        if date.toString(formatter: "HH:mm:ss") < deadline {
            return disqualifiedColor
        } else {
            return qualifiedColor
        }
    }
}

// MARK: - FSCalendarLongPressDelegate
extension CalendarViewController: FSCalendarLongPressDelegate {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition){
        
        let alertController = UIAlertController(title: "是否更新下班时间", message: date.toString(formatter: "yyyy-MM-dd"), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let sureAction = UIAlertAction(title: "确认", style: .default, handler: { action in

            let datePicker = DatePickerView.datePicker(style: .hourMinuteSecond, scrollToDate: date) { date in
                guard let date = date else { return }

            }

            datePicker.show()
        })
        
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
