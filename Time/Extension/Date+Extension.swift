//
//  Date+Extension.swift
//  Time
//
//  Created by yaoxinpan on 2018/4/2.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation

extension Date {
    
    /// 把Date转换成formatter格式的字符串
    ///
    /// - Parameter formatter: 格式 "yyyy-MM-dd HH:mm:ss"
    /// - Returns: 转换后的字符串
    public func toString(formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    /// 获取年
    ///
    /// - Returns: 返回当地时间年
    public func year() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    
    
    /// 获取月
    ///
    /// - Returns: 返回当地时间月
    public func month() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    
    
    /// 获取日期
    ///
    /// - Returns: 返回当地时间日期
    public func day() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    /// 获取本周的第一天日期和最后一天日期.周日第一天，周六最后一天
    ///
    /// - Returns: 返回元组，包含第一天和最后一天
    public func firstAndLastDayOfThisWeek() -> (first: Date, last: Date)? {
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else {
            return nil
        }
        
        var components = calendar.components(NSCalendar.Unit.weekday, from: self)
        
        guard let weekday = components.weekday else { return nil }
        let firstDiff = 1 - weekday
        let lastDiff = 7 - weekday
        
        components = DateComponents()
        components.day = firstDiff
        guard let firstDate = calendar.date(byAdding: components, to: self, options: NSCalendar.Options.matchFirst) else {
            return nil
        }
        
        components.day = lastDiff
        guard let lastDate = calendar.date(byAdding: components, to: self, options: .matchFirst) else {
            return nil
        }
        
        return (firstDate, lastDate)
    }
    
    /// 获取本月的第一天日期和最后一天日期
    ///
    /// - Returns: 返回元组，包含第一天和最后一天
    public func firstAndLastDayOfThisMonth() -> (first: Date, last: Date)? {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        guard calendar != nil else {
            return nil
        }
        
        var components = calendar!.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue), from: self)
        
        components.day = 1
        let firstDate = calendar!.date(from: components)
        guard firstDate != nil else {
            return nil
        }
        
        components = DateComponents()
        components.month = 1
        components.day = -1
        let lastDate = calendar!.date(byAdding: components, to: firstDate!, options: NSCalendar.Options.matchFirst)
        guard lastDate != nil else {
            return nil
        }
        
        return (firstDate!, lastDate!)
    }
    
    /// 获取本季度的第一天日期和最后一天日期
    ///
    /// - Returns: 返回元组，包含第一天和最后一天
    public func firstAndLastDayOfThisQuarter() -> (first: Date, last: Date)? {
        let year = self.year()
        var firstMonth: String
        let firstDay: String = "01"
        var lastMonth: String
        var lastDay: String
        
        guard let monthInt = Int(self.month()) else { return nil }
        switch monthInt {
        case 1, 2, 3:
            firstMonth = "01"
            lastMonth = "03"
            lastDay = "31"
        case 4, 5, 6:
            firstMonth = "04"
            lastMonth = "06"
            lastDay = "30"
        case 7, 8, 9:
            firstMonth = "07"
            lastMonth = "09"
            lastDay = "30"
        case 10, 11, 12:
            firstMonth = "10"
            lastMonth = "12"
            lastDay = "31"
        default:
            return nil
        }
        
        let firstDateStr = year + "-" + firstMonth + "-" + firstDay
        let lastDateStr = year + "-" + lastMonth + "-" + lastDay
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let firstDate = dateFormatter.date(from: firstDateStr) else { return nil }
        guard let lastDate = dateFormatter.date(from: lastDateStr) else { return nil }
        
        return (firstDate, lastDate)

    }
    
    /// 获取本年的第一天日期和最后一天日期
    ///
    /// - Returns: 返回元组，包含第一天和最后一天
    public func firstAndLastDayOfThisYear() -> (first: Date, last: Date)? {
        let year = self.year()
        let firstDateStr = year + "-01-01"
        let lastDateStr = year + "-12-31"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let firstDate = dateFormatter.date(from: firstDateStr) else { return nil }
        guard let lastDate = dateFormatter.date(from: lastDateStr) else { return nil }
        
        return (firstDate, lastDate)
    }
}
