//
//  SQLiteManager.swift
//  Time
//
//  Created by yaoxinpan on 2018/4/2.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import Foundation
import SQLite

struct SQliteManager {
    // 数据库连接
    var database: Connection!
    
    init() {
        do {
            let path = NSHomeDirectory() + "/Documents/time.sqlite3"
            database = try Connection(path)
        } catch {
            print("\(error)")
        }
    }
    
}


/// 时间表，比数今天18点打卡。主键:2018-04-02， 字段:18:00:00
struct TimeTable {
    
    /// 数据库管理员
    private let sqlManager = SQliteManager()
    
    /// 表
    private let timeTable = Table("Time_table")
    
    /// 日期格式
    private let dayFormatter = "YYYYMMdd"
    
    /// 时间格式
    private let timeFormatter = "HH:mm:ss"
    
    /// 表字段
    let day = Expression<Int64>("day")
    let time = Expression<String>("time")
    
    init() {
        try! sqlManager.database.run(timeTable.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
            t.column(day, primaryKey: true)
            t.column(time)
        }))
    }
    
    /// 插入数据。当天已经插入过数据返回false
    ///
    /// - Parameter date: 打卡时间Date()
    /// - Returns: 插入成功返回true，插入失败返回false
    func insert(_ date: Date) -> Bool {
        if let tmpDay = Int64(date.toString(formatter: dayFormatter)) {
            do {
                let tmpTime = date.toString(formatter: timeFormatter)
                try sqlManager.database.run(timeTable.insert(day <- tmpDay, time <- tmpTime))
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    
    /// 插入数据，数据已经存在则替换
    ///
    /// - Parameter date: 打卡时间Date()
    /// - Returns: 插入成功返回true，插入失败返回false
    func forcedInsert(_ date: Date) -> Bool {
        if let tmpDay = Int64(date.toString(formatter: dayFormatter)) {
            do {
                let tmpTime = date.toString(formatter: timeFormatter)
                try sqlManager.database.run(timeTable.insert(or: .replace, day <- tmpDay, time <- tmpTime))
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    /// 查找数据
    ///
    /// - Parameter date: 要查找的日期
    /// - Returns: 返回查找到的时间
    func search(_ date: Date) -> Date? {
        if let tmpDay = Int64(date.toString(formatter: dayFormatter)) {
            for value in try! sqlManager.database.prepare(timeTable.filter(day == tmpDay)) {
                let tmpTime = value[time]
                let tmpValue = "\(tmpDay)" + " " + tmpTime
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.dateFormat = dayFormatter + " " + timeFormatter
                let newTime = formatter.date(from: tmpValue)
                return newTime
            }
        }
        return nil
    }
    
    /// 删除数据
    ///
    /// - Parameter date: 要删除的数据
    /// - Returns: 删除成功返回true,删除失败或者数据不存在返回false
    func delete(_ date: Date) -> Bool {
        
        if let tmpDay = Int64(date.toString(formatter: dayFormatter)) {
            
            do {
                let value = timeTable.filter(day == tmpDay)
                
                if try sqlManager.database.run(value.delete()) > 0 {
                    return true
                } else {
                    return false
                }
            } catch {
                return false
            }
        }
        return false
    }
    
    /// 查看是否有date日期的数据
    ///
    /// - Parameter date: 要查询的日期，必须包含年月日
    /// - Returns: 已经存在返回true，否则返回false
    func exist(_ date: Date) -> Bool {
        if let tmpDay = Int64(date.toString(formatter: dayFormatter)) {

            for _ in try! sqlManager.database.prepare(timeTable.filter(day == tmpDay)) {
                return true
            }
        }
        return false
    }
    
}

// MARK: - 高级方法
extension TimeTable {
    
//    func currentWeekAverageKnockoffTime() -> String? {
//        
//    }
    
    /// 获取指定时间段的平均下班时间
    ///
    /// - Parameters:
    ///   - from: 开始日期
    ///   - to: 结束日期
    /// - Returns: 平均下班时间
    func averageKnockOffTime(from: Date, to: Date) -> String? {
        if let fromDay = Int64(from.toString(formatter: dayFormatter)),
           let toDay = Int64(to.toString(formatter: dayFormatter)) {
            
            var times = [String]()
            
            for value in try! sqlManager.database.prepare(timeTable.filter(day >= fromDay && day <= toDay)) {
                times.append(value[time])
            }
            
            return averageTimeFrom(times: times)
        }
        
        return nil
    }
    
    
    /// 返回平均时间
    ///
    /// - Parameter times: 时间数据，格式是"HH:mm:ss"
    /// - Returns: 平均时间，格式是"HH:mm:ss"
    func averageTimeFrom(times: Array<String>) -> String? {
        
        // 1. 把所有时间"HH:mm:ss"补全成当天的时间 "YYYY-MM-dd HH:mm:ss"
        // 2. 计算每个时间与当天00:00:00的时间差
        // 3. 求和，然后求平均值
        // 4. 平均值去年日期，即得结果"HH:mm:ss"
        
        let currentDay = Date().toString(formatter: dayFormatter)
        let originDateStr = currentDay + " " + "00:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dayFormatter + " " + timeFormatter
        let originDate = dateFormatter.date(from: originDateStr)  // 当天00:00:00
        guard originDate != nil else {
            return nil
        }
        
        var timeInterval64: UInt64 = 0
        var validCount: UInt64 = 0
        
        
        for time in times {
            let tmpDateStr = currentDay + " " + time  // 换算成当天时间
            
            if let tmpDate = dateFormatter.date(from: tmpDateStr) {
                // 下班时间到当天00:00:00的时长和
                timeInterval64 += UInt64(tmpDate.timeIntervalSince(originDate!))
                validCount += 1
            }
        }
        
        // 平均每天下班到00:00:00的时长
        let avgTimeInterval64  = timeInterval64 / validCount
        
        // 根据时长换算成date
        let avgDate = originDate!.addingTimeInterval(TimeInterval(avgTimeInterval64))
        
        return avgDate.toString(formatter: timeFormatter)
    }
}
