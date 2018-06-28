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
    
    @IBOutlet weak var monthAvg: UILabel!
    
    @IBOutlet weak var quarterAvg: UILabel!
    
    @IBOutlet weak var yearAvg: UILabel!
    
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
        
        showAverageKnockOffTime(Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.twoTapsDelegate = self
        calendar.appearance.todayColor = UIColor.white
        calendar.appearance.titleTodayColor = UIColor.blue
        _ = calendar.twoTaps
    }
    
    private func showAverageKnockOffTime(_ date: Date) {
        
        monthAvg.text = timeTableDB.averageKnockOffTimeOfTheMonth(date: date) ?? "00:00:00"
        
        quarterAvg.text = timeTableDB.averageKnockOffTimeOfTheQuarter(date: date) ?? "00:00:00"
        
        yearAvg.text = timeTableDB.averageKnockOffTimeOfTheYear(date: date) ?? "00:00:00"
        
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        showAverageKnockOffTime(calendar.currentPage)
        
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
extension CalendarViewController: FSCalendarTwoTapsDelegate {
    func calendar(_ calendar: FSCalendar, date: Date, at monthPosition: FSCalendarMonthPosition){
        
        let alertController = UIAlertController(title: "是否更新下班时间", message: date.toString(formatter: "yyyy-MM-dd"), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let sureAction = UIAlertAction(title: "确认", style: .default, handler: { action in
            
            var scrollToDate: Date
            
            if let oldDate = self.timeTableDB.search(date) {
                scrollToDate = Date.date(date.toString(formatter: "yyyy-MM-dd") + " " + oldDate.toString(formatter: "HH:mm:ss"), formatter: "yyyy-MM-dd HH:mm:ss")!
            } else {
                scrollToDate = Date.date(date.toString(formatter: "yyyy-MM-dd") + " 20:00:00", formatter: "yyyy-MM-dd HH:mm:ss")!
            }

            
            let datePicker = DatePickerView.datePicker(style: .all, scrollToDate: scrollToDate) { date in
                guard let date = date else { return }
                
                self.timeTableDB.forcedInsert(date)
                
                calendar.reloadData()
                
                self.showAverageKnockOffTime(date)
            }
            
            datePicker.minLimitDate = Date.date(date.toString(formatter: "yyyy-MM-dd") + " 00:00:00", formatter: "yyyy-MM-dd HH:mm:ss")!
            
            datePicker.maxLimitDate = Date.date(date.toString(formatter: "yyyy-MM-dd") + " 23:59:59", formatter: "yyyy-MM-dd HH:mm:ss")!

            datePicker.show()
        })
        
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
